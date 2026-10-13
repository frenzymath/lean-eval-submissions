import Submission.PoincareLib.Geometry.RicciFlow.Generalized.Gauge.Providers
import Submission.PoincareLib.Geometry.RicciFlow.Rescaling.Generalized

/-! Compatibility names used by the unchanged Mapher generalized L-geometry
proof.  The metric and gauge services are supplied by the Gauge subject module;
this module retains only the downstream rescaling consumer. -/

set_option autoImplicit false

open scoped Manifold ContDiff Bundle

universe u

namespace PoincareMT

theorem generalizedParabolicRescaling_from_M12 (n : ℕ) :
    GeneralizedParabolicRescalingTheory.{u} n :=
  generalizedParabolicRescaling n (generalizedRicciGaugeGeometry_from_M03_M04_M11 n)

end PoincareMT
