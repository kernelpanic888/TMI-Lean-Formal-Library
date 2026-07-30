# TLFL v0.5.2-alpha — поле выбора

Корректирующий alpha-релиз возвращает слой выбора, присутствовавший в раннем
`TLFL_WANDERING_GOAL_FIELD.lean`.

## Формальная цепь

```text
память -> поле допустимых целей -> отдельный селектор -> выбранная цель
```

Добавлены `FieldOfNearestGoalsFrame`, `FieldOfNearestGoals`,
`FieldOfNearestGoalsSelection`, `fieldOfNearestGoals_nonempty_of_selection` и
`WanderingInsideGoalField`.

Поле остаётся множеством возможностей. Функция `choose` является отдельными
данными и не выводится из существования поля.

Также в `PredictionBoundary` булевоподобная запись `!=` заменена на строгое
пропозициональное неравенство `≠`.

Lean build и аудит аксиом в этом шаге не запускались. Статус остаётся
`authored / experimental`; стабильный `TMI.Library` новый корень не импортирует.
