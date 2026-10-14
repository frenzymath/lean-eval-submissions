import Submission.PoincareLib.Geometry.RicciFlow.Generalized.DenseTime
import Submission.PoincareLib.Geometry.RicciFlow.Generalized.BoundedDistance.DenseTheory
import Submission.PoincareLib.Topology.Manifold.NeckCap.Theory

/- The source's current dense service has an older same-named declaration in
the workspace. Preserve source proof text through this import compatibility. -/
namespace PoincareMT.BoundedDistanceSource

scoped macro "RepairedBoundedDistanceTheory" ".{" u:level "}" : term =>
  `(PoincareMT.DenseTime.BoundedDistanceTheory.{$u})

end PoincareMT.BoundedDistanceSource
