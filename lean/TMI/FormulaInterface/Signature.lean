/-
Formula-as-Pure-Interface Lean signature for TMI-Core-Proof 0.2-A7.
-/

import TMI.Core

namespace TMI
namespace FormulaInterface

open Core

axiom Formula : Type
axiom Record : Type
axiom Carrier : Type
axiom BridgeTarget : Type

axiom FormulaObj : Formula → Obj
axiom RecordObj : Record → Obj
axiom CarrierObj : Carrier → Obj
axiom RecOf : Formula → Record
axiom CarrierOfRecord : Record → Carrier

axiom PureInterfaceObj : Obj → Prop

axiom roleFormula : Role
axiom roleFormulaRecord : Role
axiom roleFormulaCarrier : Role
axiom roleBridgeCandidate : Role

axiom mdTarget : BridgeTarget
axiom BridgeTyped : Formula → BridgeTarget → Prop
axiom BridgeCandidateFormula : Formula → Prop
axiom CoreAdmissibleBridge : Formula → Prop

end FormulaInterface
end TMI
