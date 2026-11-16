# LeanEval submission metadata

The packaged library is pinned to `frenzymath/Jacobian-Challenge` commit
`dce1ca5941773caba3608dceff56371cefce58ec`, originally checked with Lean `4.35.0-rc3`.
The November 16 resubmission selects supported stable Lean `4.35.0` and Mathlib
`074063781836922cb02701cd12943c9f51731afa`.
The evaluation request pins the exact commit of this submission repository.

| Field | Value |
| --- | --- |
| Problem | `jacobian_challenge_alggeo` |
| Title | Jacobian of a smooth proper curve (Merten challenge) |
| Declared model/system | `GPT-6.1-sol xhigh with additional custom tools` |
| Authors / credit identity | Axel Delaval; Jie Xu; Shitan Xu |
| Harness | Codex with additional custom tools for a formalization graph, task delegation, code search and reuse, and Lean/cluster compilation. |
| Source repository | `frenzymath/lean-eval-submissions` |
| Resubmission branch | `fix/lean-eval-v435-stable` |
| Public library reference | https://github.com/frenzymath/Jacobian-Challenge |
| Library publication date | 2026-11-05 |
| Exact solution publication status | Public |
| Web / repository access | Yes |
| License | Apache 2.0 |

The pinned benchmark reports group `formalization-evaluation`, statement
revision 1. This package supplies all nine answers.

## Human involvement

Human direction of the project, strategy, and release; mathematical review of
milestone statements. Codex agents developed and adapted Lean proofs, integrated
them, and post-processed the completed formalization into a reusable library.

## Production description

The submission is based on the completed `frenzymath/Jacobian-Challenge` library.
Development used multiple human-directed Codex sessions, a formalization graph,
delegated proof tasks, existing formalizations, and Lean compiler feedback,
followed by library cleanup and independent release checks. Parts of the library
are adapted from Weil's conjectures project; see NOTICE. The declared system is
GPT-6.1-sol xhigh with additional custom tools. The source library is public at
https://github.com/frenzymath/Jacobian-Challenge from November 5, 2026.
Complete auxiliary-model, token, cost, and elapsed-time totals have not been
established.

## Fields left unspecified

Token counts, monetary cost, wall-clock duration, complete component-model list,
and a verbatim combined prompt are omitted. No missing measurement is represented
as zero. The user authorized the original submission on November 6, 2026 and
fixing and resubmitting it on November 16, 2026. The submission issue records
the current intake acknowledgements for fetching and evaluation, publication
of results and metadata, and indefinite encrypted audit retention. The source
library is already public under Apache 2.0.

The original submission was rejected at toolchain selection, before proof
evaluation. The resubmission preserves the authors, historical model declaration,
public library revision, and mathematical statements.

The stable package passed its full build and official comparator with both Lean
and NanoDa on November 16, 2026. The checked source digest and stage results are
recorded in [`validation-20261116.json`](validation-20261116.json).
