# Algebraic Jacobian: LeanEval submission draft

Submission workspace for `jacobian_challenge_alggeo`, Christian Merten's algebraic
Jacobian challenge. It packages the completed library from
[`frenzymath/Jacobian-Challenge`](https://github.com/frenzymath/Jacobian-Challenge)
at `b36c79371ad1bf2c84dad11769ab9510965559d5`.

## Status

The import closure and nine solution adapters are prepared. Local imports have
been relocated beneath `Submission/`; the library proof bodies are unchanged.
The official starter files are pinned to LeanEval revision
`85a88c37f80170d9f08651dc63ce6b81a8a48cb9` and remain unchanged except for the
solver-owned `Submission.lean`.

**This draft has not passed LeanEval validation.** The source library uses Lean
4.33.1 and Mathlib `0df444a360eaa60ab8c11dca51a86af692955474`; the pinned
benchmark requires Lean 4.35.0-rc3 and Mathlib
`b63f6e8a68d220e3b3bc4f3792bb53650d375f24`. Compiler compatibility, the nine
adapters, and the official Comparator/Lean/NanoDa run must be checked before
submission. Previous library acceptance does not establish those checks.

## Layout

- `submissions/jacobian_challenge_alggeo/`: the single benchmark workspace.
- `Submission.lean` in that workspace supplies all nine benchmark declarations.
- `Submission/JacobianSolution.lean` is the completed original solution.
- `Submission/Jacobian/` contains its required library modules.
- `packaging-provenance.json` records source pins, hashes, and unchanged templates.
- `METADATA.md` proposes the submission metadata for author approval.
- `tools/prepare_jacobian_submission.py` reproduces the package from pinned inputs.

The original admitted source `Challenge.lean` is excluded from the proof's import
closure. The workspace's `Challenge.lean` and `Solution.lean` are the official
benchmark statement and bridge, preserved byte for byte.

## Validation

Using the official pinned toolchain and trusted verifier installation:

```sh
cd submissions/jacobian_challenge_alggeo
lake update
lake exe cache get
lake build Submission Solution
lake test
```

The final `lake test` must use the unchanged official `WorkspaceTest.lean`.
Record its actual result before describing this draft as accepted or ready.

## Authors

- Axel Delaval
- Jie Xu
- Shitan Xu

Parts of the library are adapted from Weil's conjectures project; see
[NOTICE](NOTICE). Licensed under [Apache 2.0](LICENSE).
