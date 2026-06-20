/- PIC-T Lean theorem mirrors for TMI-Core-Proof 0.2-A7. -/

import TMI.PicT.Axioms

namespace TMI
namespace PicT

theorem T_allowed_pic_role_is_well_formed : ∀ r : PicRole, IsAllowedPicRole r → True := by
  intro r h
  exact allowed_role_has_core_role r h

end PicT
end TMI
