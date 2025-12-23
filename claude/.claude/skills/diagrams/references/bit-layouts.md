# Bit Layout Diagrams

Show register bits, flags, and binary format fields.

## Cascading Labels (jart style)

Labels with arrows pointing to bit positions:

```
//  8087 FPU Control Word
//   IM: Invalid Operation ───────────────┐
//   DM: Denormal Operand ───────────────┐│
//   ZM: Zero Divide ───────────────────┐││
//   OM: Overflow ─────────────────────┐│││
//   UM: Underflow ───────────────────┐││││
//   PM: Precision ──────────────────┐│││││
//   PC: Precision Control ───────┐  ││││││
//    {float,∅,double,long double}│  ││││││
//   RC: Rounding Control ──────┐ │  ││││││
//    {even, →-∞, →+∞, →0}      │┌┤  ││││││
//                             ┌┤││  ││││││
//                            d││││rr││││││
1:  .short  0b0001101111111
```

Key techniques:
- Right-align the arrows to the bit position
- Use `┐` for the top of arrow columns
- Use `│` to extend down
- Use `┤` where arrows merge into groups

## Boxed Bit Fields

```
┌───┬───┬───┬───┬───┬───┬───┬───┐
│ 7 │ 6 │ 5 │ 4 │ 3 │ 2 │ 1 │ 0 │
└─┬─┴─┬─┴───┴───┴─┬─┴───┴───┴─┬─┘
  │   │           │           │
  │   │           │           └─ LSB
  │   │           └─ field A (3 bits)
  │   └─ reserved
  └─ MSB / sign
```

## Register Diagram

```
63       48 47       32 31       16 15        0
┌──────────┬───────────┬───────────┬──────────┐
│ unused   │  segment  │   index   │  offset  │
└──────────┴───────────┴───────────┴──────────┘
```

## Flags Register

```
OF DF IF TF SF ZF    AF    PF    CF
 │  │  │  │  │  │     │     │     │
 ▼  ▼  ▼  ▼  ▼  ▼     ▼     ▼     ▼
┌──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐
│11│10│ 9│ 8│ 7│ 6│ 5│ 4│ 3│ 2│ 1│ 0│
└──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┘
```

## Packet Header

```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
├─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┼─┤
│Version│  IHL  │   DSCP    │ECN│          Total Length         │
├───────────────┴───────────┴───┼───────────────────────────────┤
│         Identification        │Flags│      Fragment Offset    │
├───────────────────────────────┼─────┴─────────────────────────┤
│  Time to Live │   Protocol    │         Header Checksum       │
├───────────────┴───────────────┴───────────────────────────────┤
│                       Source IP Address                       │
├───────────────────────────────────────────────────────────────┤
│                    Destination IP Address                     │
└───────────────────────────────────────────────────────────────┘
```

## Enum/Option Values

```
Mode bits [1:0]:
  00 ─── disabled
  01 ─── read-only
  10 ─── write-only
  11 ─── read-write
```
