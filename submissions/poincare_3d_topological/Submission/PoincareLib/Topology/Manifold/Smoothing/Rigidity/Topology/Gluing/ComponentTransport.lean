import Submission.PoincareLib.Compatibility.FundamentalGroup
import Submission.PoincareLib.AlgebraicTopology.FundamentalGroup.Transport.Based
import Submission.PoincareLib.AlgebraicTopology.FundamentalGroup.PathMaps

/-!
# Faithful transport over all path components

One loop group is retained for each path component. Existing based
transport supplies the square identities, and its coordinate on the
component of a loop detects the complete homotopy class of that loop.
-/

set_option autoImplicit false

open Set
open scoped unitInterval FundamentalGroup

namespace PoincareMT.M76.IncompressibleGluing

variable {X : Type*} [TopologicalSpace X]

open Path.Homotopic.Quotient

/-- Conjugation by a path, with opposite groups recording the order of
path concatenation. -/
noncomputable def pathConjugation {b x : X} (t : Path.Homotopic.Quotient b x) :
    (FundamentalGroup X x)ᵐᵒᵖ ≃* (FundamentalGroup X b)ᵐᵒᵖ where
  toFun q := MulOpposite.op (FundamentalGroup.fromPath
    (t.trans ((MulOpposite.unop q).toPath.trans t.symm)))
  invFun q := MulOpposite.op (FundamentalGroup.fromPath
    (t.symm.trans ((MulOpposite.unop q).toPath.trans t)))
  left_inv q := by
    apply MulOpposite.unop_injective
    apply CategoryTheory.End.ext
    change t.symm.trans ((t.trans ((MulOpposite.unop q).toPath.trans t.symm)).trans t) = _
    simp only [trans_assoc, symm_trans_assoc, symm_trans, trans_refl]
  right_inv q := by
    apply MulOpposite.unop_injective
    apply CategoryTheory.End.ext
    change t.trans ((t.symm.trans ((MulOpposite.unop q).toPath.trans t)).trans t.symm) = _
    simp only [trans_assoc, trans_symm_assoc, trans_symm, trans_refl]
  map_mul' p q := by
    apply MulOpposite.unop_injective
    apply CategoryTheory.End.ext
    change t.trans (((MulOpposite.unop p).toPath.trans (MulOpposite.unop q).toPath).trans t.symm) =
      (t.trans ((MulOpposite.unop p).toPath.trans t.symm)).trans
        (t.trans ((MulOpposite.unop q).toPath.trans t.symm))
    simp only [trans_assoc, symm_trans_assoc]

/-- A representative loop group for a path component, with concatenation
in forward order. -/
abbrev ComponentGroup (X : Type*) [TopologicalSpace X] (c : ZerothHomotopy X) :=
  (FundamentalGroup X c.out)ᵐᵒᵖ

theorem joined_component_out_iff (c : ZerothHomotopy X) (x : X) :
    Joined c.out x ↔ c = ZerothHomotopy.mk x := by
  constructor
  · intro h
    exact (Quotient.out_eq' c).symm.trans (Quotient.sound h)
  · intro h
    exact Quotient.exact ((Quotient.out_eq' c).trans h)

/-- Chosen paths from a component representative. -/
noncomputable def componentTails (c : ZerothHomotopy X) (x : X)
    (h : Joined c.out x) : Path.Homotopic.Quotient c.out x := mk h.somePath

/-- Transport has one coordinate for every path component. -/
noncomputable def componentTransport (p : C(unitInterval, X)) :
    ∀ c : ZerothHomotopy X, ComponentGroup X c :=
  fun c => basedContinuousTransport c.out (componentTails c) p

@[simp] theorem componentTransport_const (x : X) :
    componentTransport (ContinuousMap.const unitInterval x) = 1 := by
  funext c
  exact basedContinuousTransport_const c.out (componentTails c) x

/-- Only the component of the path can have nontrivial transport. -/
theorem componentTransport_eq_one_of_ne (p : C(unitInterval, X))
    (c : ZerothHomotopy X) (hc : c ≠ ZerothHomotopy.mk (p 0)) :
    componentTransport p c = 1 := by
  exact basedTransport_of_not_joined c.out (componentTails c) (mk p.toPath)
    (fun h => hc ((joined_component_out_iff c (p 0)).mp h))

/-- Component transport satisfies the square identity without any
connectedness assumption on the space. -/
theorem componentTransport_square (S : C(unitInterval × unitInterval, X)) :
    componentTransport (S.horizontalPath 0) * componentTransport (S.verticalPath 1) =
      componentTransport (S.verticalPath 0) * componentTransport (S.horizontalPath 1) := by
  funext c
  exact basedContinuousTransport_square c.out (componentTails c) S

/-- The homomorphism on loop classes induced by component transport. -/
noncomputable def componentLoopTransport (x : X) :
    (FundamentalGroup X x)ᵐᵒᵖ →* (∀ c : ZerothHomotopy X, ComponentGroup X c) where
  toFun q c := basedTransport c.out (componentTails c) (MulOpposite.unop q).toPath
  map_one' := by
    funext c
    exact basedTransport_refl c.out (componentTails c) x
  map_mul' p q := by
    funext c
    exact basedTransport_trans c.out (componentTails c)
      (MulOpposite.unop p).toPath (MulOpposite.unop q).toPath

@[simp] theorem componentLoopTransport_mk (x : X) (p : Path x x) :
    componentLoopTransport x (MulOpposite.op (mk p)) =
      componentTransport p.toContinuousMap := by
  funext c
  exact (basedContinuousTransport_path c.out (componentTails c) p).symm

/-- Component transport is faithful on loops at every basepoint. -/
theorem componentLoopTransport_injective (x : X) :
    Function.Injective (componentLoopTransport x) := by
  let c := ZerothHomotopy.mk x
  have hx : Joined c.out x := (joined_component_out_iff c x).mpr rfl
  intro p q hpq
  have heq := congrFun hpq c
  change basedTransport c.out (componentTails c) (MulOpposite.unop p).toPath =
    basedTransport c.out (componentTails c) (MulOpposite.unop q).toPath at heq
  rw [basedTransport_of_joined _ _ _ hx hx,
    basedTransport_of_joined _ _ _ hx hx] at heq
  exact (pathConjugation (componentTails c x hx)).injective heq

end PoincareMT.M76.IncompressibleGluing
