# External Proofs

TLFL 0.1 includes mirrored external proof files in the Zenodo package under:

```text
external_proofs/
```

These files check the public release boundary in Z3, Vampire and E prover. They
do not mirror every Lean theorem.

## Z3

```bash
z3 external_proofs/olean_library_z3_0_1.smt2
z3 external_proofs/olean_internal_frequency_z3_0_1.smt2
z3 external_proofs/tlfl_proof_self_model_z3_0_1.smt2
```

Expected pattern:

```text
theorem checks: unsat
guard checks: sat
```

## Vampire

```bash
vampire --mode casc --time_limit 10 external_proofs/olean_library_tptp_0_1.p
vampire --mode casc --time_limit 10 external_proofs/olean_internal_frequency_tptp_0_1.p
vampire --mode casc --time_limit 10 external_proofs/tlfl_proof_self_model_tptp_0_1.p
```

Expected:

```text
SZS status Theorem
```

## E Prover

```bash
eprover --auto --cpu-limit=10 external_proofs/olean_library_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/olean_internal_frequency_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/tlfl_proof_self_model_tptp_0_1.p
```

Expected:

```text
SZS status Theorem
```

## Boundary

The external proofs verify release-boundary claims only:

```text
OLean imports TMI.Library.
OLean uses the Lean kernel.
OLean does not introduce a new kernel.
TLFL is not a Lean fork.
Complete boundary verification gives internal frequency G4/749.
TLFL + External Proof Layer {Z3, Vampire, E} builds a proof-chain self-model.
```

They do not prove empirical physical validity.
