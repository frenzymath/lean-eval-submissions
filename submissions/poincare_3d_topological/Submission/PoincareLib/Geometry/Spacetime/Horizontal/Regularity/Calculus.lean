import Submission.PoincareLib.Geometry.Spacetime.Horizontal.Assembly
import Submission.PoincareLib.Geometry.Spacetime.Horizontal.Regularity.Trace
import Submission.PoincareLib.Geometry.Spacetime.Horizontal.Regularity.Norm
import Submission.PoincareLib.Geometry.RicciFlow.Generalized.Gauge.Cover

/-!
# Horizontal Ricci calculus from an adapted cover

Assemble the joint curvature regularity of the retained leafwise connection,
including at interval endpoints, independently of coordinate Christoffel helpers.

Source: Morgan-Tian, Definition 1.4, pp. 5-7, and Definitions 3.34-3.38,
pp. 59-61.
-/

set_option autoImplicit false
set_option synthInstance.maxHeartbeats 100000
set_option maxSynthPendingDepth 12

open scoped Manifold ContDiff Bundle Topology

universe u

namespace PoincareMT

variable {n : ℕ} {X : Type u} [TopologicalSpace X] {time : X → ℝ}
  {I : SpacetimeInterval} {F : GeneralizedFlowSpacetime n X time I}
  {S : ∀ t : ℝ, SpacetimeSliceGeometry F t}

/-- The original-data regularity producer consumed by M12's horizontal calculus.

The five fields are exactly the inputs of
`horizontalRicciCalculus_of_joint_regularity`; no stronger calculus structure
or jointly smooth connection family is assumed by this interface.
-/
theorem horizontalRicciCalculus_of_adapted_cover
    (hMetric : M12MetricPredecessors.{u} n)
    (hCoordinates : M12MetricPredecessors.{0} n)
    (D : LeafwiseLeviCivitaFamily F S)
    (T : SpacetimeIntervalSystem)
    (cover : SpacetimeGaugeCover F T) :
    HorizontalRicciCalculus D := by
  have hR := horizontalRiemann_tensor hMetric hCoordinates D cover
  have hRic := horizontalRicci_tensor_of_riemann D hR
  exact horizontalRicciCalculus_of_curvature_regularity hMetric hCoordinates D cover
    hR hRic (horizontalScalarCurvature_smooth_of_ricci D hRic)
    (horizontalCurvatureNormSq_smooth_of_riemann D hR)

end PoincareMT
