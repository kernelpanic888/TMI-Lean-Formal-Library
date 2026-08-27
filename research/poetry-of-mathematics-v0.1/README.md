# PM-01 · Poetry of Mathematics / Поэзия математики

This directory is the complete internal Lean theory behind the public PM-01
reader. The reader is for people; this package is for deep verification.

Эта директория — цельная внутренняя Lean-теория публичного ридера PM-01. Сайт
предназначен для людей; этот пакет — для глубокого погружения и проверки.

## Formal chain / Формальная цепь

`E = ℝ³`
→ bounded segment `S → p`
→ hard-shadow membership
→ extended-source irradiance integral
→ normalized field `σ`
→ derived identity `E_U = E_0(1 − σ)`
→ `0 ≤ σ ≤ 1` under explicit radiometric hypotheses
→ projected-tangency boundary inclusion
→ boundary equality under an explicit two-sided regularity contract
→ structural beauty candidate `B = C + I + G + R`
→ a reality-trace candidate only with a separate `Checked` witness
→ hypotheses `H_i` on nonnegative orbits around a confirmed core `C`
→ free angular interpretation `dθ` with `dr = 0`
→ inward motion and fact promotion only with independent verification
→ pinned upstream `StatisticalManifold` / Fisher–Rao foundation from Spectra
→ `AmariVerificationLayer`: TLFL status and verification over that base
→ poetry modeled as a readable interface to magic, not its synonym.

The package also encodes a hard status boundary: the metaphysical canon is an
author interpretation, not a kernel theorem; “other worlds” remain outside the
formal theory.

Пакет также кодирует жёсткую границу статусов: метафизический канон является
авторской интерпретацией, а не теоремой ядра; «иные миры» остаются за пределами
формальной теории.

## Reproduce / Воспроизведение

```bash
lake build PoetryOfMathematics PoetryOfMathematicsAudit
lake env lean PoetryOfMathematicsAudit.lean
vampire --mode casc --time_limit 30 --proof tptp HypothesisOrbitGate.p
eprover --auto --cpu-limit=30 --proof-object=1 --tstp-out HypothesisOrbitGate.p
```

Release gates:

- no `sorry`, `admit`, or project-defined `axiom`;
- the theory and the separate axiom audit must both compile;
- imported theorem dependencies are reported by `#print axioms`;
- physical and geometric hypotheses remain named inputs rather than being
  smuggled in as conclusions.
- the first-order gate mirror and full Vampire/E proof traces remain beside the
  Lean carrier.
- the Spectra information-geometry dependency is locked to an exact upstream
  commit; only its targets that compile against TLFL's final Mathlib pin are
  imported.

## Hypothesis orbit geometry / Геометрия орбит гипотез

`VerifiedCore`, `HypothesisOrbitFamily`, `HypothesisState`, `rotateBy`, and
`AdmissibleMove` formalize the release invariant:

```text
interpretation: any dθ, dr = 0, status' = status
radial approach: dr < 0 -> IndependentlyVerified(H_i)
fact promotion: hypothesis -> verifiedFact -> IndependentlyVerified(H_i)
```

The public reader is
`../../exports/chertogi_first_distinction_public/readers/poetry-of-mathematics/index.html`.
Current release notes are in
`RELEASE_HYPOTHESIS_ORBIT_GEOMETRY_v0.2.0.md`; the English release image is
stored under that reader's `assets/` directory. The live reader and home banner
share `hypothesis-orbit-wrapper.js`, whose finite checks live beside it.

The thematic LinkedIn post about flow, interface, trace, interpretation space,
verification and action is cited as motivation, not as a formal premise.

The Fisher–Rao foundation is imported rather than recreated:
`AmariVerificationLayer` contains Spectra's upstream `StatisticalManifold` and
adds TLFL's explicit epistemic status and verification predicate. The exact
pin, attribution and compatibility audit are recorded in
`SPECTRA_UPSTREAM.md`.

This does **not** yet identify the abstract orbit radius with Fisher–Rao
distance, KL divergence or a geodesic coordinate. Spectra's downloaded
Amari–Chentsov / alpha-connection source is not imported into the TLFL build:
its current revision targets an earlier Mathlib release-candidate API and the
chain fails against final `v4.31.0`. TLFL does not patch or relabel that
upstream source.

## Claim ceiling / Потолок утверждений

Lean verifies the definitions, algebra, order bounds, integral monotonicity,
set inclusion, conditional equality, and the stated hypothesis-gate
invariants. It does **not** empirically validate
geometric optics, infer smoothness/visibility assumptions for an arbitrary
scene, turn beauty into evidence, derive an external check from beauty, or
prove the poetic/metaphysical reading. It also does not prove that a real
verification process is independent or that the orbit radius is an
information-geometric distance.

Lean проверяет определения, алгебру, границы порядка, монотонность интеграла,
включение множеств и условное равенство. Он **не** выполняет эмпирическую
валидацию геометрической оптики, не выводит условия гладкости/видимости для
произвольной сцены, не превращает красоту в свидетельство, не выводит внешнюю
проверку из красоты и не доказывает поэтическое или метафизическое прочтение.
