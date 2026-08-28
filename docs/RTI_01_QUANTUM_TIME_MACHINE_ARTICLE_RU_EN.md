# Мы живём внутри квантовой машины времени?

## Do we live inside a quantum time machine?

**RTI-01 / RTI-02 · bilingual research article · local publication candidate**

**Authorial research line:** Aleksey Salkutsan / TMI–TLFL

**Status:** provocative question; Lean-checked logical core; physical and quantum bridges open

**Formal commits:** RTI kernel 17058ba82066732733fec34ea5f305f380495482; quantum boundary 874e7b1

**Date:** 2026-08-28

---

# RU

## Аннотация

Общая теория относительности позволяет двум наблюдателям выйти из одного события, пройти по разным будущенаправленным мировым линиям и встретиться снова, накопив различное собственное время. В предельном мысленном эксперименте путешественница проводит год в сильном гравитационном поле, тогда как земные часы между теми же событиями отсчитывают гораздо больший интервал. В слабом, метафорическом смысле это уже «машина в будущее»: участники одной встречи наследуют разные объёмы прожитого времени.

Но отсюда не следует, что Земля физически переместилась в причинное прошлое путешественницы, что локальный future-сектор стал past-сектором или что возникла замкнутая времениподобная кривая. Чтобы сформулировать более сильный тезис, RTI вводит локальные временные интерфейсы и явную карту сравнения направлений между событиями. Относительный разворот становится отдельным свидетелем, а не следствием различного старения.

Квантовый вопрос возникает ещё этажом выше. Если сравнение само имеет ветви, то «квантовая машина времени» требует хотя бы одной физически активной ветви, в которой будущее одного интерфейса читается как прошлое другого. Lean-ядро и независимые Vampire/E-зеркала доказывают отрицательную границу: если все активные ветви сохраняют future, никакие названия ветвей или абстрактные амплитуды не создают разворот. Статья поэтому защищает сильный вопрос, не выдавая его за уже полученный ответ.

## 1. Провокация

Фраза «мы живём внутри машины времени» может означать три разные вещи.

1. **Слабый релятивистский смысл.** Между общими событиями разные мировые линии накапливают разные собственные времена.
2. **Интерфейсный смысл RTI.** Направление времени сравнивается только после задания карты между локальными структурами разных событий.
3. **Сильный квантовый смысл.** Существует физическая квантовая конструкция с активной ветвью относительного разворота и наблюдаемым следствием.

Первый пункт является стандартной физикой. Второй — формальный язык сравнения. Третий — открытая исследовательская программа.

## 2. Лина, Земля и чёрная дыра

Пусть A — событие отправления, B — событие воссоединения. Есть две будущенаправленные мировые линии:

\[
\gamma_L:A\to B,
\qquad
\gamma_E:A\to B.
\]

Лина проходит по маршруту в сильном гравитационном поле; Земля проходит по своей мировой линии. Собственное время каждой линии определяется её геометрией:

\[
\tau[\gamma]
=
\int_\gamma
\sqrt{-g_{\mu\nu}\,dx^\mu dx^\nu}/c.
\]

Мысленный контраст можно записать так:

\[
\tau[\gamma_L]=1\ \text{год},
\qquad
\tau[\gamma_E]=1000\ \text{лет}.
\]

Конкретное отношение зависит от метрики, траектории, скорости, устойчивости орбиты и способа удержания аппарата. Числа 1 и 1000 здесь — модельный контраст, а не расчёт реалистичной миссии на заданной орбите.

В событии B обе записи истинны одновременно:

\[
\tau_L(B)-\tau_L(A)
<
\tau_E(B)-\tau_E(A).
\]

Лина встречает Землю на более поздней земной дате, почти не постарев по земной шкале. Поэтому её маршрут действительно действует как односторонний переход в будущее Земли.

Но инвариантная формулировка не говорит, что Земля попала в причинное прошлое Лины. Обе линии направлены из A в B, обе лежат в своих допустимых future-секторах, и встреча B остаётся будущим событием относительно A. Симметрия существует на уровне сравнения записей; накопленные собственные времена при воссоединении являются различными инвариантами путей.

## 3. Почему одной оси недостаточно

RTI начинает не с глобальной стрелки, а с события-интерфейса:

\[
T_* = p.
\]

В p определён локальный тип направлений и два непересекающихся сектора:

\[
C_p^+ \quad\text{future},
\qquad
C_p^- \quad\text{past},
\qquad
C_p^+\cap C_p^-=\varnothing.
\]

Интерфейс двусторонний. Односторонним является реализованный шаг или выбранная мировая линия:

\[
v\in C_p^+.
\]

Это различие не обращает время. Оно не позволяет смешивать геометрию доступных направлений с фактически пройденным маршрутом.

RTI сохраняет существующий двухосевой TimeTouch:

\[
\mathrm{TimeTouch}_{\Sigma}(e)
=
(t_e,\tau_e)\in\Gamma_\Sigma.
\]

Физическая запись \(t_e\) и внутренняя запись \(\tau_e\) образуют допустимую пару. Отношение \(\Gamma_\Sigma\) не объявляется заранее функцией \(\tau=f(t)\); единственность, гладкость и обратимость требуют отдельных доказательств.

## 4. Будущее соседа

Направления при p и q принадлежат разным локальным типам. Слова «его будущее смотрит туда же» не имеют формального смысла, пока не задано правило сравнения:

\[
\Theta_{p\leftarrow q}:
\operatorname{Direction}(q)
\to
\operatorname{Direction}(p).
\]

Сохраняющее чтение:

\[
\Theta_{p\leftarrow q}(C_q^+)
\subseteq
C_p^+,
\qquad
\sigma(p,q)=+1.
\]

Разворачивающее чтение:

\[
\Theta_{p\leftarrow q}(C_q^+)
\subseteq
C_p^-,
\qquad
\sigma(p,q)=-1.
\]

Знак \(\sigma=-1\) не возникает из одной разницы часов. В RTI он представлен явным объектом RelativeReversal. Будущая физическая теория должна построить соответствующую \(\Theta\) из метрики, связности, параллельного переноса, граничного интерфейса или иной проверяемой структуры.

## 5. Что уже доказано

Lean проверяет следующие утверждения без объявленных аксиом проекта:

- непустой future-сектор не может через одно и то же сравнение целиком читаться одновременно как future и past;
- RTI повторно использует существующий TimeTouch, а не создаёт конкурирующее время;
- эксперимент воссоединения хранит общие события A и B и различное собственное время путей;
- конечная модель с длительностями 1 и 1000 совместима с future-preserving сравнением;
- следовательно, differential aging не вынуждает relative reversal.

Первое утверждение имеет независимое first-order зеркало. Vampire 5.0.1 и E 3.2.5 возвращают точный статус SZS status Theorem.

Это логический сертификат различения. Это не решение уравнений Эйнштейна и не экспериментальная регистрация разворота времени.

## 6. Где начинается квантовый вопрос

Чтобы слово «квантовый» не было декоративным, нужен хотя бы кандидат с ветвями:

\[
Q=
(B,\alpha,\mathrm{Active},\Theta),
\]

где B — тип ветвей, \(\alpha(b)\) — данные амплитуды, Active(b) указывает участвующие ветви, а \(\Theta_b\) является сравнением направлений для ветви b.

Минимальный сильный критерий статьи:

\[
\mathrm{QTM}(Q)
:\Longleftrightarrow
\exists b\in B,\;
\mathrm{Active}(b)
\land
\Theta_b(C_q^+)\subseteq C_p^-.
\]

Lean-модуль QuantumComparisonBoundary оставляет тип амплитуд абстрактным. Это намеренно: пока нет гильбертова пространства, нормировки, интерференции, унитарной динамики и правила измерения, мы имеем только типизированную гипотезу, а не квантовую физическую модель.

Проверенная граница имеет вид:

\[
\bigl[
\forall b,\;
\mathrm{Active}(b)
\Rightarrow
\Theta_b(C_q^+)\subseteq C_p^+
\bigr]
\Rightarrow
\neg\mathrm{QTM}(Q).
\]

Иными словами, суперпозиция future-preserving ветвей не становится временным разворотом от одного названия «суперпозиция». Reversing-ветвь должна присутствовать как явные данные, после чего ещё требуется доказать её физическую реализуемость.

## 7. Живём ли мы внутри машины времени?

**Да — в слабом смысле:** пространство-время уже допускает path-dependent proper time. Мы постоянно движемся вдоль мировых линий, и распределение скорости и гравитационного потенциала изменяет накопленный возраст.

**Возможно — в реляционном смысле:** внутренние часы, корреляции и записи могут задавать наблюдаемый порядок без привилегированного внешнего времени. Page–Wootters, взаимодействующая реляционная конструкция Gemsheim–Rost и холодно-атомный эксперимент показывают физически содержательные способы исследовать такой вопрос.

**Пока не доказано — в сильном смысле:** нет построенной в этой работе физической \(\Theta\) с \(\sigma=-1\), нет квантового оператора сравнения, нет наблюдаемого интерференционного сигнала reversing-ветви и нет доказанного движения в собственное причинное прошлое.

Поэтому точный ответ статьи:

\[
\boxed{
\text{Мы живём в мире релятивистских машин в будущее,}
\quad
\text{но квантовая двусторонняя машина остаётся открытой гипотезой.}
}
\]

## 8. Проверяемая программа

Сильная версия RTI станет физической теорией только после закрытия пяти обязательств.

1. **Геометрический мост.** Построить \(\Theta_{p\leftarrow q}\) из явной физической геометрии и доказать её свойства.
2. **Квантовый носитель.** Задать гильбертово пространство или эквивалентную операционную структуру, нормировку, динамику и измерение ветвей.
3. **Наблюдаемый критерий.** Вывести величину, которая отличает reversing-ветвь от обычного differential aging, смены координат и декогеренции.
4. **Причинная безопасность.** Указать, означает ли \(\sigma=-1\) лишь относительное чтение, глобальную неориентируемость времени или реальную causal loop.
5. **Экспериментальный протокол.** Зафиксировать подготовку, контроль, статистический тест и условие опровержения.

До выполнения этих пунктов правильный статус — formalized hypothesis / physical bridge open.

## 9. Красная граница

Статья не утверждает:

- что Земля физически перемещается в причинное прошлое путешественницы;
- что экстремальное гравитационное замедление автоматически меняет time orientation;
- что любая квантовая суперпозиция является машиной времени;
- что холодно-атомный эксперимент проверяет TMI или RTI;
- что теневой конус является стандартным термином ОТО;
- что опубликованный авторский TMI-канон сам доказывает \(\sigma=-1\).

Теневой конус — визуальный язык данной исследовательской программы для past-сектора. Световой конус future и теневой конус past на публикационной карте могут быть наклонены и не обязаны изображаться в одной плоскости, но сама карта остаётся концептуальной.

## 10. Вывод

Главный результат не состоит в объявлении найденной машины времени. Он состоит в устранении логической подмены.

- Различное старение — не разворот.
- Две стороны локального интерфейса — не две пройденные дороги.
- Сравнение направлений — не мировая линия.
- Квантовая метка — не квантовая динамика.
- Reversing-ветвь — не физическая реализация.

После этих различений вопрос становится не слабее, а точнее:

> Может ли физическая теория породить наблюдаемую активную ветвь сравнения, в которой локальное будущее одного интерфейса читается как прошлое другого, не разрушая причинную согласованность?

Вот это и есть рабочая форма вопроса «мы живём внутри квантовой машины времени?».

---

# EN

## Abstract

General relativity allows two observers to leave the same event, follow different future-directed worldlines, and reunite after accumulating unequal proper times. In an extreme thought experiment, a traveler experiences one year in a strong gravitational field while Earth clocks register a much larger interval between the same endpoints. In a weak metaphorical sense, this is already a machine into Earth's future.

It does not follow that Earth has moved into the traveler's causal past, that a local future sector has become a past sector, or that a closed timelike curve exists. RTI introduces event-local temporal interfaces and an explicit direction-comparison map to state the stronger possibility without deriving it from differential aging.

The quantum question is one layer higher. If the comparison itself is branch-indexed, a “quantum time machine” requires at least one physically active branch in which one interface's future reads as another interface's past. The Lean kernel and independent Vampire/E mirrors establish a negative boundary: if every active branch preserves future, branch labels and abstract amplitudes cannot manufacture reversal. The strong question is therefore retained without being advertised as an answer.

## 1. Three meanings of “time machine”

The phrase can name three distinct claims:

1. **Weak relativistic claim:** different worldlines between shared endpoints accumulate different proper times.
2. **RTI interface claim:** temporal orientation across events is meaningful only relative to an explicit comparison map.
3. **Strong quantum claim:** a physical quantum construction contains an active relative-reversal branch with an observable consequence.

The first is standard physics. The second is a formal comparison language. The third is an open research program.

## 2. Lina, Earth, and the black hole

Let A be departure and B reunion. Lina and Earth follow future-directed worldlines

\[
\gamma_L:A\to B,
\qquad
\gamma_E:A\to B.
\]

Their proper times are path functionals,

\[
\tau[\gamma]
=
\int_\gamma
\sqrt{-g_{\mu\nu}\,dx^\mu dx^\nu}/c.
\]

A finite audit uses the contrast

\[
\tau[\gamma_L]=1,
\qquad
\tau[\gamma_E]=1000.
\]

These numbers are illustrative rather than an orbital calculation. A physical ratio depends on the metric, route, velocity, orbit stability, and any acceleration used to hold position.

At B, unequal aging is invariant. Yet both curves still run from A to B and remain future-directed. Lina reaches a late Earth date after little personal aging; Earth does not thereby enter Lina's causal past. What is symmetric is the need to compare records. What is path-dependent is the accumulated proper time.

## 3. From an axis to an interface

RTI treats an event \(p=T_*\) as the point at which local temporal directions are defined:

\[
C_p^+\cap C_p^-=\varnothing.
\]

The interface has future and past sides. A realized step selects one local future direction. This prevents a category error: a two-sided possibility structure is not itself a two-way traveled worldline.

The existing TLFL record remains

\[
\mathrm{TimeTouch}_{\Sigma}(e)
=
(t_e,\tau_e)\in\Gamma_\Sigma,
\]

where \(\Gamma_\Sigma\) is an admissibility relation, not a pre-assumed function.

## 4. Comparing neighboring futures

Directions at distinct events are not automatically identical. RTI therefore requires

\[
\Theta_{p\leftarrow q}:
\operatorname{Direction}(q)
\to
\operatorname{Direction}(p).
\]

Preserving and reversing readings are separated:

\[
\Theta(C_q^+)\subseteq C_p^+
\quad\text{versus}\quad
\Theta(C_q^+)\subseteq C_p^-.
\]

The second statement is explicit RelativeReversal data. Standard differential aging does not construct it.

## 5. Checked logical core

Lean verifies that:

- one comparison cannot preserve and reverse the same nonempty future sector;
- RTI reuses the compiled two-axis TimeTouch surface;
- a reunion experiment records shared endpoints and unequal path durations;
- durations 1 and 1000 coexist with a future-preserving comparison;
- therefore differential aging alone does not force relative reversal.

Vampire 5.0.1 and E 3.2.5 independently return SZS status Theorem for the mirrored first-order disjointness result.

## 6. The quantum boundary

A minimal branch-indexed candidate is written

\[
Q=(B,\alpha,\mathrm{Active},\Theta).
\]

The article's strong criterion is

\[
\mathrm{QTM}(Q)
\Longleftrightarrow
\exists b,\;
\mathrm{Active}(b)
\land
\Theta_b(C_q^+)\subseteq C_p^-.
\]

The Lean carrier deliberately leaves amplitude data abstract. It does not provide a Hilbert space, normalization, interference, unitary dynamics, measurement theory, or spacetime realization.

The checked no-smuggling result is:

\[
\left[
\forall b,\;
\mathrm{Active}(b)
\Rightarrow
\Theta_b(C_q^+)\subseteq C_p^+
\right]
\Rightarrow
\neg\mathrm{QTM}(Q).
\]

A family of preserving branches is not transformed into reversal by the word “quantum.” A reversing branch must be explicit, and its physical admissibility remains a separate obligation. The theorem has a second independent Vampire/E first-order mirror.

## 7. Answer

**Yes, weakly:** spacetime already supports route-dependent accumulated time and one-way travel into another observer's future.

**Possibly, relationally:** internal clocks and correlations can order observed dynamics without a privileged external time.

**Not yet, strongly:** RTI currently has no physical \(\sigma=-1\) construction, no quantum comparison operator, no reversal-specific observable, and no demonstrated causal loop.

Thus:

\[
\boxed{
\text{We inhabit relativistic machines into the future;}
\quad
\text{a two-way quantum time machine remains an open hypothesis.}
}
\]

## 8. Research obligations

A physical RTI theory must:

1. derive the comparison map from explicit geometry;
2. define a genuine quantum carrier and dynamics;
3. derive an observable distinct from differential aging;
4. state the causal meaning of reversal;
5. provide a falsifiable experimental protocol.

Until then, the exact status is formalized hypothesis / physical bridge open.

## 9. Conclusion

The contribution is a refusal to collapse distinct statements:

- differential aging is not reversal;
- a two-sided local interface is not a two-way trajectory;
- a comparison map is not a worldline;
- quantum vocabulary is not quantum dynamics;
- an explicit reversal branch is not yet physical realization.

The resulting question is precise:

> Can a physical theory produce an observable active comparison branch in which one local future reads as another local past without destroying causal consistency?

That is the publication form of “Do we live inside a quantum time machine?”

---

# Evidence and sources

1. A. Einstein, “Die Grundlage der allgemeinen Relativitätstheorie,” Annalen der Physik 354 (1916), [DOI](https://doi.org/10.1002/andp.19163540702).
2. D. N. Page and W. K. Wootters, “Evolution without evolution,” Physical Review D 27, 2885 (1983), [DOI](https://doi.org/10.1103/PhysRevD.27.2885).
3. S. Gemsheim and J. M. Rost, “Emergence of Time from Quantum Interaction with the Environment,” Physical Review Letters 131, 140202 (2023), [DOI](https://doi.org/10.1103/PhysRevLett.131.140202).
4. G. Barontini, “Testing the problem of time with cold atoms,” Physical Review Research 8, L022047 (2026), [journal](https://journals.aps.org/prresearch/abstract/10.1103/1h9j-df4k), [arXiv](https://arxiv.org/abs/2509.07745).
5. A. Salkutsan, “The Elusive Graviton Candidate,” authorial TMI canon, [Zenodo](https://doi.org/10.5281/zenodo.21011196).

## Formal evidence

- lean/TMI/InterfaceFoundations/RelativeTemporalInterface.lean
- lean/TMI/InterfaceFoundations/RelativeTemporalInterfaceAudit.lean
- lean/TMI/InterfaceFoundations/QuantumComparisonBoundary.lean
- lean/TMI/InterfaceFoundations/QuantumComparisonBoundaryAudit.lean
- Checked boundary theorem: all_active_branches_preserving_excludes_reversal
- Checked finite witnesses: preserving_candidate_has_no_reversing_branch; mixed_candidate_reversal_is_explicit_branch_data
- external_proofs/rti_01_future_reading_cannot_be_both_tptp_0_1.p
- external_proofs/rti_02_quantum_reversal_requires_explicit_branch_tptp_0_1.p
- scripts/audit_rti_01_relative_temporal_interface.sh

**Certificate boundary:** the formal artifacts certify only the stated logical distinctions. They do not certify a black-hole solution, a physical reversal, a closed timelike curve, quantized spacetime, or an experimental quantum time machine.
