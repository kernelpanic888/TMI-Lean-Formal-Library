import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Poetry of Mathematics / Поэзия математики

This module is the internal formal theory behind reader PM-01. It does not
formalize the poem or promote its metaphysical reading to physics. It defines
the geometric and radiometric model, proves the consequences used by the
reader, and makes the remaining physical/geometric assumptions explicit.

The public reader is written for people. This file is the deep-verification
surface.
-/

namespace TMI.PoetryOfMathematics

open MeasureTheory Set
open scoped BigOperators

noncomputable section

/-! ## 1. Space, bounded rays, and hard shadow -/

/-- The reader's ambient space `E = ℝ³`. -/
abbrev Space := Fin 3 → ℝ

/-- The point at parameter `t` on the affine line from source `S` to receiver
`p`. The shadow predicate below deliberately restricts `t` to `(0, 1)`. -/
def ray (S p : Space) (t : ℝ) : Space :=
  (1 - t) • S + t • p

/-- An obstacle occludes `p` from `S` exactly when the open segment `S → p`
meets the obstacle. -/
def Occluded (U : Set Space) (S p : Space) : Prop :=
  ∃ t ∈ Ioo (0 : ℝ) 1, ray S p t ∈ U

/-- The hard shadow cast on support `Π`. -/
def Shadow (support U : Set Space) (S : Space) : Set Space :=
  {p | p ∈ support ∧ Occluded U S p}

theorem shadow_membership_iff
    {support U : Set Space} {S p : Space} (hp : p ∈ support) :
    p ∈ Shadow support U S ↔
      ∃ t ∈ Ioo (0 : ℝ) 1, ray S p t ∈ U := by
  simp [Shadow, Occluded, hp]

theorem occlusion_witness_is_strictly_bounded
    {U : Set Space} {S p : Space} (h : Occluded U S p) :
    ∃ t : ℝ, 0 < t ∧ t < 1 ∧ ray S p t ∈ U := by
  rcases h with ⟨t, ht, hU⟩
  exact ⟨t, ht.1, ht.2, hU⟩

/-- An obstacle that can only be reached after the receiver (`t ≥ 1`) cannot
cast a shadow on that receiver in this model. -/
theorem obstacle_behind_receiver_is_not_occluding
    {U : Set Space} {S p : Space}
    (hBehind : ∀ t : ℝ, ray S p t ∈ U → 1 ≤ t) :
    ¬ Occluded U S p := by
  intro hOccluded
  rcases hOccluded with ⟨t, ht, hU⟩
  exact (not_le_of_gt ht.2) (hBehind t hU)

/-! ## 2. Extended source and radiometric soft shadow -/

/-- Irradiance from an extended source represented as an integral of a
visibility factor times a nonnegative radiometric kernel. The kernel packages
emitted radiance and the geometric term used by the public formula. -/
def irradiance
    {A : Type*} [MeasurableSpace A]
    (μ : Measure A) (visibility kernel : A → Space → ℝ) (p : Space) : ℝ :=
  ∫ s, visibility s p * kernel s p ∂μ

/-- Irradiance of the same source with visibility identically one. -/
def unoccludedIrradiance
    {A : Type*} [MeasurableSpace A]
    (μ : Measure A) (kernel : A → Space → ℝ) (p : Space) : ℝ :=
  ∫ s, kernel s p ∂μ

/-- The reader's normalized shadow field. It is defined only after the
unoccluded irradiance is known to be positive. -/
def sigma (E_U E_0 : ℝ) : ℝ :=
  1 - E_U / E_0

theorem visibility_weight_between_zero_and_kernel
    {V K : ℝ} (hV : 0 ≤ V ∧ V ≤ 1) (hK : 0 ≤ K) :
    0 ≤ V * K ∧ V * K ≤ K := by
  constructor
  · exact mul_nonneg hV.1 hK
  · nlinarith

/-- Under the explicit radiometric hypotheses `0 ≤ V ≤ 1` and `0 ≤ K`,
occluded irradiance lies between zero and unoccluded irradiance. -/
theorem irradiance_bounds
    {A : Type*} [MeasurableSpace A]
    (μ : Measure A) (visibility kernel : A → Space → ℝ) (p : Space)
    (hVisible : ∀ s, 0 ≤ visibility s p ∧ visibility s p ≤ 1)
    (hKernel : ∀ s, 0 ≤ kernel s p)
    (hOccIntegrable : Integrable (fun s => visibility s p * kernel s p) μ)
    (hFullIntegrable : Integrable (fun s => kernel s p) μ) :
    0 ≤ irradiance μ visibility kernel p ∧
      irradiance μ visibility kernel p ≤ unoccludedIrradiance μ kernel p := by
  constructor
  · apply integral_nonneg
    intro s
    exact (visibility_weight_between_zero_and_kernel (hVisible s) (hKernel s)).1
  · apply integral_mono hOccIntegrable hFullIntegrable
    intro s
    exact (visibility_weight_between_zero_and_kernel (hVisible s) (hKernel s)).2

/-- `E_U = E_0 (1 - σ)` is a derived identity, not a second physical law. -/
theorem soft_shadow_identity
    {E_U E_0 : ℝ} (hE0 : E_0 ≠ 0) :
    E_U = E_0 * (1 - sigma E_U E_0) := by
  rw [sigma]
  field_simp
  ring

theorem sigma_between_zero_and_one
    {E_U E_0 : ℝ}
    (hE0 : 0 < E_0) (hEU0 : 0 ≤ E_U) (hEU1 : E_U ≤ E_0) :
    sigma E_U E_0 ∈ Icc (0 : ℝ) 1 := by
  constructor
  · rw [sigma]
    exact sub_nonneg.mpr ((div_le_one hE0).mpr hEU1)
  · rw [sigma]
    have hRatio : 0 ≤ E_U / E_0 := div_nonneg hEU0 (le_of_lt hE0)
    linarith

theorem radiometric_sigma_between_zero_and_one
    {A : Type*} [MeasurableSpace A]
    (μ : Measure A) (visibility kernel : A → Space → ℝ) (p : Space)
    (hVisible : ∀ s, 0 ≤ visibility s p ∧ visibility s p ≤ 1)
    (hKernel : ∀ s, 0 ≤ kernel s p)
    (hOccIntegrable : Integrable (fun s => visibility s p * kernel s p) μ)
    (hFullIntegrable : Integrable (fun s => kernel s p) μ)
    (hE0 : 0 < unoccludedIrradiance μ kernel p) :
    sigma (irradiance μ visibility kernel p)
        (unoccludedIrradiance μ kernel p) ∈ Icc (0 : ℝ) 1 := by
  have hBounds := irradiance_bounds μ visibility kernel p hVisible hKernel
    hOccIntegrable hFullIntegrable
  exact sigma_between_zero_and_one hE0 hBounds.1 hBounds.2

/-! ## 3. Tangencies, projection, and the shadow edge -/

/-- The tangent set associated with obstacle `U`, outward normal field `n`,
and point source `S`. This is a set, never a single privileged point. -/
def tangentSet (U : Set Space) (n : Space → Space) (S : Space) : Set Space :=
  {x | x ∈ frontier U ∧ (∑ i, n x i * (x - S) i) = 0}

/-- Every boundary point is generated by some tangent point. This is the exact
logical content needed for the general inclusion used by the reader. -/
def BoundaryGeneratedByTangencies
    (shadowBoundary tangencies : Set Space) (projection : Space → Space) : Prop :=
  ∀ ⦃p⦄, p ∈ shadowBoundary → ∃ x ∈ tangencies, projection x = p

theorem boundary_subset_projected_tangencies
    {shadowBoundary tangencies : Set Space} {projection : Space → Space}
    (hGenerated :
      BoundaryGeneratedByTangencies shadowBoundary tangencies projection) :
    shadowBoundary ⊆ projection '' tangencies := by
  intro p hp
  rcases hGenerated hp with ⟨x, hx, hxp⟩
  exact ⟨x, hx, hxp⟩

/-- The regularity contract is deliberately split into both directions. It
does not pretend that smoothness or physical visibility was derived by Lean. -/
structure RegularProjection
    (shadowBoundary visibleTangencies : Set Space)
    (projection : Space → Space) : Prop where
  boundaryHasVisibleWitness :
    ∀ ⦃p⦄, p ∈ shadowBoundary →
      ∃ x ∈ visibleTangencies, projection x = p
  visibleWitnessLandsOnBoundary :
    ∀ ⦃x⦄, x ∈ visibleTangencies → projection x ∈ shadowBoundary

/-- Under the explicit regularity contract, the shadow boundary equals the
projection of visible tangencies. -/
theorem boundary_eq_projected_visible_tangencies
    {shadowBoundary visibleTangencies : Set Space} {projection : Space → Space}
    (hReg : RegularProjection shadowBoundary visibleTangencies projection) :
    shadowBoundary = projection '' visibleTangencies := by
  apply Subset.antisymm
  · intro p hp
    rcases hReg.boundaryHasVisibleWitness hp with ⟨x, hx, hxp⟩
    exact ⟨x, hx, hxp⟩
  · rintro p ⟨x, hx, rfl⟩
    exact hReg.visibleWitnessLandsOnBoundary hx

/-! ## 4. Claim boundary: theorem, assumption, interpretation -/

inductive ClaimStatus where
  | standardOpticsAssumption
  | definedHere
  | kernelTheorem
  | authorInterpretation
  | redBoundary
deriving DecidableEq, Repr

def hardShadowStatus : ClaimStatus := .definedHere
def softIdentityStatus : ClaimStatus := .kernelTheorem
def regularBoundaryStatus : ClaimStatus := .kernelTheorem
def metaphysicalCanonStatus : ClaimStatus := .authorInterpretation
def otherWorldsStatus : ClaimStatus := .redBoundary

theorem metaphysical_canon_is_not_a_kernel_theorem :
    metaphysicalCanonStatus ≠ ClaimStatus.kernelTheorem := by
  decide

theorem other_worlds_claim_is_outside_the_theory :
    otherWorldsStatus = ClaimStatus.redBoundary := by
  rfl

end

end TMI.PoetryOfMathematics
