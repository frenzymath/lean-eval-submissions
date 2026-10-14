import Mathlib
import Lake.Toml
import Lake.Util.Message
import Lean
import Submission.Helpers
import Submission.PoincareLib.Topology.Manifold.Poincare

-- Keep the benchmark's canonical subtype topology when this module is imported.
-- The gluing alias is definitionally equal but changes the exported statement.
attribute [instance 1100] instTopologicalSpaceSubtype

open Metric (sphere)

namespace Submission

theorem poincare_3d_topological {M : Type*} [TopologicalSpace M] [T2Space M]
    [ChartedSpace (EuclideanSpace ℝ (Fin 3)) M]
    [SimplyConnectedSpace M] [CompactSpace M] :
    Nonempty (M ≃ₜ sphere (0 : EuclideanSpace ℝ (Fin 4)) 1) := by
  letI : SecondCountableTopology M :=
    ChartedSpace.secondCountable_of_sigmaCompact (EuclideanSpace ℝ (Fin 3)) M
  exact PoincareMT.topologicalPoincareSkeleton M

end Submission
