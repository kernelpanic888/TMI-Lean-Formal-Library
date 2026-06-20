/-
TMI-Core-Proof 0.2-A7 Lean signature.

This module declares the base sorts, objects, predicates, and role primitives
used by the compiled Lean axiom-shell skeleton.
-/

namespace TMI
namespace Core

axiom Obj : Type
axiom Event : Type
axiom Time : Type
axiom Boundary : Type
axiom Structure : Type
axiom Role : Type

axiom primaryI0 : Obj

axiom Der : Obj → Obj → Prop
axiom TransitionBetween : Obj → Obj → Obj → Prop
axiom PreIspace : Obj → Prop
axiom Ispace : Obj → Prop
axiom SubinterfaceOf : Obj → Obj → Prop
axiom ValidStr : Obj → Prop
axiom Dyn : Obj → Prop
axiom Static : Obj → Prop
axiom NonStatic : Obj → Prop
axiom AutoBox : Obj → Prop
axiom ReachTrig : Obj → Prop
axiom ExtControl : Obj → Boundary → Prop
axiom BoundaryOf : Obj → Boundary
axiom CausalFrame : Obj → Prop
axiom Integrated : Obj → Prop
axiom AbsoluteIsolation : Obj → Prop
axiom StaticOnly : Obj → Prop
axiom PassiveChannel : Obj → Prop
axiom EventAt : Event → Obj → Time → Prop
axiom StatusChanged : Obj → Prop

axiom PreInterfaceStructure : Structure → Prop
axiom InterfaceStructure : Structure → Prop
axiom InStructure : Obj → Structure → Prop
axiom StructurallyLinked : Obj → Structure → Prop
axiom MaxStruct : Structure → Prop
axiom StructLift : Structure → Prop
axiom BoundaryOfStruct : Structure → Boundary
axiom BoundaryIsolation : Structure → Boundary → Prop
axiom StructObj : Structure → Obj

axiom DomTMI : Obj → Prop
axiom Meaningful : Obj → Prop
axiom Distinguishable : Obj → Prop
axiom TypedInInterfaceDomain : Obj → Prop
axiom TypedAs : Obj → Role → Prop
axiom roleInterface : Role

end Core
end TMI
