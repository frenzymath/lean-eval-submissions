# Poincare LeanEval submission draft

This draft contains two self-contained submission workspaces for the
Poincare source library. The normal library remains in its development
repository; this is a lean source snapshot for evaluation, excluding
reference PDFs and build artifacts.

## Current status

**Packaged draft, not yet accepted by LeanEval.** The original source checkout
passed `lake build` on Lean 4.33.1. These workspaces use the official benchmark
templates at `38361be884302c7edce1908c4aef8296eb2cb27e`, including their own pinned toolchain
and Mathlib. They have NOT yet been built on that toolchain or checked by
Comparator/Nanoda. Toolchain compatibility and transitive admissions remain
verification questions. No successful submission is claimed.

## Layout and imports

- `submissions/poincare_3d_smooth/`: smooth benchmark workspace.
- `submissions/poincare_3d_topological/`: topological benchmark workspace.
- `source-notices/`: original license notices retained with their source paths.
- `packaging-provenance.json`: input revisions, overrides, file hashes and checks.
- `tools/prepare_submission.py`: reproducible import-closure packager.

Each workspace contains its own `Submission.lean` and
`Submission/PoincareLib/` helpers. Library declaration namespaces and proof
bodies are preserved; local import module names gain the `Submission.` prefix.
Any reachable local Mathlib compatibility module is likewise packaged beneath
`Submission/Mathlib/`, without shadowing the trusted Mathlib module name.
This duplication is required because the evaluator creates a fresh workspace
per problem and copies only `Submission.lean` and `Submission/**/*.lean`.
Sibling/root library imports and symlinks escaping `Submission/` do not work.
Git stores identical helper blobs once even though both snapshots contain them.
Source comments, author credits, and notices are retained; this draft does not
relicense third-party material. Review provenance/licensing before submission.

## Validation and submission

Follow the official [solver instructions](https://github.com/leanprover/lean-eval#quick-start-for-solvers)
to install the exact pinned verification tools outside the writable workspace.
Then, from either problem directory, run `lake update`, obtain dependency
caches, and run `lake test` to check Comparator and Nanoda. This is a separate
validation objective from the existing Horizon run's `lake-build-only` policy.
Treat version errors, resource limits, and rejected proofs separately.

Once verified, install the required GitHub Apps and use
[the submission service](https://lean-lang.org/eval/submit/) with the hosting
repository and its exact source commit. Make one request for each problem ID.
The current evaluation code requires private source for the
`formalization-evaluation` group, despite the more permissive repository README:
see [fetch_submission.py](https://github.com/leanprover/lean-eval-submissions/blob/0c5ad9e534a976c764b1c08c90edfe817cd6ff95/scripts/fetch_submission.py#L745).
Installing Apps, accepting terms and choosing publication are separate
submitter actions; no submission has been sent.

Regenerate from a chosen source checkout, without changing that checkout:

```bash
python3 tools/prepare_submission.py --source /path/to/poincare \
  --benchmark-commit 38361be884302c7edce1908c4aef8296eb2cb27e --archive /path/to/new-draft.tar.gz
```

The packager includes tracked source plus relevant working-tree edits, records
those overrides, checks local import closure, preserves official trusted files,
and enforces the 100,000,000-byte compressed archive cap. It does not compile
the proof or run any verifier. This is an evaluation layout, not a library
replacement.
