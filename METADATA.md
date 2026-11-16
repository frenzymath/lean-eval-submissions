# Poincaré resubmission metadata

- Problems: `poincare_3d_smooth`, `poincare_3d_topological`.
- Model/workflow credit: **Archon Horizon + Codex**.
- Exact solution publication status: **Public**.
- Original publication date: **2026-10-14**.
- Production reference: https://arxiv.org/html/2610.08329v1.
- Previous public submissions: [smooth #2119](https://github.com/leanprover/lean-eval-submissions/issues/2119),
  [topological #2113](https://github.com/leanprover/lean-eval-submissions/issues/2113).

The previous remote evaluations reached the six-hour limit during compilation
on the October 14 GitHub-hosted runner. They did not reach final proof checking.
The current standard runner has 16 CPUs and 32 GB of memory; this motivates a
fresh supported-toolchain attempt, without establishing that it will finish.

This preparation starts from the public rc3 migration
`b3e354bdacbfb0708af2a366e40867fa48ee3739` and updates to supported Lean
`4.35.0`, with Mathlib `074063781836922cb02701cd12943c9f51731afa`.
Trusted benchmark files come from LeanEval
`8955681b9914d7ebc7d286414843021b7d6c9de1`.

Both stable-toolchain packages passed compilation and the unchanged official
NanoDa/Lean comparator test. Exact checked source hashes, completion timestamps,
commands, exit codes, and logs are in `reports/evidence/stable-20261116/`.
Both final builds reuse helper and pinned dependency artifacts; topological
helpers were recompiled under their distinct package name in a preceding build.
Historical rc3 validation remains separately recorded in `reports/evidence/`. Local validation uses independent allocations:
16 CPUs / 60,000 MiB for smooth and 26 CPUs / 100,000 MiB for topological,
with configured Lean thread counts of 16 and 8 respectively. The cluster
enforces a CPU-to-memory allocation ratio; local timings do not reproduce
the hosted 16-CPU / 32-GB tier.

The existing project provenance, original source comments, author credits, and
third-party license notices remain applicable. See `packaging-provenance.json`
and `source-notices/`. No new authorship or model attribution is claimed by
the toolchain update.
