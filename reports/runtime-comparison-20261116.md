# Poincaré evaluation runtime comparison

The October 14 timed-out submission and the October 23 accepted submission
used different runner classes despite the same six-hour limit.

| Evaluation | Runner | Outcome |
| --- | --- | --- |
| Original smooth #2119, October 14 | GitHub `ubuntu-latest`, standard public Linux tier documented as 4 CPUs / 16 GB | Six-hour limit during compilation |
| Accepted smooth #2165, October 23 | Namespace `16x32`, explicitly recorded in setup logs | Complete evaluation in 3h52m26s |
| Accepted topological #2166, October 23 | Namespace `16x32` | Complete evaluation in 3h51m09s |
| Current standard tier | 16 CPUs / 32 GB | Six-hour limit |

The old job log identifies the hosted image but does not independently measure
its CPU count. The successful smooth log explicitly records its machine type.
This hardware difference makes a retry plausible; it does not establish a
particular speedup or guarantee completion.

The current policy also permits one fresh resource-failure retry on 32 CPUs /
64 GB with a 24-hour job budget, if the authenticated submitter is on the
larger-runner allowlist. Ordinary Lean/proof errors do not trigger this retry.
At workflow revision `637f791024947c4ac2f51445ac5458d02f15dddd`, the currently
authenticated account `AxelDlv00` is not allowlisted. Eligibility follows the
submitter, not the source repository owner. An unposted request draft is prepared
alongside the submission drafts; no policy change or larger runner is assumed.
The exact policy, allowlist, workflow, and observation are preserved under
`evidence/stable-20261116/hosted-runner-policy-observation.json`. The hosted
`vm.max_map_count` is not established by those files.

The accepted runs' durations cover the entire evaluation. Buffered comparator
output does not provide reliable separate compilation and kernel-check times.
The competing submitted source is private, so its proof structure cannot be
compared directly. Lean source length alone does not measure elaboration,
import loading, dependency ordering, or kernel-checking cost.
Lean checks the elaborated proof term: one short tactic can generate more
checking work than many direct applications of existing lemmas.

The recovery validation uses independent Slurm allocations on one node:
16 CPUs / 60,000 MiB for smooth and 26 CPUs / 100,000 MiB for topological.
The CPU requests follow the cluster's memory-per-CPU policy; configured
`LEAN_NUM_THREADS` values are 16 and 8 respectively. Both selected final builds
reuse compiled helpers. A preceding topological build recompiled the helper
sources under their distinct Lake package name, using pinned dependency
artifacts, and passed in 18,784.481 seconds (about 5h13m). Its test then stopped
during dependency resolution because cloned local overrides pointed to the
smooth workspace, which the comparator sandbox hides. Correcting those
unsubmitted overrides preserved all package source hashes and compiled helpers;
the retry's complete build passed in 11.340 seconds. The initial build and
setup failure are retained separately in the evidence.
Each endpoint has its own memory cgroup and source/build workspace. The
preparatory topological build overlapped the successful smooth check on the same
physical node; the final topological retry began after smooth had finished.
An earlier attempt sharing one 60,000-MiB
allocation was killed for exceeding its memory limit; it is not a successful
validation. These conditions do not reproduce a cold hosted run.
Separate smooth and topological snapshots ensure one evaluation job builds
one requested endpoint.

A five-second sample of the current local smooth check measured 4.99 CPU
seconds in 5.000 wall seconds for the stock `leanchecker` process, about one
CPU core despite a 16-CPU allocation. This is one sample of one checking phase,
not a whole-run scaling measurement. It illustrates why additional build cores
cannot predict the speed of every phase. The sample is preserved in
`evidence/stable-20261116/lean-checker-resource-observation.json`.

One observed example from the local compatibility build is
`ScalarLaplacianControl.lean`: its 162 lines took 896 seconds to compile
successfully. It compares nested derivative and norm instances. This is a
single-module observation from an incremental build, not a cold hosted-run
estimate; the surrounding compatibility build still contained other errors.
The observation and source hash are preserved with the final evidence.
The topological preparatory build independently recorded 911 seconds for the same
unchanged module; that successful module result is in
`topological-preparatory-build-and-setup-failure.log` in the evidence directory.

Evidence:

- [Original smooth job](https://github.com/leanprover/lean-eval-submissions/actions/runs/38517495987/job/115699989986)
- [Accepted smooth job](https://github.com/leanprover/lean-eval-submissions/actions/runs/39938458456/job/120364095597)
- [GitHub standard runner specifications](https://docs.github.com/en/actions/reference/runners/github-hosted-runners#standard-github-hosted-runners-for-public-repositories)
- [Current evaluator runner documentation](https://github.com/leanprover/lean-eval-submissions/blob/main/docs/larger-runners.md)
