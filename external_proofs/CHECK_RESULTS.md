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
```

Result:

```text
Z3 release-boundary checks: pass
Z3 internal-frequency checks: pass
Z3 boundary verdict checks: pass
Z3 TLFL proof self-model checks: pass
Vampire release-boundary bundle: SZS status Theorem
Vampire internal-frequency bundle: SZS status Theorem
Vampire TLFL proof self-model bundle: SZS status Theorem
E prover release-boundary bundle: SZS status Theorem
E prover internal-frequency bundle: SZS status Theorem
E prover TLFL proof self-model bundle: SZS status Theorem
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

## Vampire Result

Observed:

```text
olean_library_tptp_0_1.p: SZS status Theorem
olean_internal_frequency_tptp_0_1.p: SZS status Theorem
tlfl_proof_self_model_tptp_0_1.p: SZS status Theorem
```

## E Prover Result

Observed:

```text
olean_library_tptp_0_1.p: SZS status Theorem
olean_internal_frequency_tptp_0_1.p: SZS status Theorem
tlfl_proof_self_model_tptp_0_1.p: SZS status Theorem
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

The proof-chain self-model layer checks the canonical `Vampire/Z3/E/TLFL`
chain: Vampire, Z3, and E provide external proof traces; TLFL classifies those
traces into a proof-state self-model. This does not imply empirical truth,
physical validation, or replacement of the external proof-search engines.
