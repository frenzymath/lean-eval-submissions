# Independent LowerTerm review

PASS: private bilinear extraction and API order adaptations preserve formulas, Holder exponents, domain, endpoint statement and assumptions. No new admission or axiom.

Independent read-only diff and full source review, checked actual suAlphaLowerTerm definition and current Mathlib MemLp multiplication/scalar order; no duplicate compilation.

Public suWeakAlphaLowerTerm definition and SUInitialGain.alpha_lowerTerm_memLp statement are byte-identical to baseline. No added endpoint hypotheses or weaker exponent/domain.

Private generic helper first evaluates B(x) on v(x) using L-infinity times Lp to obtain Lp, then evaluates the resulting linear map on the same v(x) using HolderTriple p p q. Instantiations retain p=16,q=8 for B(v_i,v_i), and p=8,q=4 for Gamma(v_i,v_i). Output vectors/scalars and argument order match the original proof exactly.

Q, d=lambda+Q, dl, actual metric coefficients B, Christoffel coefficient Gamma, coefficient derivatives, positivity bounds and inverse denominator bound are unchanged. Cubic derivative estimates keep 32×32→16 then 16×16→8.

Current fun_mul takes the written coefficient first: hQ.fun_mul hdl then fun_mul hInv proves Q*dl*lambda inverse, equal to the existing Q*dl/lambda formula. Current MemLp.smul is coefficient-first: (hs-hq).smul hcol proves exactly the existing scalar lower expression acting on V_i; (hdInv.const_mul (alpha-1)).smul h2 preserves the outer multiplier (alpha-1)/d applied to the sum. Measures and finite sums unchanged.

The final lower term remains minus sum_i Gamma(v_i,v_i) minus ((alpha-1)/d) times sum_i ((sum_j DG(v_i,v_j,v_j)-Q*dl_i/lambda) smul v_i), matching suAlphaLowerTerm in Minimizer/Compactness/Equation. All local instances pre-exist and remain canonical; only broad transparency override removed. Existing heartbeat allowance is unchanged.

Baseline commit: `d85511909ae9f950df6c84a8ddf8f10c8311f861`.
Baseline SHA256: `9019c13400eac1c3f5c0bbb5bf95cc59978615cbcc8edb88d68ecd928d92b408`.
Current source SHA256: `003e099c37223a35b825a1d2a3f7de30222f6befa3f766677f474e6d7a30493e`.
