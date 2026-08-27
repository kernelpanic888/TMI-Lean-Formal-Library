import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Spectra.InformationGeometry.StatisticalManifold

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

/-! ## 4. Beauty, verification, magic, and poetic reading -/

/-- `B = C + I + G + R` is represented as a structural conjunction rather
than an arithmetic equality. The four predicates remain explicit inputs. -/
def BeautyCandidate
    {α : Type*}
    (Coherent Invariant Generative Repeatable : α → Prop) (x : α) : Prop :=
  Coherent x ∧ Invariant x ∧ Generative x ∧ Repeatable x

/-- A beautiful form becomes a candidate trace of reality only when a
separate check is supplied. This definition does not identify beauty with
proof and does not say what empirical protocol must implement `Checked`. -/
def RealityTraceCandidate
    {α : Type*}
    (Coherent Invariant Generative Repeatable Checked : α → Prop)
    (x : α) : Prop :=
  BeautyCandidate Coherent Invariant Generative Repeatable x ∧ Checked x

/-- The verification requirement is a projection from the definition, not a
claim that beauty manufactures its own evidence. -/
theorem reality_trace_candidate_requires_check
    {α : Type*}
    {Coherent Invariant Generative Repeatable Checked : α → Prop}
    {x : α}
    (h : RealityTraceCandidate
      Coherent Invariant Generative Repeatable Checked x) :
    Checked x := by
  exact h.2

/-- If the external check is absent, a structurally beautiful candidate is not
a reality-trace candidate in this model. -/
theorem unverified_beauty_is_not_reality_trace
    {α : Type*}
    {Coherent Invariant Generative Repeatable Checked : α → Prop}
    {x : α}
    (_hBeauty : BeautyCandidate Coherent Invariant Generative Repeatable x)
    (hUnchecked : ¬ Checked x) :
    ¬ RealityTraceCandidate
      Coherent Invariant Generative Repeatable Checked x := by
  intro hTrace
  exact hUnchecked hTrace.2

/-- Poetry is modeled as a human reading of magic, not as a synonym for magic.
`Readable` is an explicit interface and is not derived from `Magic`. -/
def PoeticReading
    {α : Type*} (Magic Readable : α → Prop) (x : α) : Prop :=
  Magic x ∧ Readable x

theorem poetic_reading_presupposes_magic
    {α : Type*} {Magic Readable : α → Prop} {x : α}
    (h : PoeticReading Magic Readable x) : Magic x := by
  exact h.1

theorem poetic_reading_requires_readability
    {α : Type*} {Magic Readable : α → Prop} {x : α}
    (h : PoeticReading Magic Readable x) : Readable x := by
  exact h.2

/-! ## 5. Hypothesis orbits around a verified factual core -/

/-- Epistemic status is not a geometric coordinate.  In particular, changing
an angle does not silently change a hypothesis into a verified fact. -/
inductive EpistemicStatus where
  | hypothesis
  | verifiedFact
deriving DecidableEq, Repr

/-- The center `C` is data together with an explicit confirmation witness.
The structure does not manufacture that witness or prescribe an empirical
verification protocol. -/
structure VerifiedCore
    (Fact : Type*) (Confirmed : Fact → Prop) where
  C : Fact
  confirmed : Confirmed C

/-- A family of named hypotheses `H_i`, each assigned a nonnegative orbit
radius `r_i` and an angle.  Radius represents distance from the confirmed
core in this model, not a physical metric inferred from observations. -/
structure HypothesisOrbitFamily (Hypothesis : Type*) where
  hypothesisAt : Nat → Hypothesis
  radiusAt : Nat → ℝ
  angleAt : Nat → ℝ
  radius_nonnegative : ∀ i, 0 ≤ radiusAt i

/-- The state of one hypothesis in polar coordinates around `C`. -/
structure HypothesisState (Hypothesis : Type*) where
  hypothesis : Hypothesis
  radius : ℝ
  radius_nonnegative : 0 ≤ radius
  angle : ℝ
  status : EpistemicStatus

/-- The initial state of `H_i` on its named orbit `r_i`. -/
def HypothesisOrbitFamily.state
    {Hypothesis : Type*} (family : HypothesisOrbitFamily Hypothesis) (i : Nat) :
    HypothesisState Hypothesis where
  hypothesis := family.hypothesisAt i
  radius := family.radiusAt i
  radius_nonnegative := family.radius_nonnegative i
  angle := family.angleAt i
  status := .hypothesis

/-- Radial displacement `dr`; an inward move has `dr < 0`. -/
def dRadius
    {Hypothesis : Type*}
    (before after : HypothesisState Hypothesis) : ℝ :=
  after.radius - before.radius

/-- Angular displacement `dθ`; no normalization modulo a full turn is needed
for the epistemic invariant proved below. -/
def dTheta
    {Hypothesis : Type*}
    (before after : HypothesisState Hypothesis) : ℝ :=
  after.angle - before.angle

/-- Free angular interpretation: add any `dθ`, holding radius and epistemic
status fixed. -/
def rotateBy
    {Hypothesis : Type*}
    (state : HypothesisState Hypothesis) (deltaTheta : ℝ) :
    HypothesisState Hypothesis :=
  { state with angle := state.angle + deltaTheta }

@[simp] theorem dRadius_rotateBy_zero
    {Hypothesis : Type*}
    (state : HypothesisState Hypothesis) (deltaTheta : ℝ) :
    dRadius state (rotateBy state deltaTheta) = 0 := by
  simp [dRadius, rotateBy]

@[simp] theorem dTheta_rotateBy
    {Hypothesis : Type*}
    (state : HypothesisState Hypothesis) (deltaTheta : ℝ) :
    dTheta state (rotateBy state deltaTheta) = deltaTheta := by
  simp [dTheta, rotateBy]

@[simp] theorem rotateBy_preserves_status
    {Hypothesis : Type*}
    (state : HypothesisState Hypothesis) (deltaTheta : ℝ) :
    (rotateBy state deltaTheta).status = state.status :=
  rfl

/-- A pure interpretation move may change angle freely, but it preserves the
hypothesis identity, orbit radius, and epistemic status. -/
structure InterpretationMove
    {Hypothesis : Type*}
    (before after : HypothesisState Hypothesis) : Prop where
  sameHypothesis : after.hypothesis = before.hypothesis
  radiusFixed : dRadius before after = 0
  statusFixed : after.status = before.status

/-- Every `rotateBy` operation is a pure interpretation move. -/
def rotationMove
    {Hypothesis : Type*}
    (state : HypothesisState Hypothesis) (deltaTheta : ℝ) :
    InterpretationMove state (rotateBy state deltaTheta) where
  sameHypothesis := rfl
  radiusFixed := dRadius_rotateBy_zero state deltaTheta
  statusFixed := rfl

/-- General admissibility gate.  An inward radial move or a promotion from
hypothesis to verified fact is accepted only when the named hypothesis has an
independent verification witness.  Independence remains an explicit input. -/
structure AdmissibleMove
    {Hypothesis : Type*}
    (IndependentlyVerified : Hypothesis → Prop)
    (before after : HypothesisState Hypothesis) : Prop where
  sameHypothesis : after.hypothesis = before.hypothesis
  inwardRequiresVerification :
    dRadius before after < 0 → IndependentlyVerified before.hypothesis
  promotionRequiresVerification :
    before.status = .hypothesis →
      after.status = .verifiedFact →
        IndependentlyVerified before.hypothesis

/-- A pure interpretation move is admissible for every verification predicate:
it neither approaches the core nor promotes epistemic status. -/
def InterpretationMove.toAdmissible
    {Hypothesis : Type*}
    {IndependentlyVerified : Hypothesis → Prop}
    {before after : HypothesisState Hypothesis}
    (move : InterpretationMove before after) :
    AdmissibleMove IndependentlyVerified before after where
  sameHypothesis := move.sameHypothesis
  inwardRequiresVerification := by
    intro hInward
    rw [move.radiusFixed] at hInward
    exact False.elim (lt_irrefl 0 hInward)
  promotionRequiresVerification := by
    intro hBefore hAfter
    rw [move.statusFixed, hBefore] at hAfter
    cases hAfter

/-- `dr < 0` exposes the independent verification witness required by the
admissibility gate. -/
theorem radial_approach_requires_independent_verification
    {Hypothesis : Type*}
    {IndependentlyVerified : Hypothesis → Prop}
    {before after : HypothesisState Hypothesis}
    (move : AdmissibleMove IndependentlyVerified before after)
    (hInward : dRadius before after < 0) :
    IndependentlyVerified before.hypothesis :=
  move.inwardRequiresVerification hInward

/-- Promoting a hypothesis to fact status exposes the same independent
verification obligation. -/
theorem fact_promotion_requires_independent_verification
    {Hypothesis : Type*}
    {IndependentlyVerified : Hypothesis → Prop}
    {before after : HypothesisState Hypothesis}
    (move : AdmissibleMove IndependentlyVerified before after)
    (hBefore : before.status = .hypothesis)
    (hAfter : after.status = .verifiedFact) :
    IndependentlyVerified before.hypothesis :=
  move.promotionRequiresVerification hBefore hAfter

/-- Without independent verification, an admissible move cannot approach the
core.  Moving outward is not prohibited by this one-sided gate. -/
theorem no_verification_blocks_radial_approach
    {Hypothesis : Type*}
    {IndependentlyVerified : Hypothesis → Prop}
    {before after : HypothesisState Hypothesis}
    (move : AdmissibleMove IndependentlyVerified before after)
    (hUnverified : ¬ IndependentlyVerified before.hypothesis) :
    ¬ dRadius before after < 0 := by
  intro hInward
  exact hUnverified (move.inwardRequiresVerification hInward)

/-- Without independent verification, an admissible move cannot change a
hypothesis into a verified fact. -/
theorem no_verification_blocks_fact_promotion
    {Hypothesis : Type*}
    {IndependentlyVerified : Hypothesis → Prop}
    {before after : HypothesisState Hypothesis}
    (move : AdmissibleMove IndependentlyVerified before after)
    (hBefore : before.status = .hypothesis)
    (hUnverified : ¬ IndependentlyVerified before.hypothesis) :
    after.status ≠ .verifiedFact := by
  intro hAfter
  exact hUnverified (move.promotionRequiresVerification hBefore hAfter)

/-- Main visual invariant: interpretation may realize any angular displacement,
while `dr = 0` and factual status remain unchanged. -/
theorem interpretation_changes_angle_not_fact_status
    {Hypothesis : Type*}
    (state : HypothesisState Hypothesis) (deltaTheta : ℝ) :
    dTheta state (rotateBy state deltaTheta) = deltaTheta ∧
      dRadius state (rotateBy state deltaTheta) = 0 ∧
        (rotateBy state deltaTheta).status = state.status := by
  simp

/-! ## 6. Verification layer over an upstream Fisher–Rao base -/

/-- A thin TLFL integration layer over Spectra's upstream statistical
manifold.  The Fisher–Rao geometry is imported rather than reimplemented.

The structure deliberately keeps the epistemic status and the independent
verification predicate outside the statistical manifold.  It does *not* yet
identify the orbit radius above with Fisher–Rao distance or a divergence. -/
structure AmariVerificationLayer
    (Hypothesis : Type*) (n : ℕ) (Sample : Type*)
    [MeasurableSpace Sample] where
  statisticalBase :
    Spectra.InformationGeometry.StatisticalManifold n Sample
  coreParameter : Spectra.InformationGeometry.ParamSpace n
  hypothesisParameter :
    Hypothesis → Spectra.InformationGeometry.ParamSpace n
  status : Hypothesis → EpistemicStatus
  independentlyVerified : Hypothesis → Prop

/-- The imported Fisher metric is positive on every nonzero tangent vector
inside the statistical model's parameter domain.  This theorem is a thin
reuse of Spectra's upstream result, not a local reconstruction of it. -/
theorem upstream_fisher_metric_positive
    {Hypothesis : Type*} {n : ℕ} {Sample : Type*}
    [MeasurableSpace Sample]
    (layer : AmariVerificationLayer Hypothesis n Sample)
    {θ : Spectra.InformationGeometry.ParamSpace n}
    (hθ : θ ∈ layer.statisticalBase.domain)
    {v : Spectra.InformationGeometry.ParamSpace n}
    (hv : v ≠ 0) :
    0 < layer.statisticalBase.fisherMetric.eval θ v v :=
  layer.statisticalBase.fisherMetric_pos_def hθ hv

/-- The verification predicate remains explicit after installing the upstream
statistical base: geometry alone does not manufacture its witness. -/
theorem amari_layer_keeps_verification_explicit
    {Hypothesis : Type*} {n : ℕ} {Sample : Type*}
    [MeasurableSpace Sample]
    (layer : AmariVerificationLayer Hypothesis n Sample)
    (hypothesis : Hypothesis)
    (witness : layer.independentlyVerified hypothesis) :
    layer.independentlyVerified hypothesis :=
  witness

/-! ## 7. Claim boundary: theorem, assumption, interpretation -/

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
def beautyFormulaStatus : ClaimStatus := .definedHere
def verifiedTraceProjectionStatus : ClaimStatus := .kernelTheorem
def magicPoetryRelationStatus : ClaimStatus := .definedHere
def hypothesisOrbitModelStatus : ClaimStatus := .definedHere
def hypothesisOrbitInvariantStatus : ClaimStatus := .kernelTheorem
def amariVerificationLayerStatus : ClaimStatus := .definedHere
def orbitRadiusIsFisherRaoStatus : ClaimStatus := .redBoundary
def physicalHypothesisGeometryStatus : ClaimStatus := .authorInterpretation
def metaphysicalCanonStatus : ClaimStatus := .authorInterpretation
def otherWorldsStatus : ClaimStatus := .redBoundary

theorem physical_hypothesis_geometry_is_not_a_kernel_theorem :
    physicalHypothesisGeometryStatus ≠ ClaimStatus.kernelTheorem := by
  decide

theorem orbit_radius_is_not_claimed_as_fisher_rao :
    orbitRadiusIsFisherRaoStatus = ClaimStatus.redBoundary :=
  rfl

theorem metaphysical_canon_is_not_a_kernel_theorem :
    metaphysicalCanonStatus ≠ ClaimStatus.kernelTheorem := by
  decide

theorem other_worlds_claim_is_outside_the_theory :
    otherWorldsStatus = ClaimStatus.redBoundary := by
  rfl

end

end TMI.PoetryOfMathematics
