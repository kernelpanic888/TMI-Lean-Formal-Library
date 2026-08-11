function bit(value, label) {
  if (value !== 0 && value !== 1) throw new TypeError(`${label} must return 0 or 1`);
  return value;
}

export function admitted(action, { selfValidate, externalValidate, safe }) {
  return bit(selfValidate(action), "V0")
    & bit(externalValidate(action), "Vext")
    & bit(safe(action), "Safe");
}

export function execute(action, gate) {
  return admitted(action, gate) === 1 ? action : null;
}
