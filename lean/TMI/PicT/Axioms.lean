/- PIC-T Lean axioms for TMI-Core-Proof 0.2-A7. -/

import TMI.PicT.Signature

namespace TMI
namespace PicT

axiom allowed_role_has_core_role : ∀ r : PicRole, IsAllowedPicRole r → True

end PicT
end TMI
