/-
Lean-native numeric certificates for the TMI light bridge.

These certificates do not prove external physics. They replay the bounded
integer arithmetic behind the public G4 light-gradient row so that the
remaining physical constants are not only checked by Python/JSON.
-/

import TMI.BridgePhysics.Contracts

namespace TMI
namespace BridgePhysics

def RoundedHalfUpQuotient
    (numerator denominator rounded : Nat) : Prop :=
  denominator > 0 ∧
    2 * denominator * rounded <= 2 * numerator + denominator ∧
    2 * numerator + denominator < 2 * denominator * (rounded + 1)

def G4FrequencyFromSpeedOfLightCertificate : Prop :=
  let metric := lightPhotonBridgeMetric LightBridgeLevel.G4
  metric.wavelengthNm = 400 ∧
    metric.frequencyThz = 749 ∧
    FrequencyRoundedFromSpeedOfLight metric ∧
    metric.wavelengthNm * metric.frequencyThz * 1000 = 299600000 ∧
    speedOfLightNmThzMilliScale = 299792458

def G4EnergyFromConstantsCertificate : Prop :=
  let metric := lightPhotonBridgeMetric LightBridgeLevel.G4
  metric.wavelengthNm = 400 ∧
    metric.energyMilliEv = 3100 ∧
    planckConstantJouleSecond.significand = 662607015 ∧
    planckConstantJouleSecond.exponent10 = -42 ∧
    speedOfLightMetersPerSecond.significand = 299792458 ∧
    elementaryChargeCoulomb.significand = 1602176634 ∧
    elementaryChargeCoulomb.exponent10 = -28 ∧
    RoundedHalfUpQuotient
      (planckConstantJouleSecond.significand *
        speedOfLightMetersPerSecond.significand)
      (metric.wavelengthNm *
        elementaryChargeCoulomb.significand *
        100)
      metric.energyMilliEv

def EnergyRoundedFromConstants
    (metric : LightPhotonBridgeMetric) : Prop :=
  RoundedHalfUpQuotient
    (planckConstantJouleSecond.significand *
      speedOfLightMetersPerSecond.significand)
    (metric.wavelengthNm *
      elementaryChargeCoulomb.significand *
      100)
    metric.energyMilliEv

def certifiedLightPhotonBridgeMetric : LightBridgeLevel -> LightPhotonBridgeMetric
  | LightBridgeLevel.G0 =>
      { level := LightBridgeLevel.G0, index := 0, wavelengthNm := 700,
        frequencyThz := 428, energyMilliEv := 1771 }
  | LightBridgeLevel.G1 =>
      { level := LightBridgeLevel.G1, index := 1, wavelengthNm := 625,
        frequencyThz := 480, energyMilliEv := 1984 }
  | LightBridgeLevel.G2 =>
      { level := LightBridgeLevel.G2, index := 2, wavelengthNm := 550,
        frequencyThz := 545, energyMilliEv := 2254 }
  | LightBridgeLevel.G3 =>
      { level := LightBridgeLevel.G3, index := 3, wavelengthNm := 475,
        frequencyThz := 631, energyMilliEv := 2610 }
  | LightBridgeLevel.G4 =>
      { level := LightBridgeLevel.G4, index := 4, wavelengthNm := 400,
        frequencyThz := 749, energyMilliEv := 3100 }

def CertifiedMetricSharesVisualFrame (level : LightBridgeLevel) : Prop :=
  let visual := lightPhotonBridgeMetric level
  let certified := certifiedLightPhotonBridgeMetric level
  certified.level = visual.level ∧
    certified.index = visual.index ∧
    certified.wavelengthNm = visual.wavelengthNm ∧
    certified.frequencyThz = visual.frequencyThz

def AllVisibleLightFrequencyCertificates : Prop :=
  FrequencyRoundedFromSpeedOfLight
      (lightPhotonBridgeMetric LightBridgeLevel.G0) ∧
    FrequencyRoundedFromSpeedOfLight
      (lightPhotonBridgeMetric LightBridgeLevel.G1) ∧
    FrequencyRoundedFromSpeedOfLight
      (lightPhotonBridgeMetric LightBridgeLevel.G2) ∧
    FrequencyRoundedFromSpeedOfLight
      (lightPhotonBridgeMetric LightBridgeLevel.G3) ∧
    FrequencyRoundedFromSpeedOfLight
      (lightPhotonBridgeMetric LightBridgeLevel.G4)

def CertifiedEnergyLightRows : Prop :=
  EnergyRoundedFromConstants
      (lightPhotonBridgeMetric LightBridgeLevel.G3) ∧
    EnergyRoundedFromConstants
      (lightPhotonBridgeMetric LightBridgeLevel.G4)

def NonCertifiedEnergyLightRows : Prop :=
  ¬ EnergyRoundedFromConstants
      (lightPhotonBridgeMetric LightBridgeLevel.G0) ∧
    ¬ EnergyRoundedFromConstants
      (lightPhotonBridgeMetric LightBridgeLevel.G1) ∧
    ¬ EnergyRoundedFromConstants
      (lightPhotonBridgeMetric LightBridgeLevel.G2)

def AllCertifiedLightFrequencyCertificates : Prop :=
  FrequencyRoundedFromSpeedOfLight
      (certifiedLightPhotonBridgeMetric LightBridgeLevel.G0) ∧
    FrequencyRoundedFromSpeedOfLight
      (certifiedLightPhotonBridgeMetric LightBridgeLevel.G1) ∧
    FrequencyRoundedFromSpeedOfLight
      (certifiedLightPhotonBridgeMetric LightBridgeLevel.G2) ∧
    FrequencyRoundedFromSpeedOfLight
      (certifiedLightPhotonBridgeMetric LightBridgeLevel.G3) ∧
    FrequencyRoundedFromSpeedOfLight
      (certifiedLightPhotonBridgeMetric LightBridgeLevel.G4)

def AllCertifiedLightEnergyCertificates : Prop :=
  EnergyRoundedFromConstants
      (certifiedLightPhotonBridgeMetric LightBridgeLevel.G0) ∧
    EnergyRoundedFromConstants
      (certifiedLightPhotonBridgeMetric LightBridgeLevel.G1) ∧
    EnergyRoundedFromConstants
      (certifiedLightPhotonBridgeMetric LightBridgeLevel.G2) ∧
    EnergyRoundedFromConstants
      (certifiedLightPhotonBridgeMetric LightBridgeLevel.G3) ∧
    EnergyRoundedFromConstants
      (certifiedLightPhotonBridgeMetric LightBridgeLevel.G4)

def VisualCertifiedEnergyBoundary : Prop :=
  (lightPhotonBridgeMetric LightBridgeLevel.G0).energyMilliEv ≠
      (certifiedLightPhotonBridgeMetric LightBridgeLevel.G0).energyMilliEv ∧
    (lightPhotonBridgeMetric LightBridgeLevel.G1).energyMilliEv ≠
      (certifiedLightPhotonBridgeMetric LightBridgeLevel.G1).energyMilliEv ∧
    (lightPhotonBridgeMetric LightBridgeLevel.G2).energyMilliEv ≠
      (certifiedLightPhotonBridgeMetric LightBridgeLevel.G2).energyMilliEv ∧
    (lightPhotonBridgeMetric LightBridgeLevel.G3).energyMilliEv =
      (certifiedLightPhotonBridgeMetric LightBridgeLevel.G3).energyMilliEv ∧
    (lightPhotonBridgeMetric LightBridgeLevel.G4).energyMilliEv =
      (certifiedLightPhotonBridgeMetric LightBridgeLevel.G4).energyMilliEv

def energyRenormalizationDelta : LightBridgeLevel -> Nat
  | LightBridgeLevel.G0 => 1
  | LightBridgeLevel.G1 => 4
  | LightBridgeLevel.G2 => 4
  | LightBridgeLevel.G3 => 0
  | LightBridgeLevel.G4 => 0

def EnergyRenormalizationLaw (level : LightBridgeLevel) : Prop :=
  (lightPhotonBridgeMetric level).energyMilliEv +
      energyRenormalizationDelta level =
    (certifiedLightPhotonBridgeMetric level).energyMilliEv

def AllEnergyRenormalizationLaws : Prop :=
  EnergyRenormalizationLaw LightBridgeLevel.G0 ∧
    EnergyRenormalizationLaw LightBridgeLevel.G1 ∧
    EnergyRenormalizationLaw LightBridgeLevel.G2 ∧
    EnergyRenormalizationLaw LightBridgeLevel.G3 ∧
    EnergyRenormalizationLaw LightBridgeLevel.G4

def EnergyRenormalizationSupportBoundary : Prop :=
  energyRenormalizationDelta LightBridgeLevel.G0 = 1 ∧
    energyRenormalizationDelta LightBridgeLevel.G1 = 4 ∧
    energyRenormalizationDelta LightBridgeLevel.G2 = 4 ∧
    energyRenormalizationDelta LightBridgeLevel.G3 = 0 ∧
    energyRenormalizationDelta LightBridgeLevel.G4 = 0

theorem g4_frequency_certificate_rounded_from_speed_of_light :
    G4FrequencyFromSpeedOfLightCertificate := by
  simp [G4FrequencyFromSpeedOfLightCertificate,
    FrequencyRoundedFromSpeedOfLight, lightPhotonBridgeMetric,
    speedOfLightNmThzMilliScale]

theorem g4_energy_certificate_rounded_from_constants :
    G4EnergyFromConstantsCertificate := by
  simp [G4EnergyFromConstantsCertificate, RoundedHalfUpQuotient,
    lightPhotonBridgeMetric, planckConstantJouleSecond,
    speedOfLightMetersPerSecond, elementaryChargeCoulomb]

theorem all_visible_light_frequency_certificates :
    AllVisibleLightFrequencyCertificates := by
  simp [AllVisibleLightFrequencyCertificates,
    FrequencyRoundedFromSpeedOfLight, lightPhotonBridgeMetric,
    speedOfLightNmThzMilliScale]

theorem certified_energy_light_rows :
    CertifiedEnergyLightRows := by
  simp [CertifiedEnergyLightRows, EnergyRoundedFromConstants,
    RoundedHalfUpQuotient, lightPhotonBridgeMetric,
    planckConstantJouleSecond, speedOfLightMetersPerSecond,
    elementaryChargeCoulomb]

theorem non_certified_energy_light_rows :
    NonCertifiedEnergyLightRows := by
  simp [NonCertifiedEnergyLightRows, EnergyRoundedFromConstants,
    RoundedHalfUpQuotient, lightPhotonBridgeMetric,
    planckConstantJouleSecond, speedOfLightMetersPerSecond,
    elementaryChargeCoulomb]

theorem certified_metric_shares_visual_frame
    (level : LightBridgeLevel) :
    CertifiedMetricSharesVisualFrame level := by
  cases level <;>
    simp [CertifiedMetricSharesVisualFrame, lightPhotonBridgeMetric,
      certifiedLightPhotonBridgeMetric]

theorem all_certified_light_frequency_certificates :
    AllCertifiedLightFrequencyCertificates := by
  simp [AllCertifiedLightFrequencyCertificates,
    FrequencyRoundedFromSpeedOfLight, certifiedLightPhotonBridgeMetric,
    speedOfLightNmThzMilliScale]

theorem all_certified_light_energy_certificates :
    AllCertifiedLightEnergyCertificates := by
  simp [AllCertifiedLightEnergyCertificates, EnergyRoundedFromConstants,
    RoundedHalfUpQuotient, certifiedLightPhotonBridgeMetric,
    planckConstantJouleSecond, speedOfLightMetersPerSecond,
    elementaryChargeCoulomb]

theorem visual_certified_energy_boundary :
    VisualCertifiedEnergyBoundary := by
  simp [VisualCertifiedEnergyBoundary, lightPhotonBridgeMetric,
    certifiedLightPhotonBridgeMetric]

theorem energy_renormalization_law
    (level : LightBridgeLevel) :
    EnergyRenormalizationLaw level := by
  cases level <;>
    simp [EnergyRenormalizationLaw, lightPhotonBridgeMetric,
      certifiedLightPhotonBridgeMetric, energyRenormalizationDelta]

theorem all_energy_renormalization_laws :
    AllEnergyRenormalizationLaws := by
  simp [AllEnergyRenormalizationLaws, EnergyRenormalizationLaw,
    lightPhotonBridgeMetric, certifiedLightPhotonBridgeMetric,
    energyRenormalizationDelta]

theorem energy_renormalization_support_boundary :
    EnergyRenormalizationSupportBoundary := by
  simp [EnergyRenormalizationSupportBoundary, energyRenormalizationDelta]

theorem g4_numeric_light_certificates :
    G4FrequencyFromSpeedOfLightCertificate ∧
      G4EnergyFromConstantsCertificate := by
  exact ⟨
    g4_frequency_certificate_rounded_from_speed_of_light,
    g4_energy_certificate_rounded_from_constants
  ⟩

theorem visible_light_numeric_certificate_boundary :
    AllVisibleLightFrequencyCertificates ∧
      CertifiedEnergyLightRows ∧
      NonCertifiedEnergyLightRows := by
  exact ⟨
    all_visible_light_frequency_certificates,
    certified_energy_light_rows,
    non_certified_energy_light_rows
  ⟩

theorem certified_light_numeric_certificate_boundary :
    (∀ level : LightBridgeLevel, CertifiedMetricSharesVisualFrame level) ∧
      AllCertifiedLightFrequencyCertificates ∧
      AllCertifiedLightEnergyCertificates ∧
      VisualCertifiedEnergyBoundary ∧
      AllEnergyRenormalizationLaws ∧
      EnergyRenormalizationSupportBoundary := by
  exact ⟨
    certified_metric_shares_visual_frame,
    all_certified_light_frequency_certificates,
    all_certified_light_energy_certificates,
    visual_certified_energy_boundary,
    all_energy_renormalization_laws,
    energy_renormalization_support_boundary
  ⟩

end BridgePhysics
end TMI
