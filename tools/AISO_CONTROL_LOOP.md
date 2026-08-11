# AISO-01 / Safe Improvement Control Loop

## Status

`FORMAL CORE + EXECUTABLE REFERENCE + BLIND CORPUS`

AISO-01 is a selector above the Certified System Steward. AISO chooses a proof-carrying admissible change. CSS applies that change inside the passport action field and emits a runtime receipt.

## Model

`AISO = (S, M, A, J, C, V, P)`

- `S`: state and state history.
- `M`: model used at the current tick.
- `A`: available actions.
- `J`: weighted objective.
- `C`: domain constraints and protected invariants.
- `V`: validation predicate.
- `P`: authorization predicate.

For time `t`, define the admissible set:

`D_t = {delta in A_t | Improve(S_t,delta)>0 and Risk(delta)<=rho and C and V and P and Safe and PreservesInv and RollbackWitness}`

The selected action is:

`delta*_t = argmax_(delta in D_t) J(S_t,delta)`

`J(S_t,delta) = alpha Improve - beta Risk - gamma Cost - lambda Entropy`

If `D_t` is empty, the only decision is `NO_OP`. A committed transition must pass post-verification, strictly improve the declared quality measure, preserve every protected invariant, and carry rollback evidence. Learning is constructed only from a verified transition.

## Cycle

`Observe -> Model -> Select -> Validate -> Authorize -> Apply -> Verify -> Learn`

The loop is deliberately asymmetric. Selection can be complex. Admission, post-verification, rollback evidence, and the no-op branch remain explicit and inspectable.

## Artifacts

- `AISOControlLoop.lean`: formal definitions and local theorems.
- `AISOControlLoopAudit.lean`: axiom audit.
- `aiso-control-loop.mjs`: side-effect-free reference selector and commit gate.
- `tests/aiso-control-loop.test.mjs`: mutation and failure scenarios.

## Scientific shoulders

- [Achiam et al., Constrained Policy Optimization](https://arxiv.org/abs/1705.10528): optimize an objective while satisfying explicit constraints.
- [Alshiekh et al., Safe Reinforcement Learning via Shielding](https://arxiv.org/abs/1708.08611): expose or enforce only actions that satisfy a formal safety specification.
- [Rivera et al., An Architectural Description of the Simplex Architecture](https://www.sei.cmu.edu/library/an-architectural-description-of-the-simplex-architecture/): keep a complex controller behind a verified high-assurance control boundary.
- [NIST AI RMF 1.0](https://doi.org/10.6028/NIST.AI.100-1): continuous mapping, measuring, managing, and explicit deployment decisions.

## Red boundary

Lean verifies consequences of the predicates supplied to AISO. It does not establish that a physical adapter is complete, that `Q` measures real benefit, that `Risk` is calibrated, or that a validator predicts the world. `BestAdmissible` is proof-carrying evidence for a chosen action; it is not a proof that a computable global argmax exists for every action space. Rollback is guaranteed only when a concrete witness is supplied. The physical privileged helper remains the separate CSS-04 milestone.

---

# AISO-01 / Контур безопасного улучшения

AISO-01 выбирает переход, а Certified System Steward исполняет его в разрешённом поле действий и выпускает квитанцию. Допустимы только действия с положительным улучшением, риском не выше `rho`, успешной валидацией и авторизацией, сохранением защищённых инвариантов и конкретным свидетельством отката. Среди них выбирается максимум `J`; при пустом множестве выполняется `NO_OP`. Обучение разрешается только после постпроверки результата.

Красная граница: доказана логика условного выбора, а не достоверность внешней модели мира, функции качества или оценки риска.

