# Independent review of ninth-build root repairs

All four changes preserve mathematical formulas, canonical structures, assumptions and conclusions. No new axioms or admissions and no semantic weakening. TensorTransport statement adds only an explicit type argument already forced by context.

Read complete four diffs against repository HEAD and surrounding formulas. Read Mathlib multiplication, ULift module and ContMDiffSection operation definitions. Read final stable StateApprox source after root direct recheck11523 PASS. No source edits or compilation during review.

Baseline commit: `d85511909ae9f950df6c84a8ddf8f10c8311f861`.

## MixedMetricPotential

Current MemLp.fun_mul is coefficient-first. Reversing the old mul' call proves the same H(p) * xi(p)^2 integrand. Measures, exponents, support, constants, theorem signature and energy estimate unchanged.

Baseline SHA256: `bcfe912dfa2ff2ae79244727b41398506cb75a1935870d8ae5f409a50388faa8`.
Current source SHA256: `e79d2c1429caaee9898d7971851c78f5d8a74ea135dcbbdf4b7521268b6dd39c`.

## TensorTransport

Explicit innerSL output domain is EuclideanSpace Real (Fin 3), already forced by g0.euclideanCoefficients. Metric normalization equality, tensor derivatives, chart transport and theorem conditions unchanged; only inference annotation changes the source statement syntax.

Baseline SHA256: `e17ca5cb437c746467c5548e45b31ad1e4679327021f4a252938bd685777cd1e`.
Current source SHA256: `a94a29b58b218b88a3fac321747becf76fd556c392c259825ab160ea93e997c9`.

## OriginalModelSphereBound

Explicit ModuleCat.of supplies the canonical ULift.module' from Mathlib Algebra/Module/ULift. Carrier remains ULift (ZMod 2); scalar action is the canonical action transported by down/up. Same homology coefficients, nonexceptional classes, incidence count and final rank bound; no theorem signature change.

Baseline SHA256: `eff6878ce9b1f8b8ee6c13169cb235cc8f4d1668ae9d4a624e652970049fc87b`.
Current source SHA256: `b8b7be368caff72692eab53b7a75a2f77dbc72575246f24e4d668089debff83f`.

## DeTurckStateApproximation

New dual ContinuousAdd is obtained by infer_instance, bilinear IsTopologicalAddGroup is the canonical ContinuousLinearMap instance, and section Add/SMul are exactly ContMDiffSection.instAdd/instSMul. Mathlib definitions show both are pointwise operations. No norms or tangent-space norm attributes introduced. All original declarations/bodies unchanged apart from removing the defeq transparency override and adding local instance choices. Symmetric decoding remains one half of h plus its transpose; native approximation, derivative tuples and output identities retained.

Baseline SHA256: `35e5ae4e13adb604e5f05ee49fca581d88c6be3df27aa043913309e187a0455c`.
Current source SHA256: `9cb1733827942a4bd10ab94c9546f913940185b07ecadd55806c6ec4fefcca32`.

No compilation was duplicated. Root supplied direct checks; full integration remains its responsibility.
