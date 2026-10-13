import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.Corners.DimensionInduction
import Submission.PoincareLib.Geometry.Riemannian.Curvature.Basic
import Submission.PoincareLib.Geometry.Curvature.Integral.ThreeDimensional
import Submission.PoincareLib.Geometry.Curvature.Integral.Reduction.Product
import Submission.PoincareLib.Geometry.Riemannian.Measure.Basic
import Submission.PoincareLib.Geometry.RicciFlow.Harnack.Basic
import Submission.PoincareLib.Geometry.Curvature.Integral.AreaEstimates
import Submission.PoincareLib.Geometry.Curvature.Integral.Compactness
import Submission.PoincareLib.Geometry.Curvature.Integral.Rescaling
import Submission.PoincareLib.Geometry.Curvature.Integral.Bochner
import Submission.PoincareLib.Geometry.Curvature.Integral.Hypersurface
import Submission.PoincareLib.Geometry.Curvature.Integral.LevelCutoff
import Submission.PoincareLib.Geometry.Curvature.Integral.RegularLevelScalar
import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.RegularLevels
import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.Sectional
import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.MeanCurvature
import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.Boundary
import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.LevelScalar
import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.SlabError
import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.Annulus
import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.LimitSlabs
import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.AreaSlabs
import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.PointedScalarAnnuli
import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.Corners.Regularity
import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.Corners.Fiber
import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.Corners.Projection
import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.Corners.RestrictedGradient
import Submission.PoincareLib.Geometry.Curvature.Integral.Induction.Corners.Hessian
import Submission.PoincareLib.Geometry.Riemannian.Metric.Induced.RegularFiber
import Submission.PoincareLib.Geometry.Riemannian.Normalization.Scaling.Gradient
import Submission.PoincareLib.Geometry.Riemannian.Comparison.Hessian.Distance
import Submission.PoincareLib.Geometry.Riemannian.Comparison.Hessian.Semiconcavity
import Submission.PoincareLib.Geometry.Riemannian.Distance.Smoothing.Intrinsic
import Submission.PoincareLib.Geometry.Riemannian.Distance.Smoothing.Patching
import Submission.PoincareLib.Geometry.Riemannian.Distance.Smoothing.CompactDistance
import Submission.PoincareLib.Geometry.Riemannian.Distance.Smoothing.Directional.RegularSlab
import Submission.PoincareLib.Geometry.Riemannian.Distance.Smoothing.Directional.Radial
import Submission.PoincareLib.Geometry.Riemannian.Distance.Smoothing.Directional.Ascent
import Submission.PoincareLib.Geometry.Riemannian.Distance.Smoothing.Directional.AscentStability
import Submission.PoincareLib.Analysis.Convex.Semiconcavity.Approximation
import Submission.PoincareLib.Analysis.InnerProductSpace.AlmostOpposite
import Submission.PoincareLib.Analysis.Approximation.Convolution.Directional
import Submission.PoincareLib.Geometry.Alexandrov.Applications.Counterexamples
import Submission.PoincareLib.Geometry.Riemannian.Coordinates.Exponential.Gauss.Bounds
import Submission.PoincareLib.Geometry.Curvature.Integral.Concentration.Blowup
import Submission.PoincareLib.Geometry.Curvature.Integral.Concentration.LimitPacking
import Submission.PoincareLib.Geometry.Curvature.Integral.Concentration.LimitSlabs
import Submission.PoincareLib.Geometry.Curvature.Integral.Concentration.AreaSlabs
import Submission.PoincareLib.Geometry.Curvature.Integral.Concentration.RegularRadius
import Submission.PoincareLib.Geometry.Curvature.Integral.Concentration.PuncturedCover
import Submission.PoincareLib.Geometry.Curvature.Integral.Concentration.Spire
import Submission.PoincareLib.Geometry.Curvature.Integral.Concentration.SpireRescaling
import Submission.PoincareLib.Geometry.Curvature.Integral.Concentration.VariableRescaling
import Submission.PoincareLib.Geometry.Curvature.Integral.Reduction.Counterexamples
import Submission.PoincareLib.Geometry.Curvature.Hypersurface.Scalar
import Submission.PoincareLib.Geometry.Riemannian.Measure.Coarea.HypersurfaceSlab
import Submission.PoincareLib.Geometry.Riemannian.Curvature.SectionalBounds

/-!
# The uniform scalar-curvature integral bound

Petrunin, Theorem 1.1, author manuscript p. 1. The estimate is proved in
every dimension. Dimensions at least four use the weighted corner induction
in `Integral.Induction.Corners.DimensionInduction`. The
three-dimensional case uses the intrinsic surface estimate and the
rank-increasing concentration argument in `Integral.ThreeDimensional`.
The two-dimensional case follows by adjoining a flat line and comparing
product-cylinder integrals in `Integral.Reduction.Product`.
The compactly supported hypersurface Bochner step is
proved in `Integral.Hypersurface` and `Integral.LevelCutoff`. The counterexample
sequence extraction is proved in `Integral.Compactness`, and the induced
scalar Gauss identity in `Hypersurface.Scalar`. `Integral.Induction.RegularLevels`
integrates the induced scalar identity, and `Integral.Concentration.Blowup`
constructs divergent scalar integrals on fixed rescaled unit balls.
`Integral.Reduction.Counterexamples` constructs these sequences from failure
of the original theorem, without a connectedness or universe restriction.
`Integral.Induction.Sectional` supplies the induced sectional lower bound
from the ambient bound and the normalized tangential Hessian estimate.
The `Boundary` and `SlabError` modules absorb the signed endpoint terms and
the integrated induced sectional error using actual level area variation.
`Alexandrov.Applications.Counterexamples` supplies the lower-curvature limit.
`Distance.Smoothing.CompactDistance` constructs smooth distance approximations
with intrinsic gradient and Hessian bounds on compact annuli.
`Distance.Smoothing.Directional.RegularSlab` constructs proper regular slabs
under a small metric-excess condition, retaining the approximation and
derivative bounds throughout their core annuli.
`Integral.Concentration.LimitPacking` retains finite angle packing in the
actual counterexample limit and constructs positive punctured ascent radii.
`Integral.Concentration.RegularRadius` constructs the corresponding radius
function and finite exceptional set on compact subsets. Source local-ascent
stability is uniform on compact limit annuli. `Integral.Induction.LimitSlabs`
constructs proper regular slabs in the approximating manifolds from their
sectional lower bound and proper geodesic pointed limit, with common value,
gradient and Hessian bounds. `Integral.Induction.AreaSlabs` constructs a
common power bound for the actual induced level areas from coarea, first
variation and volume comparison; the counterexample sequence retains it.
`Integral.Induction.PointedScalarAnnuli` applies the annular scalar estimate
to these constructed functions and a fixed ambient radial interval.
The weighted corner induction supplies the scalar estimates on the actual
induced level metrics. Concentration and strict growth of bounded angular
packing rank complete the rescaling contradiction.
-/

set_option autoImplicit false

open Set MeasureTheory
open scoped Manifold ContDiff Bundle ENNReal

universe u

namespace PoincareMT

/-- The zero-dimensional base case for Petrunin's dimension induction.

In dimension zero every tangent fiber is zero-dimensional, so the scalar
curvature trace vanishes pointwise.  We retain a strictly positive constant
because the uniform statement is phrased with a positive witness. -/
theorem exists_uniform_unitBall_scalar_integral_bound_zero :
    ∃ C : ℝ, 0 < C ∧
      ∀ (M : Type u) [TopologicalSpace M] [MeasurableSpace M] [BorelSpace M]
        [T3Space M] [ChartedSpace (EuclideanSpace ℝ (Fin 0)) M]
        [IsManifold (𝓡 0) ∞ M]
        (g : RiemannianMetric 0 M) (D : LeviCivitaData g),
        MetricComplete g →
        (∀ (x : M) (v w : TangentSpace (𝓡 0) x),
          -1 ≤ D.sectionalCurvature x v w) →
        ∀ p : M,
          (∫ x in g.ball p 1, D.scalarCurvature x ∂g.volumeMeasure) ≤ C := by
  refine ⟨1, by norm_num, ?_⟩
  intro M _ _ _ _ _ _ g D _ _ p
  have hscalar : ∀ x : M, D.scalarCurvature x = 0 := by
    intro x
    have hdim : Module.finrank ℝ (TangentSpace (𝓡 0) x) = 0 := by
      change Module.finrank ℝ (EuclideanSpace ℝ (Fin 0)) = 0
      simp
    have hcard : Fintype.card (Fin (Module.finrank ℝ (TangentSpace (𝓡 0) x))) = 0 := by
      rw [Fintype.card_fin, hdim]
    letI : IsEmpty (Fin (Module.finrank ℝ (TangentSpace (𝓡 0) x))) :=
      Fintype.card_eq_zero_iff.mp hcard
    unfold LeviCivitaData.scalarCurvature
    exact Fintype.sum_empty _
  simp only [hscalar, integral_zero]
  norm_num

/-- The one-dimensional base case for Petrunin's dimension induction.

The curvature tensor is alternating in its first two slots.  Since every
tangent fiber has rank one, the two slots in each Ricci summand are equal,
so the scalar curvature vanishes pointwise. -/
theorem exists_uniform_unitBall_scalar_integral_bound_one :
    ∃ C : ℝ, 0 < C ∧
      ∀ (M : Type u) [TopologicalSpace M] [MeasurableSpace M] [BorelSpace M]
        [T3Space M] [ChartedSpace (EuclideanSpace ℝ (Fin 1)) M]
        [IsManifold (𝓡 1) ∞ M]
        (g : RiemannianMetric 1 M) (D : LeviCivitaData g),
        MetricComplete g →
        (∀ (x : M) (v w : TangentSpace (𝓡 1) x),
          -1 ≤ D.sectionalCurvature x v w) →
        ∀ p : M,
          (∫ x in g.ball p 1, D.scalarCurvature x ∂g.volumeMeasure) ≤ C := by
  refine ⟨1, by norm_num, ?_⟩
  intro M _ _ _ _ _ _ g D _ _ p
  have hscalar : ∀ x : M, D.scalarCurvature x = 0 := by
    intro x
    have hdim : Module.finrank ℝ (TangentSpace (𝓡 1) x) = 1 := by
      change Module.finrank ℝ (EuclideanSpace ℝ (Fin 1)) = 1
      simp
    have hidx (i : Fin (Module.finrank ℝ (TangentSpace (𝓡 1) x))) : i.val = 0 := by
      have hi : i.val < 1 := by simpa [hdim] using i.isLt
      omega
    unfold LeviCivitaData.scalarCurvature
    simp only [LeviCivitaData.ricci]
    apply Finset.sum_eq_zero
    intro i hi
    apply Finset.sum_eq_zero
    intro j hj
    have hij : i = j := Fin.ext (by simp [hidx i, hidx j])
    simpa [hij] using D.curvatureTensor_zero_first x (g.orthonormalBasis x i)
      (g.orthonormalBasis x i) (g.orthonormalBasis x i)
  simp only [hscalar, integral_zero]
  norm_num

/-- Petrunin's dimension-uniform unit-ball scalar integral estimate.
The original geometric hypotheses hold in every dimension. -/
theorem exists_uniform_unitBall_scalar_integral_bound (n : ℕ) :
    ∃ C : ℝ, 0 < C ∧
      ∀ (M : Type u) [TopologicalSpace M] [MeasurableSpace M] [BorelSpace M]
        [T3Space M] [ChartedSpace (EuclideanSpace ℝ (Fin n)) M]
        [IsManifold (𝓡 n) ∞ M]
        (g : RiemannianMetric n M) (D : LeviCivitaData g),
        MetricComplete g →
        (∀ (x : M) (v w : TangentSpace (𝓡 n) x), -1 ≤ D.sectionalCurvature x v w) →
        ∀ p : M, (∫ x in g.ball p 1, D.scalarCurvature x ∂g.volumeMeasure) ≤ C := by
  cases n with
  | zero =>
      simpa using exists_uniform_unitBall_scalar_integral_bound_zero
  | succ n =>
      cases n with
      | zero =>
          simpa using exists_uniform_unitBall_scalar_integral_bound_one
      | succ n =>
          cases n with
          | zero => exact exists_uniform_unitBall_scalar_integral_bound_two
          | succ n =>
              cases n with
              | zero => exact exists_uniform_unitBall_scalar_integral_bound_three
              | succ n =>
                  exact exists_uniform_unitBall_scalar_integral_bound_of_three_le _ (by omega)

end PoincareMT
