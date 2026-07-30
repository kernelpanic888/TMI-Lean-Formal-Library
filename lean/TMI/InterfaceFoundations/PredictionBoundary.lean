/-!
# Prediction boundary

If an interface state changes observations while endpoints stay fixed, no
endpoint-only predictor can be universally exact.
-/

universe u v w x

namespace TMI.InterfaceFoundations.PredictionBoundary

variable
  {LeftState : Type u}
  {InterfaceState : Type v}
  {RightState : Type w}
  {Observation : Type x}

def EndpointExact
    (full : LeftState -> InterfaceState -> RightState -> Observation)
    (endpointOnly : LeftState -> RightState -> Observation) : Prop :=
  forall left interface right,
    endpointOnly left right = full left interface right

theorem interface_state_blocks_endpoint_exactness
    (full : LeftState -> InterfaceState -> RightState -> Observation)
    (hRelevant :
      exists left right interface₁ interface₂,
        full left interface₁ right != full left interface₂ right) :
    Not (exists endpointOnly : LeftState -> RightState -> Observation,
      EndpointExact full endpointOnly) := by
  rintro ⟨endpointOnly, hExact⟩
  rcases hRelevant with ⟨left, right, interface₁, interface₂, hDifferent⟩
  apply hDifferent
  calc
    full left interface₁ right = endpointOnly left right :=
      (hExact left interface₁ right).symm
    _ = full left interface₂ right := hExact left interface₂ right

end TMI.InterfaceFoundations.PredictionBoundary
