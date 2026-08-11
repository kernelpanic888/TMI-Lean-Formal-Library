/-
Self-closed theorem of the paradoxical formula.

Canonical destination after review:
  lean/TMI/FormulaInterface/ParadoxicalFormulaTheorem.lean

This file introduces no model, no axiom, no structure and no object-specific
definition. Every symbol occurring in the theorem is bound by the theorem.
The result is relative to the selected formula class Phi and to the three
explicit hypotheses describing freedom, completeness and forcing.
-/

namespace TMI
namespace FormulaInterface

/--
If the limit object is freely connected, every Phi-complete formula would
force it, and forcing contradicts its free connectivity, then no formula from
Phi fully exhausts the object.

This is a closed theorem schema: all types, predicates, the object and the
three hypotheses are universally bound by the declaration.
-/
theorem T_paradoxical_formula_self_closed
    {F O : Type}
    (Phi : F → Prop)
    (Full : F → O → Prop)
    (Free : O → Prop)
    (Force : F → O → Prop)
    (U : O)
    (hFree : Free U)
    (hFullForces : ∀ φ, Phi φ → Full φ U → Force φ U)
    (hForceExcludesFree : ∀ φ, Phi φ → Force φ U → ¬ Free U) :
    ¬ ∃ φ, Phi φ ∧ Full φ U := by
  rintro ⟨φ, hPhi, hFull⟩
  have hForce : Force φ U := hFullForces φ hPhi hFull
  exact (hForceExcludesFree φ hPhi hForce) hFree

#print axioms T_paradoxical_formula_self_closed

end FormulaInterface
end TMI
