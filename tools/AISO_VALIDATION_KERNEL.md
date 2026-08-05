# K-00 / Interface closure kernel

There are two states, `S_A` and `S_B`, their validators `V_A` and `V_B`, and an interface compatibility predicate `C_I`.

`V_A : S_A -> {0,1}`

`V_B : S_B -> {0,1}`

`C_I : S_A x S_B -> {0,1}`

`Act_I(a,b) = V_A(a) and V_B(b) and C_I(a,b)`

`Exec_I(a,b) = some(a,b)` when `Act_I(a,b)=1`; otherwise `none`.

The triple is not an optional score. It is an operational closure. Full agreement yields the unchanged candidate act. One mismatch yields silence: no fallback, repair, substitution, ranking, learning, or side effect.

Formal evidence: `AISOValidationKernel.lean` and `AISOValidationKernelAudit.lean`.

Executable evidence: `aiso-validation-kernel.mjs` and the complete eight-row truth table in `tests/aiso-validation-kernel.test.mjs`.

Red boundary: the kernel proves the semantics of triple agreement. It does not prove that `V_A`, `V_B`, or `C_I` correctly represent the outside world.

---

# K-00 / Ядро интерфейсного замыкания

Есть два состояния, `S_A` и `S_B`, две проверки их допустимости, `V_A` и `V_B`, и предикат совместимости интерфейса `C_I`.

Действие возникает только при одновременном совпадении трёх условий. Тройная связка не является оценкой или дополнительной опцией. Это операциональное замыкание. Полное совпадение возвращает исходный кандидат действия. Любое несовпадение означает тишину: без запасного хода, исправления, подмены, ранжирования, обучения или побочного эффекта.
