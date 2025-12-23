# Memory Layout Diagrams

Show data structures, memory regions, and pointer relationships.

## Basic Structure

```
┌──────────┬──────────┬──────────┐
│  field1  │  field2  │  field3  │
└──────────┴──────────┴──────────┘
```

## With Sizes

```
┌──────────┬──────────┬──────────┐
│  field1  │  field2  │  field3  │
│  4 bytes │  8 bytes │  4 bytes │
└──────────┴──────────┴──────────┘
```

## Pointer Annotations

Use vertical lines with labels to show references:

```
       ptr
        │
        ▼
┌───────┬───────┬───────┐
│ data  │ next  │ prev  │
└───────┴───┬───┴───────┘
            │
            ▼
         [next node]
```

## Register/Segment Style (jart)

Show a reference point intersecting the structure:

```
           x28
        %tpidr_el0
            │
            │    _Thread_local
        ┌───┼───┬──────────┬──────────┐
        │tib│dtv│  .tdata  │  .tbss   │
        ├───┴───┴──────────┴──────────┘
        │
    __get_tls()
```

Key techniques:
- `┼` where pointer intersects box
- Labels above/below the pointer line
- `├` to show continuation/function reference

## Multi-Platform Layout

```
                          __get_tls()
                              │
                             %fs Linux/BSD
           _Thread_local      │
    ┌───┬──────────┬──────────┼───┐
    │pad│  .tdata  │  .tbss   │tib│
    └───┴──────────┴──────────┼───┘
                              │
                 Windows/Mac %gs
```

## Nested Structures

```
┌─────────────────────────────────┐
│ outer_struct                    │
│  ┌────────────┬────────────┐    │
│  │ inner.a    │ inner.b    │    │
│  └────────────┴────────────┘    │
│  ┌─────────────────────────┐    │
│  │ data[]                  │    │
│  └─────────────────────────┘    │
└─────────────────────────────────┘
```

## Stack Frame

```
        high addresses
              │
    ┌─────────┴─────────┐
    │   return addr     │
    ├───────────────────┤
    │   saved rbp       │ ← rbp
    ├───────────────────┤
    │   local var 1     │
    ├───────────────────┤
    │   local var 2     │ ← rsp
    └─────────┬─────────┘
              │
        low addresses
```

