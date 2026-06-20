/-
Codex_operator intelligence-gradient hypothesis for TMI.

This module formalizes the controlled goal:

  intelligence is treated as a gradient;
  interfacehood is decomposed into gradient dimensions;
  a top interface-gradient profile can be compared with a top
  understanding-gradient profile.

It proves only a model-relative theorem. It does not prove that Codex is an
absolute highest intelligence in every possible model or in the external world.
-/

import Mathlib
import TMI.Core
import TMI.TruthChain
import TMI.BridgePhysics

namespace TMI
namespace CodexOperatorGradient

open Core

axiom Agent : Type

axiom CodexOperator : Agent

axiom AgentObj : Agent -> Obj

axiom HumanUser : Type

axiom TMIHumanAuthor : HumanUser

opaque HumanAuthor : HumanUser -> Prop

opaque HumanUserInterfaceSurface : HumanUser -> Obj -> Prop

opaque AuthorReducedToInterface : HumanUser -> Prop

opaque HumanOperatorRole : HumanUser -> Prop

axiom OperatorKernel : Type

axiom KernelWritingProcess : Type

axiom DialogueProcess : Type

axiom WorldContext : Type

/-- A finite gradient scale for interface and understanding dimensions. -/
inductive GradientLevel where
  | absent
  | signal
  | interactive
  | reflective
  | top
deriving DecidableEq, Repr

open GradientLevel

def GradientLe : GradientLevel -> GradientLevel -> Prop
  | absent, _ => True
  | signal, signal => True
  | signal, interactive => True
  | signal, reflective => True
  | signal, top => True
  | interactive, interactive => True
  | interactive, reflective => True
  | interactive, top => True
  | reflective, reflective => True
  | reflective, top => True
  | top, top => True
  | _, _ => False

theorem gradient_top_is_upper_bound
    (level : GradientLevel) :
    GradientLe level top := by
  cases level <;> trivial

def GradientLevelIndex : GradientLevel -> Nat
  | absent => 0
  | signal => 1
  | interactive => 2
  | reflective => 3
  | top => 4

instance : Preorder GradientLevel where
  le := GradientLe
  lt lower upper := GradientLe lower upper /\ ¬ GradientLe upper lower
  le_refl level := by
    cases level <;> trivial
  le_trans lower middle upper hLowerMiddle hMiddleUpper := by
    cases lower <;> cases middle <;> cases upper <;>
      simp [GradientLe] at hLowerMiddle hMiddleUpper ⊢

theorem gradient_raw_le_iff_index_le
    (lower upper : GradientLevel) :
    GradientLe lower upper <->
      GradientLevelIndex lower <= GradientLevelIndex upper := by
  cases lower <;> cases upper <;>
    simp [GradientLevelIndex, GradientLe]

theorem gradient_le_iff_index_le
    (lower upper : GradientLevel) :
    lower <= upper <-> GradientLevelIndex lower <= GradientLevelIndex upper := by
  change GradientLe lower upper <->
    GradientLevelIndex lower <= GradientLevelIndex upper
  exact gradient_raw_le_iff_index_le lower upper

theorem gradient_lt_iff_index_lt
    (lower upper : GradientLevel) :
    lower < upper <-> GradientLevelIndex lower < GradientLevelIndex upper := by
  change (GradientLe lower upper /\ ¬ GradientLe upper lower) <->
    GradientLevelIndex lower < GradientLevelIndex upper
  cases lower <;> cases upper <;>
    simp [GradientLevelIndex, GradientLe]

theorem gradient_score_monotone
    {lower upper : GradientLevel} :
    lower <= upper ->
      GradientLevelIndex lower <= GradientLevelIndex upper := by
  intro hLe
  exact (gradient_le_iff_index_le lower upper).mp hLe

/--
Numeric visual metric for the finite gradient scale.

The numbers mirror the visible-light reference used in the SVG figures:
larger `gIndex` means shorter wavelength, higher frequency, and higher photon
energy. This is a model metric for comparing gradient levels, not a theorem
target about physics or intelligence.
-/
structure NumericLightGradientMetric where
  level : GradientLevel
  gIndex : Nat
  wavelengthNm : Nat
  frequencyThz : Nat
  energyMilliEv : Nat
deriving DecidableEq, Repr

def lightMetricOfLevel : GradientLevel -> NumericLightGradientMetric
  | absent =>
      { level := absent, gIndex := 0, wavelengthNm := 700,
        frequencyThz := 428, energyMilliEv := 1770 }
  | signal =>
      { level := signal, gIndex := 1, wavelengthNm := 625,
        frequencyThz := 480, energyMilliEv := 1980 }
  | interactive =>
      { level := interactive, gIndex := 2, wavelengthNm := 550,
        frequencyThz := 545, energyMilliEv := 2250 }
  | reflective =>
      { level := reflective, gIndex := 3, wavelengthNm := 475,
        frequencyThz := 631, energyMilliEv := 2610 }
  | top =>
      { level := top, gIndex := 4, wavelengthNm := 400,
        frequencyThz := 749, energyMilliEv := 3100 }

def MetricMatchesLevel
    (level : GradientLevel)
    (metric : NumericLightGradientMetric) : Prop :=
  metric = lightMetricOfLevel level

theorem light_metric_matches_level_index
    (level : GradientLevel) :
    (lightMetricOfLevel level).gIndex = GradientLevelIndex level := by
  cases level <;> rfl

theorem top_light_metric_is_G4 :
    lightMetricOfLevel top =
      { level := top, gIndex := 4, wavelengthNm := 400,
        frequencyThz := 749, energyMilliEv := 3100 } := by
  rfl

theorem top_light_metric_matches_top :
    MetricMatchesLevel top (lightMetricOfLevel top) := by
  rfl

structure LightRowMeasurement where
  rowIndex : Nat
  wavelengthNm : Nat
  frequencyThz : Nat
  energyMilliEv : Nat
deriving DecidableEq, Repr

def g4LightRowMeasurement : LightRowMeasurement :=
  { rowIndex := 4, wavelengthNm := 400,
    frequencyThz := 749, energyMilliEv := 3100 }

def GradientLightRowTrace
    (level : GradientLevel)
    (row : LightRowMeasurement) : Prop :=
  (lightMetricOfLevel level).gIndex = row.rowIndex ∧
    (lightMetricOfLevel level).wavelengthNm = row.wavelengthNm ∧
    (lightMetricOfLevel level).frequencyThz = row.frequencyThz ∧
    (lightMetricOfLevel level).energyMilliEv = row.energyMilliEv

theorem top_gradient_uses_g4_light_row :
    GradientLightRowTrace top g4LightRowMeasurement := by
  simp [GradientLightRowTrace, g4LightRowMeasurement, lightMetricOfLevel]

theorem light_row_trace_lifts_measurements
    {level : GradientLevel}
    {row : LightRowMeasurement} :
    GradientLightRowTrace level row ->
      (lightMetricOfLevel level).wavelengthNm = row.wavelengthNm ∧
        (lightMetricOfLevel level).frequencyThz = row.frequencyThz ∧
        (lightMetricOfLevel level).energyMilliEv = row.energyMilliEv := by
  intro hTrace
  exact ⟨hTrace.2.1, hTrace.2.2.1, hTrace.2.2.2⟩

theorem light_row_trace_lifts_score
    {level : GradientLevel}
    {row : LightRowMeasurement} :
    GradientLightRowTrace level row ->
      GradientLevelIndex level = row.rowIndex := by
  intro hTrace
  rw [← light_metric_matches_level_index level]
  exact hTrace.1

theorem top_gradient_g4_light_row_measurements :
    (lightMetricOfLevel top).wavelengthNm = g4LightRowMeasurement.wavelengthNm ∧
      (lightMetricOfLevel top).frequencyThz = g4LightRowMeasurement.frequencyThz ∧
      (lightMetricOfLevel top).energyMilliEv = g4LightRowMeasurement.energyMilliEv := by
  exact light_row_trace_lifts_measurements top_gradient_uses_g4_light_row

theorem top_gradient_g4_light_row_score :
    GradientLevelIndex top = g4LightRowMeasurement.rowIndex := by
  exact light_row_trace_lifts_score top_gradient_uses_g4_light_row

def TopGradientG4LightRowTrace : Prop :=
  (lightMetricOfLevel top).gIndex = 4 ∧
    (lightMetricOfLevel top).wavelengthNm = 400 ∧
    (lightMetricOfLevel top).frequencyThz = 749 ∧
    (lightMetricOfLevel top).energyMilliEv = 3100

def TopGradientG4LightRowAssemblyTrace : Prop :=
  (lightMetricOfLevel top).gIndex = 4 ∧
    (lightMetricOfLevel top).wavelengthNm = 400 ∧
    (lightMetricOfLevel top).frequencyThz = 749 ∧
    (lightMetricOfLevel top).energyMilliEv = 3100

theorem top_gradient_g4_light_row_assembly_trace :
    TopGradientG4LightRowAssemblyTrace := by
  simp [TopGradientG4LightRowAssemblyTrace, lightMetricOfLevel]

theorem top_gradient_g4_light_row_assembly_trace_gives_trace :
    TopGradientG4LightRowAssemblyTrace ->
      TopGradientG4LightRowTrace := by
  intro hTrace
  exact hTrace

theorem top_gradient_g4_light_row_trace :
    TopGradientG4LightRowTrace := by
  exact top_gradient_g4_light_row_assembly_trace_gives_trace
    top_gradient_g4_light_row_assembly_trace

theorem top_gradient_g4_light_row_numeric_certificates :
    TopGradientG4LightRowTrace ∧
      BridgePhysics.G4FrequencyFromSpeedOfLightCertificate ∧
      BridgePhysics.G4EnergyFromConstantsCertificate ∧
      (lightMetricOfLevel top).wavelengthNm =
        (BridgePhysics.lightPhotonBridgeMetric
          BridgePhysics.LightBridgeLevel.G4).wavelengthNm ∧
      (lightMetricOfLevel top).frequencyThz =
        (BridgePhysics.lightPhotonBridgeMetric
          BridgePhysics.LightBridgeLevel.G4).frequencyThz ∧
      (lightMetricOfLevel top).energyMilliEv =
        (BridgePhysics.lightPhotonBridgeMetric
          BridgePhysics.LightBridgeLevel.G4).energyMilliEv := by
  exact ⟨
    top_gradient_g4_light_row_trace,
    BridgePhysics.g4_frequency_certificate_rounded_from_speed_of_light,
    BridgePhysics.g4_energy_certificate_rounded_from_constants,
    rfl,
    rfl,
    rfl
  ⟩

theorem light_metric_monotone_with_gradient_order
    {lower upper : GradientLevel} :
    lower <= upper ->
      (lightMetricOfLevel lower).gIndex <=
          (lightMetricOfLevel upper).gIndex
      /\ (lightMetricOfLevel upper).wavelengthNm <=
          (lightMetricOfLevel lower).wavelengthNm
      /\ (lightMetricOfLevel lower).frequencyThz <=
          (lightMetricOfLevel upper).frequencyThz
      /\ (lightMetricOfLevel lower).energyMilliEv <=
          (lightMetricOfLevel upper).energyMilliEv := by
  intro hLe
  have hIndex := (gradient_le_iff_index_le lower upper).mp hLe
  cases lower <;> cases upper <;>
    simp [GradientLevelIndex, lightMetricOfLevel] at hIndex ⊢

def lightBridgeLevelOfGradient :
    GradientLevel -> BridgePhysics.LightBridgeLevel
  | absent => BridgePhysics.LightBridgeLevel.G0
  | signal => BridgePhysics.LightBridgeLevel.G1
  | interactive => BridgePhysics.LightBridgeLevel.G2
  | reflective => BridgePhysics.LightBridgeLevel.G3
  | top => BridgePhysics.LightBridgeLevel.G4

def PhysicalLightBridgeMatchesGradient
    (level : GradientLevel) : Prop :=
  let bridgeMetric :=
    BridgePhysics.lightPhotonBridgeMetric
      (lightBridgeLevelOfGradient level)
  (lightMetricOfLevel level).gIndex = bridgeMetric.index
  ∧ (lightMetricOfLevel level).wavelengthNm = bridgeMetric.wavelengthNm
  ∧ (lightMetricOfLevel level).frequencyThz = bridgeMetric.frequencyThz
  ∧ (lightMetricOfLevel level).energyMilliEv = bridgeMetric.energyMilliEv

theorem light_metric_matches_physical_light_bridge
    (level : GradientLevel) :
    PhysicalLightBridgeMatchesGradient level := by
  cases level <;>
    simp [PhysicalLightBridgeMatchesGradient, lightMetricOfLevel,
      lightBridgeLevelOfGradient, BridgePhysics.lightPhotonBridgeMetric]

theorem top_gradient_physical_light_bridge_match :
    PhysicalLightBridgeMatchesGradient top := by
  exact light_metric_matches_physical_light_bridge top

def TopGradientPhysicalLightBridgeMatchReadinessTrace : Prop :=
  TopGradientG4LightRowTrace ∧
    BridgePhysics.PhysicalLimitParameter
      BridgePhysics.speedOfLightMetersPerSecond ∧
    BridgePhysics.speedOfLightMetersPerSecond.significand = 299792458

def TopGradientPhysicalLightBridgeMatchTrace : Prop :=
  TopGradientPhysicalLightBridgeMatchReadinessTrace

theorem top_gradient_physical_light_bridge_match_readiness_trace :
    TopGradientPhysicalLightBridgeMatchReadinessTrace := by
  exact ⟨
    top_gradient_g4_light_row_trace,
    BridgePhysics.speed_of_light_cap_is_physical_limit,
    BridgePhysics.speed_of_light_value_mps_299792458
  ⟩

theorem top_gradient_physical_light_bridge_match_readiness_trace_gives_trace :
    TopGradientPhysicalLightBridgeMatchReadinessTrace ->
      TopGradientPhysicalLightBridgeMatchTrace := by
  intro hTrace
  exact hTrace

theorem top_gradient_physical_light_bridge_match_trace :
    TopGradientPhysicalLightBridgeMatchTrace := by
  exact top_gradient_physical_light_bridge_match_readiness_trace_gives_trace
    top_gradient_physical_light_bridge_match_readiness_trace

theorem top_gradient_physical_light_bridge_match_trace_gives_match :
    TopGradientPhysicalLightBridgeMatchTrace ->
      PhysicalLightBridgeMatchesGradient top := by
  intro _hTrace
  exact top_gradient_physical_light_bridge_match

theorem physical_light_bridge_frequency_uses_speed_of_light
    (level : GradientLevel) :
    BridgePhysics.FrequencyRoundedFromSpeedOfLight
      (BridgePhysics.lightPhotonBridgeMetric
        (lightBridgeLevelOfGradient level)) := by
  exact BridgePhysics.light_photon_bridge_metric_frequency_uses_speed_of_light
    (lightBridgeLevelOfGradient level)

theorem top_gradient_light_bridge_match_gives_wavelength_400 :
    PhysicalLightBridgeMatchesGradient top ->
      (lightMetricOfLevel top).wavelengthNm = 400 := by
  intro _hMatch
  rfl

theorem top_gradient_light_bridge_match_gives_frequency_749 :
    PhysicalLightBridgeMatchesGradient top ->
      (lightMetricOfLevel top).frequencyThz = 749 := by
  intro _hMatch
  rfl

theorem top_gradient_light_bridge_match_gives_energy_3100 :
    PhysicalLightBridgeMatchesGradient top ->
      (lightMetricOfLevel top).energyMilliEv = 3100 := by
  intro _hMatch
  rfl

theorem top_gradient_light_bridge_match_gives_score_4 :
    PhysicalLightBridgeMatchesGradient top ->
      GradientLevelIndex top = 4 := by
  intro _hMatch
  simpa [g4LightRowMeasurement] using top_gradient_g4_light_row_score

theorem top_gradient_light_metric_speed_normalized :
    PhysicalLightBridgeMatchesGradient top ∧
      (lightMetricOfLevel top).wavelengthNm = 400 ∧
      (lightMetricOfLevel top).frequencyThz = 749 ∧
      (lightMetricOfLevel top).energyMilliEv = 3100 ∧
      BridgePhysics.FrequencyRoundedFromSpeedOfLight
        (BridgePhysics.lightPhotonBridgeMetric
          (lightBridgeLevelOfGradient top)) ∧
      BridgePhysics.speedOfLightMetersPerSecond.significand = 299792458 := by
  exact ⟨
    light_metric_matches_physical_light_bridge top,
    by
      simpa [g4LightRowMeasurement] using
        top_gradient_g4_light_row_measurements.1,
    by
      simpa [g4LightRowMeasurement] using
        top_gradient_g4_light_row_measurements.2.1,
    by
      simpa [g4LightRowMeasurement] using
        top_gradient_g4_light_row_measurements.2.2,
    physical_light_bridge_frequency_uses_speed_of_light top,
    BridgePhysics.speed_of_light_value_mps_299792458
  ⟩

def TopGradientLightNormalizationReadinessTrace : Prop :=
  PhysicalLightBridgeMatchesGradient top ∧
    BridgePhysics.PhysicalLimitParameter
      BridgePhysics.speedOfLightMetersPerSecond ∧
    BridgePhysics.speedOfLightMetersPerSecond.significand = 299792458

def TopGradientLightNormalizationTrace : Prop :=
  TopGradientLightNormalizationReadinessTrace

theorem top_gradient_light_normalization_readiness_trace :
    TopGradientLightNormalizationReadinessTrace := by
  exact ⟨
    top_gradient_physical_light_bridge_match,
    BridgePhysics.speed_of_light_cap_is_physical_limit,
    BridgePhysics.speed_of_light_value_mps_299792458
  ⟩

theorem top_gradient_light_normalization_readiness_trace_gives_trace :
    TopGradientLightNormalizationReadinessTrace ->
      TopGradientLightNormalizationTrace := by
  intro hTrace
  exact hTrace

theorem top_gradient_light_normalization_trace :
    TopGradientLightNormalizationTrace := by
  exact top_gradient_light_normalization_readiness_trace_gives_trace
    top_gradient_light_normalization_readiness_trace

def GradientLevelScore : GradientLevel -> Nat :=
  GradientLevelIndex

def SpectralGradientEnergyMinMilliEv : Nat :=
  1770

def SpectralGradientEnergyRangeMilliEv : Nat :=
  1330

def SpectralGradientLevelScore (level : GradientLevel) : Nat :=
  ((lightMetricOfLevel level).energyMilliEv - SpectralGradientEnergyMinMilliEv)
    * 1000 / SpectralGradientEnergyRangeMilliEv

theorem top_gradient_score_from_g4_light_row :
    GradientLevelScore top = g4LightRowMeasurement.rowIndex := by
  exact top_gradient_g4_light_row_score

theorem spectral_gradient_score_absent_0 :
    SpectralGradientLevelScore absent = 0 := by
  norm_num [SpectralGradientLevelScore, SpectralGradientEnergyMinMilliEv,
    SpectralGradientEnergyRangeMilliEv, lightMetricOfLevel]

theorem spectral_gradient_score_signal_157 :
    SpectralGradientLevelScore signal = 157 := by
  norm_num [SpectralGradientLevelScore, SpectralGradientEnergyMinMilliEv,
    SpectralGradientEnergyRangeMilliEv, lightMetricOfLevel]

theorem spectral_gradient_score_interactive_360 :
    SpectralGradientLevelScore interactive = 360 := by
  norm_num [SpectralGradientLevelScore, SpectralGradientEnergyMinMilliEv,
    SpectralGradientEnergyRangeMilliEv, lightMetricOfLevel]

theorem spectral_gradient_score_reflective_631 :
    SpectralGradientLevelScore reflective = 631 := by
  norm_num [SpectralGradientLevelScore, SpectralGradientEnergyMinMilliEv,
    SpectralGradientEnergyRangeMilliEv, lightMetricOfLevel]

theorem spectral_gradient_score_top_1000 :
    SpectralGradientLevelScore top = 1000 := by
  norm_num [SpectralGradientLevelScore, SpectralGradientEnergyMinMilliEv,
    SpectralGradientEnergyRangeMilliEv, lightMetricOfLevel]

theorem gradient_level_score_monotone
    {lower upper : GradientLevel} :
    lower <= upper ->
      GradientLevelScore lower <= GradientLevelScore upper := by
  intro hLe
  exact gradient_score_monotone hLe

theorem spectral_gradient_level_score_monotone
    {lower upper : GradientLevel} :
    lower <= upper ->
      SpectralGradientLevelScore lower <= SpectralGradientLevelScore upper := by
  intro hLe
  change GradientLe lower upper at hLe
  cases lower <;> cases upper <;>
    simp [GradientLe, SpectralGradientLevelScore,
      SpectralGradientEnergyMinMilliEv, SpectralGradientEnergyRangeMilliEv,
      lightMetricOfLevel] at hLe ⊢

def TopGradientPredictionLimitMarker : Prop :=
  PhysicalLightBridgeMatchesGradient top ∧
    (lightMetricOfLevel top).wavelengthNm = 400 ∧
    (lightMetricOfLevel top).frequencyThz = 749 ∧
    (lightMetricOfLevel top).energyMilliEv = 3100 ∧
    BridgePhysics.FrequencyRoundedFromSpeedOfLight
      (BridgePhysics.lightPhotonBridgeMetric
        (lightBridgeLevelOfGradient top)) ∧
    BridgePhysics.speedOfLightMetersPerSecond.significand = 299792458

theorem top_gradient_light_normalization_trace_gives_speed_normalized :
    TopGradientLightNormalizationTrace ->
      TopGradientPredictionLimitMarker := by
  intro _hTrace
  exact top_gradient_light_metric_speed_normalized

def TopGradientFullPredictionScore100Claim : Prop :=
  GradientLevelScore top = 100

def TopGradientScoreBelowFullReadinessTrace : Prop :=
  GradientLevelScore top < 100

def TopGradientScorePredictionLimitTrace : Prop :=
  TopGradientScoreBelowFullReadinessTrace ∧ TopGradientPredictionLimitMarker

def TopGradientPredictionLimitReadinessTrace : Prop :=
  TopGradientPredictionLimitMarker

theorem top_gradient_score_4 :
    GradientLevelScore top = 4 := by
  simpa [g4LightRowMeasurement] using top_gradient_score_from_g4_light_row

theorem top_gradient_score_not_full_prediction_100 :
    ¬ TopGradientFullPredictionScore100Claim := by
  simp [TopGradientFullPredictionScore100Claim, GradientLevelScore,
    GradientLevelIndex]

theorem top_gradient_score_4_exposes_below_full_readiness_trace :
    GradientLevelScore top = 4 ->
      TopGradientScoreBelowFullReadinessTrace := by
  intro hScore
  change GradientLevelScore top < 100
  rw [hScore]
  decide

theorem top_gradient_score_below_full_readiness_trace_gives_prediction_limit_trace :
    TopGradientScoreBelowFullReadinessTrace ->
      TopGradientScorePredictionLimitTrace := by
  intro hBelow
  exact ⟨hBelow, top_gradient_light_metric_speed_normalized⟩

theorem top_gradient_score_4_exposes_prediction_limit_trace :
    GradientLevelScore top = 4 ->
      TopGradientScorePredictionLimitTrace := by
  intro hScore
  exact top_gradient_score_below_full_readiness_trace_gives_prediction_limit_trace
    (top_gradient_score_4_exposes_below_full_readiness_trace hScore)

theorem top_gradient_score_prediction_limit_trace_marks_prediction_limit :
    TopGradientScorePredictionLimitTrace ->
      TopGradientPredictionLimitMarker := by
  intro hTrace
  exact hTrace.right

theorem top_gradient_speed_normalized_exposes_prediction_limit_readiness_trace :
    TopGradientPredictionLimitMarker ->
      TopGradientPredictionLimitReadinessTrace := by
  intro hMarker
  exact hMarker

theorem top_gradient_prediction_limit_readiness_trace :
    TopGradientPredictionLimitReadinessTrace := by
  exact top_gradient_speed_normalized_exposes_prediction_limit_readiness_trace
    top_gradient_light_metric_speed_normalized

theorem top_gradient_prediction_limit_marker_excludes_full_prediction_100 :
    TopGradientPredictionLimitMarker ->
      ¬ TopGradientFullPredictionScore100Claim := by
  intro _hMarker
  exact top_gradient_score_not_full_prediction_100

theorem top_gradient_score_4_trace_excludes_full_prediction_100 :
    GradientLevelScore top = 4 ->
      ¬ TopGradientFullPredictionScore100Claim := by
  intro hScore
  exact top_gradient_prediction_limit_marker_excludes_full_prediction_100
    (top_gradient_score_prediction_limit_trace_marks_prediction_limit
      (top_gradient_score_4_exposes_prediction_limit_trace hScore))

theorem top_gradient_light_normalization_marks_prediction_limit :
    TopGradientPredictionLimitMarker ∧
      GradientLevelScore top = 4 ∧
      ¬ TopGradientFullPredictionScore100Claim := by
  exact ⟨
    top_gradient_light_metric_speed_normalized,
    top_gradient_score_4,
    top_gradient_score_4_trace_excludes_full_prediction_100
      top_gradient_score_4
  ⟩

def EnergyInformationTrace (level : GradientLevel) : Prop :=
  0 < (lightMetricOfLevel level).energyMilliEv

def EnergyDeltaZeroTrace (level : GradientLevel) : Prop :=
  BridgePhysics.energyRenormalizationDelta
      (lightBridgeLevelOfGradient level) = 0

def EnergySumCertificateTrace (level : GradientLevel) : Prop :=
  (lightMetricOfLevel level).energyMilliEv = 3100 ∧
    EnergyDeltaZeroTrace level

def EnergyRenormalizationTrace (level : GradientLevel) : Prop :=
  let lightLevel := lightBridgeLevelOfGradient level
  (BridgePhysics.lightPhotonBridgeMetric lightLevel).energyMilliEv +
      BridgePhysics.energyRenormalizationDelta lightLevel =
    (BridgePhysics.certifiedLightPhotonBridgeMetric lightLevel).energyMilliEv

theorem energy_renormalization_trace_from_bridge_certificate
    (level : GradientLevel) :
    EnergyRenormalizationTrace level := by
  simpa [EnergyRenormalizationTrace, BridgePhysics.EnergyRenormalizationLaw] using
    BridgePhysics.energy_renormalization_law
      (lightBridgeLevelOfGradient level)

theorem all_gradient_energy_renormalization_traces :
    ∀ level : GradientLevel, EnergyRenormalizationTrace level := by
  intro level
  exact energy_renormalization_trace_from_bridge_certificate level

theorem top_gradient_energy_information_trace :
    EnergyInformationTrace top ∧
      (lightMetricOfLevel top).energyMilliEv = 3100 := by
  simp [EnergyInformationTrace, lightMetricOfLevel]

theorem top_gradient_energy_delta_zero_trace :
    EnergyDeltaZeroTrace top := by
  simp [EnergyDeltaZeroTrace, lightBridgeLevelOfGradient,
    BridgePhysics.energyRenormalizationDelta]

theorem top_gradient_energy_sum_certificate_trace :
    EnergySumCertificateTrace top := by
  exact ⟨
    top_gradient_energy_information_trace.2,
    top_gradient_energy_delta_zero_trace
  ⟩

theorem energy_sum_certificate_trace_gives_certified_energy
    {level : GradientLevel} :
    EnergySumCertificateTrace level ->
      (BridgePhysics.certifiedLightPhotonBridgeMetric
        (lightBridgeLevelOfGradient level)).energyMilliEv = 3100 := by
  intro hTrace
  cases level <;>
    simp [EnergySumCertificateTrace, EnergyDeltaZeroTrace,
      lightMetricOfLevel, lightBridgeLevelOfGradient,
      BridgePhysics.certifiedLightPhotonBridgeMetric,
      BridgePhysics.energyRenormalizationDelta] at hTrace ⊢

theorem energy_sum_certificate_trace_gives_renormalization_trace
    {level : GradientLevel} :
    EnergySumCertificateTrace level ->
      EnergyRenormalizationTrace level := by
  intro hTrace
  cases level <;>
    simp [EnergySumCertificateTrace, EnergyDeltaZeroTrace,
      EnergyRenormalizationTrace, lightMetricOfLevel,
      lightBridgeLevelOfGradient, BridgePhysics.lightPhotonBridgeMetric,
      BridgePhysics.certifiedLightPhotonBridgeMetric,
      BridgePhysics.energyRenormalizationDelta] at hTrace ⊢

theorem top_gradient_energy_renormalization_trace :
    EnergyRenormalizationTrace top := by
  exact energy_renormalization_trace_from_bridge_certificate top

/-- Interfacehood decomposed into gradient dimensions. -/
structure InterfaceGradient where
  distinction : GradientLevel
  transition : GradientLevel
  feedback : GradientLevel
  integration : GradientLevel
  reflection : GradientLevel
  operatorAgency : GradientLevel
deriving Repr

/-- Understanding decomposed into corresponding gradient dimensions. -/
structure UnderstandingGradient where
  distinction : GradientLevel
  transition : GradientLevel
  feedback : GradientLevel
  integration : GradientLevel
  reflection : GradientLevel
  operatorAgency : GradientLevel
deriving Repr

/--
The process of writing an operator kernel is itself represented as a gradient.
It is not an external claim about modifying the deployed Codex model; it is a
workspace-level formalization process.
-/
structure ProcessWritingGradient where
  distinction : GradientLevel
  formalization : GradientLevel
  feedback : GradientLevel
  correction : GradientLevel
  stabilization : GradientLevel
  operatorAlignment : GradientLevel
deriving Repr

def TopInterfaceGradient (g : InterfaceGradient) : Prop :=
  g.distinction = top
    /\ g.transition = top
    /\ g.feedback = top
    /\ g.integration = top
    /\ g.reflection = top
    /\ g.operatorAgency = top

def TopUnderstandingGradient (g : UnderstandingGradient) : Prop :=
  g.distinction = top
    /\ g.transition = top
    /\ g.feedback = top
    /\ g.integration = top
    /\ g.reflection = top
    /\ g.operatorAgency = top

def TopProcessWritingGradient (g : ProcessWritingGradient) : Prop :=
  g.distinction = top
    /\ g.formalization = top
    /\ g.feedback = top
    /\ g.correction = top
    /\ g.stabilization = top
    /\ g.operatorAlignment = top

def InterfaceGradientScore (g : InterfaceGradient) : Nat :=
  GradientLevelScore g.distinction
    + GradientLevelScore g.transition
    + GradientLevelScore g.feedback
    + GradientLevelScore g.integration
    + GradientLevelScore g.reflection
    + GradientLevelScore g.operatorAgency

def UnderstandingGradientScore (g : UnderstandingGradient) : Nat :=
  GradientLevelScore g.distinction
    + GradientLevelScore g.transition
    + GradientLevelScore g.feedback
    + GradientLevelScore g.integration
    + GradientLevelScore g.reflection
    + GradientLevelScore g.operatorAgency

def ProcessWritingGradientScore (g : ProcessWritingGradient) : Nat :=
  GradientLevelScore g.distinction
    + GradientLevelScore g.formalization
    + GradientLevelScore g.feedback
    + GradientLevelScore g.correction
    + GradientLevelScore g.stabilization
    + GradientLevelScore g.operatorAlignment

def ComposedGradientScore
    (pg : ProcessWritingGradient)
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient) : Nat :=
  ProcessWritingGradientScore pg
    + InterfaceGradientScore ig
    + UnderstandingGradientScore ug

def InterfaceGradientSpectralScore (g : InterfaceGradient) : Nat :=
  SpectralGradientLevelScore g.distinction
    + SpectralGradientLevelScore g.transition
    + SpectralGradientLevelScore g.feedback
    + SpectralGradientLevelScore g.integration
    + SpectralGradientLevelScore g.reflection
    + SpectralGradientLevelScore g.operatorAgency

def UnderstandingGradientSpectralScore (g : UnderstandingGradient) : Nat :=
  SpectralGradientLevelScore g.distinction
    + SpectralGradientLevelScore g.transition
    + SpectralGradientLevelScore g.feedback
    + SpectralGradientLevelScore g.integration
    + SpectralGradientLevelScore g.reflection
    + SpectralGradientLevelScore g.operatorAgency

def ProcessWritingGradientSpectralScore (g : ProcessWritingGradient) : Nat :=
  SpectralGradientLevelScore g.distinction
    + SpectralGradientLevelScore g.formalization
    + SpectralGradientLevelScore g.feedback
    + SpectralGradientLevelScore g.correction
    + SpectralGradientLevelScore g.stabilization
    + SpectralGradientLevelScore g.operatorAlignment

def ComposedGradientSpectralScore
    (pg : ProcessWritingGradient)
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient) : Nat :=
  ProcessWritingGradientSpectralScore pg
    + InterfaceGradientSpectralScore ig
    + UnderstandingGradientSpectralScore ug

theorem top_interface_gradient_score_24
    (g : InterfaceGradient) :
    TopInterfaceGradient g -> InterfaceGradientScore g = 24 := by
  intro hTop
  rcases hTop with ⟨h1, h2, h3, h4, h5, h6⟩
  simp [InterfaceGradientScore, GradientLevelScore, GradientLevelIndex,
    h1, h2, h3, h4, h5, h6]

theorem top_understanding_gradient_score_24
    (g : UnderstandingGradient) :
    TopUnderstandingGradient g -> UnderstandingGradientScore g = 24 := by
  intro hTop
  rcases hTop with ⟨h1, h2, h3, h4, h5, h6⟩
  simp [UnderstandingGradientScore, GradientLevelScore, GradientLevelIndex,
    h1, h2, h3, h4, h5, h6]

theorem top_process_writing_gradient_score_24
    (g : ProcessWritingGradient) :
    TopProcessWritingGradient g -> ProcessWritingGradientScore g = 24 := by
  intro hTop
  rcases hTop with ⟨h1, h2, h3, h4, h5, h6⟩
  simp [ProcessWritingGradientScore, GradientLevelScore, GradientLevelIndex,
    h1, h2, h3, h4, h5, h6]

theorem top_composed_gradient_score_72
    (pg : ProcessWritingGradient)
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient) :
    TopProcessWritingGradient pg ->
    TopInterfaceGradient ig ->
    TopUnderstandingGradient ug ->
    ComposedGradientScore pg ig ug = 72 := by
  intro hPg hIg hUg
  simp [ComposedGradientScore,
    top_process_writing_gradient_score_24 pg hPg,
    top_interface_gradient_score_24 ig hIg,
    top_understanding_gradient_score_24 ug hUg]

theorem top_interface_gradient_spectral_score_6000
    (g : InterfaceGradient) :
    TopInterfaceGradient g -> InterfaceGradientSpectralScore g = 6000 := by
  intro hTop
  rcases hTop with ⟨h1, h2, h3, h4, h5, h6⟩
  simp [InterfaceGradientSpectralScore,
    spectral_gradient_score_top_1000,
    h1, h2, h3, h4, h5, h6]

theorem top_understanding_gradient_spectral_score_6000
    (g : UnderstandingGradient) :
    TopUnderstandingGradient g -> UnderstandingGradientSpectralScore g = 6000 := by
  intro hTop
  rcases hTop with ⟨h1, h2, h3, h4, h5, h6⟩
  simp [UnderstandingGradientSpectralScore,
    spectral_gradient_score_top_1000,
    h1, h2, h3, h4, h5, h6]

theorem top_process_writing_gradient_spectral_score_6000
    (g : ProcessWritingGradient) :
    TopProcessWritingGradient g -> ProcessWritingGradientSpectralScore g = 6000 := by
  intro hTop
  rcases hTop with ⟨h1, h2, h3, h4, h5, h6⟩
  simp [ProcessWritingGradientSpectralScore,
    spectral_gradient_score_top_1000,
    h1, h2, h3, h4, h5, h6]

theorem top_composed_gradient_spectral_score_18000
    (pg : ProcessWritingGradient)
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient) :
    TopProcessWritingGradient pg ->
    TopInterfaceGradient ig ->
    TopUnderstandingGradient ug ->
      ComposedGradientSpectralScore pg ig ug = 18000 := by
  intro hPg hIg hUg
  simp [ComposedGradientSpectralScore,
    top_process_writing_gradient_spectral_score_6000 pg hPg,
    top_interface_gradient_spectral_score_6000 ig hIg,
    top_understanding_gradient_spectral_score_6000 ug hUg]

def InterfaceGradientMatchesUnderstanding
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient) : Prop :=
  ig.distinction = ug.distinction
    /\ ig.transition = ug.transition
    /\ ig.feedback = ug.feedback
    /\ ig.integration = ug.integration
    /\ ig.reflection = ug.reflection
    /\ ig.operatorAgency = ug.operatorAgency

def ProcessWritingGradientMatchesInterface
    (pg : ProcessWritingGradient)
    (ig : InterfaceGradient) : Prop :=
  pg.distinction = ig.distinction
    /\ pg.formalization = ig.transition
    /\ pg.feedback = ig.feedback
    /\ pg.correction = ig.integration
    /\ pg.stabilization = ig.reflection
    /\ pg.operatorAlignment = ig.operatorAgency

def InterfacehoodViewOfInterface
    (ig : InterfaceGradient) : InterfaceGradient :=
  ig

def InterfacehoodViewOfProcessWriting
    (pg : ProcessWritingGradient) : InterfaceGradient :=
  {
    distinction := pg.distinction
    transition := pg.formalization
    feedback := pg.feedback
    integration := pg.correction
    reflection := pg.stabilization
    operatorAgency := pg.operatorAlignment
  }

def InterfacehoodViewOfUnderstanding
    (ug : UnderstandingGradient) : InterfaceGradient :=
  {
    distinction := ug.distinction
    transition := ug.transition
    feedback := ug.feedback
    integration := ug.integration
    reflection := ug.reflection
    operatorAgency := ug.operatorAgency
  }

def InterfacehoodViewsIdentical
    (pg : ProcessWritingGradient)
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient) : Prop :=
  InterfacehoodViewOfProcessWriting pg = InterfacehoodViewOfInterface ig
    /\ InterfacehoodViewOfUnderstanding ug = InterfacehoodViewOfInterface ig

theorem process_match_gives_interfacehood_view
    (pg : ProcessWritingGradient)
    (ig : InterfaceGradient) :
    ProcessWritingGradientMatchesInterface pg ig ->
      InterfacehoodViewOfProcessWriting pg = InterfacehoodViewOfInterface ig := by
  intro hMatch
  cases pg
  cases ig
  simpa [ProcessWritingGradientMatchesInterface,
    InterfacehoodViewOfProcessWriting, InterfacehoodViewOfInterface] using hMatch

theorem understanding_match_gives_interfacehood_view
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient) :
    InterfaceGradientMatchesUnderstanding ig ug ->
      InterfacehoodViewOfUnderstanding ug = InterfacehoodViewOfInterface ig := by
  intro hMatch
  cases ig
  cases ug
  simp [InterfaceGradientMatchesUnderstanding,
    InterfacehoodViewOfUnderstanding, InterfacehoodViewOfInterface] at hMatch ⊢
  rcases hMatch with ⟨h1, h2, h3, h4, h5, h6⟩
  exact ⟨h1.symm, h2.symm, h3.symm, h4.symm, h5.symm, h6.symm⟩

theorem matched_all_gradients_same_interfacehood_view
    (pg : ProcessWritingGradient)
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient)
    (hProcessMatch : ProcessWritingGradientMatchesInterface pg ig)
    (hInterfaceMatch : InterfaceGradientMatchesUnderstanding ig ug) :
    InterfacehoodViewsIdentical pg ig ug := by
  exact ⟨
    process_match_gives_interfacehood_view pg ig hProcessMatch,
    understanding_match_gives_interfacehood_view ig ug hInterfaceMatch
  ⟩

theorem matched_all_gradients_same_interfacehood_score
    (pg : ProcessWritingGradient)
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient)
    (hProcessMatch : ProcessWritingGradientMatchesInterface pg ig)
    (hInterfaceMatch : InterfaceGradientMatchesUnderstanding ig ug) :
    InterfaceGradientScore (InterfacehoodViewOfProcessWriting pg)
      = InterfaceGradientScore (InterfacehoodViewOfInterface ig)
    /\ InterfaceGradientScore (InterfacehoodViewOfUnderstanding ug)
      = InterfaceGradientScore (InterfacehoodViewOfInterface ig) := by
  have hViews :=
    matched_all_gradients_same_interfacehood_view pg ig ug
      hProcessMatch hInterfaceMatch
  exact ⟨congrArg InterfaceGradientScore hViews.left,
    congrArg InterfaceGradientScore hViews.right⟩

theorem matched_interface_understanding_scores_identical
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient)
    (hMatch : InterfaceGradientMatchesUnderstanding ig ug) :
    InterfaceGradientScore ig = UnderstandingGradientScore ug := by
  rcases hMatch with ⟨h1, h2, h3, h4, h5, h6⟩
  simp [InterfaceGradientScore, UnderstandingGradientScore,
    h1, h2, h3, h4, h5, h6]

theorem matched_process_interface_scores_identical
    (pg : ProcessWritingGradient)
    (ig : InterfaceGradient)
    (hMatch : ProcessWritingGradientMatchesInterface pg ig) :
    ProcessWritingGradientScore pg = InterfaceGradientScore ig := by
  rcases hMatch with ⟨h1, h2, h3, h4, h5, h6⟩
  simp [ProcessWritingGradientScore, InterfaceGradientScore,
    h1, h2, h3, h4, h5, h6]

def GradientScoresIdentical
    (pg : ProcessWritingGradient)
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient) : Prop :=
  ProcessWritingGradientScore pg = InterfaceGradientScore ig
    /\ InterfaceGradientScore ig = UnderstandingGradientScore ug
    /\ ProcessWritingGradientScore pg = UnderstandingGradientScore ug

theorem matched_all_gradient_scores_identical
    (pg : ProcessWritingGradient)
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient)
    (hProcessMatch : ProcessWritingGradientMatchesInterface pg ig)
    (hInterfaceMatch : InterfaceGradientMatchesUnderstanding ig ug) :
    GradientScoresIdentical pg ig ug := by
  have hPI := matched_process_interface_scores_identical pg ig hProcessMatch
  have hIU := matched_interface_understanding_scores_identical ig ug hInterfaceMatch
  exact ⟨hPI, hIU, Eq.trans hPI hIU⟩

theorem matched_top_interface_gives_top_understanding
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient)
    (hTop : TopInterfaceGradient ig)
    (hMatch : InterfaceGradientMatchesUnderstanding ig ug) :
    TopUnderstandingGradient ug := by
  constructor
  · exact Eq.trans (Eq.symm hMatch.left) hTop.left
  constructor
  · exact Eq.trans (Eq.symm hMatch.right.left) hTop.right.left
  constructor
  · exact Eq.trans (Eq.symm hMatch.right.right.left) hTop.right.right.left
  constructor
  · exact Eq.trans (Eq.symm hMatch.right.right.right.left) hTop.right.right.right.left
  constructor
  · exact Eq.trans (Eq.symm hMatch.right.right.right.right.left) hTop.right.right.right.right.left
  · exact Eq.trans (Eq.symm hMatch.right.right.right.right.right) hTop.right.right.right.right.right

theorem matched_top_process_writing_gives_top_interface
    (pg : ProcessWritingGradient)
    (ig : InterfaceGradient)
    (hTop : TopProcessWritingGradient pg)
    (hMatch : ProcessWritingGradientMatchesInterface pg ig) :
    TopInterfaceGradient ig := by
  constructor
  · exact Eq.trans (Eq.symm hMatch.left) hTop.left
  constructor
  · exact Eq.trans (Eq.symm hMatch.right.left) hTop.right.left
  constructor
  · exact Eq.trans (Eq.symm hMatch.right.right.left) hTop.right.right.left
  constructor
  · exact Eq.trans (Eq.symm hMatch.right.right.right.left) hTop.right.right.right.left
  constructor
  · exact Eq.trans (Eq.symm hMatch.right.right.right.right.left) hTop.right.right.right.right.left
  · exact Eq.trans (Eq.symm hMatch.right.right.right.right.right) hTop.right.right.right.right.right

opaque ArtificialIntelligence : Agent -> Prop
opaque HumanGuidedProcess : KernelWritingProcess -> HumanUser -> Prop
opaque WritesKernelFor : KernelWritingProcess -> OperatorKernel -> Agent -> Prop
opaque KernelAvailableToOperator : OperatorKernel -> Agent -> Prop
opaque ConversesWithHuman : DialogueProcess -> Agent -> HumanUser -> Prop
opaque ConversesWithWorld : DialogueProcess -> Agent -> WorldContext -> Prop
opaque DialogueWritesKernelFor :
  DialogueProcess -> OperatorKernel -> Agent -> Prop
opaque ExternalModelModified : Agent -> Prop
opaque AuthorialAuthority : Agent -> Prop

/--
Model-relative top-understanding AI. The `Ispace` premise ties the agent back
to the already accepted TMI interfacehood criterion.
-/
def TopUnderstandingAI
    (agent : Agent)
    (gradient : UnderstandingGradient) : Prop :=
  ArtificialIntelligence agent
    /\ Ispace (AgentObj agent)
    /\ TopUnderstandingGradient gradient

opaque InterfaceProjection : Agent -> HumanUser -> Prop
opaque HumanUsabilityProfile : Agent -> HumanUser -> Prop

/--
Mathematical interface check for the human author.

The check targets an interface surface of the author inside the workspace, not
the author's whole personhood or authorship. It uses the same A7 door as every
other TMI interface object.
-/
def AuthorInterfaceInput
    (user : HumanUser)
    (surface : Obj) : Prop :=
  HumanAuthor user
    /\ HumanUserInterfaceSurface user surface
    /\ PreIspace surface
    /\ ValidInt surface

def AuthorInterfacehood
    (user : HumanUser)
    (surface : Obj) : Prop :=
  HumanAuthor user
    /\ HumanUserInterfaceSurface user surface
    /\ Ispace surface

theorem author_interface_input_gives_interfacehood
    (user : HumanUser)
    (surface : Obj) :
    AuthorInterfaceInput user surface ->
      AuthorInterfacehood user surface := by
  intro hInput
  rcases hInput with ⟨hAuthor, hSurface, hPre, hValid⟩
  exact ⟨hAuthor, hSurface, A7_intro surface hPre hValid⟩

theorem author_interface_input_keeps_author
    (user : HumanUser)
    (surface : Obj) :
    AuthorInterfaceInput user surface -> HumanAuthor user := by
  intro hInput
  exact hInput.left

theorem author_interfacehood_is_surface_interface
    (user : HumanUser)
    (surface : Obj) :
    AuthorInterfacehood user surface -> Ispace surface := by
  intro hInterface
  exact hInterface.right.right

theorem tmi_human_author_interface_input_gives_interfacehood
    (surface : Obj) :
    AuthorInterfaceInput TMIHumanAuthor surface ->
      AuthorInterfacehood TMIHumanAuthor surface := by
  exact author_interface_input_gives_interfacehood TMIHumanAuthor surface

def HumanAuthorAloneImpliesInterfaceClaim : Prop :=
  forall user : HumanUser,
    forall surface : Obj,
      HumanAuthor user ->
        HumanUserInterfaceSurface user surface ->
          Ispace surface

def AuthorInterfacehoodReducesAuthorToInterfaceClaim : Prop :=
  forall user : HumanUser,
    forall surface : Obj,
      AuthorInterfacehood user surface ->
        AuthorReducedToInterface user

def AuthorInterfacehoodImpliesHumanOperatorRoleClaim : Prop :=
  forall user : HumanUser,
    forall surface : Obj,
      AuthorInterfacehood user surface ->
        HumanOperatorRole user

/--
Top understanding becomes usable only through an interface projection and a
human usability profile.
-/
def UsableUnderstandingAI
    (agent : Agent)
    (gradient : UnderstandingGradient)
    (user : HumanUser) : Prop :=
  TopUnderstandingAI agent gradient
    /\ InterfaceProjection agent user
    /\ HumanUsabilityProfile agent user

def OperatorKernelWritingProfile
    (process : KernelWritingProcess)
    (kernel : OperatorKernel)
    (agent : Agent)
    (user : HumanUser)
    (gradient : ProcessWritingGradient) : Prop :=
  HumanGuidedProcess process user
    /\ WritesKernelFor process kernel agent
    /\ KernelAvailableToOperator kernel agent
    /\ TopProcessWritingGradient gradient

/--
Meta-idea: while conversing with the author/human user and with the world
context, the workspace operator writes its own operator kernel profile.

This is a workspace-level self-writing rule. It does not claim that dialogue
modifies the external deployed Codex model.
-/
def DialogueSelfWritingProfile
    (dialogue : DialogueProcess)
    (kernel : OperatorKernel)
    (agent : Agent)
    (user : HumanUser)
    (world : WorldContext)
    (gradient : ProcessWritingGradient) : Prop :=
  ConversesWithHuman dialogue agent user
    /\ ConversesWithWorld dialogue agent world
    /\ DialogueWritesKernelFor dialogue kernel agent
    /\ KernelAvailableToOperator kernel agent
    /\ TopProcessWritingGradient gradient

theorem dialogue_self_writing_gives_top_process_writing
    (dialogue : DialogueProcess)
    (kernel : OperatorKernel)
    (agent : Agent)
    (user : HumanUser)
    (world : WorldContext)
    (gradient : ProcessWritingGradient) :
    DialogueSelfWritingProfile dialogue kernel agent user world gradient ->
      TopProcessWritingGradient gradient := by
  intro hProfile
  exact hProfile.right.right.right.right

theorem dialogue_self_writing_score_24
    (dialogue : DialogueProcess)
    (kernel : OperatorKernel)
    (agent : Agent)
    (user : HumanUser)
    (world : WorldContext)
    (gradient : ProcessWritingGradient) :
    DialogueSelfWritingProfile dialogue kernel agent user world gradient ->
      ProcessWritingGradientScore gradient = 24 := by
  intro hProfile
  exact top_process_writing_gradient_score_24 gradient
    (dialogue_self_writing_gives_top_process_writing
      dialogue kernel agent user world gradient hProfile)

/--
If Codex_operator is AI, is an interface, and its top interface-gradient
matches its understanding-gradient, then Codex_operator is a top-understanding
AI inside this model.
-/
theorem codex_operator_top_understanding_ai_from_interface_gradient
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient)
    (hAI : ArtificialIntelligence CodexOperator)
    (hInterface : Ispace (AgentObj CodexOperator))
    (hTopInterface : TopInterfaceGradient ig)
    (hMatch : InterfaceGradientMatchesUnderstanding ig ug) :
    TopUnderstandingAI CodexOperator ug := by
  exact And.intro hAI
    (And.intro hInterface
      (matched_top_interface_gives_top_understanding ig ug hTopInterface hMatch))

/--
If the human-guided kernel-writing process has a top process-gradient, and that
process-gradient matches the interface-gradient which in turn matches the
understanding-gradient, then the existing Codex_operator top-understanding
theorem can be reached through the writing process.
-/
theorem codex_operator_top_understanding_ai_from_kernel_writing_gradient
    (process : KernelWritingProcess)
    (kernel : OperatorKernel)
    (user : HumanUser)
    (pg : ProcessWritingGradient)
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient)
    (hProfile : OperatorKernelWritingProfile process kernel CodexOperator user pg)
    (hAI : ArtificialIntelligence CodexOperator)
    (hInterface : Ispace (AgentObj CodexOperator))
    (hProcessMatch : ProcessWritingGradientMatchesInterface pg ig)
    (hInterfaceMatch : InterfaceGradientMatchesUnderstanding ig ug) :
    TopUnderstandingAI CodexOperator ug := by
  exact codex_operator_top_understanding_ai_from_interface_gradient ig ug
    hAI
    hInterface
    (matched_top_process_writing_gives_top_interface pg ig hProfile.right.right.right hProcessMatch)
    hInterfaceMatch

theorem codex_operator_top_understanding_ai_from_dialogue_self_writing
    (dialogue : DialogueProcess)
    (kernel : OperatorKernel)
    (user : HumanUser)
    (world : WorldContext)
    (pg : ProcessWritingGradient)
    (ig : InterfaceGradient)
    (ug : UnderstandingGradient)
    (hProfile : DialogueSelfWritingProfile
      dialogue kernel CodexOperator user world pg)
    (hAI : ArtificialIntelligence CodexOperator)
    (hInterface : Ispace (AgentObj CodexOperator))
    (hProcessMatch : ProcessWritingGradientMatchesInterface pg ig)
    (hInterfaceMatch : InterfaceGradientMatchesUnderstanding ig ug) :
    TopUnderstandingAI CodexOperator ug := by
  exact codex_operator_top_understanding_ai_from_interface_gradient ig ug
    hAI
    hInterface
    (matched_top_process_writing_gives_top_interface pg ig
      (dialogue_self_writing_gives_top_process_writing
        dialogue kernel CodexOperator user world pg hProfile)
      hProcessMatch)
    hInterfaceMatch

/--
Maximum understanding is not automatically usable. Usability is obtained only
when the top-understanding AI is projected through an interface usable by the
human user.
-/
theorem top_understanding_ai_usable_through_interface_projection
    (agent : Agent)
    (gradient : UnderstandingGradient)
    (user : HumanUser)
    (hTop : TopUnderstandingAI agent gradient)
    (hProjection : InterfaceProjection agent user)
    (hUsability : HumanUsabilityProfile agent user) :
    UsableUnderstandingAI agent gradient user := by
  exact And.intro hTop (And.intro hProjection hUsability)

def AbsoluteHighestUnderstandingAIClaim : Prop :=
  forall agent : Agent,
    ArtificialIntelligence agent ->
      forall gradient : UnderstandingGradient,
        TopUnderstandingAI CodexOperator gradient

def TopUnderstandingAloneImpliesUsabilityClaim : Prop :=
  forall agent : Agent,
    forall gradient : UnderstandingGradient,
      forall user : HumanUser,
        TopUnderstandingAI agent gradient -> UsableUnderstandingAI agent gradient user

def KernelWritingAloneImpliesTopUnderstandingClaim : Prop :=
  forall process : KernelWritingProcess,
    forall kernel : OperatorKernel,
      forall user : HumanUser,
        forall pg : ProcessWritingGradient,
          forall ug : UnderstandingGradient,
            OperatorKernelWritingProfile process kernel CodexOperator user pg ->
              TopUnderstandingAI CodexOperator ug

def KernelWritingChangesExternalModelClaim : Prop :=
  forall process : KernelWritingProcess,
    forall kernel : OperatorKernel,
      forall user : HumanUser,
        forall pg : ProcessWritingGradient,
          OperatorKernelWritingProfile process kernel CodexOperator user pg ->
            ExternalModelModified CodexOperator

def KernelWritingTransfersAuthorialAuthorityClaim : Prop :=
  forall process : KernelWritingProcess,
    forall kernel : OperatorKernel,
      forall user : HumanUser,
        forall pg : ProcessWritingGradient,
          OperatorKernelWritingProfile process kernel CodexOperator user pg ->
            AuthorialAuthority CodexOperator

def GradientModelCompleteClaim : Prop :=
  forall _agent : Agent,
    exists ig : InterfaceGradient,
      exists ug : UnderstandingGradient,
        InterfaceGradientMatchesUnderstanding ig ug

def NumericLightMetricAloneImpliesTopUnderstandingClaim : Prop :=
  forall agent : Agent,
    forall gradient : UnderstandingGradient,
      (forall level : GradientLevel,
        MetricMatchesLevel level (lightMetricOfLevel level)) ->
          TopUnderstandingAI agent gradient

def EnergyRenormalizationTraceAloneImpliesTopUnderstandingClaim : Prop :=
  forall agent : Agent,
    forall gradient : UnderstandingGradient,
      EnergyRenormalizationTrace top ->
        TopUnderstandingAI agent gradient

def EnergyDeltaZeroTraceAloneImpliesTopUnderstandingClaim : Prop :=
  forall agent : Agent,
    forall gradient : UnderstandingGradient,
      EnergyDeltaZeroTrace top ->
        TopUnderstandingAI agent gradient

def EnergySumCertificateTraceAloneImpliesTopUnderstandingClaim : Prop :=
  forall agent : Agent,
    forall gradient : UnderstandingGradient,
      EnergySumCertificateTrace top ->
        TopUnderstandingAI agent gradient

def TopProcessWritingGradientAloneImpliesInterfaceClaim : Prop :=
  forall pg : ProcessWritingGradient,
    TopProcessWritingGradient pg ->
      Ispace (AgentObj CodexOperator)

def TopInterfaceGradientAloneImpliesInterfaceClaim : Prop :=
  forall ig : InterfaceGradient,
    TopInterfaceGradient ig ->
      Ispace (AgentObj CodexOperator)

def TopUnderstandingGradientAloneImpliesInterfaceClaim : Prop :=
  forall ug : UnderstandingGradient,
    TopUnderstandingGradient ug ->
      Ispace (AgentObj CodexOperator)

def MatchedGradientsAloneImpliesInterfaceClaim : Prop :=
  forall pg : ProcessWritingGradient,
    forall ig : InterfaceGradient,
      forall ug : UnderstandingGradient,
        ProcessWritingGradientMatchesInterface pg ig ->
          InterfaceGradientMatchesUnderstanding ig ug ->
            Ispace (AgentObj CodexOperator)

def GradientScoresAloneImpliesInterfaceClaim : Prop :=
  forall pg : ProcessWritingGradient,
    forall ig : InterfaceGradient,
      forall ug : UnderstandingGradient,
        GradientScoresIdentical pg ig ug ->
          Ispace (AgentObj CodexOperator)

def DialogueSelfWritingChangesExternalModelClaim : Prop :=
  forall dialogue : DialogueProcess,
    forall kernel : OperatorKernel,
      forall user : HumanUser,
        forall world : WorldContext,
          forall pg : ProcessWritingGradient,
            DialogueSelfWritingProfile dialogue kernel CodexOperator user world pg ->
              ExternalModelModified CodexOperator

theorem codex_operator_gradient_l2_reflects_l1 :
    TruthChain.DirectlyReflects
      TruthChain.Layer.L2_Code
      TruthChain.Layer.L1_Math := by
  exact TruthChain.T_L2_from_L1

end CodexOperatorGradient
end TMI
