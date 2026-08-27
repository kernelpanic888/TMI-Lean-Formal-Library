import Lake

open Lake DSL

package poetry_of_mathematics where
  moreLeanArgs := #["-DwarningAsError=true"]

/- Upstream information-geometry formalization.  This pins the exact
Spectra revision audited by PM-01; the formalization remains in its original
namespace and under its upstream Apache-2.0 attribution. -/
require Spectra from git
  "https://github.com/adambornemann-glitch/Spectra.git" @
    "8dbaaf6728d1342ae16acf79fd7eef7c59b37e63"

/- Keep Mathlib last so the PM-01 v4.31.0 release pin, rather than Spectra's
earlier v4.31.0-rc1 transitive pin, controls the shared dependency graph. -/
require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.31.0"

lean_lib PoetryOfMathematics where
  roots := #[`PoetryOfMathematics]

lean_lib PoetryOfMathematicsAudit where
  roots := #[`PoetryOfMathematicsAudit]
