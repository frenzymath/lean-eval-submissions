# LeanEval submission metadata

The packaged library is pinned to `frenzymath/Jacobian-Challenge` commit
`dce1ca5941773caba3608dceff56371cefce58ec`, checked with Lean `4.35.0-rc3`.
The evaluation request pins the exact commit of this submission repository.

| Field | Value |
| --- | --- |
| Problem | `jacobian_challenge_alggeo` |
| Title | Jacobian of a smooth proper curve (Merten challenge) |
| Declared model/system | `GPT-6.1-sol xhigh with additional custom tools` |
| Authors / credit identity | Axel Delaval; Jie Xu; Shitan Xu |
| Harness | Codex with additional custom tools for a formalization graph, task delegation, code search and reuse, and Lean/cluster compilation. |
| Source repository | `frenzymath/lean-eval-submissions` |
| Intended branch | `leaneval-jacobian` |
| Public library reference | https://github.com/frenzymath/Jacobian-Challenge |
| Library publication date | 2026-11-05 |
| Publication choice | `scheduled` for the current submission service, as required for this public repository. |
| Web / repository access | Yes |
| License | Apache 2.0 |

The current service resolves the canonical group and statement revision from its
catalog. The pinned benchmark currently reports `formalization-evaluation`,
revision 1. These are recorded for reference rather than supplied as client
fields.

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
as zero. The user authorized submission on November 6, 2026. The request accepts the
current LeanEval terms, including private fetch, archive, build and execution,
indefinite encrypted retention, public results and metadata, and scheduled
Apache 2.0 release. The source library is already public.

The authenticated submitter must have access to the exact source commit, and the
current service requires its two read-only GitHub Apps on the source repository.
