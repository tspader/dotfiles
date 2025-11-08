import gdb
import gdb.printing
import re
import json

class SpHtPrinter:
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

    def _is_valid_hash_table_type(self, gdb_type):
        if gdb_type.code not in (gdb.TYPE_CODE_PTR, 23):
            return False

        try:
            dummy_val = gdb.Value(0).cast(gdb_type)
            dereferenced_type = dummy_val.dereference().type
        except:
            return False

        if dereferenced_type.code != gdb.TYPE_CODE_STRUCT:
            return False

        try:
            fields = [f.name for f in dereferenced_type.fields()]
            required_fields = ['data', 'tmp_key', 'tmp_val', 'info']

            for field in required_fields:
                if field not in fields:
                    return False

            return True
        except (KeyError, gdb.error):
            return False

    def _get_type_name(self, gdb_type):
        try:
            if gdb_type.name:
                type_name = gdb_type.name
                return self._typedef_map.get(type_name, type_name)

            if gdb_type.code == gdb.TYPE_CODE_PTR:
                target_name = self._get_type_name(gdb_type.target())
                return f"{target_name}*"

            if gdb_type.code == gdb.TYPE_CODE_ARRAY:
                element_name = self._get_type_name(gdb_type.target())
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

    def _format_key(self, val):
        formatted = self._format_value(val)
        if isinstance(formatted, str) and formatted.startswith('"') and formatted.endswith('"'):
            # Remove the quotes from string values for cleaner key display
            inner = formatted[1:-1]
            return f'[{inner}]'
        else:
            return f'[{formatted}]'

    def _format_value(self, val):
        if val.type.code == gdb.TYPE_CODE_INT:
            return str(int(val))
        elif val.type.code == gdb.TYPE_CODE_PTR:
            if val.type.target().name == 'char':
                try:
                    char_ptr = val.cast(gdb.lookup_type('char').pointer())
                    string_val = char_ptr.string()
                    return f'"{string_val}"'
                except:
                    return str(int(val))
            else:
                return str(int(val))
        elif val.type.code == gdb.TYPE_CODE_ARRAY:
            if val.type.target().name == 'char':
                try:
                    string_val = val.string()
                    return f'"{string_val}"'
                except:
                    return str(val)
            else:
                return str(val)
        elif val.type.code == gdb.TYPE_CODE_STRUCT:
            if val.type.name and 'sp_str_t' in val.type.name:
                try:
                    data = val['data']
                    size = val['size']
                    if int(data) != 0 and int(size) > 0:
                        char_ptr = data.cast(gdb.lookup_type('char').pointer())
                        string_val = char_ptr.string(length=int(size))
                        return f'"{string_val}"'
                    else:
                        return '""'
                except:
                    return str(val)

            fields = {}
            for field in val.type.fields():
                field_name = field.name
                if field_name is None:
                    continue
                field_val = val[field_name]
                fields[f'.{field_name}'] = self._format_value(field_val)

            return fields
        else:
            return str(val)

    def _serialize_hash_table(self, include_metadata=True):
        try:
            if not self._is_valid_hash_table_type(self.val.type):
                return {'error': 'invalid hash table structure'}

            if int(self.val) == 0:
                return None

            ht = self.val.dereference()

            data_ptr = ht['data']
            if int(data_ptr) == 0:
                return {} if not include_metadata else {'data': {}, 'size': 0, 'capacity': 0}

            dyn_array_head_type = gdb.lookup_type('sp_dyn_array')
            dyn_array_head = (data_ptr.cast(gdb.lookup_type('char').pointer()) -
                             dyn_array_head_type.sizeof).cast(dyn_array_head_type.pointer()).dereference()

            size = int(dyn_array_head['size'])
            capacity = int(dyn_array_head['capacity'])

            if size == 0:
                return {} if not include_metadata else {'data': {}, 'size': 0, 'capacity': 0}

            info = ht['info']
            stride = int(info['stride'])
            klpvl = int(info['klpvl'])

            try:
                tmp_key = ht['tmp_key']
                tmp_val = ht['tmp_val']
                key_type_name = self._get_type_name(tmp_key.type)
                val_type_name = self._get_type_name(tmp_val.type)
            except:
                key_type_name = 'unknown'
                val_type_name = 'unknown'

            data = {}
            count = 0
            for i in range(capacity):
                entry_ptr = (data_ptr.cast(gdb.lookup_type('char').pointer()) +
                           i * stride).cast(data_ptr.type)

                entry_start = entry_ptr.cast(gdb.lookup_type('char').pointer())
                state_ptr = (entry_start + klpvl).cast(gdb.lookup_type('sp_ht_entry_state').pointer())
                state = state_ptr.dereference()

                if int(state) == 1:
                    key = entry_ptr['key']
                    val = entry_ptr['val']

                    key_str = self._format_key(key)
                    val_formatted = self._format_value(val)
                    data[key_str] = val_formatted

                    count += 1

                    if count >= size:
                        break

            if include_metadata:
                return {
                    'key': key_type_name,
                    'value': val_type_name,
                    'size': size,
                    'capacity': capacity,
                    'data': data
                }
            else:
                return data

        except Exception as e:
            return {'error': f'error reading hash table: {e}'}

    def to_string(self):
        serialized = self._serialize_hash_table(include_metadata=True)
        return json.dumps(serialized, indent=2)

    def display_hint(self):
        return 'map'

class SpHtDataPrinter:
    def __init__(self, val):
        self.val = val

    def to_string(self):
        printer = SpHtPrinter(self.val)
        serialized = printer._serialize_hash_table(include_metadata=False)
        return json.dumps(serialized, indent=2)

    def display_hint(self):
        return 'map'

def build_pretty_printer():
    pp = gdb.printing.RegexpCollectionPrettyPrinter("sp_ht")
    pp.add_printer('sp_ht', r'^struct \{\.\.\.\}\*$', SpHtPrinter)
    pp.add_printer('sp_ht_data', r'^struct \{\.\.\.\}\*$', SpHtDataPrinter)
    return pp

try:
    objfile = gdb.current_objfile()
    if objfile:
        gdb.printing.register_pretty_printer(objfile, build_pretty_printer(), replace=True)
    else:
        gdb.printing.register_pretty_printer(None, build_pretty_printer(), replace=True)
except:
    gdb.printing.register_pretty_printer(None, build_pretty_printer(), replace=True)

def print_sp_ht(val):
    if isinstance(val, str):
        val = gdb.parse_and_eval(val)
    printer = SpHtPrinter(val)
    print(printer.to_string())

def print_sp_ht_data(val):
    if isinstance(val, str):
        val = gdb.parse_and_eval(val)
    printer = SpHtDataPrinter(val)
    print(printer.to_string())

class PrintSpHtCommand(gdb.Command):
    def __init__(self):
        super(PrintSpHtCommand, self).__init__("pht", gdb.COMMAND_DATA)

    def invoke(self, argument, from_tty):
        print_sp_ht(argument)

class PrintSpHtDataCommand(gdb.Command):
    def __init__(self):
        super(PrintSpHtDataCommand, self).__init__("ht", gdb.COMMAND_DATA)

    def invoke(self, argument, from_tty):
        print_sp_ht_data(argument)

PrintSpHtCommand()
PrintSpHtDataCommand()
