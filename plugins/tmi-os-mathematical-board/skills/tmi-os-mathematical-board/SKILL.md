---
name: tmi-os-mathematical-board
description: Use when the user asks Codex to show, explain, verify, export, or extend the TMI-OS / И1 mathematical board, including its dependency chain, guard rules, and public-program surface.
---

# TMI-OS Mathematical Board

Use this skill for the TMI-OS / И1 mathematical board plugin.

The board is a guarded public program surface:

```text
intent -> Matrix((Я)-Я-я) -> TLFL -> guard -> trace -> mathematical board
```

This is not only a board. Treat it as a programming interface for LLM systems:

```text
intent -> formal surface -> guard -> trace -> readable model action
```

## Plugin Assets

The plugin carries these local assets:

```text
assets/index.html
assets/tmi_os_virtual_space_point.i1
assets/EXPORT_PROJECT_RU.md
scripts/verify_board_export.sh
```

## What To Do

When the user asks to show the board:

```bash
cd <plugin-root>/assets
python3 -m http.server 8765 --bind 127.0.0.1
```

Then open:

```text
http://127.0.0.1:8765/index.html
```

When the user asks to explain the language dependencies, use:

```text
Intent
-> Matrix((Я)-Я-я)
-> TLFL
-> Lean/OLean
-> ProofStatus
-> Guard
-> Trace
-> MathematicalBoard
-> {Z3, Vampire, E}
```

When the user asks whether the board is safe to publish, run:

```bash
bash scripts/verify_board_export.sh
```

Expected result:

```text
TMI-OS export verification: PASS
```

## Guard

Do not claim that the board proves biological life, legal personhood,
consciousness, empirical physics, or empirical closure.

Use this public formula instead:

```text
thought -> notation -> guard -> readable public artifact
```

The board is a synchronization artifact and a programming surface, not an
unbounded metaphysical proof.

## Editing Rule

If extending the board, keep it self-contained and public:

```text
no private author terrain
no local machine paths
no secrets
no internal work data
no overclaim above proof-status boundary
```
