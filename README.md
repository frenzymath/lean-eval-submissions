# Poincare LeanEval submission draft

This draft contains two self-contained submission workspaces for the
Poincare source library. The normal library remains in its development
repository; this is a lean source snapshot for evaluation, excluding
reference PDFs and build artifacts.

The formalization was developed through combined Archon Horizon and Codex
workflows, including work before the LeanEval adaptation. See the
[project paper](https://arxiv.org/html/2610.08329v1).

## Current status

**Both Poincare submissions pass the complete local official LeanEval checks.** Both workspaces target official benchmark
`38361be884302c7edce1908c4aef8296eb2cb27e`, Lean 4.35.0-rc3, and its exact
Mathlib dependencies. The topological `lake test` finished with Comparator's
`Your solution is okay!`, Nanoda acceptance, and Lean default-kernel acceptance.
Its source fingerprint and terminal log are in
[the migration report](reports/leaneval-lean435-migration.md). The separate
process exit code was not recovered from the session registry; the complete
success log is retained.

The smooth submission also passed Comparator, Nanoda, and Lean default-kernel
verification (`checks/20261014-084623-3760373.log`). Topological checking reuses 23,558 verified unchanged helpers and
freshly compiled roots. External host resource workarounds use the unchanged
compiler and its existing loader fallback. The public topological snapshot is
submitted through [LeanEval issue #2113](https://github.com/leanprover/lean-eval-submissions/issues/2113).
The smooth snapshot is submitted through
[LeanEval issue #2119](https://github.com/leanprover/lean-eval-submissions/issues/2119).
Remote acceptance is pending; the earlier private-source attempt could not
fetch the repository and did not evaluate the proof.

## Layout and imports

- `submissions/poincare_3d_smooth/`: smooth benchmark workspace.
- `submissions/poincare_3d_topological/`: topological benchmark workspace.
- `source-notices/`: original license notices retained with their source paths.
- `packaging-provenance.json`: input revisions, overrides, file hashes and checks.
- `tools/prepare_submission.py`: reproducible import-closure packager.

Each workspace contains its own `Submission.lean` and
`Submission/PoincareLib/` helpers. Initial packaging preserved library
declaration namespaces and proof bodies while prefixing local import module
names with `Submission.`; the migration adapts helper proofs to the pinned API.
Both benchmark theorem statements remain unchanged.
Any reachable local Mathlib compatibility module is likewise packaged beneath
`Submission/Mathlib/`, without shadowing the trusted Mathlib module name.
This duplication is required because the evaluator creates a fresh workspace
per problem and copies only `Submission.lean` and `Submission/**/*.lean`.
Sibling/root library imports and symlinks escaping `Submission/` do not work.
Git stores identical helper blobs once even though both snapshots contain them.
Source comments, author credits, and notices are retained; this draft does not
relicense third-party material. Review provenance/licensing before submission.

The source audit found complete import closure, identical helper copies, no
source symlinks or top-level helper shadows, and exact matches for all 14
trusted template files against recorded official hashes. The comments/string
masked trust scan covered 1,346 changed or added Lean files with no admission,
new axiom, unsafe declaration, or listed kernel-bypass mechanism found. These
source checks precede the separately reviewed submission instance-priority
correction and supplement the official verifier results.

## Validation and submission

Follow the official [solver instructions](https://github.com/leanprover/lean-eval#quick-start-for-solvers)
to install the exact pinned verification tools outside the writable workspace.
Then, from either problem directory, run `lake update`, obtain dependency
caches, and run `lake test` to check Comparator and Nanoda. This is a separate
validation objective from the existing Horizon run's `lake-build-only` policy.
Treat version errors, resource limits, and rejected proofs separately.

The documented GitHub issue intake accepts public repositories. This repository
is public, and the topological-only snapshot is pinned at
[`31597dd539847c6a030c439de25d3104370f9614`](https://github.com/frenzymath/lean-eval-submissions/tree/31597dd539847c6a030c439de25d3104370f9614).
The declared system is **Archon Horizon + Codex**; the production description
links the project paper above. Issue intake discovers every matching workspace,
so this snapshot contains only the validated topological problem at its root.

The newer [submission service](https://lean-lang.org/eval/submit/) has separate
App-access and source-visibility rules. The private-source requirement in
`fetch_submission_server` for formalization problems does not apply to the
legacy issue route used here.

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
