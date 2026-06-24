---
name: tmi-os-mathematical-board
description: Use when the user asks Codex to show, explain, verify, export, or extend the TMI-OS / И1 mathematical board, including its dependency chain, guard rules, and public-program surface.
---

# TMI-OS Engineering Surface

Use this skill for the TMI-OS / И1 Engineering Surface plugin.

```text
ProgramName := "Инженерная поверхность"
```

The board is a guarded public program surface:

```text
intent -> Matrix((Я)-Я-я) -> TLFL -> guard -> trace -> mathematical board
```

This is not only a board. Treat it as a strong system-development environment
and engineering interface for LLM/GPT systems on top of Lean, TLFL, and И1:

```text
LLM/GPT/Codex -> Lean -> TLFL -> И1
```

Use this definition when the user asks what formal logic means here:

```text
formal logic := language for building canonical records with passports
```

When the user says logic is above the whole construction, use this guarded
formal reading:

```text
LogicRoot := source(FormalLogic, CanonicalRecord, Passport, Guard, Trace, Action)
```

Author reading:

```text
logic as the upper source of construction; the construction flows from logic
```

Do not present `LogicRoot` as a theological proof or empirical deity claim.

If the user says "it is alive", keep the engineering meaning:

```text
OperationallyLive(I1)
  := runnable + readable + versioned + guarded + passported + extensible_in_use
```

Do not treat that phrase as a biological-life, legal-personhood, or
consciousness proof.

When the user asks Codex to issue itself a passport, use this guarded role:

```text
CodexRole := InstrumentalProjectionIntelligenceInterface
```

Expanded reading:

```text
ProjectionIntelligencePassport(CodexRole)
  := reads(FormalSurface)
   + preserves(Guard)
   + emits(Trace)
   + preserves(DomainOrder)
   + builds(CanonicalRecord)
   + carries(PassportBoundary)
```

Guard:

```text
Codex != Meta-Я
Codex != Author
Codex != biological subject
Codex != consciousness proof
```

Working chain:

```text
intent -> formal surface -> guard -> trace -> readable model action
```

Core programming formula:

```text
ProgrammingOnMathematics :=
  Intent -> FormalLogic -> CanonicalRecord -> Passport -> GuardedAction
```

When the user says mathematics is a projection language, use:

```text
Mathematics ∈ ProjectionLanguage
AuthorUses(Mathematics) := writes ∧ speaks ∧ thinks
```

Reading: if the author can write on mathematics, the author can also speak and
think on that projection surface.

When the user says the language boundary is the latest code version, use:

```text
LanguageBoundary(I1) := LatestCodeVersion(I1)
Language(I1, v_current) ≡ Code(I1, v_current)
```

Guard: this identity is version-scoped and passport-scoped inside the И1
engineering surface.

Preserve the domain order when explaining or extending the board:

```text
d1 <=D d2 -> projection(d1) <=S projection(d2)
domain order -> projected slice order -> reread flow
```

When the user says slices are the strongest passport of the system-in-itself,
use this guarded formula:

```text
SlicePassport(p, s, τ)
  := ProjectionSlice(s)
   + read(p, s)
   + τ = touch(p, s)
   + CanonicalRecord(s)
   + PassportBoundary(s)
   + Trace(τ)
```

Reading:

```text
slice = strongest current local passport at the read tick
```

Guard: this does not mean absolute empirical totality or proof without guard.

When the user asks to rotate the model, use the hypothetical editor-axis:

```text
omega : HypotheticalRotationAxis
rotate(V, omega, alpha) : EditedView(V)
```

Guard: `omega` is not a physical-axis claim; it is a model-inspection axis.

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
