# Comparator Challenge Passport

This passport records the trusted browser-local challenge slice for the
standalone TLFL canonical passport used in Comparator-style checking.

## Passport Line

```text
You have previously chosen to trust this challenge in this browser (SHA256 b67c8f1be23b73884083beb319d530c9b89d9b8fd2a62c6e020226656c21855d)
```

## Subject

```text
Subject := TLFL_CANONICAL_PASSPORT_CHALLENGE
File := examples/lean/TLFL_CANONICAL_PASSPORT_CHALLENGE.lean
SHA256 := b67c8f1be23b73884083beb319d530c9b89d9b8fd2a62c6e020226656c21855d
Role := Comparator challenge / theorem target
```

## Paired Solution

```text
File := examples/lean/TLFL_CANONICAL_PASSPORT_SOLUTION.lean
SHA256 := 323a85d7dfe3eebfb72572292e98e188dd26915a5127b68abee624be400fb6c1
Role := Comparator candidate solution / proof body
```

## Passport Formula

```text
ComparatorChallengePassport :=
  identifies(challenge_file)
  ∧ preserves(challenge_hash)
  ∧ separates(challenge, solution)
  ∧ marks(challenge_tail, "sorry")
  ∧ marks(solution_tail, "simp [PassportCertified, canonicalPassport]")
  ∧ does_not_change(Lean_statement)
```

## Guard

This is a trust-surface passport only. It does not change the Lean statement,
the solution proof, the TLFL package passport, or any public claim boundary.
