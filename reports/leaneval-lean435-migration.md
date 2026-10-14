# LeanEval toolchain migration

Status as of 2026-10-14: the topological submission passes the complete local
official LeanEval test, including Comparator, Nanoda, and Lean's default kernel.
Its terminal log reports `Your solution is okay!`. A separate process exit
code was not recovered from the session registry; acceptance is established
by the retained complete success log. The corrected smooth roots also build,
and their fully explicit theorem types match the challenge byte for byte. Its official test also passed Comparator, Nanoda, and Lean default-kernel replay. No submission has been sent to LeanEval, and remote
evaluation acceptance is not claimed.

The migration branch starts from packaged source
`d85511909ae9f950df6c84a8ddf8f10c8311f861`. It targets official benchmark
snapshot `38361be884302c7edce1908c4aef8296eb2cb27e`, Lean `4.35.0-rc3`
(compiler `470d5ce1400764999581fd26d5d72b00d990b0f4`), Mathlib
`5e0c4e5239cb0a2d86d68a884bf52cfd963fce22`, and lean-pool
`e9d53e9cbcff8dfd0cc816ba94db7a26b082929f`. The original successful Lean
4.33.1 workspace is preserved; its oleans are not used by the new toolchain.

## Build evidence

The successful logs finish with `Build completed successfully (32522 jobs).`
This is Lake's completed task count, not a claim of 32,522 newly compiled files.
Logs and source receipts are retained outside the repository under
`~/.horizon/development-tmp/poincare-leaneval-port/`.

| Workspace | Command and outcome | Log | Staged-source SHA256 |
| --- | --- | --- | --- |
| Smooth, before adapter change | Normal `lake build`, exit 0 | `checks/20261014-002741-3619846.log` | `6aa920b5dfea059b85e26ff62f7deb0f1aa0de1c334fc5319df2c5c97891b821` |
| Topological, canonical-instance priority change | Verified helper reuse with `lake --old build`, exit 0; fresh endpoint roots | `checks/20261014-013008-3658152.log` | `68a395dd260b81bceac3c98f6ea5e154dd3ce02ad0c8d78952e2799df13edcf2` |
| Smooth, canonical-instance priority change | Verified helper reuse with `lake --old build`, exit 0; fresh endpoint roots | `checks/20261014-084347-3759749.log` | `416764a8a538067d2ed16b3afebe72628bc3999d5742b3a87883e9c653bc0ab6` |

Each log has a companion `.sources.json` receipt. Its 23,566 staged
source/config files include a retained unimported diagnostic probe; the
submission import closure contains 23,559 modules. The smooth build uses normal
Lake freshness checks and artifacts retained across repair passes. Before the
topological build, all 23,558 helper sources were independently checked to be
byte-identical to the successful smooth snapshot, with the same pinned
compiler, dependencies, and compilation options. Challenge, Submission, and
Solution artifact families were deleted and those roots rebuilt. The
controlled reuse changes Lake freshness policy; it does not modify artifact
payloads or replace final independent verification. It is not a general
verifier for arbitrary supplied caches.

The editable Submission.lean adapters set Mathlib's existing
`instTopologicalSpaceSubtype` priority to 1100. This prevents the imported
gluing alias `Poincare.Gluing.pieceTopologicalSpace` from changing the sphere's
exported topology expression relative to trusted Challenge. The alias and
canonical topology are definitionally equal, independently proved by `rfl`;
the instance body, mathematical topology, theorem assumptions, and trusted
templates are unchanged. Fully explicit printed Challenge/Solution types match
byte-for-byte, and the final topological official test accepts the result.
All helper sources remain unchanged by this endpoint correction.

## Source migration and audit

Both benchmark theorem statements and trusted workspace templates remain
unchanged. The current migration modifies 1,344 baseline helper files and adds
two compatibility modules, for 1,346 changed or added Lean files per copied
library. Changes cover renamed finite-product lemmas, new `MemLp` accessors and
multiplication APIs, explicit tangent transports, metric-specific instances,
and elaboration repairs. A proved model-space derivative adapter recovers the
previous coordinate formula. A proved homeomorphism transports singular
simplices between the legacy coordinate subtype and the new finite-distribution
representation. Scoped instances and explicit types retain the selected norms,
metrics, scalar operations, and mathematical formulas. Some expensive proofs
were factored through typed generic lemmas to avoid repeated elaboration.

Some auxiliary measure-theory contracts now require explicit measurability or
`SFinite` hypotheses because the pinned Mathlib changes `eLpNorm` and
nonmeasurable measure-map semantics. Existing smoothness, `MemLp`, and finite
restricted-volume facts discharge these hypotheses at geometric callers.
Neither Poincaré endpoint gains an assumption.

The final packaging audit found 23,559 reachable modules in each workspace,
including 23,558 byte-identical helper files and complete local import closure.
The smooth source snapshot has 151,843,782 bytes. There are no source symlinks
outside excluded `.lake` directories, top-level helper shadows, missing local
imports, or unsupported external imports. All 14 trusted files, including
Solution.lean in both workspaces, exactly match the official template hashes
recorded in preserved packaging-provenance.json. Fresh remote template fetches
were unavailable because of network timeouts; the comparison is against the
recorded official hashes.

Two independent scans agree on every submitted source fingerprint. Their
source-manifest SHA256 is
`449fd628456d78ff4712acdb6ea7d08f77096fa7de348fa46dcb95c8290ec74e`.
The comments/string-masked scan of all submitted modules and the source-bound
scan of 1,346 changed or added files found no listed admission, new axiom,
unsafe/extern declaration, declaration-injection code, or kernel-bypass
mechanism. The broader lexical scan's 242 evaluation identifiers and 36
local/scoped term macros were reviewed as ordinary mathematical evaluation or
typed term/theorem expansions. These source checks precede the separately reviewed Submission.lean
instance-priority correction; final kernel acceptance for the topological
endpoint is supplied by the official test below.

Detailed audit evidence is retained alongside the build logs:
`final-packaging-trust-audit.md/json`, `final-source-fingerprints.json`,
`changed-source-trust-scan.json`, `packaging-integrity-review.json`, and
`helper-reuse-independent-review.md/json`. The identity-model derivative review
also covered 678 helper modules: 630 pure import/API replacements and 48 with
additional local repairs.

## Host resource handling

Checks run on local disk of Slurm allocation 4108752, with system GCC for
native linking and exact dependency caches selected by external local Lake
package overrides. Those overrides are absent from submission source and
trusted configuration. The host encountered thread-creation failures and its
65,530 virtual-memory-mapping limit while importing the large endpoint closure.
External wrappers restrict compiler/import concurrency to one worker; Lake's
outer scheduling setting uses six threads on the 16-CPU allocation. Glibc
allocator settings reduce anonymous mappings and allocator arenas.

A selectively preloaded host shim rejects only fixed-address Lean artifact
mappings (`MAP_FIXED_NOREPLACE` for the listed olean/IR suffixes). This selects
the unchanged pinned compiler loader's existing, header-validated malloc/read
fallback and normal relocation path. It preserves artifact bytes, elaboration,
and theorem checking. Ordinary file and anonymous mappings are forwarded.
The compiler, Lake, WorkspaceTest, Comparator, lean4export, Nanoda, and landrun
binaries and sources are unchanged. External sandbox wrappers restore the
same host runtime settings when Comparator clears its environment. Independent
shim review and forwarding tests passed; a scratch `False` proof negative
control was rejected with identical diagnostics with and without the shim.
This is host resource handling, not a proof or kernel modification.

## Verifier status

| Tool | Pinned commit |
| --- | --- |
| Comparator | `d03acab154d269c06e60e4de7e4cc85deebff94b` |
| lean4export | `076e8e57707e813375e8f9da8bf989799ace9680` |
| Nanoda | `68d5ca9db226849b41a6fff59d796ff19d0a8840` |
| landrun | `5ed4a3db3a4ad930d577215c6b9abaa19df7f99f` |

All four tools were built outside the submission workspace; Comparator and
lean4export use the exact benchmark compiler. A two-plus-two smoke workspace
using official WorkspaceTest.lean passed Comparator, Nanoda, and Lean's default
kernel on 2026-10-13. A separate cold smoke also passed with the external
sandbox/runtime wrappers. These validate tool installation and runtime wiring,
not the full Poincaré submissions.

<!-- FINAL_VERIFIER_RESULTS: integrating owner updates smooth results after checking. -->

| Workspace | Official `lake test` | Comparator | Nanoda | Default kernel |
| --- | --- | --- | --- | --- |
| Smooth | Passed (`checks/20261014-084623-3760373.log`) | Passed | Accepted | Accepted |
| Topological | Success terminal log | Accepts | Accepts | Accepts |

The accepted topological test log is
`checks/20261014-013145-3658528.log`, with source receipt
`checks/20261014-013145-3658528.sources.json` and staged-source SHA256
`68a395dd260b81bceac3c98f6ea5e154dd3ce02ad0c8d78952e2799df13edcf2`.
The command was `lake --old test`, using the disclosed verified helper cache
and unchanged official WorkspaceTest. The terminal log explicitly records:

```text
nanoda kernel accepts the solution
Lean default kernel accepts the solution
Your solution is okay!
```

The test's original process session is no longer available in the harness
registry, so no separate numeric exit-code receipt is claimed. The complete
terminal success log is the acceptance evidence. Smooth final logs and source
fingerprints will be added after its checks finish. Neither submission has
been sent to the LeanEval service.

Smooth final verification is recorded in `reports/evidence/smooth-verifier-success.json`;
its complete terminal log reports both kernel acceptances and `Your solution is okay!`.
