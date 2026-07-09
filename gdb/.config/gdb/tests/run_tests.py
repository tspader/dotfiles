#!/usr/bin/env python3
"""Smoke tests for the sp.h GDB visualizers (sp_da.py / sp_ht.py / sp_om.py).

Compiles tests/test_visualizers.c against examples/sp.h, runs it under gdb in
batch mode with the visualizer scripts sourced, then asserts on the command
output. Run directly:

    python3 tests/run_tests.py

Exits 0 if all checks pass, 1 otherwise. Requires gcc and gdb on PATH.
"""

import os
import re
import shutil
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)               # the gdb config dir (holds the .py scripts)
EXAMPLES = os.path.join(ROOT, "examples")  # holds sp.h / sp_om.h
SCRIPTS = ["sp_da.py", "sp_ht.py", "sp_om.py"]


def require(tool):
    path = shutil.which(tool)
    if not path:
        sys.exit(f"error: required tool '{tool}' not found on PATH")
    return path


def build(workdir):
    src = os.path.join(HERE, "test_visualizers.c")
    binary = os.path.join(workdir, "test_visualizers")
    cmd = [require("gcc"), "-g", "-O0", "-I", EXAMPLES, "-o", binary, src]
    proc = subprocess.run(cmd, capture_output=True, text=True)
    if proc.returncode != 0:
        sys.exit(f"error: compilation failed\n{proc.stderr}")
    return binary


def run_gdb(binary, workdir):
    cmds = os.path.join(workdir, "cmds.gdb")
    lines = ["set debuginfod enabled off", "set pagination off"]
    lines += [f"source {os.path.join(ROOT, s)}" for s in SCRIPTS]
    lines += [
        "break sp_test_break",
        "run",
        "up",  # select main()'s frame so its locals are in scope
        "echo \\n@@pda nums\\n",   "pda nums",
        "echo \\n@@da nums\\n",    "da nums",
        "echo \\n@@pda strs\\n",   "pda strs",
        "echo \\n@@pda pts\\n",    "pda pts",
        "echo \\n@@ht\\n",         "ht ht",
        "echo \\n@@htget\\n",      "htget ht 1",
        "echo \\n@@om\\n",         "om om",
        "echo \\n@@omn\\n",        "omn om 1",
        "echo \\n@@done\\n",
        "kill",
        "quit",
    ]
    with open(cmds, "w") as f:
        f.write("\n".join(str(l) for l in lines) + "\n")

    proc = subprocess.run(
        [require("gdb"), "-q", "-nx", "-batch", "-x", cmds, binary],
        capture_output=True, text=True, cwd=workdir,
    )
    return proc.stdout + proc.stderr


def section(output, name):
    """Return the text between marker @@<name> and the next @@marker."""
    m = re.search(r"@@" + re.escape(name) + r"\n(.*?)(?=\n@@|\Z)", output, re.S)
    return m.group(1) if m else ""


CHECKS = []


def check(name):
    def deco(fn):
        CHECKS.append((name, fn))
        return fn
    return deco


@check("pda renders int array with metadata")
def _(out):
    s = section(out, "pda nums")
    assert '"size": 5' in s, s
    assert '"capacity": 8' in s, s
    assert re.search(r"\b0,\s*\n\s*10,\s*\n\s*20,\s*\n\s*30,\s*\n\s*40\b", s), s


@check("da renders int array element-per-line")
def _(out):
    s = section(out, "da nums")
    for i, v in enumerate([0, 10, 20, 30, 40]):
        assert f"[{i}] = {v}" in s, s


@check("pda renders sp_str_t array as unquoted strings")
def _(out):
    s = section(out, "pda strs")
    assert '"type": "sp_str_t"' in s, s
    for w in ("alpha", "beta", "gamma"):
        assert f'"{w}"' in s, s


@check("pda renders struct array as nested objects")
def _(out):
    s = section(out, "pda pts")
    assert '"x": 1' in s and '"y": 2' in s, s
    assert '"x": 3' in s and '"y": 4' in s, s


@check("ht lists all active entries")
def _(out):
    s = section(out, "ht")
    assert "69 => 420" in s, s
    assert "1 => 2" in s, s
    assert "7 => 8" in s, s


@check("htget resolves the Nth active entry")
def _(out):
    s = section(out, "htget")
    # entry index 1 in iteration order is key 69 -> 420 (see `ht` output)
    assert "69" in s and "420" in s, s


@check("om lists entries in insertion order")
def _(out):
    s = section(out, "om")
    order = [s.index(k) for k in ("first", "second", "third")]
    assert all(i >= 0 for i in order), s
    assert order == sorted(order), f"not in insertion order: {s}"


@check("omn resolves Nth entry by insertion order")
def _(out):
    s = section(out, "omn")
    assert "second" in s, s
    assert "200" in s, s


def main():
    with tempfile.TemporaryDirectory() as workdir:
        binary = build(workdir)
        out = run_gdb(binary, workdir)

    if "@@done" not in out:
        print(out)
        sys.exit("error: gdb session did not complete (no @@done marker)")

    failures = 0
    for name, fn in CHECKS:
        try:
            fn(out)
            print(f"  ok   - {name}")
        except AssertionError as e:
            failures += 1
            print(f"  FAIL - {name}")
            detail = str(e).strip()
            if detail:
                print("\n".join("         " + ln for ln in detail.splitlines()))

    total = len(CHECKS)
    print(f"\n{total - failures}/{total} checks passed")
    if failures:
        print("\n--- full gdb output ---")
        print(out)
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
