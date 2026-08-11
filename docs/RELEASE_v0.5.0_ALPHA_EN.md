# TLFL v0.5.0-alpha

Release type: experimental interface-foundations layer.

Date: 2026-07-30.

## Purpose

`v0.5.0-alpha` adds a separate formal vocabulary for the current interface
research program. The stable aggregate import `TMI.Library` is not replaced by
the experiment. The new layer is requested explicitly:

```lean
import TMI.InterfaceFoundationsAlpha
```

## Geometry

```text
L <-> Sigma <-> R

merge
| PlanckTouch
| admissible interface corridor
| HorizonTouch
| loss of contact
```

`PlanckTouch` is read as the lower boundary of admissible distinguishable
contact. `HorizonTouch` is read as an excluded upper boundary that admissible
states may approach. A lower boundary does not by itself prove that an upper
boundary exists.

## Formal Records

- `TwoSidedLanguage` records `L`, `R`, the interface `Sigma`, forward and
  reverse contact, evolution, backreaction, memory, and energy.
- `ThirdBodyRecord` separates the third-body criterion from metaphor.
- `InterfaceCorridor` records two boundaries and admissible states between
  them.
- `HorizonApproach` provides an abstract neighborhood system for an excluded
  limiting touch.
- `TimeRelation` relates physical event time to internal record time.
- `PredictionGate` requires improvement over a baseline error.
- `PrecisionBoundary` records `gap != measurement error`.

## Red Boundary

The release does not claim:

- empirical physics validation;
- detection of an external super-domain;
- a proof of consciousness;
- identity between the authorial geometry and the structure of the universe;
- existence of `HorizonTouch` from `PlanckTouch` alone.

Module status: `experimental`.

## Route to v0.5.0

A stable release requires:

1. a Lean build;
2. an axiom and import audit;
3. compatibility checking against the current toolchain;
4. a nontrivial corridor model;
5. a connection to an observable or computable prediction task;
6. synchronized bilingual documentation.
