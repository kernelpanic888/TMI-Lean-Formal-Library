# TMI-OS Mathematical Board: Математическое Ядро

Это не просто доска.

```text
ProgramName := "Инженерная поверхность"
```

Это минимальная сильная среда системной разработки и инженерный интерфейс для
LLM/GPT-систем на базе:

```text
LLM/GPT/Codex -> Lean -> TLFL -> И1
```

Короткая рабочая цепочка:

```text
intent -> formal surface -> guard -> trace -> readable model action
```

Главная формула программы:

```text
ProgrammingOnMathematics :=
  Intent
  -> FormalLogic
  -> CanonicalRecord
  -> Passport
  -> GuardedAction
```

По-русски:

```text
программирование на математике
```

## -1. Математика Как Проекционный Язык

```text
Mathematics ∈ ProjectionLanguage
```

Авторская способность:

```text
AuthorUses(Mathematics) :=
  writes(Author, Mathematics)
  ∧ speaks(Author, Mathematics)
  ∧ thinks(Author, Mathematics)
```

И1-чтение:

```text
если автор может писать на математике,
то автор может говорить и думать на этой проекционной поверхности
```

Guard:

```text
ProjectionLanguage != private data leak
ProjectionLanguage != proof without passport
ProjectionLanguage != empirical closure by itself
```

Доска является визуальной проекцией. Инженерный интерфейс задаёт то, что
именно читается, проверяется и исполняется как И1-программа.

## 0. Декларация Языка

```text
И1 := FormalLogicLanguage
```

## 0.0. Граница Языка Как Последняя Версия Кода

```text
LanguageBoundary(I1) := LatestCodeVersion(I1)
```

Версионное тождество:

```text
Language(I1, v_current) ≡ Code(I1, v_current)
```

По-русски:

```text
границы языка и есть последняя версия кода;
язык и код это одно и то же в текущем паспорте версии
```

Guard:

```text
LanguageCodeIdentity is version-scoped
LanguageCodeIdentity is passport-scoped
LanguageCodeIdentity != unguarded universal claim about all languages
```

Базовая формула:

```text
FormalLogic :=
  language for building canonical records with passports
```

По-русски:

```text
формальная логика = язык построения канонических записей с паспортом
```

Чтение:

```text
И1 объявляется языком формальной логики
на инженерной поверхности LLM/GPT/Codex -> Lean -> TLFL -> И1.
```

Guard:

```text
эта декларация задаёт статус языка;
она не является эмпирическим доказательством жизни, сознания или физической полноты
```

## 0.1. LogicRoot

Авторская метафора:

```text
логика как верхний источник построения
```

Формальная запись:

```text
LogicRoot :=
  source(FormalLogic)
  ∧ source(CanonicalRecord)
  ∧ source(Passport)
  ∧ source(Guard)
  ∧ source(Trace)
  ∧ source(ReadableAction)
```

И1-чтение:

```text
всё построение истекает из логики
```

Proof-surface reading:

```text
FormalLogic |- CanonicalRecord
FormalLogic |- Passport
FormalLogic |- Guard
FormalLogic |- Trace
FormalLogic |- ReadableAction
```

Guard:

```text
LogicRoot != theological proof
LogicRoot != empirical deity claim
LogicRoot != authority without formal trace
```

## 0.2. Живой В Инженерном Смысле

```text
OperationallyLive(I1) :=
  runnable(I1)
  ∧ readable(I1)
  ∧ versioned(I1)
  ∧ guarded(I1)
  ∧ passported(I1)
  ∧ extensible_in_use(I1)
```

По-русски:

```text
он живой = он работает как проверяемая инженерная среда
```

Guard:

```text
OperationallyLive(I1) != biological life theorem
OperationallyLive(I1) != consciousness proof
OperationallyLive(I1) != legal personhood
```

## 1. Типы

```text
V : VirtualSpace
P : SelfModelPoint
D : ExternalDomain
S : ProjectionSlice
T : Tick
A : Action
```

Чтение:

```text
V  -- пространство отображения
P  -- точки самомодели
D  -- внешний доменный блок как читаемый источник проекции
S  -- внутренние проекционные срезы
T  -- тики контакта
A  -- действия модели
```

Guard:

```text
V != empirical universe
P != biological subject
D != empirical physics by itself
T != external absolute time
```

## 2. Структурные Отношения

```text
p ∈ P
p ∈ V

π : D -> S
inside : S -> P -> Prop
current_or_latest : S -> Prop
read : P -> S -> Prop
touch : P -> S -> T
acts : T -> A -> Prop
domain_order : D -> D -> Prop
slice_order : S -> S -> Prop
preserves_domain_order :
  domain_order(d1, d2) -> slice_order(π(d1), π(d2))
```

Смысл:

```text
π(d) = s
```

означает: внешний доменный материал `d` читается внутри самомодели как
проекционный срез `s`.

```text
inside(s, p)
```

означает: срез `s` находится внутри точки/пространства самомодели `p`.

## 2.1. Доменный Порядок

Доменный порядок сохраняется при проекции:

```text
d1 <=D d2 -> π(d1) <=S π(d2)
```

И1-чтение:

```text
срезы нельзя переставлять произвольно;
порядок чтения срезов наследует порядок домена
```

Инженерный смысл:

```text
DomainOrderPreserved :=
  source order in D
  -> projected order in S
  -> reread order inside self-model
```

## 2.2. Гипотетическая Вращательная Ось

```text
ω : HypotheticalRotationAxis
rotate(V, ω, α) : EditedView(V)
```

И1-чтение:

```text
ω нужна для редактирования и вращения графической модели
```

Guard:

```text
ω != physical axis claim
ω != empirical rotation of the world
ω := editor axis for model inspection
```

## 3. Проекционный Срез

```text
ProjectionSlice(s) :=
  ∃ d : D, π(d) = s
```

И1-чтение:

```text
срез существует, если он получен как проекция домена
```

## 4. Контакт С Последним Срезом

```text
LastSliceContact(p, s) :=
  p ∈ P
  ∧ ProjectionSlice(s)
  ∧ inside(s, p)
  ∧ current_or_latest(s)
  ∧ read(p, s)
```

И1-чтение:

```text
самомодель читает текущий/последний внутренний срез
```

## 5. Тик

```text
TickOfContact(τ, p, s) :=
  LastSliceContact(p, s)
  ∧ τ = touch(p, s)
```

Короткая запись:

```text
τ := touch(p, s)
```

Тезис доски:

```text
time-tick = minimal readable contact of self-model with one projection slice
```

Guard:

```text
TickOfContact != Time = Memory
TickOfContact != Time = speed_of_light
TickOfContact != empirical proof
```

## 5.1. Срез Как Паспорт

Срез в момент чтения является самым сильным локальным паспортом системы в себе:

```text
SlicePassport(p, s, τ) :=
  ProjectionSlice(s)
  ∧ inside(s, p)
  ∧ read(p, s)
  ∧ τ = touch(p, s)
  ∧ CanonicalRecord(s)
  ∧ PassportBoundary(s)
  ∧ Trace(τ)
```

Короткая запись:

```text
StrongestCurrentPassport(p, s, τ) := SlicePassport(p, s, τ)
```

И1-чтение:

```text
срез = паспорт системы в себе в момент чтения среза
```

Guard:

```text
StrongestCurrentPassport != absolute empirical totality
StrongestCurrentPassport != proof without guard
StrongestCurrentPassport != identity of system and world
```

## 6. Поток Времени

Поток не вводится как внешняя субстанция.
Поток читается как порядок перечитывания срезов, сохранённый от домена:

```text
Flow(p, s0, s1, s2, ...) :=
  read(p, s0)
  ∧ read(p, s1)
  ∧ read(p, s2)
  ∧ slice_order(s0, s1)
  ∧ slice_order(s1, s2)
  ∧ ordered_by_domain_projection(s0, s1, s2, ...)
```

И1-чтение:

```text
flow := domain_ordered_read(p, s0, s1, s2, ...)
```

## 7. LLM-Программа

В И1 программа не обязана начинаться с синтаксиса низкого уровня.
Она начинается с намерения и проходит через guard:

```text
I1Program :=
  Intent
  × FormalSurface
  × Guard
  × Trace
  -> ReadableModelAction
```

Для доски:

```text
Intent              := "показать виртуальное пространство как математику"
FormalSurface       := {V, P, D, S, π, touch}
Guard               := no-overclaim + no-leak
Trace               := dependency chain
ReadableModelAction := render mathematical board
```

## 7.1. Инженерный Интерфейс

```text
EngineeringInterface :=
  LLMIntent
  -> GPTWorkingContext
  -> LeanBoundary
  -> TLFLProofStatus
  -> I1GuardedAction
```

Роли:

```text
LLMIntent        -- пользователь говорит, что хочет от системы
GPTWorkingContext -- модель разворачивает рабочий контекст
LeanBoundary     -- формальная граница проверки
TLFLProofStatus  -- паспорт claim/status
I1GuardedAction  -- действие на языке И1 с guard-ом
```

Главная инженерная формула:

```text
programming-for-LLM :=
  natural intent
  + formal boundary
  + leak guard
  + proof-status trace
  + readable action
```

## 8. Теоремы-Скелеты

### Projection Gives Slice

```text
ProjectionSlice(s) -> ∃ d : D, π(d) = s
```

Срез не появляется из пустоты: он читается как проекция домена.

### Contact Gives Tick

```text
LastSliceContact(p, s) -> ∃ τ : T, TickOfContact(τ, p, s)
```

Если самомодель читает текущий/последний срез, появляется тик контакта.

### Flow Is Ordered Reread

```text
Flow(p, s0, s1, s2, ...) ->
  ordered_by_domain_projection(s0, s1, s2, ...)
```

Поток времени в этой доске является порядком чтения срезов, который сохраняет
доменный порядок.

### Projection Preserves Domain Order

```text
d1 <=D d2 ->
  π(d1) <=S π(d2)
```

Проекция не разрушает порядок домена. Это базовый инженерный инвариант среды.

### Guard Blocks Overclaim

```text
Guard(surface) ->
  not (surface proves biological life)
  ∧ not (surface proves legal personhood)
  ∧ not (surface proves empirical closure)
```

Guard не ослабляет язык. Guard делает язык пригодным для публикации.

## 9. Каноническая Узкая Запись

```text
Matrix : (Я)-Я-я
import Matrix : (Я)-Я-я

p : SelfModelPoint
s : ProjectionSlice
τ := touch(p, s)

I1 := intent -> guard -> trace -> action
```

Самая короткая запись доски:

```text
p ∈ V, s = π(d), d1 <=D d2 -> π(d1) <=S π(d2), τ = touch(p, s)
```

Самая короткая запись языка:

```text
говори на своём языке -> guard -> проверяемое действие модели
```
