# Tree Diagrams

Directory structures, hierarchies, and organizational charts.

## Directory Tree

```
project/
├── src/
│   ├── main.c
│   ├── utils.c
│   └── utils.h
├── include/
│   └── project.h
├── tests/
│   ├── test_main.c
│   └── test_utils.c
├── Makefile
└── README.md
```

Characters:
- `├──` branch with siblings below
- `└──` last item in branch
- `│   ` vertical continuation

## Deep Nesting

```
root/
├── level1/
│   ├── level2/
│   │   ├── level3/
│   │   │   └── deep.txt
│   │   └── file.txt
│   └── other.txt
└── sibling/
    └── file.txt
```

## With Annotations

```
src/
├── main.c          # entry point
├── config.c        # configuration loading
├── config.h
├── network/
│   ├── socket.c    # TCP/UDP handling
│   ├── http.c      # HTTP client
│   └── tls.c       # TLS wrapper
└── utils/
    ├── string.c
    └── memory.c    # custom allocator
```

## Org Chart (vertical)

```
                 ┌───────────┐
                 │    CEO    │
                 └─────┬─────┘
           ┌───────────┼───────────┐
           ▼           ▼           ▼
      ┌────────┐  ┌────────┐  ┌────────┐
      │  CTO   │  │  CFO   │  │  COO   │
      └───┬────┘  └────────┘  └───┬────┘
    ┌─────┴─────┐           ┌─────┴─────┐
    ▼           ▼           ▼           ▼
┌───────┐  ┌───────┐   ┌───────┐  ┌───────┐
│ Dev 1 │  │ Dev 2 │   │ Ops 1 │  │ Ops 2 │
└───────┘  └───────┘   └───────┘  └───────┘
```

## Class Hierarchy

```
        Object
           │
     ┌─────┴─────┐
     ▼           ▼
  Vehicle     Animal
     │           │
  ┌──┴──┐     ┌──┴──┐
  ▼     ▼     ▼     ▼
 Car  Truck  Dog   Cat
```

## Parse Tree

```
        expr
       ╱    ╲
    term     +
   ╱    ╲     ╲
factor   *    term
  │      │      │
  3      │    factor
       factor    │
         │       2
         4
```

## Decision Tree

```
                  [age > 30?]
                 ╱           ╲
              yes             no
             ╱                 ╲
      [income > 50k?]      [student?]
       ╱         ╲          ╱      ╲
     yes         no       yes      no
      │           │        │        │
   approve     deny    approve   deny
```

## ASCII-Only Tree

When Unicode unavailable:

```
project/
+-- src/
|   +-- main.c
|   +-- utils.c
|   `-- utils.h
+-- tests/
|   `-- test.c
`-- Makefile
```
