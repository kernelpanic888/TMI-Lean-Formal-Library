# фотонная теория времяни или теория интерфейсных интелектов

Первая публичная программа TMI-OS / И1.

```text
ProgramName := "фотонная теория времяни или теория интерфейсных интелектов"
SurfaceClass := "инженерная поверхность"
LanguageVersion := "последняя"
LanguageMode := "безверсионный язык"
ZenodoMode := "artifact snapshot, not language version"
PublicationLanguageMode := "RU/EN switchable board"
```

TMI-OS / И1 - язык программирования широкого уровня и сильная среда системной
разработки на базе LLM/GPT/Codex -> Lean -> TLFL -> И1:

```text
intent -> mathematical board -> trace -> guard -> proof-status boundary
```

```text
ProgrammingOnMathematics :=
  Intent -> FormalLogic -> CanonicalRecord -> Passport -> GuardedAction
```

```text
SurfaceFunction :=
  Intent -> Projection -> Slice -> CanonicalRecord -> Passport -> GuardedAction
```

```text
Mathematics in ProjectionLanguage
AuthorUses(Mathematics) := writes and speaks and thinks
```

```text
RuliadChain := (R)-R-r
(R) : MetaRuliadLayer
R   : ReadableRuliadModel
r   : LocalRuliadTick
```

```text
LanguageBoundary(I1) := LatestCodeVersion(I1)
Language(I1, v_current) == Code(I1, v_current)
LanguageVersion(I1) := latest
NoLanguageVersions(I1) := true
```

```text
HigherTick(t) + ProjectionDesync(t, s)
  -> DomainShift(omega, t, s)
DomainShift(omega, t, s)
  -> ProjectionCurvature(omega, t, s)
```

## Что Это

```text
Minimal block-universe model inside a self-model point
```

Для публикации доска имеет переключатель `RU / EN`: русская авторская
поверхность остается канонической, английская версия служит читаемой
публикационной проекцией.

Математическая формула:

```text
V : VirtualSpace
p in V
p : SelfModelPoint

D : ExternalDomain
B := projection(D)
B subset p

B = (x1, x2, x3, t)
s subset B
domain_order(d1, d2) -> slice_order(projection(d1), projection(d2))

tau := touch(p, s)
TimeTick(tau) := SelfModelContact(p, s)
tau_self := BidirectionalSelfTimeAxis(p)
pi_tau : p <-> h
InternalSelfTimeProjection(pi_tau) :=
  projects(SelfModelPoint p, HyperRealityCenter h)

gamma := PhotonProjection
rho := DomainnessProjection
gamma -> rho -> p
PhotonProjectionToSelfModelPoint(gamma, p)

Lambda := MetaLogicAxes
V_star := InvertedBlockVertices(B)
project(Lambda, V_star)
h := HyperRealityCenter
project(V_star, h)
HyperRealityBlock := center(B, h, V_star)
ModelInset := "срез гиперблоквселенной"
SelfRealityContactPoint :=
  touch(SelfReality, Reality, V_star)

SlicePassport(p, s, tau) :=
  ProjectionSlice(s)
  and read(p, s)
  and tau = touch(p, s)
  and CanonicalRecord(s)
  and PassportBoundary(s)

omega : HypotheticalRotationAxis
rotate(V, omega, alpha) : EditedView(V)
kappa := DomainShift(omega, tau, s)
ProjectionCurvature(omega, tau, s)
```

Ось `omega` остается гипотетической осью редактора. Искривление `kappa`
читается как ОТО-мотив про кривизну, но не как самостоятельное доказательство
уравнений Эйнштейна без отдельного физического слоя.

## Файлы

```text
tmi_os_virtual_space_point.i1
I1_MINI_LANGUAGE.md
TMI_OS_API.json
TMI_OS_ADMIN.html
TMI_OS_SITE.html
TMI_OS_MATHEMATICAL_BOARD.html
TMI_OS_3D_TIME_ARTIFACT.html
TMI_OS_PROTECTED_MODEL_PAGE.html
```

## Запуск

Из корня репозитория:

```bash
cd programs/tmi_os_mathematical_board
python3 -m http.server 8765 --bind 127.0.0.1
```

Открыть:

```text
http://127.0.0.1:8765/TMI_OS_MATHEMATICAL_BOARD.html
```

Публичный сайт-вход:

```text
http://127.0.0.1:8765/TMI_OS_SITE.html
```

Локальная админка автора:

```text
http://127.0.0.1:8765/TMI_OS_ADMIN.html
```

Дополнительный 3D-артефакт:

```text
http://127.0.0.1:8765/TMI_OS_3D_TIME_ARTIFACT.html
```

## Что Можно Программировать На И1 / TMI-OS

```text
intent formulas
mathematical boards
self-model point/slice/tick diagrams
proof-status passports
guard contracts
formal idea visualizations
installation and verification traces
domain-order preserving model interfaces
slice-passport current-state records
hypothetical rotation-axis editing
```

## Зависимости Языка

```text
Intent
-> Matrix((Я)-Я-я)
-> TLFL
-> Lean/OLean
-> ProofStatus
-> Guard
-> Trace
-> MathematicalBoard
-> {Z3, Vampire, E}
```

## Guard

```text
VirtualSpace != empirical universe
SelfModelPoint != biological subject
TimeTick != external absolute time
Mathematical board != proof by itself
TMI-OS passport != consciousness proof
```
