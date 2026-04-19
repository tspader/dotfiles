import gdb


def _da_size(da_ptr):
    """Get size of a sp_da by reading the header before the data pointer."""
    if int(da_ptr) == 0:
        return 0
    head_type = gdb.lookup_type('sp_dyn_array')
    char_ptr = da_ptr.cast(gdb.lookup_type('char').pointer())
    head = (char_ptr - head_type.sizeof).cast(head_type.pointer()).dereference()
    return int(head['size'])


def _ht_find_key_for_val(ht_ptr, val_addr):
    """Walk ht entries to find the key whose val matches val_addr."""
    if int(ht_ptr) == 0:
        return None
    ht = ht_ptr.dereference()
    capacity = int(ht['capacity'])
    data = ht['data']
    for i in range(capacity):
        entry = data[i]
        if int(entry['state']) == 1:
            if int(entry['val']) == val_addr:
                return entry['key']
    return None


class SpOmCommand(gdb.Command):
    """List sp_om entries in insertion order.
    Usage: om <variable>
    """

    def __init__(self):
        super(SpOmCommand, self).__init__("om", gdb.COMMAND_DATA)

    def invoke(self, argument, from_tty):
        args = gdb.string_to_argv(argument)
        if len(args) != 1:
            print("Usage: om <variable>")
            return

        try:
            om_ptr = gdb.parse_and_eval(args[0])
        except gdb.error as e:
            print(f"Error: {e}")
            return

        if int(om_ptr) == 0:
            print("(null)")
            return

        try:
            om = om_ptr.dereference()
            order = om['order']
            index = om['index']
            size = _da_size(order)

            if size == 0:
                print("(empty)")
                return

            for i in range(size):
                val_ptr = order[i]
                val_addr = int(val_ptr)
                key = _ht_find_key_for_val(index, val_addr)
                key_str = key if key is not None else "?"
                print(f"[{i}] {key_str} => {val_ptr}")

        except gdb.error as e:
            print(f"Error reading ordered map: {e}")


class SpOmGetCommand(gdb.Command):
    """Get Nth entry from sp_om by insertion order.
    Usage: omn <variable> <index>
    """

    def __init__(self):
        super(SpOmGetCommand, self).__init__("omn", gdb.COMMAND_DATA)

    def invoke(self, argument, from_tty):
        args = gdb.string_to_argv(argument)
        if len(args) != 2:
            print("Usage: omn <variable> <index>")
            return

        try:
            om_ptr = gdb.parse_and_eval(args[0])
            target = int(args[1])
        except (gdb.error, ValueError) as e:
            print(f"Error: {e}")
            return

        if int(om_ptr) == 0:
            print("(null)")
            return

        try:
            om = om_ptr.dereference()
            order = om['order']
            index = om['index']
            size = _da_size(order)

            if target < 0 or target >= size:
                print(f"Index {target} out of range (size: {size})")
                return

            val_ptr = order[target]
            val_addr = int(val_ptr)
            key = _ht_find_key_for_val(index, val_addr)

            if key is not None:
                gdb.set_convenience_variable("_omkey", key)
                gdb.execute("p $_omkey")

            val = val_ptr.dereference()
            gdb.set_convenience_variable("_omval", val)
            gdb.execute("p $_omval")

        except gdb.error as e:
            print(f"Error: {e}")


SpOmCommand()
SpOmGetCommand()
