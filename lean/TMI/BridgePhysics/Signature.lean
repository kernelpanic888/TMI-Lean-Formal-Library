/-
Bridge/Physics boundary signature for TMI-Core-Proof 0.2-A7.

These markers are intentionally outside Core and FormulaInterface. They name
physics-proof claims that bridge admissibility does not establish by itself.
-/

import TMI.FormulaInterface

namespace TMI
namespace BridgePhysics

open FormulaInterface

axiom CoreProvenPhysics : Formula → Prop
axiom PhysicalFieldProven : Formula → Prop

inductive LightBridgeLevel where
  | G0
  | G1
  | G2
  | G3
  | G4
deriving DecidableEq, Repr

structure ExactPhysicalConstant where
  significand : Nat
  exponent10 : Int
  unitCode : String
deriving DecidableEq, Repr

def speedOfLightMetersPerSecond : ExactPhysicalConstant :=
  { significand := 299792458, exponent10 := 0, unitCode := "m/s" }

def planckConstantJouleSecond : ExactPhysicalConstant :=
  { significand := 662607015, exponent10 := -42, unitCode := "J*s" }

def elementaryChargeCoulomb : ExactPhysicalConstant :=
  { significand := 1602176634, exponent10 := -28, unitCode := "C" }

structure LightPhotonBridgeMetric where
  level : LightBridgeLevel
  index : Nat
  wavelengthNm : Nat
  frequencyThz : Nat
  energyMilliEv : Nat
deriving DecidableEq, Repr

structure PhotonLifecycleTrace where
  emissionIndex : Nat
  absorptionIndex : Nat
  properDurationTicks : Nat
deriving DecidableEq, Repr

def lightPhotonBridgeMetric : LightBridgeLevel -> LightPhotonBridgeMetric
  | LightBridgeLevel.G0 =>
      { level := LightBridgeLevel.G0, index := 0, wavelengthNm := 700,
        frequencyThz := 428, energyMilliEv := 1770 }
  | LightBridgeLevel.G1 =>
      { level := LightBridgeLevel.G1, index := 1, wavelengthNm := 625,
        frequencyThz := 480, energyMilliEv := 1980 }
  | LightBridgeLevel.G2 =>
      { level := LightBridgeLevel.G2, index := 2, wavelengthNm := 550,
        frequencyThz := 545, energyMilliEv := 2250 }
  | LightBridgeLevel.G3 =>
      { level := LightBridgeLevel.G3, index := 3, wavelengthNm := 475,
        frequencyThz := 631, energyMilliEv := 2610 }
  | LightBridgeLevel.G4 =>
      { level := LightBridgeLevel.G4, index := 4, wavelengthNm := 400,
        frequencyThz := 749, energyMilliEv := 3100 }

def speedOfLightNmThzMilliScale : Nat :=
  299792458

def photonLifecycleTraceOfLightMetric
    (metric : LightPhotonBridgeMetric) : PhotonLifecycleTrace :=
  { emissionIndex := 0
    absorptionIndex := metric.index + 1
    properDurationTicks := 0 }

end BridgePhysics
end TMI
