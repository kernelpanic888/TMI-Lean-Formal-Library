# TMI-Lean Formal Library (TLFL): What It Is And Why It Exists

## Short Statement

TMI-Lean Formal Library (TLFL) is a Lean 4 formal library for interface-event
theory and proof-status classification. It is not a fork of Lean and not a new
proof kernel. It is a library checked by the ordinary Lean kernel, with selected
release-boundary claims mirrored through Z3, Vampire, and E.

The canonical public verification wording is:

```text
TLFL + External Proof Layer {Z3, Vampire, E}
```

## Why TLFL Exists

A proof artifact does not speak for itself. A theorem, a model, an SMT query, or
an ATP result may be correct inside its own technical boundary, while still
leaving open what kind of claim has actually been established.

TLFL exists to formalize that boundary.

It asks:

- What is the claim?
- What evidence bundle admits the claim?
- Which proof path was used?
- Which verifier or prover checked the relevant surface?
- What is the strongest allowed status of the claim?
- Which conclusions are explicitly forbidden?
- How can this status be exposed publicly without overclaiming?

In this sense, TLFL is a meta-interface for proof status. It does not replace
Lean, Z3, Vampire, or E. It classifies the proof-state they help produce.

## The Core Idea

TLFL treats a claim as part of a structured process:

```text
claim
-> evidence bundle
-> admissible proof path
-> verification boundary
-> prover compatibility
-> allowed claim ceiling
-> forbidden jump map
-> proof-state self-model
-> public certificate / audit surface
```

This makes the proof package inspectable. A reader can see not only that
something passed, but also what kind of pass it was and what it does not imply.

## OLean

OLean is the connection and admission interface inside TLFL. It connects TLFL
artifacts to Lean-kernel checking. It does not introduce a new kernel.

OLean asks whether the represented boundary is complete:

```text
encoded in Lean
+ checked by Lean kernel
+ built by Lake
+ represented external proof layer where required
+ no new kernel introduced
```

Complete represented checks return `pass`; incomplete checks return `fail`.

## Proof-State Self-Model

TLFL also formalizes a proof-state self-model. This means the system records a
structured model of its own proof status:

```text
external proof traces
+ OLean admission boundary
+ TLFL classification
+ proof-state maps
+ non-claim guards
-> proof-state self-model
```

This is not consciousness and not empirical truth. It is structured knowledge
of proof status.

## Claim Passport

The TLFL claim-passport layer turns a claim and its proof-state boundary into a
public certificate. The passport records:

- claim object;
- evidence bundle;
- Lean trace;
- Z3/Vampire/E traces where applicable;
- TLFL classification;
- proof-state self-model;
- allowed claim ceiling;
- forbidden jumps.

The public certificate and audit sheet allow a reader to inspect the status of a
claim without raising the claim beyond its justified boundary.

## What TLFL Claims

TLFL claims:

- a Lean 4 formal library for interface-event theory;
- an OLean admission boundary to Lean-kernel checking;
- a proof-status classification layer;
- a proof-state self-model layer;
- claim passports, public certificates, audit sheets, review gates, and release
  gates for proof-status reporting;
- external proof mirrors for selected release-boundary claims.

## What TLFL Does Not Claim

TLFL does not claim:

- empirical proof of TMI as physics;
- physical validation of universe-level claims;
- consciousness;
- empirical closure;
- a new Lean kernel;
- replacement of Z3, Vampire, or E;
- that external prover output alone is enough for full formal status.

## Why It Matters

TLFL is useful when a formal project needs more than theorem files. It gives a
vocabulary for proof status, claim ceilings, forbidden jumps, public audit
surfaces, and reproducible verification boundaries.

The goal is practical honesty: make proof packages easier to inspect, easier to
review, and harder to misread.

## Author

Salkutsan Aleksey

ORCID:

```text
https://orcid.org/0009-0006-8717-0492
```

Zenodo:

```text
https://doi.org/10.5281/zenodo.20773095
```

