# GINF-01 — Sampled Hypergraph Impulse

**Выборочный гиперграф, DL-04 и граница полного носителя / Sampled hypergraph, DL-04, and the full-carrier boundary**

- **Status:** Lean-kernel-checked sampled-carrier and admitted-impulse interface; browser visualization executable; full-carrier physics and life claims open.
- **Core:** `TMI.InterfaceFoundations.SampledHypergraphImpulse`
- **Audit:** `TMI.InterfaceFoundations.SampledHypergraphImpulseAudit`
- **Reused kernel:** `TMI.DigitalLifeTwoAxisTick`
- **Reader view:** `G∞ · DL-04`, 4,000 rendered nodes, symbolic (10^{12})-vertex carrier, 30/70 layout, 70–180% right-scene scale.

## RU — что мы формализуем

### 1. Не рисуем триллион объектов

Полный носитель и экранная выборка имеют разные типы:

\[
V := \operatorname{Fin}(10^{12}),
\qquad
S := \operatorname{Fin}(4000).
\]

Lean проверяет отображение

\[
\pi:S\to V,
\qquad
\pi(i)=i.
\]

Это символическая конечная конструкция. Lean не создаёт список из триллиона
элементов, а браузер не пытается отрисовать триллион точек.

В ядре определены:

- `SampleProjection` — явное отображение экранных узлов в носитель;
- `CoversCarrier π` — каждый узел носителя имеет экранного представителя;
- `ProperSample π` — существует узел носителя, отсутствующий на экране.

Для текущих чисел Lean строит явный пропущенный индекс (4000\in V) и
доказывает:

\[
\operatorname{ProperSample}(\pi),
\qquad
\neg\operatorname{CoversCarrier}(\pi).
\]

Это формальная версия надписи `rendered(V) ≪ V`.

### 2. Связность относится к видимому графу

`SampledHypergraph` хранит:

- бинарные видимые рёбра;
- видимые гиперрёбра как предикат на списках экранных узлов;
- доказательство `Reachable` между любыми двумя экранными узлами.

Носитель при этом не получает автоматически ни рёбер, ни гиперрёбер, ни
топологии. `FullCarrierClaim` обязан отдельно предъявить хотя бы доказательство
покрытия. Теорема

```text
proper_sample_excludes_full_carrier_claim
```

запрещает превратить связную картинку proper-sample в утверждение о полном
носителе без нового моста.

### 3. Что именно означает DL-04

Lean-тип `DL04State` содержит шесть публичных полей:

\[
(q,m,r,u,C,guard).
\]

Он не вводит вторую динамику. Оператор перехода повторно используется из
существующего `TickContract.applyAction`, а принятый переход несёт существующий
`TickReceipt`.

`SampledImpulseStep` дополнительно требует:

1. исходный и целевой экранные узлы;
2. видимое ребро между ними;
3. сертифицированный `TickReceipt`;
4. истинный guard до и после перехода.

Из этих данных Lean проверяет:

\[
s_{n+1}=T(s_n,a_n),
\qquad
C(s_{n+1})=C(s_n)+1,
\qquad
C(s_n)\le C(s_{n+1}),
\]

и наследование существующего `TimeTouch` по двум временным чтениям.

### 4. Вращение и масштаб — не шаг модели

`ViewFrame` хранит только презентационные параметры:

\[
(scale,yaw,pitch,leftWeight,rightWeight).
\]

`reframe` заменяет вид, сохраняя модель. Lean доказывает:

\[
\operatorname{model}(\operatorname{reframe}(P,v'))
=\operatorname{model}(P)
\]

и, следовательно, сохраняет любую функцию наблюдения модели, включая
сертификат. Аудит явно проверяет переход от вида 30/70 при 100% к повёрнутому
виду 30/70 при 150% без изменения состояния.

### 5. Конечный аудит

Аудит содержит:

- proper-проекцию `Fin 3 → Fin 4`;
- связный трёхузловой экранный граф;
- явный пропущенный четвёртый узел носителя;
- состояние `DL04State Nat Nat Nat Nat`;
- один принятый tick с сертификатом (0\to1);
- проверку инвариантности сертификата при zoom/rotation.

Все 17 экспортированных теорем отчётно не зависят от аксиом.

### 6. Красная граница

GINF-01 **не доказывает**:

- что реальный физический мир имеет (10^{12}) узлов;
- что полный носитель связен, если связна экранная выборка;
- что видимые гиперрёбра существуют вне визуальной модели;
- что импульс является квантовым состоянием или физическим сигналом;
- что DL-04 является биологической жизнью, сознанием или субъектом;
- что граф реализует относительный разворот времени или машину времени;
- что JavaScript-арифметика `tanh` и floating-point побитно совпадает с
  математикой Lean.

Точная численная рекуррентность текущего браузерного DL-04 остаётся отдельным
обязательством: необходимо выбрать математический числовой носитель, задать
`tanh`, доказать ограниченность и затем отдельно верифицировать runtime-adapter.

## EN — what is formalized

### 1. No trillion-object rendering

The carrier and the rendered sample are distinct symbolic types:

\[
V=\operatorname{Fin}(10^{12}),
\qquad
S=\operatorname{Fin}(4000),
\qquad
\pi:S\to V.
\]

Lean checks the index embedding without allocating or enumerating a trillion
vertices. Carrier index 4000 is an explicit omitted vertex, so the current
projection is a `ProperSample` and cannot satisfy `CoversCarrier`.

### 2. Visible connectedness stays visible

`SampledHypergraph` contains screen edges, screen hyperedges, and a reachability
proof for screen nodes only. It contains no carrier edge relation. A
`FullCarrierClaim` must separately prove coverage, and a proper sample makes
that field impossible.

### 3. DL-04 interface

`DL04State` exposes the typed tuple

\[
(q,m,r,u,C,guard).
\]

The transition itself remains the reused `TickContract.applyAction`. A
`SampledImpulseStep` couples one visible edge with an existing certified
`TickReceipt` and guard proofs. Lean then checks the declared transition,
exact certificate increment, certificate monotonicity, and inherited two-axis
`TimeTouch`.

### 4. View invariance

Rotation, zoom, and 30/70 layout are fields of `ViewFrame`. `reframe` changes
only the view. The kernel proves that the model and every observation of it are
unchanged. The finite audit instantiates the public 100% view and a rotated
150% view and checks certificate equality.

### 5. Checked audit

The finite audit supplies a proper `Fin 3 → Fin 4` projection, a connected
three-node visible graph, one admitted DL-04 tick with certificate (0\to1),
and the reframe witness. All 17 reported theorems have no axiom dependencies.

### 6. Red boundary

GINF-01 proves no physical trillion-vertex universe, no full-carrier
connectivity, no quantum dynamics, no physical signal, no biological life or
consciousness, no relative time reversal, and no quantum time machine. The
exact floating-point `tanh` recurrence executed in JavaScript is not yet a
Lean theorem; its mathematical numeric carrier and runtime refinement remain
open obligations.

## Status map / Карта статусов

| Surface | Status |
|---|---|
| `Fin 4000 → Fin 10¹²` projection | Lean kernel checked |
| Proper sample does not cover carrier | Lean kernel checked |
| Visible reachability interface | Lean kernel checked |
| Reused admitted tick and certificate growth | Lean kernel checked |
| Rotation/zoom/layout preserve model | Lean kernel checked |
| Browser Canvas2D graph and impulse | Executable visualization |
| Exact JS floating-point recurrence refinement | Open |
| Full-carrier physical interpretation | Open |
| Life, consciousness, or time-machine claim | Not established |

## Files

- `lean/TMI/InterfaceFoundations/SampledHypergraphImpulse.lean`
- `lean/TMI/InterfaceFoundations/SampledHypergraphImpulseAudit.lean`
- `scripts/audit_ginf_01_sampled_hypergraph_impulse.sh`
- `public reader: /readers/activation-relic-shadow-boundary/#experiment`

## Next point / Следующая точка

Define the exact real-valued DL-04 recurrence, prove its ball/boundedness guard
in mathematical arithmetic, and construct a separately audited adapter from
the browser runtime trace to that recurrence. This remains distinct from any
claim of physical realization or life.
