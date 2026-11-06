# Algebraic Jacobian: LeanEval submission

Submission workspace for `jacobian_challenge_alggeo`, Christian Merten's algebraic
Jacobian challenge. The library is packaged from
[`frenzymath/Jacobian-Challenge`](https://github.com/frenzymath/Jacobian-Challenge/tree/dce1ca5941773caba3608dceff56371cefce58ec)
at `dce1ca5941773caba3608dceff56371cefce58ec`.

The workspace uses Lean `4.35.0-rc3` and Mathlib
`b63f6e8a68d220e3b3bc4f3792bb53650d375f24`, matching LeanEval revision
`85a88c37f80170d9f08651dc63ce6b81a8a48cb9`.
All nine benchmark answers are supplied. The 723 required source modules
retain their proof bodies; only local import paths are relocated under
`Submission/`. The original admitted `Challenge.lean` from the library is
excluded from the proof dependencies.

## Layout

- `submissions/jacobian_challenge_alggeo/`: official benchmark workspace.
- `Submission.lean`: the nine answers delegating to the library.
- `Submission/JacobianSolution.lean`: the original completed solution.
- `Submission/Jacobian/`: its library dependencies.
- `packaging-provenance.json`: immutable input revisions and file hashes.
- `METADATA.md`: declared model, authors, and production details.
- `tools/prepare_jacobian_submission.py`: reproducible packaging script.

The trusted benchmark `Challenge.lean`, `Solution.lean`, `WorkspaceTest.lean`,
`config.json`, `holes.json`, `lakefile.toml`, and toolchain remain unchanged.

## Validation

The source library's full build, original solution interface, and 43-root
permitted-axiom check passed on Lean `4.35.0-rc3`. The packaged workspace's
own compilation and official comparator checks are being run separately;
source-library acceptance alone is not a LeanEval result.

```sh
cd submissions/jacobian_challenge_alggeo
lake update
lake exe cache get
lake build Submission Solution Challenge
lake test
```

`lake test` uses the unchanged official test driver and requires both the
Lean checker and NanoDa in the pinned toolchain, plus bubblewrap.

## Authors

- Axel Delaval
- Jie Xu
- Shitan Xu

Parts of the library are adapted from Weil's conjectures project; see
[NOTICE](NOTICE). Licensed under [Apache 2.0](LICENSE).
