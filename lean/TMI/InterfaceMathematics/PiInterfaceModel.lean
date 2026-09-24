import TMI.Library

/-!
# PIM-01: *Pi* as an interface model

This module does not formalize a claim made or proved by the film. It gives a
conditional mathematical reading of one line in *Pi* (1998): the visible
number is a carrier, while meaning may factor through syntax and relations
"between" its signs.

The central result is deliberately conditional. A representation change
preserves meaning only when it preserves an explicitly selected relational
layer and the two interpretations are aligned.
-/

namespace TMI.PiInterfaceModel

universe uW uO uD uX uY uS uM uN uV uH

/-! ## Interface: world → observation → data → carrier -/

/--
An interface separates a world state from the carrier it presents.
An observer, mode, or context `θ` can be represented by a family of interfaces.
-/
structure Interface
    (World : Type uW)
    (Observed : Type uO)
    (Data : Type uD)
    (Carrier : Type uX)
    (Meaning : Type uM) where
  observe : World → Observed
  select : Observed → Data
  encode : Data → Carrier
  decode : Carrier → Option Data
  interpret : Carrier → Meaning

/-- The carrier `x` presented by an interface for a world state `w`. -/
def Interface.present
    {World : Type uW}
    {Observed : Type uO}
    {Data : Type uD}
    {Carrier : Type uX}
    {Meaning : Type uM}
    (I : Interface World Observed Data Carrier Meaning)
    (w : World) : Carrier :=
  I.encode (I.select (I.observe w))

/-- The interpretation `μ_I(x)` assigned by an interface. -/
def Interface.meaning
    {World : Type uW}
    {Observed : Type uO}
    {Data : Type uD}
    {Carrier : Type uX}
    {Meaning : Type uM}
    (I : Interface World Observed Data Carrier Meaning) : Carrier → Meaning :=
  I.interpret

/-- A family of interfaces indexed by an observer, mode, or context `θ`. -/
abbrev InterfaceFamily
    (Context : Type uV)
    (World : Type uW)
    (Observed : Type uO)
    (Data : Type uD)
    (Carrier : Type uX)
    (Meaning : Type uM) :=
  Context → Interface World Observed Data Carrier Meaning

/-! ## Relational structure and meaning -/

/-- A meaning that factors through the relevant relational layer:
`μ(x) = Φ(π(R(x)))`. -/
def relationalMeaning
    {Carrier : Type uX}
    {Structure : Type uS}
    {Meaning : Type uM}
    (R : Carrier → Structure)
    (relevant : Structure → Structure)
    (interpretStructure : Structure → Meaning) : Carrier → Meaning :=
  fun x => interpretStructure (relevant (R x))

/--
`T` preserves the selected relational layer. This is an explicit premise, not
a consequence of the bare existence of `T`.
-/
def PreservesRelevantStructure
    {X : Type uX}
    {Y : Type uY}
    {Structure : Type uS}
    (T : X → Y)
    (Rₓ : X → Structure)
    (Rᵧ : Y → Structure)
    (relevant : Structure → Structure) : Prop :=
  ∀ x, relevant (Rᵧ (T x)) = relevant (Rₓ x)

/-- A complete record of a change of representation `I → J`. -/
structure RepresentationChange
    (X : Type uX)
    (Y : Type uY)
    (Structure : Type uS) where
  transform : X → Y
  sourceRelations : X → Structure
  targetRelations : Y → Structure
  relevant : Structure → Structure
  preserves : ∀ x,
    relevant (targetRelations (transform x)) =
      relevant (sourceRelations x)

/--
If both semantics read the same relevant relational layer, preservation of
that layer entails preservation of meaning.
-/
theorem meaning_preserved_of_relations
    {X : Type uX}
    {Y : Type uY}
    {Structure : Type uS}
    {Meaning : Type uM}
    (T : X → Y)
    (Rₓ : X → Structure)
    (Rᵧ : Y → Structure)
    (relevant : Structure → Structure)
    (interpretStructure : Structure → Meaning)
    (hT : PreservesRelevantStructure T Rₓ Rᵧ relevant) :
    ∀ x,
      relationalMeaning Rᵧ relevant interpretStructure (T x) =
        relationalMeaning Rₓ relevant interpretStructure x := by
  intro x
  simpa [relationalMeaning] using congrArg interpretStructure (hT x)

/--
The main theorem with explicit interface-relative meanings `μI` and `μJ`.
Their common factorization through `Φ ∘ π ∘ R` is a separate premise.
-/
theorem meaning_preserved_of_common_factorization
    {X : Type uX}
    {Y : Type uY}
    {Structure : Type uS}
    {Meaning : Type uM}
    (T : X → Y)
    (Rₓ : X → Structure)
    (Rᵧ : Y → Structure)
    (relevant : Structure → Structure)
    (interpretStructure : Structure → Meaning)
    (μI : X → Meaning)
    (μJ : Y → Meaning)
    (hI : ∀ x, μI x = interpretStructure (relevant (Rₓ x)))
    (hJ : ∀ y, μJ y = interpretStructure (relevant (Rᵧ y)))
    (hT : PreservesRelevantStructure T Rₓ Rᵧ relevant) :
    ∀ x, μJ (T x) = μI x := by
  intro x
  calc
    μJ (T x) = interpretStructure (relevant (Rᵧ (T x))) := hJ (T x)
    _ = interpretStructure (relevant (Rₓ x)) := congrArg interpretStructure (hT x)
    _ = μI x := (hI x).symm

/-- Semantic commutation with an adapter between two meaning spaces. -/
def SemanticCommutation
    {X : Type uX}
    {Y : Type uY}
    {MeaningI : Type uM}
    {MeaningJ : Type uN}
    (T : X → Y)
    (μI : X → MeaningI)
    (μJ : Y → MeaningJ)
    (adapt : MeaningI → MeaningJ) : Prop :=
  ∀ x, μJ (T x) = adapt (μI x)

/--
Aligned interpreters and structure preservation give the semantic commuting
square `μJ ∘ T = adapt ∘ μI`.
-/
theorem semantic_commutation_of_relevant_structure
    {X : Type uX}
    {Y : Type uY}
    {Structure : Type uS}
    {MeaningI : Type uM}
    {MeaningJ : Type uN}
    (T : X → Y)
    (Rₓ : X → Structure)
    (Rᵧ : Y → Structure)
    (relevant : Structure → Structure)
    (ΦI : Structure → MeaningI)
    (ΦJ : Structure → MeaningJ)
    (μI : X → MeaningI)
    (μJ : Y → MeaningJ)
    (adapt : MeaningI → MeaningJ)
    (hI : ∀ x, μI x = ΦI (relevant (Rₓ x)))
    (hJ : ∀ y, μJ y = ΦJ (relevant (Rᵧ y)))
    (hAlign : ∀ s, ΦJ s = adapt (ΦI s))
    (hT : PreservesRelevantStructure T Rₓ Rᵧ relevant) :
    SemanticCommutation T μI μJ adapt := by
  intro x
  calc
    μJ (T x) = ΦJ (relevant (Rᵧ (T x))) := hJ (T x)
    _ = adapt (ΦI (relevant (Rᵧ (T x)))) := hAlign _
    _ = adapt (ΦI (relevant (Rₓ x))) :=
      congrArg adapt (congrArg ΦI (hT x))
    _ = adapt (μI x) := congrArg adapt (hI x).symm

/-! ## Invariants and information loss -/

/-- `ν` is invariant relative to an explicit class of transformations. -/
def IsInvariant
    {X : Type uX}
    {Value : Type uV}
    (TransformClass : (X → X) → Prop)
    (ν : X → Value) : Prop :=
  ∀ T, TransformClass T → ∀ x, ν (T x) = ν x

/-- Two transformations preserving `ν` preserve it under composition. -/
theorem invariant_under_composition
    {X : Type uX}
    {Value : Type uV}
    (ν : X → Value)
    (T U : X → X)
    (hT : ∀ x, ν (T x) = ν x)
    (hU : ∀ x, ν (U x) = ν x) :
    ∀ x, ν (T (U x)) = ν x := by
  intro x
  calc
    ν (T (U x)) = ν (U x) := hT (U x)
    _ = ν x := hU x

/-- `μ` is constant on the fibres of a potentially lossy transformation. -/
def ConstantOnFibers
    {X : Type uX}
    {Y : Type uY}
    {Meaning : Type uM}
    (T : X → Y)
    (μ : X → Meaning) : Prop :=
  ∀ ⦃x₁ x₂⦄, T x₁ = T x₂ → μ x₁ = μ x₂

/--
If meaning factors through `T`, then `T` cannot identify carriers with
different values of that meaning.
-/
theorem semantic_preservation_requires_constant_on_fibers
    {X : Type uX}
    {Y : Type uY}
    {Meaning : Type uM}
    (T : X → Y)
    (μI : X → Meaning)
    (μJ : Y → Meaning)
    (h : ∀ x, μJ (T x) = μI x) :
    ConstantOnFibers T μI := by
  intro x₁ x₂ hEq
  calc
    μI x₁ = μJ (T x₁) := (h x₁).symm
    _ = μJ (T x₂) := congrArg μJ hEq
    _ = μI x₂ := h x₂

/-! ## World structure is not observation structure -/

/-- A proposed structure belonging to the world model itself. -/
structure WorldAccount
    (World : Type uW)
    (WorldStructure : Type uV) where
  structureOf : World → WorldStructure

/-- Equivalence only relative to the output of a specified interface. -/
def ObservationallyEquivalent
    {World : Type uW}
    {Observed : Type uO}
    {Data : Type uD}
    {Carrier : Type uX}
    {Meaning : Type uM}
    (I : Interface World Observed Data Carrier Meaning)
    (w₁ w₂ : World) : Prop :=
  I.present w₁ = I.present w₂

/-- An interface that deliberately forgets every Boolean world distinction. -/
def collapsingBoolInterface : Interface Bool Unit Unit Unit Unit where
  observe := fun _ => ()
  select := fun _ => ()
  encode := fun _ => ()
  decode := fun _ => some ()
  interpret := fun _ => ()

def boolWorldStructure (w : Bool) : Bool := w

/--
A counterexample to identifying world structure with observation structure:
the same interface carrier is compatible with different world states.
-/
theorem same_observation_can_hide_world_difference :
    ObservationallyEquivalent collapsingBoolInterface false true ∧
      boolWorldStructure false ≠ boolWorldStructure true := by
  constructor
  · rfl
  · decide

/-! ## Interface state and memory -/

structure StatefulInterface
    (World : Type uW)
    (Memory : Type uH)
    (Carrier : Type uX) where
  present : World → Memory → Carrier
  update : Memory → Carrier → Memory

/-- One step: produce `x_t`, then update memory to `h_(t+1)`. -/
def StatefulInterface.step
    {World : Type uW}
    {Memory : Type uH}
    {Carrier : Type uX}
    (I : StatefulInterface World Memory Carrier)
    (w : World)
    (h : Memory) : Carrier × Memory :=
  let x := I.present w h
  (x, I.update h x)

theorem StatefulInterface.step_carrier
    {World : Type uW}
    {Memory : Type uH}
    {Carrier : Type uX}
    (I : StatefulInterface World Memory Carrier)
    (w : World)
    (h : Memory) :
    (I.step w h).1 = I.present w h := by
  rfl

theorem StatefulInterface.step_memory
    {World : Type uW}
    {Memory : Type uH}
    {Carrier : Type uX}
    (I : StatefulInterface World Memory Carrier)
    (w : World)
    (h : Memory) :
    (I.step w h).2 = I.update h (I.present w h) := by
  rfl

/-- Dynamic compatibility: `T ∘ Fₓ = Fᵧ ∘ T`. -/
def CommutesWithDynamics
    {X : Type uX}
    {Y : Type uY}
    (T : X → Y)
    (Fₓ : X → X)
    (Fᵧ : Y → Y) : Prop :=
  ∀ x, T (Fₓ x) = Fᵧ (T x)

/-! ## Toy witness: signs change while the selected relation is preserved -/

namespace ToySignChange

inductive NumericSign where
  | zero
  | one
  deriving DecidableEq, Repr

inductive LetterSign where
  | circle
  | stroke
  deriving DecidableEq, Repr

def translate : NumericSign → LetterSign
  | .zero => .circle
  | .one => .stroke

def numericCode : NumericSign → Bool
  | .zero => false
  | .one => true

def letterCode : LetterSign → Bool
  | .circle => false
  | .stroke => true

/-- Here a list of Boolean codes is the selected layer `π(R_x)`. -/
def numericRelations (xs : List NumericSign) : List Bool :=
  xs.map numericCode

def letterRelations (xs : List LetterSign) : List Bool :=
  xs.map letterCode

theorem code_after_translation (sign : NumericSign) :
    letterCode (translate sign) = numericCode sign := by
  cases sign <;> rfl

theorem translate_preserves_relations (xs : List NumericSign) :
    letterRelations (xs.map translate) = numericRelations xs := by
  unfold letterRelations numericRelations
  induction xs with
  | nil => rfl
  | cons sign tail ih =>
      change
        letterCode (translate sign) ::
            List.map letterCode (List.map translate tail) =
          numericCode sign :: List.map numericCode tail
      rw [code_after_translation sign, ih]

/--
Every meaning factoring through the selected relational code is preserved by
the change of alphabet.
-/
theorem any_relational_meaning_preserved
    {Meaning : Type uM}
    (Φ : List Bool → Meaning)
    (xs : List NumericSign) :
    Φ (letterRelations (xs.map translate)) = Φ (numericRelations xs) :=
  congrArg Φ (translate_preserves_relations xs)

end ToySignChange

end TMI.PiInterfaceModel
