# Stable Poincaré submission preparation — November 16, 2026

Both packages passed compilation and the unchanged official comparator test,
which enforces bundled NanoDa and the Lean kernel. These are local validation
results. The separate snapshots are prepared locally; no new Poincaré issue has
been posted and no new hosted evaluation result is claimed.

## Inputs

| Component | Revision |
| --- | --- |
| Public migration base | `b3e354bdacbfb0708af2a366e40867fa48ee3739` |
| LeanEval trusted templates | `8955681b9914d7ebc7d286414843021b7d6c9de1` |
| Lean | `leanprover/lean4:v4.35.0` |
| Mathlib | `074063781836922cb02701cd12943c9f51731afa` |
| lean-pool | `e9d53e9cbcff8dfd0cc816ba94db7a26b082929f` |

Original attribution is Archon Horizon + Codex; the original public date is
October 14, 2026. The [paper](https://arxiv.org/html/2610.08329v1), source comments,
provenance, and third-party notices remain applicable.

The benchmark theorem statements are preserved. The trusted Challenge,
Solution, WorkspaceTest, config, holes, and empty Helpers files match the
current official benchmark byte for byte. The exported adapter retains
`attribute [instance 1100] instTopologicalSpaceSubtype`. Dependency manifests
are pinned; absolute local overrides and build artifacts are excluded.

## Verified sources and results

For each package, validation ran `lake --no-cache build Submission Solution
Challenge`, then `lake test`, without source changes during either sequence.
The original official test driver enforces bundled NanoDa as an external kernel
as well as Lean. Every checked input hash was compared to the packaged bytes
before the validation evidence was recorded.

| Package | Final local build (seconds) | Official test (seconds) | Finished (UTC) |
| --- | ---: | ---: | --- |
| smooth | 8.144 | 9675.715 | 2026-11-16T14:17:45.997176+00:00 |
| topological | 11.340 | 10620.341 | 2026-11-16T19:49:35.438218+00:00 |

Input-tree SHA-256 values:

- smooth: `25e112c97470f3cfcaaa4e928a110f84d4cc6697491eef59ed10b5c9aa20e2f2`.
- topological: `ae8c8dd8318c843c608bce4ad2e450444fa3541c854dc2dec23d1c344a85b64c`.

Complete receipts, per-file hashes, and available console logs are in
[`evidence/stable-20261116/`](evidence/stable-20261116/). Historical rc3 evidence
remains separate and does not certify the stable migration.

The smooth console capture stopped during the default kernel check when the
login session was interrupted. Validation continued on the compute node, whose
final receipt records `lake test` exit code 0 and stable sources. The unchanged
official driver requires both kernels to succeed for that exit status. The
capture gap and exact receipt are recorded in
`smooth-console-capture-observation.json`; no missing success message has been
inserted into the captured log. Topological validation writes its console log
directly from its batch job.

Both packages contain the same 23,558 helper modules. The
final static audit confirms identical helper bytes, unchanged trusted files,
and no forbidden proof escapes in changed source. The declaration contract
audit found no changes to existing headers or docstrings. These source audits
supplement the official proof checks.

## Compatibility changes

The stable Mathlib port repairs proof bodies for structured sets and explicit
set domains, covariant-derivative domain inference, fundamental-group wrappers,
null measurability in indicator/piecewise lemmas, and moved operator APIs.
Compiler-reported noncomputability and instance-search limits are addressed in
the affected modules. Added compatibility helpers are proved from Mathlib;
no new axioms or sorries are introduced.

## Runtime limits and evaluation snapshots

Local validation used independent Slurm allocations on the same node: 16 CPUs
and 60,000 MiB for smooth, and 26 CPUs and 100,000 MiB for topological. The
configured `LEAN_NUM_THREADS` values were 16 and 8 respectively. The CPU requests
follow this cluster's memory-per-CPU allocation policy. Each endpoint had its
own memory cgroup, source directory, and build directory. The preparatory
topological build overlapped the successful smooth check on the same physical
node; the final topological retry began after smooth had finished. Toolchain
and dependency copies were node-local.
The current hosted standard tier has 16 CPUs and 32 GB.

An earlier attempt overlapped both endpoints within one 60,000-MiB allocation
and was killed for exceeding its memory limit. That interruption is recorded
as a resource failure, not a successful proof check. Only the complete successful
recovery runs appear in the results table.

This node's `vm.max_map_count=65530` prevented the complete import closure from
loading with the default memory-mapped loader. A local inherited seccomp
restriction returned `EEXIST` for `MAP_FIXED_NOREPLACE`, selecting the unmodified
Lean loader's built-in `read`/`malloc` fallback. It changes no source or artifact
bytes and does not weaken either kernel's proof checks. The launcher source and
policy receipt are in the evidence directory. This resource workaround is not
part of the submitted build configuration and is another reason the local
timings cannot predict hosted performance. The fallback reads imported files
into private buffers; its memory use differs from normal shared file mappings.
Memory use on the hosted 32-GB runner has not been measured.

Both final builds reuse compiled helper artifacts. Changing the Lake package
name changes module identity, so a preceding topological build recompiled the
identical helper sources under its own package name. That complete build passed
in 18,784.481 seconds (about 5h13m), using pinned dependency artifacts. Its test
then failed during dependency resolution: copied local overrides still pointed
to the smooth workspace, which the comparator sandbox hides. Correcting the
unsubmitted local overrides preserved the helper cache and all package source
hashes. The successful retry uses that cache. The initial complete build, setup
failure, and correction are preserved separately in the evidence directory.
The table is not a cold-build benchmark and cannot
guarantee completion under the hosted six-hour limit. The
[runtime comparison](runtime-comparison-20261116.md) documents why a
retry on the newer runner is plausible and why source length does not predict
compile time.

The current policy also offers one resource-failure retry on a 32-CPU / 64-GB
runner with a 24-hour job budget for allowlisted submitters. At the recorded
workflow revision, the currently authenticated account `AxelDlv00` is not on that
list. An unposted request draft is prepared separately; eligibility or a policy
change is not assumed. See the runtime comparison and preserved policy evidence.

Each prepared evaluation snapshot contains exactly one benchmark lakefile,
so smooth and topological are evaluated separately. Local snapshot commits,
archive hashes, and complete issue drafts are recorded alongside this checkout
in `prepared-snapshots.json` and `submission-drafts/`. Publishing is a separate
step from this preparation.
