# AZ-AUTH-00: canonical public authorship gate

## Status

`AZ-AUTH-00` is a fail-closed publication boundary for this repository. It is
not a statement about scientific merit or legal ownership. It answers a
narrower operational question before public Git history is accepted:

> Are the author, committer, tagger, remote and reachable technical records
> consistent with the canonical public identity of this repository?

The canonical Git identity is:

```text
name  = kernelpanic888
email = 48477233+kernelpanic888@users.noreply.github.com
repo  = kernelpanic888/TMI-Lean-Formal-Library
```

Scientific prose may state the author's human name. The gate concerns Git
metadata and technical coordinates; it must not erase attribution inside the
research itself.

## Closure rule

Let `L` be the local operator state, `H` the reachable history and `P` the
publication transition. Publication is admitted only when both checks pass:

```text
Admit(P) := Canonical(L) AND Clean(H)

Canonical(L) :=
  canonical name
  AND canonical no-reply email
  AND canonical origin
  AND no inherited signing key
  AND explicit user.useConfigOnly
  AND no forbidden technical coordinates in the proposed index

Clean(H) :=
  canonical commit authors
  AND canonical committers
  AND canonical annotated-tag taggers
  AND no forbidden technical coordinates in refs, messages, paths or blobs
```

If any term is false, the only allowed action is silence: no commit and no
publication.

## Local installation

```bash
git config user.name kernelpanic888
git config user.email 48477233+kernelpanic888@users.noreply.github.com
git config user.useConfigOnly true
git config --unset-all user.signingKey || true
git config commit.gpgSign false
git config tag.gpgSign false
git config core.hooksPath .githooks
./scripts/az-auth-00.sh
```

The committed pre-commit hook runs the local identity check and the reachable
history check. GitHub Actions independently repeats the history check on every
push and pull request.

## Incident protocol

The gate never rewrites history automatically. If it fails:

1. Freeze publication.
2. Preserve a complete local mirror and bundle.
3. Isolate the repository from inherited work profiles and signing keys.
4. Audit commits, tags, refs, paths, messages and reachable blobs.
5. Build a reproducible repaired mirror.
6. Prove structural preservation before any remote replacement.
7. Replace public refs atomically with exact force-with-lease expectations.
8. Remove blocking forks and request server-side dereference and cache purge.
9. Resume publication only after the public audit passes.

The red boundary is explicit: a convenient shell profile, cached credential or
successful push is never evidence that the acting identity is admissible.
