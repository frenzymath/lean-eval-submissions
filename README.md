# Algebraic Jacobian: LeanEval submission

Submission workspace for `jacobian_challenge_alggeo`, Christian Merten's algebraic
Jacobian challenge. The library is packaged from
[`frenzymath/Jacobian-Challenge`](https://github.com/frenzymath/Jacobian-Challenge/tree/dce1ca5941773caba3608dceff56371cefce58ec)
at `dce1ca5941773caba3608dceff56371cefce58ec`.

The workspace uses stable Lean `4.35.0` and Mathlib
`074063781836922cb02701cd12943c9f51731afa`, matching the stable configuration of
LeanEval revision `8955681b9914d7ebc7d286414843021b7d6c9de1`.
All nine benchmark answers are supplied. The 723 required source modules are
relocated under `Submission/`. The stable Mathlib migration adapts categorical
endomorphisms to their explicit wrapper; details and file hashes are recorded
in `packaging-provenance.json`. Three existing lemmas and the categorical gluing module also use
higher checking limits. The original admitted `Challenge.lean` from the
library is excluded from the proof dependencies.

## Layout

- `submissions/jacobian_challenge_alggeo/`: official benchmark workspace.
- `Submission.lean`: the nine answers delegating to the library.
- `Submission/JacobianSolution.lean`: the original completed solution.
- `Submission/Jacobian/`: its library dependencies.
- `packaging-provenance.json`: immutable input revisions and file hashes.
- `METADATA.md`: declared model, authors, and production details.
- `tools/prepare_jacobian_submission.py`: original import-only packaging script.

The trusted benchmark `Challenge.lean`, `Solution.lean`, `WorkspaceTest.lean`,
`config.json`, `holes.json`, and `Submission/Helpers.lean` match the current
benchmark byte-for-byte. The workspace selects the supported stable toolchain
and Mathlib pin; its lakefile includes the dependencies used by this solution.
The committed Lake manifest pins their transitive dependencies.

The original [submission #2172](https://github.com/leanprover/lean-eval-submissions/issues/2172)
was rejected before evaluating any proofs because Lean `4.35.0-rc3` was no longer
supported. This resubmission updates the toolchain and dependency pins and
adapts the affected library code to the current endomorphism API.

## Validation

The original package passed its full build and official comparator on Lean
`4.35.0-rc3`, including the Lean and NanoDa kernel checks, on November 6, 2026.
The stable Lean `4.35.0` package passed the full build and unchanged official
comparator, including both kernel checks, on November 16, 2026.
The commands, source digest, and results are in
[`validation-20261116.json`](validation-20261116.json).

```sh
cd submissions/jacobian_challenge_alggeo
lake exe cache get
lake build Submission Solution Challenge
lake test
```

`lake test` uses the unchanged official test driver and requires both the
Lean checker and NanoDa in the pinned toolchain, plus bubblewrap.

To reproduce the initial packaging, run the packaging script with the library
revision above and benchmark revision `85a88c37f80170d9f08651dc63ce6b81a8a48cb9`.
Then apply this repository's stable migration changes and Lake manifest.
LeanEval regenerates its own trusted workspace and overlays only the submitted
`Submission.lean` and `Submission/**/*.lean` files.

## Authors

- Axel Delaval
- Jie Xu
- Shitan Xu

Parts of the library are adapted from Weil's conjectures project; see
[NOTICE](NOTICE). Licensed under [Apache 2.0](LICENSE).
