import Submission.PoincareLib.Topology.Manifold.Poincare.Final.Main

open scoped Manifold ContDiff

/-!
# Smooth and topological Poincare theorems

Imported from `PoincareMT/Proofs/Main.lean` at
`a27691488baa6c690f50afc23376abb51abd2f9c`, preserving both endpoint statements
and proof terms. The smooth branch applies M75 directly; the topological
branch projects the final package. Neither endpoint has a predecessor-package
argument. Recursive dependency verification is performed by
`scripts/check_poincare_endpoints.lean`.
-/

set_option autoImplicit false

universe u

namespace PoincareMT

/-- Every compact Hausdorff second-countable simply connected smooth
three-manifold is diffeomorphic to the standard three-sphere. Source:
Morgan--Tian Corollary 0.2(a), assembled through the numbered skeleton. -/
theorem smoothPoincareSkeleton : SmoothPoincare.{u} := by
  exact m75SmoothPoincare m90SmoothEndpointInputs

/-- Every compact Hausdorff second-countable simply connected topological
three-manifold is homeomorphic to the standard three-sphere. Apply smooth
Poincare through M76's compatible smoothing and the checked M77--M90 route;
no smoothness hypothesis is imposed on the original manifold. -/
theorem topologicalPoincareSkeleton : TopologicalPoincare.{u} := by
  obtain ⟨C⟩ := m90FinalAssemblyFromMilestones.{u}
  exact C.topological

/-- Lean Eval smooth endpoint with second countability derived locally from
the compact charted-space assumptions. -/
theorem poincare_3d_smooth :
    ∀ (M : Type u) [TopologicalSpace M] [T2Space M]
      [ChartedSpace (EuclideanSpace ℝ (Fin 3)) M]
      [IsManifold (𝓡 3) ∞ M] [CompactSpace M] [SimplyConnectedSpace M],
      Nonempty (Diffeomorph (𝓡 3) (𝓡 3) M ThreeSphere ∞) := by
  intro M _ _ _ _ _ _
  letI : SecondCountableTopology M :=
    ChartedSpace.secondCountable_of_sigmaCompact (EuclideanSpace ℝ (Fin 3)) M
  exact smoothPoincareSkeleton M

/-- Lean Eval topological endpoint with second countability derived locally
from the compact charted-space assumptions. -/
theorem poincare_3d_topological :
    ∀ (M : Type u) [TopologicalSpace M] [T2Space M]
      [ChartedSpace (EuclideanSpace ℝ (Fin 3)) M]
      [CompactSpace M] [SimplyConnectedSpace M],
      Nonempty (M ≃ₜ ThreeSphere) := by
  intro M _ _ _ _ _
  letI : SecondCountableTopology M :=
    ChartedSpace.secondCountable_of_sigmaCompact (EuclideanSpace ℝ (Fin 3)) M
  exact topologicalPoincareSkeleton M

end PoincareMT
