# PIM-01 · The Film *Pi* as an interface model

**Status:** Lean-checked formal interpretation · release candidate without DOI or tag<br>
**Author:** Salkutsan Aleksey<br>
**ORCID:** 0009-0006-8717-0492<br>
**AI assistance:** Lina Amethyst — source audit, formalization, Lean implementation, and verification

## The line and the interface reading

In *Pi* (1998), Max says:

> “The number is nothing. It’s the meaning. The syntax. It’s what’s between the numbers.”

Here **interface** is the formal name for what the line points toward: a
carrier is presented, selected, and interpreted, while meaning may depend on
syntax and relations rather than on isolated signs.

The word `interface` is not spoken in the audited film transcript. The term is
our formal interpretation, not a hidden quotation or a claim that the film
contains Lean mathematics.

**Notation boundary:** *Pi* is the film title. The number π is one mathematical
motif in Max's world. The symbol `ρ` below names our selection of the relevant
relational layer; it is not the number π.

## Formal dictionary

- `x`: the presented carrier — digits, letters, a graph, an image, or a signal;
- `R x`: the structure of relations carried by `x`;
- `ρ`: the operator selecting the explicitly relevant relational layer;
- `I`: the observation/selection/encoding/interpretation interface;
- `μI x`: meaning relative to interface `I` and its context;
- `T`: a change of representation;
- `Φ`: an interpreter of the relevant relational structure.

The central factorization is:

```text
μI(x) = Φ(ρ(Rₓ(x)))
```

For a second representation:

```text
ρ(Rᵧ(T(x))) = ρ(Rₓ(x))
μI(x) = Φ(ρ(Rₓ(x)))
μJ(y) = Φ(ρ(Rᵧ(y)))
────────────────────────
μJ(T(x)) = μI(x)
```

Signs may therefore change while meaning is preserved — but only under the
stated relation-preservation and interpretation-alignment premises.

## TLFL carrier

- [`PiInterfaceModel.lean`](../../lean/TMI/InterfaceMathematics/PiInterfaceModel.lean)
- [`PiInterfaceModelAudit.lean`](../../lean/TMI/InterfaceMathematics/PiInterfaceModelAudit.lean)
- canonical dependency: `import TMI.Library`
- kernel: Lean 4.31.0-rc1

The formal carrier includes:

1. the interface pipeline `world → observation → data → carrier`;
2. meanings factored through a selected relational structure;
3. representation changes and semantic commutation;
4. invariants relative to an explicit transformation class;
5. a necessary condition for lossy transformations;
6. a counterexample separating world structure from observation structure;
7. state and memory;
8. a toy alphabet change whose selected relational meaning is preserved.

## Claim boundary

The kernel checks a conditional implication inside the stated model. It does
not prove that:

- the film discovered a hidden numerical code of nature;
- the selected structure `R` is objective or unique;
- gematria preserves semantic content;
- structural isomorphism alone fixes interpretation;
- every change of representation preserves meaning;
- the film itself asserts the formalism in this module.

The film supplies the line and the research problem. The interface model is a
separate, inspectable formal construction.

## Source coordinate

- Darren Aronofsky, *Pi* (1998), final-film line at approximately
  `01:12:34–01:12:48` in the audited English subtitle track.
- The quoted passage is short; all broader scene analysis remains paraphrased.
