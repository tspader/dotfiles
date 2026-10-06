---
description: Issue tracker and transcript search for Claude Code
argument-hint: Use the recall CLI to ...
---

Use the `recall` CLI to $ARGUMENTS

`recall` is a CLI on top of an indexed SQLite database of every Claude Code
thread ever.

To find a session, you can query, grep, or list all sessions:

```
recall query "something to vector search"
recall query "..." --dir ~/source/foo --since 2026-07-01   # -j for JSON
recall grep "regex|works" -i --dir ~/source/foo
recall list --dir ~/source/foo --since 2026-07-01
```

# session

To explore a known session, use `recall session $id`:

```
usage:
  recall session $id [options]

arguments
  id string session tag (SES-n), or session id (unique prefix ok) (required)

options
  -n, --limit     number  max stored blocks (default: entire thread)
      --tail      number  show only the last N stored blocks
      --before    string  messages before this uuid or timestamp
      --after     string  messages after this uuid or timestamp
      --around    string  messages centered on this uuid or timestamp
      --agent     string  read a subagent thread (agent id, unique prefix ok)
      --tools     boolean expand tool calls and inputs
      --results   boolean include tool result bodies and expand tool calls (implies --tools)
      --thinking  boolean include thinking blocks
      --cap       number  truncate message bodies to N chars (0 = no cap) (default: 1000)
      --db        string  database path (default from config)
      --skip-sync boolean skip index refresh
  -h, --help      boolean Show help

```

By default, `recall session` truncates long messages and doesn't print tool
call details. Use it to get your bearings, and then do targeted reads of full
turns as needed. Generally, tool calls aren't useful and spend a lot of your
context, so only ask for them when you have a reason to.

# blame

To find out why a line of code is the way it is, blame it against step
history. A step is one human prompt plus everything the agent did in
response; blame resolves a line to the step that wrote it, the prompt behind
it, and a pointer into the session at that point. Lines nobody's step wrote
show as `outside` (hand edits, formatters) or `working` (not yet in any
closed step).

```
recall blame src/foo.ts:42        # one line, then the whole step behind it
recall blame src/foo.ts           # every line
recall log src/foo.ts             # steps that touched the file, newest first
recall show $step                 # prompt, reply, files, parent, siblings, children
```

# issues

Unless you need to write to the issue tracker, the CLI's help text has
everything you need. If you do need to write, read `issues.md`. If you're
implementing for an issue, make sure to update it when done.

```
usage:
  recall issues $command

options
  -h, --help boolean Show help

commands
  list                   List root issues, most recently active first
  show       key         Print everything about one issue
  new        title       Open an issue
  retitle    key title   Replace the title
  describe   key body    Replace the body
  patch      key ops     Edit the body in place
  move       key repo    Move to another repo
  close      key         Mark done
  reopen     key         Mark open
  parent     key parent  Set the parent
  unparent   key         Clear the parent
  relate     key other   Relate two issues
  unrelate   key other   Unrelate two issues
  block      key blocker Add a blocker
  unblock    key blocker Remove a blocker
  link       key session Link a session
  unlink     key session Unlink a session
  note       key body    Add a note
  edit-note  id body     Replace a note's text
  patch-note id ops      Edit a note's text in place
  rm-note    id          Delete a note
  rm         key         Delete an issue; sub-issues move to its parent unless --to or --subs
```
