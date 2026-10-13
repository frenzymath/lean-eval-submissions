import Submission.PoincareLib.Geometry.RicciFlow.Surgery.Induction.NoncollapseTheory
import Submission.PoincareLib.Geometry.RicciFlow.Surgery.Induction.NoncollapseData
import Submission.PoincareLib.Geometry.RicciFlow.Generalized.Noncollapse.Theory
import Submission.PoincareLib.Geometry.RicciFlow.Curvature.Theory
import Submission.PoincareLib.Geometry.Spacetime.GeometryTheory
import Submission.PoincareLib.Geometry.RicciFlow.Generalized.Gauge.Geometry
import Submission.PoincareLib.Geometry.RicciFlow.Rescaling.Theory
import Submission.PoincareLib.Geometry.RicciFlow.Generalized.ReducedGeometry.Theory
import Submission.PoincareLib.Geometry.RicciFlow.Surgery.Continuation.RegularHistory

/-!
# M46 repaired noncollapsing induction statement

The selected calibrated setup admits the noncollapsing extension at every
finite parameter prefix with the same initial seeds.
-/

set_option autoImplicit false

open scoped Manifold ContDiff Bundle ENNReal Topology

universe u

namespace PoincareMT

structure M46Predecessors : Prop where
  m04 : RicciFlowCurvatureTheory.{u}
  m11 : GeneralizedSpacetimeGeometryTheory.{u} 3
  m12 : GeneralizedRicciGaugeTheory.{u} 3
  m13 : GeneralizedParabolicRescalingTheory.{u} 3
  m14 : GeneralizedLGeometryTheory.{u} 3
  m15 : GeneralizedNoncollapsingConclusion.{u} 3
  regular_history : ∀ (F : SurgeryFlowData.{u}) (W : M33RegularHistoryWindow F),
    Nonempty (M33RegularHistoryData W)

end PoincareMT
