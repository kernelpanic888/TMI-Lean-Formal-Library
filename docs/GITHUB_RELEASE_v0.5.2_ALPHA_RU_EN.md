# TLFL v0.5.2-alpha — Selection Field

## RU

Возвращён отдельный селектор поля ближайших целей:

`память -> поле возможностей -> селектор -> выбранная цель`.

Поле не выбирает само себя. `choose` является дополнительной структурой.
Добавлены формальный frame, set-valued field, selection predicate, теорема о
непустоте и блуждание внутри поля. В `PredictionBoundary` исправлено
пропозициональное неравенство.

Lean build и аудит аксиом не запускались; статус `authored / experimental`.

## EN

The separate nearby-goal selector has been restored:

`memory -> possibility field -> selector -> selected goal`.

The field does not select itself. `choose` is additional structure. The release
adds the formal frame, set-valued field, selection predicate, nonemptiness
result, and wandering inside the field. The prediction boundary now uses
propositional inequality.

No Lean build or axiom audit was run; status is `authored / experimental`.
