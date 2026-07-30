import Mathlib.CategoryTheory.EpiMono

/-!
# Two-point trace interface

A comparison admitting an external trace has a concrete retraction and loses
no internal distinction. Existence of the trace remains a separate obligation.
-/

namespace TMI.InterfaceFoundations.TwoPointTrace

open CategoryTheory

universe v u

structure TwoPointInterface {C : Type u} [Category.{v} C]
    {Z I E : C} (coordinate : Z ≅ I) (comparison : I ⟶ E) where
  externalTrace : E ⟶ Z
  align : comparison ≫ externalTrace = coordinate.inv

namespace TwoPointInterface

variable {C : Type u} [Category.{v} C] {Z I E : C}
  {coordinate : Z ≅ I} {comparison : I ⟶ E}

def retraction (interface : TwoPointInterface coordinate comparison) : E ⟶ I :=
  interface.externalTrace ≫ coordinate.hom

@[reassoc]
theorem comparison_retraction (interface : TwoPointInterface coordinate comparison) :
    comparison ≫ interface.retraction = 𝟙 I := by
  dsimp [retraction]
  rw [← Category.assoc, interface.align, coordinate.inv_hom_id]

theorem comparison_mono (interface : TwoPointInterface coordinate comparison) :
    Mono comparison := by
  constructor
  intro W f g h
  simpa only [Category.assoc, comparison_retraction interface, Category.comp_id] using
    congrArg (fun k : W ⟶ E => k ≫ interface.retraction) h

def carrier : Z ⟶ E :=
  coordinate.hom ≫ comparison

@[reassoc]
theorem carrier_trace (interface : TwoPointInterface coordinate comparison) :
    carrier (coordinate := coordinate) (comparison := comparison) ≫
      interface.externalTrace = 𝟙 Z := by
  dsimp [carrier]
  rw [Category.assoc, interface.align, coordinate.hom_inv_id]

end TwoPointInterface
end TMI.InterfaceFoundations.TwoPointTrace
