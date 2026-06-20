# Claim Boundary

This document fixes the public claim boundary of **TMI-Lean Formal Library
(TLFL) 0.1**.

## What TLFL 0.1 Claims

TLFL 0.1 claims that this repository contains a Lean 4 formal library with a
checked public boundary:

```text
TMI artifact
-> OLean encoding interface
-> Lean object
-> Lean kernel check
-> formal Lean status
```

It also claims a selected external proof mirror:

```text
Lean/Lake
+ Z3
+ Vampire
+ E prover
+ TLFL classification
-> proof-chain self-model
```

The canonical displayed chain is:

```text
Vampire/Z3/E/TLFL
```

## What TLFL Means By Proof Self-Model

`ProofChainSelfModel` is structured knowledge of proof status:

```text
which prover traces exist;
which verification boundary was used;
which prover compatibility was represented;
which non-claim guards are active;
which epistemic status is allowed.
```

Short formula:

```text
ProofSelfModel != empirical truth
ProofSelfModel = structured knowledge of proof status
```

## What `pass` Means

`OLean.CheckVerdict.pass` means that the represented boundary check is complete
inside the TLFL 0.1 release model:

```text
encoded in Lean
+ Lean-kernel checked
+ Lake build passed
+ Z3 passed
+ Vampire passed
+ E prover passed
+ no new kernel introduced
```

`pass` does not mean empirical closure.

## What TLFL 0.1 Does Not Claim

TLFL 0.1 does not claim:

```text
full empirical proof of TMI as a physical theory;
that the universe has been empirically proven to be the carrier of the full chain;
that a proof self-model is consciousness;
that TLFL replaces Lean, Z3, Vampire, or E;
that internal interface frequency is a physical speed-of-light theorem;
that guarded branches are already final physical laws.
```

## Role Of TLFL Relative To External Provers

Vampire, Z3, and E are proof engines.

TLFL is not a stronger proof search engine than Vampire. It is a higher-order
classification interface around proof traces. In this repository:

```text
Vampire/Z3/E produce proof traces.
TLFL classifies the proof state.
```

So TLFL stands one order higher as a meta-interface of proof status, not as a
replacement for the proof engines themselves.

## Guarded Branches

The public branch names `MD`, `QC`, `QG`, `LIFE`, and `OPS` are guarded branch
surfaces. They are part of the formal library vocabulary and organization.

Their presence in the library does not imply that their corresponding empirical
physical claims are already validated.

## One-Line Boundary

```text
TLFL 0.1 is a formal proof-status library, not a claim of empirical closure.
```
