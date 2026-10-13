import Submission.PoincareLib.Geometry.RicciFlow.Generalized.Gauge.Assembly
import Submission.PoincareLib.Geometry.Spacetime.Realization
import Submission.PoincareLib.Geometry.Riemannian.Curvature.IntrinsicCalculus
import Submission.PoincareLib.Geometry.Riemannian.Normalization.Connection.Existence
import Submission.PoincareLib.Geometry.Riemannian.Normalization.Connection.Regularity

/-!
# Generalized Ricci-gauge providers

The M12 metric inputs and the assembled generalized gauge theory belong to the
gauge subject layer.  The statements and proof bodies are preserved from the
source provider at `fbdf7e1493ed0566f4e74a287819fb3b0f765284`.

Sources: Morgan--Tian Theorem 1.2 and formula (1.1), pp. 3-4; Definition 1.4,
pp. 5-7; Definition 3.36 and Remark 3.37, pp. 60-61; Definition 14.7 and
Remark 14.9, pp. 348-349 for the within-interval endpoint convention.
-/

set_option autoImplicit false

open scoped Manifold ContDiff Bundle

universe u

namespace PoincareMT

theorem m12MetricPredecessors (n : ℕ) : M12MetricPredecessors.{u} n where
  connection_exists _ _ _ _ _ _ g := normalization_exists_leviCivitaData g
  connection_regular _ _ _ _ _g D _ hU Y hY :=
    D.normalization_contMDiffOn_connection hU Y hY
  curvature_calculus _ _ _ _ _g D := D.intrinsicCurvatureTensorCalculus

theorem generalizedRicciGaugeGeometry_from_M03_M04_M11 (n : ℕ) :
    GeneralizedRicciGaugeTheory.{u} n :=
  generalizedRicciGaugeGeometry n (generalizedSpacetimeGeometry n)
    (m12MetricPredecessors.{u} n) (m12MetricPredecessors.{0} n)

end PoincareMT
