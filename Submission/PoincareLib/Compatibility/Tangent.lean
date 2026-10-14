import Mathlib.Geometry.Manifold.MFDeriv.NormedSpace

/-! # Identity-model derivative compatibility

Mathlib records the canonical identifications of tangent spaces explicitly in
manifold derivatives. This helper expresses the same derivative on normed spaces
as a continuous linear map between their underlying model spaces.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

open scoped Manifold

namespace Poincare.Compatibility

variable {𝕜 : Type*} [NontriviallyNormedField 𝕜]
  {E F : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
  [NormedAddCommGroup F] [NormedSpace 𝕜 F]

/-- On normed spaces with identity models, the manifold derivative is the usual derivative,
when read as a map between the model spaces. -/
theorem mfderiv_eq_fderiv_model {f : E → F} {x : E} :
    (mfderiv 𝓘(𝕜, E) 𝓘(𝕜, F) f x : E →L[𝕜] F) = fderiv 𝕜 f x := by
  ext v
  simp only [mfderiv_eq_fderiv, ContinuousLinearMap.comp_apply]
  rfl

/-- The corresponding formula for derivatives within a subset of a normed space. -/
theorem mfderivWithin_eq_fderivWithin_model {f : E → F} {s : Set E} {x : E} :
    (mfderivWithin 𝓘(𝕜, E) 𝓘(𝕜, F) f s x : E →L[𝕜] F) =
      fderivWithin 𝕜 f s x := by
  ext v
  simp only [mfderivWithin_eq_fderivWithin, ContinuousLinearMap.comp_apply]
  rfl

/-- The normed-space-valued manifold derivative, read on its underlying model space. -/
theorem mvfderiv_eq_fderiv_model {f : E → F} {x : E} :
    (mvfderiv 𝓘(𝕜, E) f x : E →L[𝕜] F) = fderiv 𝕜 f x := by
  ext v
  simp only [mvfderiv_eq_fderiv, ContinuousLinearMap.comp_apply]
  rfl

end Poincare.Compatibility
