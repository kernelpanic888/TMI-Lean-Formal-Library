function bit(value, label) {
  if (value !== 0 && value !== 1) throw new TypeError(`${label} must return 0 or 1`);
  return value;
}

export function closed(act, { validateA, validateB, compatible }) {
  return bit(validateA(act.stateA), "VA")
    & bit(validateB(act.stateB), "VB")
    & bit(compatible(act.stateA, act.stateB), "CI");
}

export function execute(act, interfaceGate) {
  return closed(act, interfaceGate) === 1 ? act : null;
}
