import gdb
import gdb.printing

class SpPsConfigPrinter:
    def __init__(self, val):
        self.val = val

    def children(self):
        for field in self.val.type.fields():
            if field.name == 'io':
                # Skip io field - we'll handle it differently
                continue
            else:
                yield (field.name, self.val[field.name])

        # Add io modes as separate fields to avoid nested object issues
        try:
            io_val = self.val['io']
            yield ('stdin', io_val['in']['mode'])
            yield ('stdout', io_val['out']['mode'])
            yield ('stderr', io_val['err']['mode'])
        except:
            pass

    def display_hint(self):
        return 'sp_ps_config_t'

class SpPsPrinter:
    def __init__(self, val):
        self.val = val

    def children(self):
        for field in self.val.type.fields():
            if field.name == 'io':
                # Skip io field - we'll handle it differently
                continue
            else:
                yield (field.name, self.val[field.name])

        # Add io modes as separate fields to avoid nested object issues
        try:
            io_val = self.val['io']
            yield ('io_in_mode', io_val['in']['mode'])
            yield ('io_out_mode', io_val['out']['mode'])
            yield ('io_err_mode', io_val['err']['mode'])
        except:
            pass

    def display_hint(self):
        return 'sp_ps_t'

class SpEnvVarPrinter:
    def __init__(self, val):
        self.val = val

    def children(self):
        yield ('key', self.val['key'])
        yield ('value', self.val['value'])

    def display_hint(self):
        return 'sp_env_var_t'

def build_pretty_printer():
    pp = gdb.printing.RegexpCollectionPrettyPrinter("sp_ps")
    pp.add_printer('sp_ps_config_t', '^sp_ps_config_t$', SpPsConfigPrinter)
    pp.add_printer('sp_ps_t', '^sp_ps_t$', SpPsPrinter)
    pp.add_printer('sp_env_var_t', '^sp_env_var_t$', SpEnvVarPrinter)
    return pp

try:
    objfile = gdb.current_objfile()
    if objfile:
        gdb.printing.register_pretty_printer(objfile, build_pretty_printer(), replace=True)
    else:
        gdb.printing.register_pretty_printer(None, build_pretty_printer(), replace=True)
except:
    gdb.printing.register_pretty_printer(None, build_pretty_printer(), replace=True)
