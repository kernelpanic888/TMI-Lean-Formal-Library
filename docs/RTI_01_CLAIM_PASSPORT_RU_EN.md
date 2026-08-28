# RTI-01 / RTI-02 — Relative Temporal Interface and Quantum Boundary

**Относительная ориентация временных интерфейсов / Relative orientation of temporal interfaces**

- **Status:** Lean-kernel-checked RTI core + quantum no-smuggling boundary + two independent first-order ATP mirrors; physical bridge open.
- **Kernel commit:** `17058ba82066732733fec34ea5f305f380495482`
- **Quantum-boundary commit:** `874e7b1`
- **Quantum module:** `TMI.InterfaceFoundations.QuantumComparisonBoundary`
- **Quantum audit:** `TMI.InterfaceFoundations.QuantumComparisonBoundaryAudit`
- **Article question / Вопрос статьи:** **«Мы живём внутри квантовой машины времени?» / “Do we live inside a quantum time machine?”**
- **TLFL location:** `TMI.InterfaceFoundations.RelativeTemporalInterface`
- **Audit location:** `TMI.InterfaceFoundations.RelativeTemporalInterfaceAudit`
- **Parent surface:** `TMI.ActivationRelicTwoAxisTime`

## RU — паспорт утверждения

### 1. Что уже было в TLFL

RTI-01 не вводит вторую конкурирующую модель времени. Он повторно использует существующие объекты:

\[
\mathrm{TwoAxisTime},\qquad
\mathrm{TimeCoordinate},\qquad
\mathrm{TimeTouch}.
\]

Поэтому событие по-прежнему получает согласованную пару физического и внутреннего чтений:

\[
\mathrm{TimeTouch}_{\Sigma}(e)=(t_e,\tau_e)\in\Gamma_{\Sigma},
\]

где \(\Gamma_{\Sigma}\) остаётся отношением допустимости, а не заранее заданной функцией \(\tau=f(t)\).

### 2. Новое минимальное расширение

Для каждого события \(p\) вводится собственный тип локальных направлений и два непересекающихся предиката:

\[
C_p^+ \quad\text{(future)},
\qquad
C_p^- \quad\text{(past)},
\qquad
C_p^+\cap C_p^-=\varnothing.
\]

Это означает: **временной интерфейс двусторонний; реализованный шаг или мировая линия выбирает одно локальное направление.**

Направления в разных событиях не отождествляются автоматически. Для чтения направлений события \(q\) из интерфейса \(p\) требуется явное отображение сравнения:

\[
\Theta_{p\leftarrow q}:\operatorname{Direction}(q)\to\operatorname{Direction}(p).
\]

Ни обратимость, ни гладкость, ни совместимость со связностью в определение не зашиты.

### 3. Два возможных чтения

Сохранение ориентации:

\[
\Theta_{p\leftarrow q}(C_q^+)\subseteq C_p^+.
\]

Относительный разворот чтения:

\[
\Theta_{p\leftarrow q}(C_q^+)\subseteq C_p^-,
\qquad \sigma(p,q)=-1.
\]

RTI-01 формализует вторую запись как явный свидетель `RelativeReversal`; он **не выводит** её из общей теории относительности.

### 4. Что проверено ядром Lean

- Одно и то же отображение сравнения не может одновременно читать непустой будущий сектор целиком как будущий и целиком как прошлый.
- Два события с относительным разворотом повторно используют существующий `TimeTouch`; новый предикат касания времени не вводится.
- Эксперимент воссоединения хранит общие точки отправления и встречи и неравенство собственных времён двух путей.
- Конечная аудит-модель показывает контрпример импликации «различное старение ⇒ относительный разворот»: значения \(1\) и \(1000\) сосуществуют с сохраняющим будущее сравнением.
- Квантовый кандидат хранит ветви, абстрактные амплитудные данные, признак активности и отдельное сравнение на каждой ветви.
- Если все активные ветви сохраняют future, кандидат не может иметь reversing-ветвь; смешанная конечная модель показывает, что такой разворот появляется только как явно заданные данные ветви.

### 4.1. Независимые ATP-зеркала

Теорема `future_reading_cannot_be_both` независимо переведена в first-order TPTP-задачу:

```text
∃d, Future(d)
∀d, Future(d) → Future(Θ(d))
∀d, Future(d) → Past(Θ(d))
∀d, ¬(Future(d) ∧ Past(d))
⊢ False
```

Аудит на commit `17058ba82066732733fec34ea5f305f380495482` получил точный статус `SZS status Theorem` от **Vampire 5.0.1** и **E 3.2.5**.

Второе TPTP-зеркало на quantum-boundary commit `874e7b1` проверяет: семейство, в котором все активные ветви сохраняют future, несовместимо с существованием активной ветви, читающей тот же непустой future как past. Оба prover снова возвращают точный `SZS status Theorem`.

Эти задачи являются независимыми логическими зеркалами двух фрагментов, а не заменой Lean kernel, квантовой моделью или доказательством физического разворота времени. Зависимые типы `TimeTouch`, `ReunionExperiment`, абстрактные амплитудные данные и конечные модели остаются в области Lean-аудита.

### 5. Красная граница

Из RTI-01 сейчас **не следуют**:

- физический разворот ориентации времени в обычном time-oriented пространстве-времени ОТО;
- движение по мировой линии в собственное причинное прошлое;
- замкнутая времениподобная кривая;
- физическая реализация \(\sigma(p,q)=-1\);
- физическая квантовая суперпозиция мировых линий, часов или отображений сравнения: текущий Lean-объект является только абстрактным кандидатом без гильбертова пространства, нормировки, интерференции, динамики и измерения;
- экспериментальное подтверждение «квантовой машины времени».

Гравитационное замедление времени и релятивистское различное старение дают разные собственные времена между общими событиями, но сами по себе не определяют знак \(\sigma(p,q)\).

### 6. Открытые обязательства

1. Построить \(\Theta_{p\leftarrow q}\) из физической геометрии: метрики, связности, параллельного переноса или явно заданного интерфейса.
2. Установить условия, при которых \(\sigma(p,q)=-1\) физически допустим и наблюдаем.
3. Отделить локальный разворот чтения от глобальной неориентируемости времени и от замкнутых времениподобных кривых.
4. Повысить абстрактный `QuantumComparisonCandidate` до физического квантового объекта: задать пространство состояний, нормировку, динамику, интерференцию и измерение.
5. Вывести наблюдаемое следствие, отличающее RTI от стандартного дифференциального старения.

## EN — claim passport

### 1. Existing TLFL base

RTI-01 does not introduce a competing time model. It reuses the compiled `TwoAxisTime`, `TimeCoordinate`, and `TimeTouch` surface. An event therefore still receives coordinated physical and internal readings,

\[
\mathrm{TimeTouch}_{\Sigma}(e)=(t_e,\tau_e)\in\Gamma_{\Sigma},
\]

with \(\Gamma_{\Sigma}\) kept as an admissibility relation rather than a pre-assumed function \(\tau=f(t)\).

### 2. Minimal extension

Each event \(p\) gets its own local direction type and disjoint future/past predicates:

\[
C_p^+\cap C_p^-=\varnothing.
\]

Thus **the temporal interface is two-sided; a realized step or worldline selects one local direction.** Directions at distinct events are not identified automatically. Reading directions at \(q\) through interface \(p\) requires an explicit comparison map:

\[
\Theta_{p\leftarrow q}:\operatorname{Direction}(q)\to\operatorname{Direction}(p).
\]

Invertibility, smoothness, and connection compatibility are not built into the definition.

### 3. Two readings

Orientation-preserving reading:

\[
\Theta_{p\leftarrow q}(C_q^+)\subseteq C_p^+.
\]

Relative reversal of the reading:

\[
\Theta_{p\leftarrow q}(C_q^+)\subseteq C_p^-,
\qquad \sigma(p,q)=-1.
\]

RTI-01 formalizes the second statement as explicit `RelativeReversal` data. It does **not** derive it from general relativity.

### 4. Lean-kernel-checked core

- One comparison cannot read the same nonempty future sector wholly as future and wholly as past.
- Two relatively reversed events reuse the existing `TimeTouch`; RTI introduces no duplicate time-touch predicate.
- A reunion experiment records shared departure/reunion events and unequal proper times for two paths.
- A finite audit model refutes the implication “differential aging implies relative reversal”: durations \(1\) and \(1000\) coexist with a future-preserving comparison.
- A quantum candidate records branches, abstract amplitude data, activity, and one comparison per branch.
- If every active branch preserves future, the candidate has no reversing branch; a mixed finite witness obtains reversal only from explicitly supplied branch data.

### 4.1. Independent ATP mirrors

The first TPTP problem mirrors `future_reading_cannot_be_both`. The second mirrors the no-smuggling quantum boundary: an all-preserving active branch family cannot also contain an active reversing branch. At commits `17058ba82066732733fec34ea5f305f380495482` and `874e7b1`, **Vampire 5.0.1** and **E 3.2.5** returned the exact result `SZS status Theorem` for both problems. These are independent first-order mirrors, not replacements for the Lean kernel, a quantum model, or evidence for physical reversal. Dependent `TimeTouch`, `ReunionExperiment`, abstract amplitude data, and finite witnesses remain Lean-side certificates.

### 5. Red boundary

RTI-01 currently proves no physical reversal in an ordinary time-oriented GR spacetime, no motion into one’s own causal past, no closed timelike curve, no physical realization of \(\sigma=-1\), no Hilbert-space quantum dynamics or measurement model, and no empirical quantum time machine. Gravitational time dilation and differential aging alone do not determine \(\sigma(p,q)\).

### 6. Open obligations

1. Construct \(\Theta_{p\leftarrow q}\) from physical geometry or an explicit interface law.
2. State conditions under which \(\sigma(p,q)=-1\) is physically admissible and observable.
3. Separate relative local reading from global time non-orientability and closed timelike curves.
4. Upgrade the abstract `QuantumComparisonCandidate` to a physical quantum object with a state space, normalization, dynamics, interference, and measurement.
5. Derive an observable that distinguishes RTI from standard differential aging.

## Canonical links

- Public TMI source canon: [The Elusive Graviton Candidate](https://doi.org/10.5281/zenodo.21011196)
- Existing public causal selector: `exports/chertogi_first_distinction_public/index.html#interface-causal-selector`
- Existing two-axis Lean surface: `lean/TMI/ActivationRelicTwoAxisTime.lean`
- RTI-01 Lean module: `lean/TMI/InterfaceFoundations/RelativeTemporalInterface.lean`
- RTI-01 finite audit: `lean/TMI/InterfaceFoundations/RelativeTemporalInterfaceAudit.lean`
- Quantum comparison boundary: `lean/TMI/InterfaceFoundations/QuantumComparisonBoundary.lean`
- Quantum boundary audit: `lean/TMI/InterfaceFoundations/QuantumComparisonBoundaryAudit.lean`
- First-order RTI mirror: `external_proofs/rti_01_future_reading_cannot_be_both_tptp_0_1.p`
- First-order quantum-boundary mirror: `external_proofs/rti_02_quantum_reversal_requires_explicit_branch_tptp_0_1.p`
- Bilingual article: `docs/RTI_01_QUANTUM_TIME_MACHINE_ARTICLE_RU_EN.md`
- Fail-closed Lean + ATP audit: `scripts/audit_rti_01_relative_temporal_interface.sh`
