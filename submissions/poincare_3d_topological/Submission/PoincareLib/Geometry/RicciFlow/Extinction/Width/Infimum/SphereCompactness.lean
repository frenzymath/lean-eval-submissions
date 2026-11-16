import Submission.PoincareLib.Geometry.Riemannian.LoopSpace.Width

/-!
# Compactness of the width parameter sphere

Morgan--Tian Definition 18.17, printed p. 430, takes the maximum over the
nonempty compact two-sphere. These instances use the contract's norm-one
subtype and its existing topology.
-/

set_option autoImplicit false

namespace PoincareMT.Proofs.M61

/-- The parameter sphere of Definition 18.17, p. 430, is compact. -/
instance loopTwoSphereCompactSpace : CompactSpace LoopTwoSphere := by
  let e : (Metric.sphere (0 : LoopAmbient) 1) ≃ₜ LoopTwoSphere :=
    Homeomorph.setCongr (show Metric.sphere (0 : LoopAmbient) 1 =
      {z : LoopAmbient | ‖z‖ = 1} by
        ext z
        simp only [Metric.mem_sphere, dist_zero_right, Set.mem_setOf_eq])
  exact e.compactSpace

/-- A unit coordinate vector inhabits the sphere of Definition 18.17, p. 430. -/
instance loopTwoSphereNonempty : Nonempty LoopTwoSphere :=
  ⟨⟨EuclideanSpace.basisFun (Fin 3) ℝ 0,
    (EuclideanSpace.basisFun (Fin 3) ℝ).norm_eq_one 0⟩⟩

end PoincareMT.Proofs.M61
