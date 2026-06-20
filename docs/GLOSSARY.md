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

## TLFL + External Proof Layer {Z3, Vampire, E}

The canonical proof-chain display order. Z3, Vampire, and E provide external
proof traces; TLFL classifies those traces into a proof-state self-model.

## Proof-Chain Self-Model

Structured knowledge of proof status: external proof traces, verification
boundary map, prover compatibility map, epistemic status map, and non-claim
guard map. A proof-chain self-model is not empirical truth.

## Claim Passport

A TLFL proof-status certificate for a claim. It records the claim object,
evidence bundle, proof-state self-model, claim classification, allowed claim
ceiling, and forbidden jump map. It does not imply empirical truth.

## Claim Ceiling

The strongest status a claim is allowed to support inside TLFL. For the first
TLFL 0.2 slice, the canonical passport ceiling is proof-state certification,
not empirical closure.

## Claim Passport Verdict

The computable `pass/fail` verdict for a claim-passport input. A complete input
with claim presentation, Lean trace, Z3/Vampire/E traces, TLFL classification,
non-claim guard trace, and proof-state self-model trace returns `pass`. Missing
TLFL classification returns `fail`.

## External Reality Trace

An externally presented trace, measurement-record input, or verification input
that can be represented at a TLFL interface boundary.

## Guarded Reality Cognition

The formal TLFL process in which an external trace enters internal interfaces,
is projected into a model, mediated by the thinker role, classified by TLFL, and
stored in the proof-state self-model. It is not empirical truth or physical
validation.

## Consciousness Limit Horizon

A guarded TLFL language surface that treats consciousness as an unreachable
limit of self-modeling: complete self-model plus perfect predictive power. It
is not a proof that any system is conscious.

## Guarded Consciousness Approximation

A bounded formal approximation surface: proof-state self-model, bounded
predictive power, and correction boundary. It does not imply empirical
consciousness, reached consciousness, or 100% predictive power.
