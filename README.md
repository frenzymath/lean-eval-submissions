# Poincare LeanEval packages

This repository prepares separate smooth and topological Poincaré submissions
for supported Lean **4.35.0**, with Mathlib pinned to
`074063781836922cb02701cd12943c9f51731afa`.

**Both stable-toolchain packages passed compilation and the unchanged official
NanoDa/Lean comparator test.** Exact source hashes, exit codes, and logs are in
[the stable migration report](reports/stable-resubmission-20261116.md).
Both final builds reuse helper and pinned dependency artifacts. Topological
helpers were recompiled under their distinct package name in a preceding build.
These are not cold hosted-build measurements.

The original formalization was developed through combined **Archon Horizon +
Codex** workflows, including work before the LeanEval adaptation. The
[project paper](https://arxiv.org/html/2610.08329v1) and
[submission metadata](METADATA.md) preserve the original attribution and public
publication date, October 14, 2026.

## Packages

- `submissions/poincare_3d_smooth/`: smooth endpoint.
- `submissions/poincare_3d_topological/`: topological endpoint.
- `packaging-provenance.json`: original source revisions, transformations,
  file hashes, historical checks, and the stable update.
- `source-notices/`: original third-party license notices with source paths.

Each package contains its own `Submission.lean` and the complete helper import
closure under `Submission/`. Packaging preserves library declaration namespaces
and source credits while prefixing local module imports with `Submission.`.
The existing benchmark theorem statements and subtype-topology instance
registration are retained. The current official trusted workspace files are
copied from LeanEval `8955681b9914d7ebc7d286414843021b7d6c9de1`.

Install the pinned toolchain and bubblewrap, obtain the exact Mathlib dependency
cache, and run `lake build Submission Solution Challenge` followed by `lake test`
inside either package. The unchanged official test requires both NanoDa and
Lean kernel acceptance. Absolute local dependency overrides and build artifacts
are not submission source.

## Historical results

The earlier Lean 4.35.0-rc3 packages passed local official checks on October 14.
Their reports and receipts remain under `reports/evidence/` and
[the historical migration report](reports/leaneval-lean435-migration.md).
Remote [topological #2113](https://github.com/leanprover/lean-eval-submissions/issues/2113)
and [smooth #2119](https://github.com/leanprover/lean-eval-submissions/issues/2119)
reached the six-hour limit during compilation on the older runner.

The current standard hosted tier has 16 CPUs and 32 GB of memory. Local
validation uses independent allocations: 16 CPUs / 60,000 MiB for smooth and
26 CPUs / 100,000 MiB for topological, with configured Lean thread counts of
16 and 8 respectively. These local timings cannot guarantee remote completion
within six hours.

Original author credits, comments, and third-party notices are retained. This
package does not relicense third-party material. The original snapshot packager
in `tools/prepare_submission.py` documents the initial packaging transformation;
it does not reproduce later migrations or certify their proofs.
