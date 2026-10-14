# Poincare LeanEval submission draft

This draft contains two self-contained submission workspaces for the
Poincare source library. The normal library remains in its development
repository; this is a lean source snapshot for evaluation, excluding
reference PDFs and build artifacts.

The formalization was developed through combined Archon Horizon and Codex
workflows, including work before the LeanEval adaptation. See the
[project paper](https://arxiv.org/html/2610.08329v1).

## Current status

The validated LeanEval migration is on
[`leaneval-lean435-port`](https://github.com/frenzymath/lean-eval-submissions/tree/leaneval-lean435-port).
The default `main` branch retains the original packaged draft.

The topological submission passed the pinned official local Comparator, Nanoda,
and Lean kernel checks. Its exact standalone snapshot is
[`31597dd539847c6a030c439de25d3104370f9614`](https://github.com/frenzymath/lean-eval-submissions/tree/31597dd539847c6a030c439de25d3104370f9614),
submitted publicly in
[LeanEval issue #2113](https://github.com/leanprover/lean-eval-submissions/issues/2113).
Remote acceptance remains pending. The smooth submission builds and has exact
statement agreement; its final local verifier is still running.
See the [migration report](https://github.com/frenzymath/lean-eval-submissions/blob/leaneval-lean435-port/reports/leaneval-lean435-migration.md)
for checks, pins, and host resource handling.

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
