import Submission.PoincareLib.Topology.Homotopy.Simplex.LegacySingular
import Mathlib.Analysis.Convex.StdSimplex
import Mathlib.AlgebraicTopology.SimplicialSet.TopAdj
import Mathlib.Topology.Connected.TotallyDisconnected
import Mathlib.Analysis.Convex.Contractible

/-!
# Singular simplices of a discrete space

Every singular simplex in a discrete space is literally constant. Initial
vertex evaluation and constant simplices therefore give inverse simplicial
maps. This keeps the fiber coordinate in the cone comparison explicit.
Source: Hatcher, the cone case of Theorem 2.27, printed pp. 128-130.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory
open scoped Simplicial

universe u

namespace PoincareMT.Proofs.M59

variable (F : Type u) [TopologicalSpace F] [DiscreteTopology F]

/-- A continuous map from a standard simplex to a discrete space is
constant on all parameters. Source: Hatcher, Theorem 2.27, pp. 128-130. -/
theorem discreteSimplex_eq {n : ℕ} (f : C(stdSimplex ℝ (Fin (n + 1)), F))
    (x y : stdSimplex ℝ (Fin (n + 1))) : f x = f y :=
  PreconnectedSpace.constant inferInstance f.continuous

/-- Evaluate each actual singular simplex at its initial vertex.
Source: Hatcher, Theorem 2.27, pp. 128-130. -/
def discreteSingularEvaluation : TopCat.toSSet.obj (TopCat.of F) ⟶
    (SimplicialObject.const (Type u)).obj F where
  app n := ↾fun s => (TopCat.of F).toLegacySSetObjEquiv n s (stdSimplex.vertex 0)
  naturality {n m} f := by
    apply ConcreteCategory.hom_ext
    intro s
    change ((TopCat.of F).toLegacySSetObjEquiv m ((TopCat.toSSet.obj (TopCat.of F)).map f s))
        (stdSimplex.vertex 0) =
      ((TopCat.of F).toLegacySSetObjEquiv n s) (stdSimplex.vertex 0)
    exact (TopCat.toLegacySSetObjEquiv_naturality_apply f.unop s _).trans
      (discreteSimplex_eq F _ _ _)

/-- Constant singular simplices retain their actual value in the
discrete carrier. Source: Hatcher, Theorem 2.27, pp. 128-130. -/
def discreteSingularConstant : (SimplicialObject.const (Type u)).obj F ⟶
    TopCat.toSSet.obj (TopCat.of F) where
  app n := ↾fun a => ((TopCat.of F).toLegacySSetObjEquiv n).symm (ContinuousMap.const _ a)
  naturality {n m} f := by
    apply ConcreteCategory.hom_ext
    intro a
    apply ((TopCat.of F).toLegacySSetObjEquiv m).injective
    rfl

/-- The singular simplicial set of a discrete space is literally
isomorphic to the constant simplicial set on that carrier.
Source: Hatcher, Theorem 2.27, pp. 128-130. -/
def discreteSingularIso : TopCat.toSSet.obj (TopCat.of F) ≅
    (SimplicialObject.const (Type u)).obj F where
  hom := discreteSingularEvaluation F
  inv := discreteSingularConstant F
  hom_inv_id := by
    ext n : 1
    apply ConcreteCategory.hom_ext
    intro s
    apply ((TopCat.of F).toLegacySSetObjEquiv n).injective
    ext t
    change ((TopCat.of F).toLegacySSetObjEquiv n s) (stdSimplex.vertex 0) =
      ((TopCat.of F).toLegacySSetObjEquiv n s) t
    exact discreteSimplex_eq F _ _ _
  inv_hom_id := by
    rfl

end PoincareMT.Proofs.M59
