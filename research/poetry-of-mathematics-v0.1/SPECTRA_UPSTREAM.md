# Spectra information-geometry upstream

PM-01 imports its Fisher–Rao foundation instead of reimplementing it.

- Upstream: <https://github.com/adambornemann-glitch/Spectra>
- Pinned revision: `8dbaaf6728d1342ae16acf79fd7eef7c59b37e63`
- Upstream path used by TLFL:
  `Spectra/InformationGeometry/StatisticalManifold.lean`
- Author attribution in the imported source: Adam Bornemann / Spectra
  Formalization Project
- License: Apache-2.0
- TLFL toolchain: Lean/Mathlib `v4.31.0`

## Verified compatibility boundary

On the TLFL `v4.31.0` dependency graph, these upstream targets build:

- `Spectra.InformationGeometry.StatisticalModel`
- `Spectra.InformationGeometry.Score`
- `Spectra.InformationGeometry.Fisher.Information`
- `Spectra.InformationGeometry.Fisher.Metric`
- `Spectra.InformationGeometry.StatisticalManifold`

The upstream chain through
`Spectra.InformationGeometry.Divergence` and consequently
`Connection.AmariChentsov` / `Connection.Basic` does **not** currently build
against final Mathlib `v4.31.0`. The pinned source was authored around an
earlier release-candidate dependency graph and fails on changed simplifier and
continuous-linear-map APIs.

TLFL does not patch or fork those modules locally. It imports only the verified
Fisher–Rao subset and leaves the alpha-connection integration open until a
compatible upstream revision is available.

## Claim boundary

`AmariVerificationLayer` places TLFL's explicit status and verification data
over an imported statistical manifold. It does not yet prove that PM-01's
abstract orbit radius is Fisher–Rao distance, KL divergence, or a geodesic
coordinate. No browser animation may claim that identification.
