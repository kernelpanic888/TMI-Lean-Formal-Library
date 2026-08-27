# PM-01 · Hypothesis Orbit Geometry v0.1.0

## English

This topic release extends the existing PM-01 Lean 4 theory with a compact
epistemic geometry around a verified factual core:

- `VerifiedCore` records the center `C` and its explicit confirmation witness;
- `HypothesisOrbitFamily` places named hypotheses `H_i` at radii `r_i`;
- `rotateBy` realizes arbitrary angular interpretation `dθ` with `dr = 0`;
- `AdmissibleMove` requires independent verification for `dr < 0`;
- promotion from `hypothesis` to `verifiedFact` requires the same witness;
- the main theorem states that interpretation changes angle, not fact status.

The release image is English-only:

`../../exports/chertogi_first_distinction_public/readers/poetry-of-mathematics/assets/hypothesis-orbit-geometry-release-en.png`

SHA-256:
`959e547115393e38e50ff5933e357588d94efd3821990b751dce7e60f873be39`

### Independent proof checks

- Lean 4.31.0 + Mathlib `v4.31.0`: both package targets pass;
- Vampire 5.0.1: `SZS status Theorem`, full TSTP proof stored in
  `HypothesisOrbitGate.vampire.tstp`;
- E 3.2.5: `SZS status Theorem`, full CNF refutation stored in
  `HypothesisOrbitGate.eprover.tstp`.

Artifact digests:

- Lean source: `d4aa862d13f1a4f99fc6b784283006924f9b576120740f9725d87afbb8e4d11c`;
- Lean axiom audit: `d96581f9ce178b99eba3c7ed4afaa46b80617ddb7fda00100c178653dcc16a71`;
- TPTP mirror: `b03c040c30141f912f8e00f6f4e3f0083021523ee9a2db67b3808daf5d1d15c9`;
- Vampire proof: `3314ab347899ecefc2a92994fe423d508efe02c1b6fba0630ee4580090768338`;
- E proof: `f48f9b8a5cfa54bb4385e3fb139163b16335844cb0cf9381f880cf9491048134`.

`HypothesisOrbitGate.p` mirrors the abstract first-order gate consequences. It
does not establish mechanical equivalence with Lean, encode real arithmetic,
or validate an empirical verification protocol.

### Information-geometry boundary

This release is a verification-gated epistemic geometry, not yet Amari
information geometry. It defines no statistical manifold, Fisher information
metric, α-connection, or divergence. Those objects form a future instantiation
seam; they must be derived and connected to the abstract radius by additional
proofs.

### Thematic source

Oleksiy Salkutsan, “The first cut is simple…”: the cycle from flow through
interface, trace, interpretation space, verification and action motivates the
reader. It is a cited interpretation source, not a theorem premise:

https://www.linkedin.com/posts/oleksiy-salkutsan-276a40184_the-first-cut-is-simple-there-is-a-source-share-7498470122597023745-Lw39/

## Русский

Тематический релиз расширяет существующую теорию PM-01 моделью эпистемического
пространства. Угловое движение `dθ` свободно меняет интерпретацию при `dr = 0` и
не меняет статус факта. Радиальное приближение `dr < 0` и повышение гипотезы до
подтверждённого факта допускаются только при отдельном свидетельстве
`IndependentlyVerified`.

Это ещё не информационная геометрия Амари: радиус остаётся абстрактной
эпистемической координатой. Fisher–Rao-метрика, статистическое многообразие,
дивергенция и доказательство их связи с верификационным шагом являются
отдельными будущими обязательствами.

## Reproduce

```bash
cd research/poetry-of-mathematics-v0.1
lake build PoetryOfMathematics PoetryOfMathematicsAudit
vampire --mode casc --time_limit 30 --proof tptp HypothesisOrbitGate.p
eprover --auto --cpu-limit=30 --proof-object=1 --tstp-out HypothesisOrbitGate.p
```
