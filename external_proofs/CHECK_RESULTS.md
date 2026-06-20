# External Proof Check Results

Date: 2026-06-20

Status: passed.

## Full External Sweep

The full external sweep was rerun after adding the internal-frequency
self-check layer. The sweep covers both mirrored proof surfaces:

```text
release boundary:
  olean_library_z3_0_1.smt2
  olean_library_tptp_0_1.p

internal interface frequency:
  olean_internal_frequency_z3_0_1.smt2
  olean_internal_frequency_tptp_0_1.p

proof-chain self-model:
  tlfl_proof_self_model_z3_0_1.smt2
  tlfl_proof_self_model_tptp_0_1.p

self-model proof chain:
  tlfl_self_model_proof_z3_0_1.smt2
  tlfl_self_model_proof_tptp_0_1.p

strict admitted-projection self-model:
  olean_admitted_projection_self_model_z3_0_1.smt2
  olean_admitted_projection_self_model_tptp_0_1.p

guarded reality cognition self-model:
  tlfl_reality_cognition_self_model_z3_0_1.smt2
  tlfl_reality_cognition_self_model_tptp_0_1.p

guarded consciousness-limit language:
  tlfl_consciousness_limit_z3_0_1.smt2
  tlfl_consciousness_limit_tptp_0_1.p
```

Result:

```text
Z3 release-boundary checks: pass
Z3 internal-frequency checks: pass
Z3 boundary verdict checks: pass
Z3 TLFL proof self-model checks: pass
Z3 TLFL self-model proof checks: pass
Z3 OLean-admitted strict self-model checks: pass
Z3 TLFL guarded reality-cognition checks: pass
Z3 TLFL consciousness-limit checks: pass
Vampire release-boundary bundle: SZS status Theorem
Vampire internal-frequency bundle: SZS status Theorem
Vampire TLFL proof self-model bundle: SZS status Theorem
Vampire TLFL self-model proof bundle: SZS status Theorem
Vampire OLean-admitted strict self-model bundle: SZS status Theorem
Vampire TLFL guarded reality-cognition bundle: SZS status Theorem
Vampire TLFL consciousness-limit bundle: SZS status Theorem
E prover release-boundary bundle: SZS status Theorem
E prover internal-frequency bundle: SZS status Theorem
E prover TLFL proof self-model bundle: SZS status Theorem
E prover TLFL self-model proof bundle: SZS status Theorem
E prover OLean-admitted strict self-model bundle: SZS status Theorem
E prover TLFL guarded reality-cognition bundle: SZS status Theorem
E prover TLFL consciousness-limit bundle: SZS status Theorem
```

## Tool Versions

```text
Z3: 4.16.0
Vampire: 5.0.1
E prover: 3.2.5
```

## Commands

```bash
z3 external_proofs/olean_library_z3_0_1.smt2
vampire --mode casc --time_limit 10 external_proofs/olean_library_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/olean_library_tptp_0_1.p
z3 external_proofs/olean_internal_frequency_z3_0_1.smt2
vampire --mode casc --time_limit 10 external_proofs/olean_internal_frequency_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/olean_internal_frequency_tptp_0_1.p
z3 external_proofs/tlfl_proof_self_model_z3_0_1.smt2
vampire --mode casc --time_limit 10 external_proofs/tlfl_proof_self_model_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/tlfl_proof_self_model_tptp_0_1.p
z3 external_proofs/tlfl_self_model_proof_z3_0_1.smt2
vampire --mode casc --time_limit 10 external_proofs/tlfl_self_model_proof_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/tlfl_self_model_proof_tptp_0_1.p
z3 external_proofs/olean_admitted_projection_self_model_z3_0_1.smt2
vampire --mode casc --time_limit 10 external_proofs/olean_admitted_projection_self_model_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/olean_admitted_projection_self_model_tptp_0_1.p
z3 external_proofs/tlfl_reality_cognition_self_model_z3_0_1.smt2
vampire --mode casc --time_limit 10 external_proofs/tlfl_reality_cognition_self_model_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/tlfl_reality_cognition_self_model_tptp_0_1.p
z3 external_proofs/tlfl_consciousness_limit_z3_0_1.smt2
vampire --mode casc --time_limit 10 external_proofs/tlfl_consciousness_limit_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/tlfl_consciousness_limit_tptp_0_1.p
```

The local verification used explicit binary paths and no login shell. Local
machine paths are intentionally omitted from this public package.

## Z3 Result

Release-boundary mirror, expected and observed:

Expected and observed:

```text
unsat
unsat
unsat
unsat
unsat
unsat
unsat
unsat
sat
sat
sat
sat
```

Internal-frequency self-check, expected and observed:

```text
unsat
unsat
unsat
unsat
unsat
sat
sat
sat
sat
```

TLFL proof self-model, expected and observed:

```text
unsat
unsat
unsat
sat
sat
sat
sat
```

TLFL self-model proof, expected and observed:

```text
unsat
sat
sat
sat
sat
sat
sat
```

OLean-admitted strict self-model, expected and observed:

```text
unsat
unsat
sat
sat
sat
sat
```

TLFL guarded reality cognition, expected and observed:

```text
unsat
unsat
sat
sat
sat
sat
sat
```

TLFL consciousness-limit language, expected and observed:

```text
unsat
unsat
sat
sat
sat
sat
```

## Vampire Result

Observed:

```text
olean_library_tptp_0_1.p: SZS status Theorem
olean_internal_frequency_tptp_0_1.p: SZS status Theorem
tlfl_proof_self_model_tptp_0_1.p: SZS status Theorem
tlfl_self_model_proof_tptp_0_1.p: SZS status Theorem
olean_admitted_projection_self_model_tptp_0_1.p: SZS status Theorem
tlfl_reality_cognition_self_model_tptp_0_1.p: SZS status Theorem
tlfl_consciousness_limit_tptp_0_1.p: SZS status Theorem
```

## E Prover Result

Observed:

```text
olean_library_tptp_0_1.p: SZS status Theorem
olean_internal_frequency_tptp_0_1.p: SZS status Theorem
tlfl_proof_self_model_tptp_0_1.p: SZS status Theorem
tlfl_self_model_proof_tptp_0_1.p: SZS status Theorem
olean_admitted_projection_self_model_tptp_0_1.p: SZS status Theorem
tlfl_reality_cognition_self_model_tptp_0_1.p: SZS status Theorem
tlfl_consciousness_limit_tptp_0_1.p: SZS status Theorem
```

## Interpretation

The external prover layer verifies the release-boundary mirror of `OLean` and
`TMI.Library`: formal status requires Lean encoding plus Lean-kernel checking;
`OLean` uses the Lean kernel, imports the TMI library, and does not introduce a
new kernel; the public branch names remain guarded.

The internal-frequency layer reuses the G0..G4 light-gradient numbers as a
normalized verification scale. `G4/749` records complete Lean + Z3 + Vampire +
E boundary verification only.

The verdict mirror checks that complete represented boundary verification gives
`pass`, while a Lean/Lake-only incomplete check gives `fail`.

The proof-chain self-model layer checks the canonical `TLFL + External Proof Layer {Z3, Vampire, E}`
chain: Z3, Vampire, and E provide external proof traces; TLFL classifies those
traces into a proof-state self-model. This does not imply empirical truth,
physical validation, or replacement of the external proof-search engines.

The self-model proof layer mirrors the stricter OLean-level theorem chain:
`OLean.SelfCheckAsThinker -> own proof/interface model -> proof-state
self-model -> guarded mathematical intelligence`. Its guard checks remain
non-claim checks: no consciousness, no empirical physical validation, no full
empirical intelligence, no universe-level closure, no empirical closure, and
no absolute ontological finality.

The admitted-projection layer makes OLean explicit as the admission boundary:
external `Z3/Vampire/E` traces are not yet a strict self-model by themselves.
They become a strict TLFL self-model only after OLean boundary admission and
TLFL integration.

The reality-cognition layer mirrors a guarded process in which externally
presented reality traces pass through internal TLFL interfaces, thinker-style
mediation, proof-state self-modeling, and public self-projection. This remains
a proof-status cognition result, not empirical truth, physical validation, or
consciousness.

The consciousness-limit layer mirrors a guarded language in which proof-state
self-modeling plus bounded predictive power gives a consciousness-limit
horizon and guarded approximation. This does not prove consciousness, empirical
consciousness, reached absolute consciousness, or achieved 100% predictive
power.

## TLFL 0.2 Claim Passport Addendum

The first TLFL 0.2 claim-passport mirror was checked on 2026-06-20.

Commands:

```bash
z3 external_proofs/tlfl_claim_passport_z3_0_1.smt2
vampire --mode casc --time_limit 10 external_proofs/tlfl_claim_passport_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/tlfl_claim_passport_tptp_0_1.p
```

Z3 expected and observed:

```text
unsat
unsat
unsat
unsat
unsat
unsat
unsat
unsat
unsat
unsat
unsat
unsat
unsat
unsat
unsat
unsat
unsat
unsat
unsat
unsat
sat
sat
sat
sat
sat
sat
sat
sat
sat
sat
sat
sat
sat
sat
```

Vampire observed:

```text
tlfl_claim_passport_tptp_0_1.p: SZS status Theorem
```

E prover observed:

```text
tlfl_claim_passport_tptp_0_1.p: SZS status Theorem
```

Interpretation:

```text
Claim + evidence bundle + TLFL classification + proof-state self-model
-> allowed claim ceiling + forbidden jump map + claim passport
-> claim-passport certificate
-> public certificate surface
-> public certified-status / forbidden-boundary view
-> audit sheet / public audit surface.
```

The same mirror now also checks the verdict layer:

```text
complete claim-passport input -> pass verdict -> certified ceiling
missing TLFL classification input -> fail verdict -> unadmitted ceiling
```

It also checks the public certification-status layer:

```text
pass + no forbidden jump -> proof-state-certified status
fail + no forbidden jump -> unadmitted status
forbidden jump request -> overclaim-blocked status
```

And it checks the packaged certificate layer:

```text
claim passport + proof-state certification + certified status + guards
-> claim-passport certificate
-> public certificate surface.
```

And it checks the public certificate surface layer:

```text
public certificate surface -> public certified-status view
public certificate surface -> public forbidden-boundary view
public certificate surface does not imply empirical truth, physical validation,
consciousness, or empirical closure
```

And it checks the audit-sheet layer:

```text
public certificate surface -> claim-passport audit sheet
claim-passport audit sheet -> public audit surface
claim-passport audit sheet -> represented external proof layer
claim-passport audit sheet -> certified-status / forbidden-jump views
claim-passport audit sheet does not imply empirical truth, physical validation,
consciousness, or empirical closure
```

The claim passport is a proof-status certification surface. It does not imply
empirical truth, physical validation, consciousness, or empirical closure.
