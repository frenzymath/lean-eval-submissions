import Mathlib.Analysis.Convex.StdSimplex
import Mathlib.AlgebraicTopology.SimplicialSet.TopAdj
import Mathlib.Topology.Homotopy.TopCat.Basic

/-! Transport singular simplices along the canonical homeomorphism from finitely
supported barycentric distributions to the existing finite coordinate simplex.
This keeps the geometric constructions independent of Mathlib's representation. -/

universe u
noncomputable section
open CategoryTheory Opposite
open scoped Simplicial

namespace Poincare.Topology

/-- The two standard finite simplex representations have identical coordinates. -/
def coordinateSimplexHomeomorph (ι : Type*) [Fintype ι] :
    Convexity.StdSimplex ℝ ι ≃ₜ stdSimplex ℝ ι where
  toFun z := ⟨z.weights, z.nonneg, z.total_of_fintype⟩
  invFun z := {
    weights := Finsupp.equivFunOnFinite.symm z.val
    nonneg i := by simpa using z.property.1 i
    total := by simpa [Finsupp.sum_fintype] using z.property.2 }
  left_inv z := by ext i; simp
  right_inv z := by apply Subtype.ext; funext i; simp
  continuous_toFun := by fun_prop
  continuous_invFun := by
    rw [(Convexity.StdSimplex.isEmbedding_toFun_comp_weights ℝ ι).continuous_iff]
    simpa only [Function.comp_def, Finsupp.coe_equivFunOnFinite_symm] using
      (continuous_subtype_val : Continuous (Subtype.val : stdSimplex ℝ ι → ι → ℝ))

@[simp] theorem coordinateSimplexHomeomorph_map
    {ι κ : Type*} [Fintype ι] [Fintype κ] (f : ι → κ)
    (z : Convexity.StdSimplex ℝ ι) :
    coordinateSimplexHomeomorph κ (Convexity.StdSimplex.map f z) =
      stdSimplex.map f (coordinateSimplexHomeomorph ι z) := by
  classical
  apply Subtype.ext
  funext i
  change Finsupp.mapDomain f z.weights i = FunOnFinite.linearMap ℝ ℝ f z.weights i
  rw [FunOnFinite.linearMap_apply_apply, Finsupp.mapDomain_apply]
  simp [Finsupp.sum_fintype, Finset.sum_filter, Finsupp.single_apply, eq_comm]

@[simp] theorem coordinateSimplexHomeomorph_symm_map
    {ι κ : Type*} [Fintype ι] [Fintype κ] (f : ι → κ)
    (z : stdSimplex ℝ ι) :
    (coordinateSimplexHomeomorph κ).symm (stdSimplex.map f z) =
      Convexity.StdSimplex.map f ((coordinateSimplexHomeomorph ι).symm z) := by
  apply (coordinateSimplexHomeomorph κ).injective
  simp

instance coordinateSimplexZeroUnique : Unique (stdSimplex ℝ (Fin 1)) :=
  (coordinateSimplexHomeomorph (Fin 1)).symm.toEquiv.unique

instance coordinateSimplexZeroInhabited : Inhabited (stdSimplex ℝ (Fin 1)) :=
  ⟨stdSimplex.vertex 0⟩

instance coordinateSimplexZeroSubsingleton : Subsingleton (stdSimplex ℝ (Fin 1)) :=
  ⟨fun a b => (coordinateSimplexZeroUnique.uniq a).trans
    (coordinateSimplexZeroUnique.uniq b).symm⟩

end Poincare.Topology

namespace TopCat

/-- Singular simplex equivalence in the project's finite coordinate model. -/
def toLegacySSetObjEquiv (X : TopCat.{u}) (n : SimplexCategoryᵒᵖ) :
    (toSSet.obj X).obj n ≃ C(stdSimplex ℝ (Fin (n.unop.len + 1)), X) :=
  (X.toSSetObjEquiv n).trans
    ((Poincare.Topology.coordinateSimplexHomeomorph _).continuousMapCongr (.refl _))

@[simp] theorem toLegacySSetObjEquiv_naturality_apply
    {X : TopCat.{u}} {n m : SimplexCategory} (f : n ⟶ m)
    (x : (toSSet.obj X).obj (op m)) (z : stdSimplex ℝ (Fin (n.len + 1))) :
    X.toLegacySSetObjEquiv _ ((toSSet.obj X).map f.op x) z =
      X.toLegacySSetObjEquiv _ x (stdSimplex.map f z) := by
  simp [toLegacySSetObjEquiv, Homeomorph.continuousMapCongr,
    Poincare.Topology.coordinateSimplexHomeomorph_symm_map]

@[simp] theorem toLegacySSetObjEquiv_δ_apply {X : TopCat.{u}} {n : ℕ}
    (x : toSSet.obj X _⦋n + 1⦌) (i : Fin (n + 2))
    (z : stdSimplex ℝ (Fin (n + 1))) :
    X.toLegacySSetObjEquiv _ ((toSSet.obj X).δ i x) z =
      X.toLegacySSetObjEquiv _ x (stdSimplex.map i.succAbove z) :=
  toLegacySSetObjEquiv_naturality_apply _ _ _

@[simp] theorem toLegacySSetObjEquiv_σ_apply {X : TopCat.{u}} {n : ℕ}
    (x : toSSet.obj X _⦋n⦌) (i : Fin (n + 1))
    (z : stdSimplex ℝ (Fin (n + 2))) :
    X.toLegacySSetObjEquiv _ ((toSSet.obj X).σ i x) z =
      X.toLegacySSetObjEquiv _ x (stdSimplex.map i.predAbove z) :=
  toLegacySSetObjEquiv_naturality_apply _ _ _

theorem toLegacySSetObjEquiv_symm_naturality {X : TopCat.{u}}
    {n m : SimplexCategory} (f : n ⟶ m)
    (g : C(stdSimplex ℝ (Fin (m.len + 1)), X)) :
    (toSSet.obj X).map f.op ((X.toLegacySSetObjEquiv _).symm g) =
      (X.toLegacySSetObjEquiv _).symm (g.comp ⟨stdSimplex.map f, stdSimplex.continuous_map _⟩) := by
  apply (X.toLegacySSetObjEquiv _).injective
  ext z
  simp

@[simp] theorem toLegacySSetObjEquiv_coordinate {X : TopCat.{u}}
    {n : ℕ} (s : toSSet.obj X _⦋n⦌)
    (z : Convexity.StdSimplex ℝ (Fin (n + 1))) :
    X.toLegacySSetObjEquiv _ s (Poincare.Topology.coordinateSimplexHomeomorph _ z) =
      (s.down : SimplexCategory.toTop.{u}.obj ⦋n⦌ ⟶ X).hom (ULift.up z) := by
  change (s.down : SimplexCategory.toTop.{u}.obj ⦋n⦌ ⟶ X).hom
    (ULift.up ((Poincare.Topology.coordinateSimplexHomeomorph _).symm
      (Poincare.Topology.coordinateSimplexHomeomorph _ z))) = _
  rw [Homeomorph.symm_apply_apply]

/-- Transport a homotopy on coordinate simplices back to the singular functor's domain. -/
def liftLegacyHomotopy {X : TopCat.{u}} {n : ℕ}
    {s t : toSSet.obj X _⦋n⦌}
    (H : ContinuousMap.Homotopy (X.toLegacySSetObjEquiv _ s)
      (X.toLegacySSetObjEquiv _ t)) : TopCat.Homotopy s.down t.down :=
  (H.compContinuousMap
    ⟨(Poincare.Topology.coordinateSimplexHomeomorph _) ∘ Homeomorph.ulift,
      (Poincare.Topology.coordinateSimplexHomeomorph _).continuous.comp
        Homeomorph.ulift.continuous⟩).cast
    (by ext z; exact toLegacySSetObjEquiv_coordinate s z.down)
    (by ext z; exact toLegacySSetObjEquiv_coordinate t z.down)

@[simp] theorem liftLegacyHomotopy_apply {X : TopCat.{u}} {n : ℕ}
    {s t : toSSet.obj X _⦋n⦌}
    (H : ContinuousMap.Homotopy (X.toLegacySSetObjEquiv _ s)
      (X.toLegacySSetObjEquiv _ t))
    (a : unitInterval) (z : SimplexCategory.toTop.{u}.obj ⦋n⦌) :
    liftLegacyHomotopy H (a,z) =
      H (a, Poincare.Topology.coordinateSimplexHomeomorph _ z.down) := rfl

@[simp] theorem toLegacySSetObjEquiv_identity (n : ℕ)
    (z : stdSimplex ℝ (Fin (n + 1))) :
    (SimplexCategory.toTop.{u}.obj ⦋n⦌).toLegacySSetObjEquiv _
      (⟨𝟙 _⟩ : toSSet.obj (SimplexCategory.toTop.{u}.obj ⦋n⦌) _⦋n⦌) z =
      ULift.up ((Poincare.Topology.coordinateSimplexHomeomorph _).symm z) := rfl

/-- Evaluation of a zero simplex is independent of simplex coordinates. -/
theorem toSSetObj₀Equiv_eq_legacy {X : TopCat.{u}}
    (x : toSSet.obj X _⦋0⦌) (z : stdSimplex ℝ (Fin 1)) :
    toSSetObj₀Equiv x = X.toLegacySSetObjEquiv _ x z := by
  change X.toSSetObjEquiv _ x default =
    X.toSSetObjEquiv _ x ((Poincare.Topology.coordinateSimplexHomeomorph _).symm z)
  exact congrArg (X.toSSetObjEquiv _ x) (Subsingleton.elim _ _)

end TopCat
