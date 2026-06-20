# Glossary

## TLFL

TMI-Lean Formal Library (TLFL). A Lean 4 library for formalizing TMI surfaces.
In the proof-chain layer, TLFL is also a meta-interface that classifies claims
by admissible proof path, verification boundary, prover compatibility, and
allowed epistemic status.

## TMI

Theory of Manifold Interfaces. In this package, TMI is encoded through Lean
definitions, structures, theorem surfaces, and guarded branch modules.

## OLean

The connection interface between TMI artifacts and Lean. OLean is not a new
kernel; it states how an artifact receives formal Lean status.

## Formal Lean Status

The status obtained when an artifact is encoded as a Lean object and checked by
the Lean kernel.

## Boundary Check Verdict

The pass/fail result returned by:

```text
OLean.boundaryCheckVerdict
```

`pass` means the represented release boundary is complete. `fail` means at
least one required boundary condition is missing.

## Internal Interface Frequency

A normalized verification-frequency scale reused from the G0..G4 light-gradient
row values. `G4/749` means complete boundary verification in TLFL. It is not a
physical light theorem.

## Guard

A formal non-claim boundary. Guards prevent a weaker condition from implying a
stronger claim, for example: external prover output without Lean-kernel checking
does not imply formal Lean status.

## Vampire/Z3/E/TLFL

The canonical proof-chain display order. Vampire, Z3, and E provide external
proof traces; TLFL classifies those traces into a proof-state self-model.

## Proof-Chain Self-Model

Structured knowledge of proof status: external proof traces, verification
boundary map, prover compatibility map, epistemic status map, and non-claim
guard map. A proof-chain self-model is not empirical truth.
