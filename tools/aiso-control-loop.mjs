const finite = (value, label) => {
  if (!Number.isFinite(value)) throw new TypeError(`${label} must be finite`);
  return value;
};

export function weightedObjective(weights, metrics) {
  return finite(weights.alpha, "alpha") * finite(metrics.improvement, "improvement")
    - finite(weights.beta, "beta") * finite(metrics.risk, "risk")
    - finite(weights.gamma, "gamma") * finite(metrics.cost, "cost")
    - finite(weights.lambda, "lambda") * finite(metrics.entropy, "entropy");
}

export function evaluateCandidate({ state, candidate, riskBound }) {
  const checks = Object.freeze({
    available: candidate.available !== false,
    constrained: candidate.constrained === true,
    positiveImprovement: finite(candidate.metrics.improvement, "improvement") > 0,
    riskWithinBound: finite(candidate.metrics.risk, "risk") <= finite(riskBound, "riskBound"),
    validated: candidate.validated === true,
    permitted: candidate.permitted === true,
    safe: candidate.safe === true,
    preservesInvariant: candidate.preservesInvariant === true,
    qualityImproves: finite(candidate.qualityAfter, "qualityAfter") > finite(state.quality, "state.quality"),
    rollbackWitness: candidate.rollbackWitness != null,
  });

  return Object.freeze({
    admissible: Object.values(checks).every(Boolean),
    checks,
  });
}

export function selectBest({ state, candidates, weights, riskBound, noOp = { id: "NO_OP" } }) {
  const evaluated = candidates.map((candidate) => {
    const evidence = evaluateCandidate({ state, candidate, riskBound });
    return {
      candidate,
      evidence,
      score: evidence.admissible ? weightedObjective(weights, candidate.metrics) : null,
    };
  });

  const admissible = evaluated
    .filter((entry) => entry.evidence.admissible)
    .sort((left, right) =>
      right.score - left.score || String(left.candidate.id).localeCompare(String(right.candidate.id))
    );

  if (admissible.length === 0) {
    return Object.freeze({
      kind: "hold",
      action: noOp,
      reason: "no-admissible-action",
      evaluated,
    });
  }

  const winner = admissible[0];
  return Object.freeze({
    kind: "act",
    action: winner.candidate,
    score: winner.score,
    evidence: winner.evidence,
    evaluated,
  });
}

export function executeDecision({
  state,
  model,
  decision,
  apply,
  postVerify,
  quality,
  invariantsHold,
  rollback,
  makeReceipt,
  learn,
}) {
  if (decision.kind === "hold") {
    return Object.freeze({ kind: "held", state, model, learned: false, action: decision.action });
  }

  const next = apply(state, decision.action);
  const verified = postVerify(state, decision.action, next) === true;
  const improved = finite(quality(next), "quality(next)") > finite(quality(state), "quality(state)");
  const protectedStatePreserved = invariantsHold(state, next, decision.action) === true;

  if (!verified || !improved || !protectedStatePreserved) {
    const restored = rollback(next, decision.action.rollbackWitness, state);
    return Object.freeze({
      kind: "rolled-back",
      state: restored,
      model,
      learned: false,
      failure: Object.freeze({ verified, improved, protectedStatePreserved }),
    });
  }

  const receipt = makeReceipt(state, decision.action, next);
  const nextModel = learn(model, state, decision.action, next, receipt);
  return Object.freeze({
    kind: "committed",
    state: next,
    model: nextModel,
    receipt,
    learned: true,
  });
}

