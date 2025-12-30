# Sequence Diagrams

Message flows, timelines, and actor interactions.

## Basic Sequence

```
Client          Server          Database
  │                │                │
  │   request      │                │
  │───────────────▶│                │
  │                │    query       │
  │                │───────────────▶│
  │                │                │
  │                │    result      │
  │                │◀───────────────│
  │   response     │                │
  │◀───────────────│                │
  │                │                │
```

## With Lifelines

```
  Client           Server          Database
    │                │                │
    │   connect()    │                │
    │───────────────▶│                │
    │                ├────┐           │
    │                │    │ auth      │
    │                │◀───┘           │
    │                │                │
    │   query(sql)   │                │
    │───────────────▶│   execute()    │
    │                │───────────────▶│
    │                │    rows        │
    │                │◀───────────────│
    │   data         │                │
    │◀───────────────│                │
    │                │                │
```

## Self-Call

```
    Object
      │
      ├────┐
      │    │ self.process()
      │◀───┘
      │
```

## Async Messages

```
Sender              Receiver
  │                    │
  │   async msg        │
  │- - - - - - - - - -▶│
  │                    │
  │   callback         │
  │◀- - - - - - - - - -│
  │                    │
```

Dashed lines indicate async.

## Timeline

```
     0ms    100ms   200ms   300ms   400ms   500ms
      │       │       │       │       │       │
      ├───────┴───────┴───────┴───────┴───────┤
      │                                       │
Task1 │████████████                           │
Task2 │        ░░░░░░░░████████               │
Task3 │                    ░░░░████████████████│
      │                                       │
      └───────────────────────────────────────┘

████ = running
░░░░ = waiting
```

## Request/Response Pairs

```
  A                B                C
  │                │                │
  │──── req1 ─────▶│                │
  │                │──── req2 ─────▶│
  │                │◀─── resp2 ────│
  │◀─── resp1 ────│                │
  │                │                │
```

## Activation Boxes

```
Client              Server
  │                   │
  │    request()      │
  │──────────────────▶│
  │                   ║
  │                   ║ processing
  │                   ║
  │    response()     ║
  │◀──────────────────║
  │                   │
```

`║` indicates active processing.

## Protocol Exchange

```
Client                          Server
  │                               │
  │ ──── SYN ───────────────────▶ │
  │ ◀─── SYN-ACK ─────────────── │
  │ ──── ACK ───────────────────▶ │
  │                               │
  │ ════ DATA ═════════════════▶ │
  │ ◀═══ DATA ═════════════════ │
  │                               │
  │ ──── FIN ───────────────────▶ │
  │ ◀─── FIN-ACK ─────────────── │
  │                               │
```

## Compact Format

```
A → B: request
B → C: forward
C → B: reply
B → A: response
```
