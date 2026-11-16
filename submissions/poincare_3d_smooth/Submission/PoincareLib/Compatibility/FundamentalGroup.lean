module

public import Mathlib.AlgebraicTopology.FundamentalGroupoid.FundamentalGroup

public section

/-! Representatives for the stable Mathlib fundamental-group wrapper. -/

namespace FundamentalGroup

variable {X : Type*} [TopologicalSpace X] {x : X}

/-- Every element of the based fundamental group has a loop representative. -/
theorem exists_path_rep (a : FundamentalGroup X x) :
    ∃ p : Path x x, fromPath ⟦p⟧ = a := by
  rcases a with ⟨a⟩
  obtain ⟨p, rfl⟩ := Path.Homotopic.Quotient.mk_surjective a
  exact ⟨p, rfl⟩

/-- Eliminate a based fundamental-group element using a representative loop. -/
@[elab_as_elim] theorem path_ind {motive : FundamentalGroup X x → Prop}
    (mk : ∀ p : Path x x, motive (fromPath ⟦p⟧)) (a : FundamentalGroup X x) : motive a := by
  obtain ⟨p, rfl⟩ := exists_path_rep a
  exact mk p

/-- A represented loop is the identity exactly when it is nullhomotopic. -/
theorem fromPath_eq_one_iff (p : Path x x) :
    fromPath ⟦p⟧ = 1 ↔ p.Homotopic (Path.refl x) := by
  constructor
  · intro h
    exact Quotient.exact (congrArg toPath h)
  · intro h
    exact CategoryTheory.End.ext (Quotient.sound h)

scoped instance : Coe (Path.Homotopic.Quotient x x) (FundamentalGroup X x) := ⟨fromPath⟩
scoped instance : Coe (FundamentalGroup X x) (Path.Homotopic.Quotient x x) := ⟨toPath⟩

end FundamentalGroup
