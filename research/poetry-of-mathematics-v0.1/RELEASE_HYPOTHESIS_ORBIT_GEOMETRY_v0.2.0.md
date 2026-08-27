# PM-01 · Hypothesis Orbit Geometry v0.2.0

Tag: `pm01-hypothesis-orbit-geometry-v0.2.0`

## English

This release turns the PM-01 hypothesis-orbit model into a bilingual live
reader while keeping its formal boundary explicit.

The Lean model still says exactly this:

- a confirmed core `C` is distinct from hypotheses `H_i`;
- angular interpretation may change `dθ` while `dr = 0` and status is
  preserved;
- inward motion `dr < 0` requires an explicit independent-verification
  witness;
- promotion from hypothesis to verified fact requires the same witness.

New in v0.2.0:

- a bilingual RU/EN reader and animated home-page banner;
- a tested handwritten browser wrapper shared by both surfaces;
- a pinned Apache-2.0 Spectra dependency at
  `8dbaaf6728d1342ae16acf79fd7eef7c59b37e63`;
- `AmariVerificationLayer`, which places TLFL status and verification data over
  Spectra's compiled `StatisticalManifold` / Fisher metric foundation;
- an upstream compatibility audit and a complete source ledger.

The animation is an operational mirror, not extracted Lean, a proof checker,
or a proof of equivalence with Lean. The release image is editorial only. The
executable visual account is the browser wrapper and its finite tests.

The imported Fisher foundation does **not** identify PM-01's abstract orbit
radius with Fisher–Rao distance, KL divergence, or a geodesic coordinate.
Spectra's downloaded Amari–Chentsov / alpha-connection chain remains cited but
outside the TLFL build because that chain does not compile against final
Mathlib `v4.31.0`. TLFL does not patch or relabel the upstream source.

## Русский

Этот релиз превращает модель орбит гипотез PM-01 в двуязычный
живой ридер, сохраняя явную формальную границу.

Lean-модель по-прежнему утверждает ровно следующее:

- подтверждённое ядро `C` отличается от гипотез `H_i`;
- интерпретация может менять `dθ` при `dr = 0`, не меняя статус;
- приближение `dr < 0` требует явного свидетеля независимой
  верификации;
- перевод гипотезы в статус проверенного факта требует тот же
  свидетель.

Новое в v0.2.0:

- двуязычный RU/EN ридер и анимированный баннер главной страницы;
- общая для обеих поверхностей ручная браузерная обёртка с тестами;
- зафиксированная Apache-2.0 зависимость Spectra точной ревизии;
- `AmariVerificationLayer`: статусы и верификация TLFL над собранным
  Spectra-основанием `StatisticalManifold` / метрики Фишера;
- аудит совместимости upstream и полный реестр источников.

Анимация — это операционное зеркало, а не извлечённый Lean-код, не
пруф-чекер и не доказательство эквивалентности Lean. Релизная картинка —
только редакционный материал. Исполняемое визуальное описание дают
браузерная обёртка и её конечные тесты.

Импортированное Fisher-основание **не** отождествляет абстрактный радиус
PM-01 с расстоянием Fisher–Rao, KL-дивергенцией или геодезической
координатой. Цепочка Amari–Chentsov / α-связностей зафиксирована и
цитируется, но не входит в сборку TLFL из-за несовместимости с финальным
Mathlib `v4.31.0`. TLFL не исправляет и не переименовывает внешний код.

## Verification record / Протокол проверки

| Gate | Result |
| --- | --- |
| Lean `lake build PoetryOfMathematics PoetryOfMathematicsAudit` | PASS |
| Browser wrapper | 10 checks PASS |
| Vampire 5.0.1 | `SZS status Theorem` |
| E 3.2.5 | `SZS status Theorem` |

Full Vampire and E proof traces remain beside `HypothesisOrbitGate.p`.

| Artifact | SHA-256 |
| --- | --- |
| `PoetryOfMathematics.lean` | `ecdd822a47471977815b99296836f992911a8663c4ab5787a67e8da9090d7573` |
| `PoetryOfMathematicsAudit.lean` | `db9ba81da3d29a330498e8e0a337838bb0c9017b151afa32e543d2b89b8785c8` |
| `HypothesisOrbitGate.p` | `b03c040c30141f912f8e00f6f4e3f0083021523ee9a2db67b3808daf5d1d15c9` |
| `HypothesisOrbitGate.vampire.tstp` | `3314ab347899ecefc2a92994fe423d508efe02c1b6fba0630ee4580090768338` |
| `HypothesisOrbitGate.eprover.tstp` | `f48f9b8a5cfa54bb4385e3fb139163b16335844cb0cf9381f880cf9491048134` |
| `hypothesis-orbit-wrapper.js` | `665c0a556e1f693e54af2a94477c4be96c117654b38f2a652022bd1eae2cfe22` |
| `hypothesis-orbit-wrapper.test.cjs` | `7faf40b508d740f90e9a13d2e9241560e5592cb96e7b3d524cc6271b3004b2ca` |
| bilingual reader `index.html` | `6381e781180f708b1f859fc30072aaa43658041caef45142c2ac64dbd8cd2e54` |
| public home `index.html` | `12d2a7ebcaf1ac6d26d3ee3242336362a3193907c42c97d6d72d8ce832db93c7` |
| English release image | `959e547115393e38e50ff5933e357588d94efd3821990b751dce7e60f873be39` |

```bash
lake update
lake build PoetryOfMathematics PoetryOfMathematicsAudit
node ../../exports/chertogi_first_distinction_public/readers/poetry-of-mathematics/hypothesis-orbit-wrapper.test.cjs
vampire --mode casc --time_limit 30 --proof tptp HypothesisOrbitGate.p
eprover --auto --cpu-limit=30 --proof-object=1 --tstp-out HypothesisOrbitGate.p
```

See `CLAIM_PASSPORT.md` for artifact hashes, axiom reports and the precise
claim ceiling; see `SPECTRA_UPSTREAM.md` for the dependency and compatibility
audit.
