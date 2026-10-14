import Submission.PoincareLib.Geometry.Riemannian.Metric

/-!
# Selected-metric extended distance

The first field of the frozen M06 interface follows directly from Mathlib's
induced extended metric. Both sides install the same selected metric; no
curvature theory or Harnack estimate is needed.

Source: `contracts/statements/ricci-flow/DifferentialHarnackAncientFlow.lean`,
`HarnackAncientTheory.metric_edist_transport`.
-/

set_option autoImplicit false

open scoped Manifold ContDiff Bundle

namespace Poincare.Geometry.RicciFlow.Harnack

open PoincareMT

theorem metric_edist_transport
    {n : ℕ} {M : Type*} [TopologicalSpace M]
    [ChartedSpace (EuclideanSpace ℝ (Fin n)) M]
    [IsManifold (𝓡 n) ∞ M] [T3Space M]
    (g : RiemannianMetric n M) (x y : M) :
    letI : Bundle.RiemannianBundle (TangentSpace (𝓡 n) : M → Type _) :=
      ⟨g.toRiemannianMetric⟩
    letI : IsContinuousRiemannianBundle (EuclideanSpace ℝ (Fin n))
        (TangentSpace (𝓡 n) : M → Type _) :=
      ⟨⟨g.inner, g.toContinuousRiemannianMetric.continuous, fun _ _ _ ↦ rfl⟩⟩
    letI : EMetricSpace M := EMetricSpace.ofRiemannianMetric (𝓡 n) M
    edist x y = g.edist x y := by
  rfl

end Poincare.Geometry.RicciFlow.Harnack
