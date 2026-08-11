import Lake

open Lake DSL

package poetry_of_mathematics where
  moreLeanArgs := #["-DwarningAsError=true"]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.31.0"

lean_lib PoetryOfMathematics where
  roots := #[`PoetryOfMathematics]

lean_lib PoetryOfMathematicsAudit where
  roots := #[`PoetryOfMathematicsAudit]
