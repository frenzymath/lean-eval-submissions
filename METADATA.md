# Proposed LeanEval metadata

This proposal accompanies an unvalidated local draft. No evaluation request has
been sent. The exact source commit will be pinned after the compatibility work
and final checks, before submission.

| Field | Proposed value |
| --- | --- |
| Problem | `jacobian_challenge_alggeo` |
| Title | Jacobian of a smooth proper curve (Merten challenge) |
| Declared model/system | `Relay (Codex; primarily GPT-6.1)` |
| Authors / credit identity | Axel Delaval; Jie Xu; Shitan Xu |
| Harness | Relay: Codex sessions with goal instructions, a formalization graph, delegated proof tasks, repository reuse, and Lean feedback. |
| Source repository | `frenzymath/lean-eval-submissions` |
| Intended branch | `leaneval-jacobian` |
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
are adapted from Weil's conjectures project; see NOTICE. GPT-6.1 with xhigh
reasoning was the primary configured model. Complete auxiliary-model, token,
cost, and elapsed-time totals have not been established.

## Fields left unspecified

Token counts, monetary cost, wall-clock duration, complete component-model list,
and a verbatim combined prompt are omitted. No missing measurement is represented
as zero. Publication and terms consent are to be confirmed with the final checked
snapshot; the draft request leaves `terms_accepted` false.

The authenticated submitter must have access to the exact source commit, and the
current service requires its two read-only GitHub Apps on the source repository.
