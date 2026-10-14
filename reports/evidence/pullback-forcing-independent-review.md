# Independent PullbackForcing review

PASS: canonical instances and direct equality composition preserve seed/natural pullback, operators, signs, formulas and public interfaces.

Independent read-only complete diff plus surrounding definitions/identity/covariance proofs; inspected SymmetricValue subtype definition and canonical section operation origins. No source edits or compiler run.

All existing declaration signatures are unchanged. The only proof change is pulledPerturbation_coordinates; definitions pullbackSeed, pullbackSeedCoordinates, pulledPerturbation, rawState and shiftedRawState are unchanged.

New dual ContinuousAdd comes from infer_instance and bilinear IsTopologicalAddGroup from ContinuousLinearMap.isTopologicalAddGroup. Tensor Add/Sub are exactly ContMDiffSection.instAdd/instSub, hence pointwise section addition/subtraction. SymmetricValue is the existing subtype of d.symmetricValue and its explicit normedAddCommGroup is the canonical submodule norm. No new tangent-space norms or altered scale/operator definitions.

The direct coordinate composition obtains hadd for the same seed plus smoothPullback h, at the same 2*r+2 level, with the actual pulledPerturbation symmetry proof supplied explicitly. evenPullback_smoothTensorCoordinates at r+1 gives P(coords(h))=coords(pullback(h)); hpull.symm therefore replaces only the second summand. congrArg adds the unchanged seed coordinates, and hadd.trans proves exactly the old endpoint equality.

Natural metric pullback remains pullbackSeed=metricTensor(Phi^*g0)-metricTensor(g0) and pulledPerturbation=seed+Phi^*h; pulledMetric_inner keeps Phi^*g=g0+pulledPerturbation. Source naturality, smooth Ricci-DeTurck tensor identities, shifted raw state correction, highGenerator subtraction, pullbackCommutator signs, radii/positivity/domain hypotheses and completed-state covariance proofs are unchanged.

Only backward.isDefEq.respectTransparency false is removed. Existing heartbeat budget is unchanged. No source axioms/admissions introduced. No duplicate compiler run; root reports direct PASS.

Baseline commit: `d85511909ae9f950df6c84a8ddf8f10c8311f861`.
Baseline SHA256: `10c6fb011ea06a51b66fc0476ad58f25eac20ae5c4748e04efc9e9d0b0a291ed`.
Current source SHA256: `4d91bc87d221d80ab564246e5810ae20a26bea6f62fa0e40b307728bd2e8ce86`.
