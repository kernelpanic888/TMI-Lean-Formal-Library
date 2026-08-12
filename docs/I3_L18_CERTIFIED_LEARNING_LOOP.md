# I³-L18 / Certified Learning Loop

## Human reading

A neural proposal is not an intellectual act, and one certified act is not yet
learning. L18 admits a parameter change only after an L17-certified act leaves
an exact trace, feedback is bound to that act, the proposed delta is bounded,
independent validation loss does not increase, and the generation/receipt head
advances exactly once. The transition carries an exact rollback capsule.

In Russian: обучение здесь означает не свободную самоперезапись, а возвращаемое
изменение, прошедшее через сертифицированный акт, след, ограниченную дельту,
внешнюю проверку и атомарное продолжение истории.

## Contract

```text
Learn18 := Act17
        ∧ FeedbackBound(trace, observation)
        ∧ Δθ ∈ {-1, 0, 1}⁶
        ∧ Lvalid(θ + Δθ) ≤ Lvalid(θ)
        ∧ generation' = generation + 1
        ∧ head' = receiptDigest
        ∧ rollback(after) = before
```

The Lean model proves identity preservation for one step and for any finite
chain of certified steps. Rejected observations hold the complete snapshot.

## Primary shoulders

- NIST AI RMF 1.0: validation, reliability, safety and accountability.
  https://doi.org/10.6028/NIST.AI.100-1
- Schulman et al., Trust Region Policy Optimization: bounded iterative policy
  change. https://arxiv.org/abs/1502.05477
- Laroche et al., Safe Policy Improvement with Baseline Bootstrapping:
  conservative improvement under uncertainty. https://arxiv.org/abs/1712.06924

## Red boundary

Non-increasing validation loss is local to the supplied test and metric. It
does not prove generalization, semantic truth, optimal learning, consciousness,
personhood, digital life, cryptographic security, hardware provenance or true
AI. The current hardware evidence used by the executable audit is synthetic.
