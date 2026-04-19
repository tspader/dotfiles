import gdb

class SpHtCommand(gdb.Command):
    """Display sp_ht hash table contents.
    Usage: sp_ht <variable>
    """

    def __init__(self):
        super(SpHtCommand, self).__init__("ht", gdb.COMMAND_DATA)

    def invoke(self, argument, from_tty):
        args = gdb.string_to_argv(argument)
        if len(args) != 1:
            print("Usage: sp_ht <variable>")
            return

        try:
            ht_ptr = gdb.parse_and_eval(args[0])
        except gdb.error as e:
            print(f"Error: {e}")
            return

        if int(ht_ptr) == 0:
            print("(null)")
            return

        try:
            ht = ht_ptr.dereference()
            size = int(ht['size'])
            capacity = int(ht['capacity'])
            data = ht['data']

            if size == 0:
                print("(empty)")
                return

            count = 0
            for i in range(capacity):
                entry = data[i]
                state = int(entry['state'])
                if state == 1:
                    key = entry['key']
                    val = entry['val']
                    print(f"[{count}] {key} => {val}")
                    count += 1

        except gdb.error as e:
            print(f"Error reading hash table: {e}")

SpHtCommand()


class SpHtGetCommand(gdb.Command):
    """Get Nth active entry from sp_ht.
    Usage: htget <variable> <index>
    """

    def __init__(self):
        super(SpHtGetCommand, self).__init__("htget", gdb.COMMAND_DATA)

    def invoke(self, argument, from_tty):
        args = gdb.string_to_argv(argument)
        if len(args) != 2:
            print("Usage: htget <variable> <index>")
            return

        try:
            ht_ptr = gdb.parse_and_eval(args[0])
            target = int(args[1])
        except (gdb.error, ValueError) as e:
            print(f"Error: {e}")
            return

        if int(ht_ptr) == 0:
            print("(null)")
            return

        try:
            ht = ht_ptr.dereference()
            capacity = int(ht['capacity'])
            data = ht['data']

            count = 0
            for i in range(capacity):
                entry = data[i]
                if int(entry['state']) == 1:
                    if count == target:
                        val = entry['val']
                        gdb.set_convenience_variable("_htkey", entry['key'])
                        gdb.set_convenience_variable("_htval", val.dereference() if val.type.code == gdb.TYPE_CODE_PTR and int(val) != 0 else val)
                        gdb.execute("p $_htkey")
                        gdb.execute("p $_htval")
                        return
                    count += 1

            print(f"Index {target} out of range (size: {count})")

        except gdb.error as e:
            print(f"Error: {e}")

SpHtGetCommand()
