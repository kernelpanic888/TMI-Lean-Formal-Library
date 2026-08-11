import Mathlib.AlgebraicTopology.AlternatingFaceMapComplex

/-!
# Semisimplicial boundary carrier

Face data and the simplicial face law produce an alternating chain boundary
with `d squared = 0`. No degeneracy maps or metaphysical interpretation are
assumed.
-/

noncomputable section

namespace TMI.InterfaceFoundations.SemisimplicialBoundary

open CategoryTheory CategoryTheory.Preadditive HomologicalComplex

variable {C : Type*} [Category* C] [Preadditive C]

structure FaceData (C : Type*) [Category* C] [Preadditive C] where
  obj : Nat -> C
  face : forall n : Nat, Fin (n + 2) -> (obj (n + 1) ⟶ obj n)
  face_comp : forall {n : Nat} {i : Fin (n + 3)} {j : Fin (n + 2)}
    (h : i <= j.castSucc),
      face (n + 1) j.succ ≫
        face n (i.castLT (lt_of_le_of_lt h (Fin.is_lt j))) =
        face (n + 1) i ≫ face n j

namespace FaceData

variable (X : FaceData C)

@[simp] def objD (n : Nat) : X.obj (n + 1) ⟶ X.obj n :=
  ∑ i : Fin (n + 2), (-1 : ℤ) ^ (i : Nat) • X.face n i

theorem d_squared (n : Nat) : objD X (n + 1) ≫ objD X n = 0 := by
  dsimp [objD]
  simp only [comp_sum, sum_comp, ← Finset.sum_product']
  let P := Fin (n + 2) × Fin (n + 3)
  let S : Finset P := {ij : P | (ij.2 : Nat) <= (ij.1 : Nat)}
  rw [Finset.univ_product_univ, ← Finset.sum_add_sum_compl S, ← eq_neg_iff_add_eq_zero,
    ← Finset.sum_neg_distrib]
  let phi : forall ij : P, ij ∈ S -> P := fun ij hij =>
    (Fin.castLT ij.2
      (lt_of_le_of_lt (Finset.mem_filter.mp hij).right (Fin.is_lt ij.1)), ij.1.succ)
  apply Finset.sum_bij phi
  · intro ij hij
    simp_rw [S, phi, Finset.compl_filter, Finset.mem_filter_univ, Fin.val_succ,
      Fin.val_castLT] at hij ⊢
    lia
  · rintro ⟨i, j⟩ hij ⟨i', j'⟩ hij' h
    rw [Prod.mk_inj]
    exact ⟨by simpa [phi] using! congr_arg Prod.snd h,
      by simpa [phi, Fin.castSucc_castLT] using!
        congr_arg Fin.castSucc (congr_arg Prod.fst h)⟩
  · rintro ⟨i', j'⟩ hij'
    simp_rw [S, Finset.compl_filter, Finset.mem_filter_univ, not_le] at hij'
    refine ⟨(j'.pred <| ?_, Fin.castSucc i'), ?_, ?_⟩
    · rintro rfl
      simp only [Fin.val_zero, not_lt_zero] at hij'
    · simpa [S] using! Nat.le_sub_one_of_lt hij'
    · simp only [phi, Fin.castLT_castSucc, Fin.succ_pred]
  · rintro ⟨i, j⟩ hij
    dsimp
    simp only [zsmul_comp, comp_zsmul, smul_smul, ← neg_smul]
    congr 1
    · simp only [phi, Fin.val_succ, pow_add, pow_one, mul_neg, neg_neg, mul_one]
      apply mul_comm
    · symm
      simpa [phi] using
        (X.face_comp (i := j) (j := i) (by simpa [S] using! hij))

noncomputable def chainComplex : ChainComplex C Nat :=
  ChainComplex.of X.obj (objD X) (d_squared X)

structure Hom (X Y : FaceData C) where
  app : forall n : Nat, X.obj n ⟶ Y.obj n
  face_naturality : forall (n : Nat) (i : Fin (n + 2)),
    app (n + 1) ≫ Y.face n i = X.face n i ≫ app n

namespace Hom

variable {X Y : FaceData C}

def toChainMap (f : Hom X Y) : X.chainComplex ⟶ Y.chainComplex :=
  ChainComplex.ofHom (fun n => f.app n) (fun n => by
    simp only [chainComplex, ChainComplex.of_d, objD, Int.reduceNeg]
    rw [comp_sum, sum_comp]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [comp_zsmul, zsmul_comp]
    congr 1
    exact f.face_naturality n i)

end Hom
end FaceData
end TMI.InterfaceFoundations.SemisimplicialBoundary
