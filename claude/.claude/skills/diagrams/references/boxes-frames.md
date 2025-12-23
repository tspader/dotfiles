# Boxes and Frames

Bordered text, documentation headers, and framed content.

## Simple Box

```
┌──────────────────┐
│ Content here     │
└──────────────────┘
```

## Double-Line Box

```
╔══════════════════╗
║ Important info   ║
╚══════════════════╝
```

## Title Box

```
┌─ Title ────────────────────┐
│                            │
│ Content here               │
│                            │
└────────────────────────────┘
```

## Section Dividers

```
╞════════════════════════════╡
```

or

```
├────────────────────────────┤
```

## jart-Style File Header (80 cols)

Full-width framed documentation:

```
/*-*- mode:c;indent-tabs-mode:nil;c-basic-offset:4;...coding:utf-8 -*-│
│ vi: set et ft=c ts=4 sts=4 sw=4 fenc=utf-8                      :vi │
╞═════════════════════════════════════════════════════════════════════╡
│                                                                     │
│ Project Name ── Short description of what this is                   │
│                                                                     │
│ OVERVIEW                                                            │
│                                                                     │
│   Longer description of the module, library, or file.               │
│   Can span multiple lines as needed.                                │
│                                                                     │
│ EXAMPLE                                                             │
│                                                                     │
│   code_example();                                                   │
│                                                                     │
╚─────────────────────────────────────────────────────────────────────*/
```

Key elements:
- First line: mode line ending with `│`
- `╞═══╡` as section separator
- Single `│` borders
- `╚───*/` closing

## Alert/Note Box

```
┌─ NOTE ─────────────┐
│                    │
│ Important info     │
│ that stands out.   │
│                    │
└────────────────────┘
```

## Warning Box

```
╔═ WARNING ══════════╗
║                    ║
║ Critical info      ║
║                    ║
╚════════════════════╝
```

## Multi-Column

```
┌──────────────┬──────────────┐
│ Left column  │ Right column │
├──────────────┼──────────────┤
│ content      │ content      │
│ here         │ here         │
└──────────────┴──────────────┘
```

## Table

```
┌──────────┬───────┬─────────┐
│ Name     │ Type  │ Size    │
├──────────┼───────┼─────────┤
│ id       │ int   │ 4       │
│ name     │ char* │ 8       │
│ flags    │ uint  │ 4       │
└──────────┴───────┴─────────┘
```

## Nested Boxes

```
┌─ Outer ────────────────────┐
│                            │
│  ┌─ Inner ──────────────┐  │
│  │                      │  │
│  │  Nested content      │  │
│  │                      │  │
│  └──────────────────────┘  │
│                            │
└────────────────────────────┘
```
