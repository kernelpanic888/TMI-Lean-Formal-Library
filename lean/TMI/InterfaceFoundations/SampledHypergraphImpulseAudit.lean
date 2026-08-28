import TMI.InterfaceFoundations.SampledHypergraphImpulse

/-!
# GINF-01 finite audit

The audit instantiates a proper three-node view of a four-vertex carrier and
one admitted digital-life tick.  It also checks that changing from the public
30/70 view at 100% to a rotated 150% view leaves the state unchanged.

These are finite logical witnesses, not claims about life, consciousness,
quantum mechanics, spacetime, or the empirical world.
-/

namespace TMI.InterfaceFoundations.SampledHypergraphImpulseAudit

open TMI.DigitalLifeTwoAxisTick
open TMI.InterfaceFoundations.SampledHypergraphImpulse

abbrev CarrierVertex := Fin 4
abbrev ScreenNode := Fin 3

def projection : SampleProjection CarrierVertex ScreenNode where
  map := fun node => ⟨node.val, Nat.lt_trans node.isLt (by decide)⟩

def graph : SampledHypergraph CarrierVertex ScreenNode where
  map := projection.map
  edge := fun _ _ => True
  hyperedge := fun nodes => 2 <= nodes.length
  connected := by
    intro source target
    exact Reachable.step trivial

theorem finite_projection_is_proper : ProperSample projection := by
  refine ⟨⟨3, by decide⟩, ?_⟩
  intro node mapped
  have sameValue : node.val = 3 := congrArg Fin.val mapped
  exact (Nat.ne_of_lt node.isLt) sameValue

theorem connected_visible_graph_is_not_full_carrier :
    (forall source target : ScreenNode,
      Reachable graph.edge source target) /\
      Not (FullCarrierClaim projection) := by
  exact
    ⟨graph.connected,
      proper_sample_excludes_full_carrier_claim finite_projection_is_proper⟩

abbrev State := DL04State Nat Nat Nat Nat

inductive Action
  | advance
deriving DecidableEq

def contract : TickContract State Action Unit Nat Nat where
  time := { admissible := fun _ _ => True }
  laboratoryForward := fun before after => after = before + 1
  relationalForward := fun before after => after = before + 1
  applyAction := fun state _ =>
    { q := state.q + 1
      memory := state.memory + 1
      reflection := state.reflection + 1
      input := state.input + 1
      certificate := state.certificate + 1
      guard := true }
  identify := fun _ => ()
  policy := fun _ _ _ => True
  safe := fun _ => True
  postVerify := fun _ _ _ => True
  certificate := DL04State.certificate

def event : TickEnvelope State Action Nat Nat where
  before :=
    { q := 0, memory := 10, reflection := 20, input := 0
      certificate := 0, guard := true }
  field := [.advance]
  action := .advance
  after :=
    { q := 1, memory := 11, reflection := 21, input := 1
      certificate := 1, guard := true }
  previousTime := { laboratory := 0, relational := 0 }
  nextTime := { laboratory := 1, relational := 1 }

def admitted : AdmittedTick contract event where
  timeAdmissible := trivial
  laboratoryAdvances := rfl
  relationalAdvances := rfl
  selectedFromField := by
    change Action.advance ∈ [Action.advance]
    exact List.Mem.head []
  applied := rfl
  policyAdmits := trivial
  identityPreserved := rfl
  safeAfter := trivial
  postVerified := trivial
  certificateExtended := rfl

def receipt : TickReceipt contract where
  event := event
  certified := admitted

def observation : DL04Observation State Nat Nat Nat Nat :=
  DL04State.observation

def impulse : SampledImpulseStep graph contract observation where
  source := ⟨0, by decide⟩
  target := ⟨1, by decide⟩
  followsVisibleEdge := trivial
  receipt := receipt
  certificateBeforeMatches := rfl
  certificateAfterMatches := rfl
  guardBefore := rfl
  guardAfter := rfl

theorem finite_impulse_uses_declared_transition :
    impulse.receipt.event.after =
      contract.applyAction
        impulse.receipt.event.before impulse.receipt.event.action :=
  sampled_impulse_applies_declared_transition impulse

theorem finite_impulse_extends_certificate :
    contract.certificate impulse.receipt.event.after =
      contract.certificate impulse.receipt.event.before + 1 :=
  sampled_impulse_extends_certificate impulse

theorem finite_impulse_certificate_is_monotone :
    contract.certificate impulse.receipt.event.before <=
      contract.certificate impulse.receipt.event.after :=
  sampled_impulse_certificate_monotone impulse

def primaryView : ViewFrame where
  scalePercent := 100
  yawUnits := 0
  pitchUnits := 0
  leftWeight := 30
  rightWeight := 70

def zoomedRotatedView : ViewFrame where
  scalePercent := 150
  yawUnits := 900
  pitchUnits := 240
  leftWeight := 30
  rightWeight := 70

def presentedAfter : Presented State where
  model := impulse.receipt.event.after
  view := primaryView

theorem zoom_and_rotation_do_not_change_certificate :
    contract.certificate (reframe presentedAfter zoomedRotatedView).model =
      contract.certificate presentedAfter.model :=
  reframe_preserves_observation contract.certificate
    presentedAfter zoomedRotatedView

#print axioms proper_sample_not_cover_carrier
#print axioms proper_sample_excludes_full_carrier_claim
#print axioms sampled_impulse_applies_declared_transition
#print axioms sampled_impulse_extends_certificate
#print axioms sampled_impulse_certificate_monotone
#print axioms sampled_impulse_observed_certificate_monotone
#print axioms sampled_impulse_has_time_touch
#print axioms reframe_preserves_model
#print axioms reframe_preserves_observation
#print axioms rendered_projection_is_proper
#print axioms rendered_sample_does_not_cover_trillion
#print axioms finite_projection_is_proper
#print axioms connected_visible_graph_is_not_full_carrier
#print axioms finite_impulse_uses_declared_transition
#print axioms finite_impulse_extends_certificate
#print axioms finite_impulse_certificate_is_monotone
#print axioms zoom_and_rotation_do_not_change_certificate

end TMI.InterfaceFoundations.SampledHypergraphImpulseAudit
