# AZ-00 / Agent Zero validation kernel

Let `X` be an action. Agent Zero has exactly three predicates:

`V_0, V_ext, Safe : X -> {0,1}`

`Exec_0(X) = some(X) iff V_0(X)=1 and V_ext(X)=1 and Safe(X)=1`.

Otherwise `Exec_0(X) = none`.

There is no score, ranking, repair, substitution, learning, fallback, or side effect in this kernel. All three predicates inspect the same action. Full agreement returns that unchanged action; one zero means no action.

Formal evidence: `AgentZeroValidationKernel.lean` and `AgentZeroValidationKernelAudit.lean`.

Executable evidence: `agent-zero-validation-kernel.mjs` and the complete eight-row truth table in `tests/agent-zero-validation-kernel.test.mjs`.

Red boundary: the kernel proves conjunction semantics. It does not prove that any predicate correctly represents the outside world.

---

# AZ-00 / Ядро валидации Agent Zero

Пусть `X` является действием. У Agent Zero есть ровно три предиката: самовалидация `V_0`, внешняя валидация `V_ext` и контур безопасности `Safe`.

`Exec_0(X)` возвращает исходное действие тогда и только тогда, когда одновременно истинны все три предиката. В противном случае результатом является бездействие `none`. Никакой оценки, подмены, исправления, обучения или запасного хода в ядре нет.
