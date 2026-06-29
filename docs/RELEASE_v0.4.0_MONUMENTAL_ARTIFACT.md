# TLFL v0.4.0-monumental-artifact

Release type: full publication-map release with guarded monumental artifact
node.

Date: 2026-06-29

## Summary

`v0.4.0-monumental-artifact` publishes the next full public TLFL/TMI-OS slice:
a repository-level navigation passport that links the formal TLFL library,
the TMI-OS / I1 engineering surface, publication snapshots, proof-status
artifacts, and claim-boundary notes.

This release does not raise the empirical status of any claim. It makes the
public map easier to review.

Public formula:

```text
MonumentalArtifact :=
  TLFL formal library
  + TMI-OS / I1 engineering surface
  + guarded passports
  + publication map
  + proof-status boundary
```

## Main Additions

- `publications/monumental_artifact_2026_06_29/README_RU.md` as the Russian
  public navigation passport.
- `publications/monumental_artifact_2026_06_29/MONUMENTAL_ARTIFACT_README_RU.pdf`
  as the rendered A4 PDF version.
- `publications/monumental_artifact_2026_06_29/POST_EN.md` as a short English
  public post.
- `publications/monumental_artifact_2026_06_29/SHA256SUMS.txt` as the local
  integrity passport for the added files.
- `publications/monumental_artifact_2026_06_29/figures/AUTHOR_VISUAL_CARD_INTERNAL_2026_06_29.png`
  as an internal author visual card linked from the passport, not used as
  public evidence.
- README, `docs/PASSPORT_INDEX.md`, and `docs/THEORY_LINKS.md` now link the
  new monumental artifact node.

## Public Links

```text
TLFL repository:
https://github.com/kernelpanic888/TMI-Lean-Formal-Library

TMI-OS repository:
https://github.com/osalkutsan-godaddy/TMI-OS

Elusive Graviton Zenodo snapshot:
https://doi.org/10.5281/zenodo.21011196

Proof/source package snapshot:
https://doi.org/10.5281/zenodo.20938776

LinkedIn public announcement trace:
https://www.linkedin.com/posts/oleksiy-salkutsan-276a40184_released-tlfl-v040-a-guarded-monumental-share-7477151831459180544-aU9c/
```

## Claim Boundary

Allowed:

- repository-level publication navigation;
- proof-status and artifact-status mapping;
- linking public publication snapshots;
- linking public announcement traces;
- linking internal author visual material as clearly bounded author material;
- SHA256 integrity checks for files added in this node.

Not allowed:

- empirical detection claims;
- physics consensus claims;
- treating diagrams as proofs;
- treating automated prover traces as empirical validation;
- treating author visual cards as public evidence;
- using LLM assistance as scientific authority.

Canonical guard:

```text
diagram != proof
candidate != detected particle
formal prover != empirical validation
LLM assistance != scientific authority
author visual card != public evidence
```

## Verification Status

Local checks completed for this release layer:

```text
SHA256SUMS: OK
PDF metadata: A4, 4 pages, no JavaScript, not encrypted
PDF render preview: visually checked
git diff --check: OK
```

The release is a publication-map release. It does not claim a new Lean theorem
pass beyond the previously documented TLFL proof-status gates.

## Release Assets

The GitHub release/tag should include:

- GitHub-generated source archives for tag `v0.4.0-monumental-artifact`;
- this release note;
- the monumental artifact folder:
  `publications/monumental_artifact_2026_06_29/`.
