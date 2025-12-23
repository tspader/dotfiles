import gdb
import gdb.printing
import json

class SpDaPrinter:
    def __init__(self, val):
        self.val = val

    _typedef_map = {
        'int8_t': 's8',
        'int16_t': 's16',
        'int32_t': 's32',
        'int64_t': 's64',
        'uint8_t': 'u8',
        'uint16_t': 'u16',
        'uint32_t': 'u32',
        'uint64_t': 'u64',
        'float': 'f32',
        'double': 'f64',
        'char': 'c8',
        'wchar_t': 'c16',
        'int': 's32',
        'unsigned int': 'u32',
        'long': 's64',
        'unsigned long': 'u64',
        'short': 's16',
        'unsigned short': 'u16',
        'signed char': 's8',
        'unsigned char': 'u8',
    }

    def _is_valid_dynamic_array_type(self, gdb_type):
        """Check if this looks like a valid sp_da dynamic array (pointer)"""
        if gdb_type.code not in (gdb.TYPE_CODE_PTR, 23):
            return False
        return True

    def _get_type_name(self, gdb_type, as_array=False):
        try:
            if gdb_type.name:
                type_name = gdb_type.name
                return self._typedef_map.get(type_name, type_name)

            if gdb_type.code == gdb.TYPE_CODE_PTR:
                target_name = self._get_type_name(gdb_type.target(), as_array)
                if as_array:
                    return f"{target_name}[]"
                else:
                    return f"{target_name}*"

            if gdb_type.code == gdb.TYPE_CODE_ARRAY:
                element_name = self._get_type_name(gdb_type.target(), as_array)
                return f"{element_name}[]"

            if gdb_type.code == gdb.TYPE_CODE_STRUCT:
                if gdb_type.tag:
                    return gdb_type.tag
                return "struct"

            type_names = {
                gdb.TYPE_CODE_INT: "int",
                gdb.TYPE_CODE_BOOL: "bool",
                gdb.TYPE_CODE_CHAR: "char",
            }
            return type_names.get(gdb_type.code, f"type_{gdb_type.code}")

        except:
            return "unknown"

    def _format_value(self, val):
        """Format a value based on its type"""
        if val.type.code == gdb.TYPE_CODE_INT:
            return int(val)
        elif val.type.code == gdb.TYPE_CODE_PTR:
            if val.type.target().name == 'char':
                try:
                    char_ptr = val.cast(gdb.lookup_type('char').pointer())
                    string_val = char_ptr.string()
                    return string_val
                except:
                    return int(val)
            else:
                return int(val)
        elif val.type.code == gdb.TYPE_CODE_ARRAY:
            if val.type.target().name == 'char':
                try:
                    string_val = val.string()
                    return string_val
                except:
                    return str(val)
            else:
                return str(val)
        elif val.type.code == gdb.TYPE_CODE_STRUCT:
            if val.type.name and 'sp_str_t' in val.type.name:
                try:
                    data = val['data']
                    length = val['len']
                    if int(data) != 0 and int(length) > 0:
                        char_ptr = data.cast(gdb.lookup_type('char').pointer())
                        string_val = char_ptr.string(length=int(length))
                        return string_val
                    else:
                        return ''
                except:
                    return str(val)

            # For other structs, format as inline JSON-like object
            fields = {}
            for field in val.type.fields():
                field_name = field.name
                if field_name is None:
                    continue
                field_val = val[field_name]
                fields[field_name] = self._format_value(field_val)

            return fields
        else:
            return str(val)

    def _serialize_dynamic_array(self, include_metadata=True):
        """Serialize dynamic array to Python dict for JSON output"""
        try:
            if not self._is_valid_dynamic_array_type(self.val.type):
                return {'error': 'invalid dynamic array type'}

            if int(self.val) == 0:
                return None

            # Get the dynamic array header (located before the data)
            dyn_array_head_type = gdb.lookup_type('sp_dyn_array')
            dyn_array_head = (self.val.cast(gdb.lookup_type('char').pointer()) -
                             dyn_array_head_type.sizeof).cast(dyn_array_head_type.pointer()).dereference()

            size = int(dyn_array_head['size'])
            capacity = int(dyn_array_head['capacity'])

            if size == 0:
                return [] if not include_metadata else {'type': self._get_type_name(self.val.type.target(), as_array=True), 'size': size, 'capacity': capacity, 'data': []}

            # Get element type name
            element_type_name = self._get_type_name(self.val.type.target(), as_array=True)

            # Serialize array data
            data = []
            for i in range(size):
                element = self.val[i]
                formatted_element = self._format_value(element)
                data.append(formatted_element)

            if include_metadata:
                return {
                    'type': element_type_name,
                    'size': size,
                    'capacity': capacity,
                    'data': data
                }
            else:
                return data

        except Exception as e:
            return {'error': f'error reading dynamic array: {e}'}

    def to_string(self):
        """Return pretty-printed JSON with metadata"""
        serialized = self._serialize_dynamic_array(include_metadata=True)
        return json.dumps(serialized, indent=2)

    def display_hint(self):
        return 'array'

class SpDaDataPrinter:
    """Simple printer that shows the dynamic array like a normal GDB array"""
    def __init__(self, val):
        self.val = val

    def _format_element(self, val):
        """Format an element using GDB's native styling"""
        try:
            # Use GDB's native format_string with styling for proper colors
            return val.format_string(styling=True)
        except:
            return str(val)

    def to_string(self):
        """Return array formatted like GDB's native array printing"""
        printer = SpDaPrinter(self.val)
        
        if not printer._is_valid_dynamic_array_type(self.val.type):
            return '<invalid dynamic array>'
        
        if int(self.val) == 0:
            return '<null>'
        
        try:
            dyn_array_head_type = gdb.lookup_type('sp_dyn_array')
            dyn_array_head = (self.val.cast(gdb.lookup_type('char').pointer()) -
                             dyn_array_head_type.sizeof).cast(dyn_array_head_type.pointer()).dereference()
            size = int(dyn_array_head['size'])
        except:
            return '<error reading array header>'
        
        if size == 0:
            return '{<empty>}'
        
        lines = []
        for i in range(size):
            element = self.val[i]
            formatted = self._format_element(element)
            lines.append(f"[{i}] = {formatted}")
        
        return "\n".join(lines)

    def display_hint(self):
        return 'array'

def build_pretty_printer():
    pp = gdb.printing.RegexpCollectionPrettyPrinter("sp_da")
    pp.add_printer('sp_da', r'^.*\*$', SpDaPrinter)
    pp.add_printer('sp_da_data', r'^.*\*$', SpDaDataPrinter)
    return pp

try:
    objfile = gdb.current_objfile()
    if objfile:
        gdb.printing.register_pretty_printer(objfile, build_pretty_printer(), replace=True)
    else:
        gdb.printing.register_pretty_printer(None, build_pretty_printer(), replace=True)
except:
    gdb.printing.register_pretty_printer(None, build_pretty_printer(), replace=True)

def print_sp_da(val):
    if isinstance(val, str):
        val = gdb.parse_and_eval(val)
    printer = SpDaPrinter(val)
    print(printer.to_string())

def print_sp_da_data(val):
    if isinstance(val, str):
        val = gdb.parse_and_eval(val)
    printer = SpDaDataPrinter(val)
    print(printer.to_string())

class PrintSpDaCommand(gdb.Command):
    def __init__(self):
        super(PrintSpDaCommand, self).__init__("pda", gdb.COMMAND_DATA)

    def invoke(self, argument, from_tty):
        print_sp_da(argument)

class PrintSpDaDataCommand(gdb.Command):
    def __init__(self):
        super(PrintSpDaDataCommand, self).__init__("da", gdb.COMMAND_DATA)

    def invoke(self, argument, from_tty):
        print_sp_da_data(argument)

PrintSpDaCommand()
PrintSpDaDataCommand()