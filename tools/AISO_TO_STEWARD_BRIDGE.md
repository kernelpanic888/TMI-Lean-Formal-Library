# AISO-02 / Selection-to-receipt bridge

## Contract

`AISO certificate -> CSS AdmittedTransition -> bound Receipt -> independent verification -> Learn`

AISO-02 prevents the selector from becoming an executor. A selection envelope binds one passport, policy, observation, action field, selected action, and objective score. CSS independently checks its own action field, adapter result, policy, and protected projection. The resulting receipt carries the original `selectionHash`. Learning is unavailable until the receipt digest and canonical `HEAD` pass verification.

## Refusal rules

- Observation or field drift invalidates the selection before application.
- Action substitution invalidates the receipt binding.
- Payload mutation invalidates the receipt digest.
- Failed independent verification blocks learning.
- Empty admissible set remains `NO_OP` and never enters CSS application.

## Evidence

- `AISOToStewardBridge.lean` and its axiom audit.
- `aiso-steward-bridge.mjs`.
- `tests/aiso-steward-bridge.test.mjs`.
- The existing CSS runtime now records `selectionHash` in intent, receipt payload, and witness.

## Red boundary

The hash binds local records but does not authenticate the selector. Authenticity still requires reviewed signatures and independent witnesses. The bridge does not install or exercise a privileged macOS helper. That physical step remains CSS-04.

## Shoulders

- [Simplex Architecture](https://www.sei.cmu.edu/library/an-architectural-description-of-the-simplex-architecture/)
- [Safe Reinforcement Learning via Shielding](https://arxiv.org/abs/1708.08611)
- [NIST AI RMF 1.0](https://doi.org/10.6028/NIST.AI.100-1)

---

# AISO-02 / Мост от выбора к квитанции

Селектор не получает права исполнения. Его результат связывается с паспортом, наблюдением, полем действий и конкретным действием. CSS повторно проверяет собственный контракт и выпускает квитанцию с тем же `selectionHash`. Только независимо проверенная квитанция открывает шаг обучения. Подмена состояния, поля, действия, содержимого квитанции или `HEAD` останавливает цикл.

