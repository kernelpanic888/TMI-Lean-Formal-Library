# Passport Audience Intros

Ready-to-use short intros for showing the TLFL Library Passport to different
audiences.

## Lean Community Intro

```text
Hi! I’m preparing a Lean 4 package for technical review.

Instead of a long introduction, here is the package passport:
https://github.com/kernelpanic888/TMI-Lean-Formal-Library/blob/llm-gpt-codex-lean-tlfl-i1/latest-public-surface/docs/TLFL_LIBRARY_PASSPORT.md

It states the package identity, canonical imports, build commands, proof-status
boundary, claims/non-claims, and the review request.

I’d appreciate feedback on Lake packaging, imports, module boundaries, naming,
documentation, and Reservoir readiness.
```

## Lean Community Intro With MWE

```text
Hi! I’m preparing a standalone Lean 4 package for technical review.

Here is the package passport:
https://github.com/kernelpanic888/TMI-Lean-Formal-Library/blob/llm-gpt-codex-lean-tlfl-i1/latest-public-surface/docs/TLFL_LIBRARY_PASSPORT.md

Here is a minimal working example after cloning the repo:
https://github.com/kernelpanic888/TMI-Lean-Formal-Library/blob/llm-gpt-codex-lean-tlfl-i1/latest-public-surface/examples/lean/TLFL_MWE.lean

It can be checked with:
lake env lean examples/lean/TLFL_MWE.lean

I’d appreciate feedback on Lake packaging, imports, module boundaries, naming,
documentation, and Reservoir readiness.
```

## Wider Public Intro

```text
Я показываю не манифест, а паспорт библиотеки.

Паспорт отвечает на простые вопросы:
кто пакет, где лежит, как собирается, что импортировать, что проверено,
что НЕ утверждается, и какой review нужен.

TLFL Library Passport:
https://github.com/kernelpanic888/TMI-Lean-Formal-Library/blob/llm-gpt-codex-lean-tlfl-i1/latest-public-surface/docs/TLFL_LIBRARY_PASSPORT.md
```

## Short Formula

```text
ShowPassport :=
  one_link
  + build_commands
  + non_claims
  + review_request
```

## Guard

```text
Do not start with a total-theory claim.
Start with package, build, import, boundary, review.
```
