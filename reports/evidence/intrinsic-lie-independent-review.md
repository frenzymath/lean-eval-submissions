# Independent review: IntrinsicLieMetric migration

Reviewed the complete diff relative to the worktree baseline. Accepted: no mathematical statement, hypothesis, coefficient, sign, field or formula change.

`smoothRicciDeTurckTensor` formerly used smooth-section scalar multiplication/addition. Those operations in pinned Mathlib are pointwise (`ContMDiffSection.coe_smul` and `coe_add` are rfl), with a smoothness proof attached. `smoothRicciTensor D` has underlying field `intrinsicRicciBilin D`; `smoothMetricLieDerivative` has underlying field `metricLieDerivative`. The new constructor therefore has the exact same underlying field at every point. It supplies smoothness from the existing proved local Ricci pairings and Lie pairings; there is no assumed certificate, extra regularity hypothesis or mathematical gap.

A scratch copy of the entire edited file plus an `example` proves by **rfl** that the new tensor at x equals `(-2 : ℝ) • smoothRicciTensor D x + smoothMetricLieDerivative D (intrinsicDeTurckField D B) (intrinsicDeTurckField_contMDiffAt D B) x`. This independently passed on the exact pinned compiler/cache; log `intrinsic-lie-review-probe.log`, receipt `intrinsic-lie-independent-review.json`. This formal check avoids the obsolete bundled-operation inference path while proving definitional equality of its field. The public application theorem still states exactly `-2 * D.ricci + metricLieDerivative`.

All declaration signatures unchanged; no admissions, axioms, opaque substitutions or assumptions added. Removal of backward-defeq transparency option changes elaboration only. No source edits were made by the reviewer.
