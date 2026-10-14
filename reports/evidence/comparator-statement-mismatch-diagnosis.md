# Comparator statement mismatch diagnosis

The official topological attempt `20261014-011327-3654638` failed at Comparator's initial statement comparison, before Nanoda/kernel verification. Repair and official retest remain pending.

Comparator uses exported `ConstantVal` equality (name, universe parameters, and `Expr.eqv` type equality), not Lean definitional equality. It ignores binder names/annotations and exported metadata, but does not unfold aliases. The complete type dumps differ at the sphere codomain topology: Challenge uses Mathlib's `instTopologicalSpaceSubtype`, while Solution uses `Poincare.Gluing.pieceTopologicalSpace`. That helper instance is a definitional alias of the same canonical subtype topology. An isolated scratch proof of equality with the explicit canonical instance passed by `rfl`; no mathematical statement strengthening was identified.

The endpoint `attribute [-instance]` is conservative within its file but is not exported to importing modules in pinned Lean: instance erasure changes scoped state, while module export serializes added entries only. It cannot by itself guarantee Solution's canonical type. Exporting a higher-priority registration of the existing Mathlib canonical subtype instance is a conservative alternative that leaves existing helper proof terms untouched; localizing the original helper instance requires rebuilding its affected cache. Either fix still needs exact type comparison and the official verifier retest. No trusted Challenge/Solution or Comparator edits are proposed.

The bundled type logs and JSON receipt bind the diagnosis to exact source hashes. Their status is evidence of a failed statement check, not verifier acceptance.

The final endpoint patch now uses `attribute [instance 1100] instTopologicalSpaceSubtype` in both editable Submission roots. This adds a global entry that is serialized and registered on import, and its priority exceeds the helper alias default. It names the existing canonical Mathlib constant and changes no proof term or constant body. Exact imported type equality and official acceptance remain pending. The earlier erasure was confirmed insufficient by an imported Solution type dump unchanged from the failed version.

Topological resolution: the final priority registration passed the unchanged official Comparator, Nanoda and Lean default kernel in attempt `20261014-013145-3658528`. This supersedes the earlier pending topological retest status; the failed attempt remains historical diagnosis evidence. Smooth official verification is still pending.
