/- PIC-T Lean signature for TMI-Core-Proof 0.2-A7. -/

import TMI.Core

namespace TMI
namespace PicT

open Core

axiom PicRole : Type

axiom ToCoreRole : PicRole → Role
axiom IsAllowedPicRole : PicRole → Prop

def InterfaceInflationClaim : Prop := ∀ x : Obj, TypedInInterfaceDomain x → Ispace x

def DomainInflationClaim : Prop := ∀ x : Obj, DomTMI x → Ispace x

end PicT
end TMI
