import Submission.PoincareLib.Topology.Manifold.Smoothing.Rigidity.Isotopy.Mathlib.HomotopyFundamentalGroup

/-! A homotopy preserves injectivity of the actual based group map. -/

set_option autoImplicit false
open CategoryTheory

namespace FundamentalGroup

theorem map_injective_of_homotopy
    {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    {f g : C(X, Y)} (H : f.Homotopy g) (x : X)
    (hf : Function.Injective (map f x)) : Function.Injective (map g x) := by
  let T := FundamentalGroupoidFunctor.homotopicMapsNatIso H
  intro a b hab
  apply hf
  apply CategoryTheory.End.ext
  have hab := congrArg CategoryTheory.End.asHom hab
  change (FundamentalGroupoid.map f).map a.asHom = (FundamentalGroupoid.map f).map b.asHom
  apply (cancel_mono (T.app ⟨x⟩)).mp
  rw [T.naturality, T.naturality]
  exact congrArg (fun u => T.app ⟨x⟩ ≫ u) hab

end FundamentalGroup
