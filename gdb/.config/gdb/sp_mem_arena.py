import gdb
import gdb.printing


GRAY = "\x1b[90m"
GREEN = "\x1b[32m"
RESET = "\x1b[0m"


def _human_bytes(n):
  n = int(n)
  if n < 1024:
    return f"{n}B"
  if n < 1024 * 1024:
    return f"{n/1024:.1f}KB"
  return f"{n/(1024*1024):.1f}MB"


def _bar(used, capacity, width=32):
  used, capacity = int(used), int(capacity)
  filled = min(width, round(width * used / capacity))
  if used > 0 and filled == 0:
    filled = 1
  return (
    f"{GRAY}[{RESET}"
    + "█" * filled
    + f"{GRAY}{'◦' * (width - filled)}]{RESET}"
  )


def _deref(val):
  if val.type.code == gdb.TYPE_CODE_PTR:
    return None if int(val) == 0 else val.dereference()
  return val


def _walk_blocks(arena):
  """Yield (idx, capacity, bytes_used, status) per block."""
  current_addr = int(arena['current'])
  block = arena['head']
  idx = 0
  passed_current = False
  while int(block):
    b = block.dereference()
    is_current = int(block) == current_addr
    status = "current" if is_current else ("free" if passed_current else "live")
    bytes_used = 0 if passed_current else int(b['bytes_used'])
    yield idx, int(b['capacity']), bytes_used, status
    if is_current:
      passed_current = True
    block = b['next']
    idx += 1


class SpMemArenaPrinter:
  def __init__(self, val):
    self.val = val

  def children(self):
    arena = _deref(self.val)
    if arena is None:
      return
    for f in arena.type.fields():
      yield (f.name, arena[f.name])
    total_used = 0
    total_cap = 0
    num_blocks = 0
    for _i, cap, used, status in _walk_blocks(arena):
      total_cap += cap
      total_used += used
      num_blocks += 1
    yield ("bytes_used", gdb.Value(total_used))
    yield ("capacity",   gdb.Value(total_cap))
    yield ("num_blocks", gdb.Value(num_blocks))


class _Lookup:
  tag = 'sp_mem_arena_lookup'

  def __call__(self, val):
    t = val.type
    if t.code == gdb.TYPE_CODE_PTR:
      t = t.target()
    if t.name == 'sp_mem_arena_t':
      return SpMemArenaPrinter(val)
    return None


gdb.pretty_printers[:] = [p for p in gdb.pretty_printers
              if getattr(p, 'tag', None) != 'sp_mem_arena_lookup']
gdb.pretty_printers.append(_Lookup())


class PrintSpMemArenaCommand(gdb.Command):
  def __init__(self):
    super().__init__("arena", gdb.COMMAND_DATA)

  def invoke(self, argument, from_tty):
    try:
      arena = _deref(gdb.parse_and_eval(argument))
    except gdb.error as e:
      print(f"arena: {e}")
      return
    if arena is None:
      print("0x0 <null sp_mem_arena_t*>")
      return
    color = {"current": GREEN, "free": GRAY, "live": ""}
    for it, cap, used, status in _walk_blocks(arena):
      idx = f"{color[status]}[{it}]{RESET}" if color[status] else f"[{it}]"
      print(f"{idx} {_bar(used, cap)} {_human_bytes(used)} / {_human_bytes(cap)}")


PrintSpMemArenaCommand()
