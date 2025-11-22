import gdb
import gdb.printing

class SpPsConfigPrinter:
    def __init__(self, val):
        self.val = val

    def children(self):
        # Return all fields except io
        for field in self.val.type.fields():
            if field.name == 'io':
                continue  # Skip io field as requested
            yield (field.name, self.val[field.name])

    def display_hint(self):
        return 'sp_ps_config_t'

class SpPsPrinter:
    def __init__(self, val):
        self.val = val

    def children(self):
        # Return all fields except io
        for field in self.val.type.fields():
            if field.name == 'io':
                continue  # Skip io field as requested
            yield (field.name, self.val[field.name])

    def display_hint(self):
        return 'sp_ps_t'

def build_pretty_printer():
    pp = gdb.printing.RegexpCollectionPrettyPrinter("sp_ps")
    pp.add_printer('sp_ps_config_t', '^sp_ps_config_t$', SpPsConfigPrinter)
    pp.add_printer('sp_ps_t', '^sp_ps_t$', SpPsPrinter)
    return pp

try:
    objfile = gdb.current_objfile()
    if objfile:
        gdb.printing.register_pretty_printer(objfile, build_pretty_printer(), replace=True)
    else:
        gdb.printing.register_pretty_printer(None, build_pretty_printer(), replace=True)
except:
    gdb.printing.register_pretty_printer(None, build_pretty_printer(), replace=True)