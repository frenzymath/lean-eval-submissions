# Local validation loader policy

The Slurm node uses `vm.max_map_count=65530`. The default loader failed while
loading the complete import closure, reporting an existing `.olean` as unreadable.
A syscall trace showed `mmap` returning `ENOMEM` at the mapping-count limit.
The successful diagnostic with the fallback policy checked the same
`ControlledSchedules/Providers.lean` bytes and the same imported artifacts.

For final validation only, `force-olean-read.c` installs an inherited,
unprivileged seccomp restriction that returns `EEXIST` for `mmap` calls using
`MAP_FIXED_NOREPLACE`. Other syscalls are allowed. Stock Lean already handles
that result by allocating a buffer, reading the original file, and relocating
its pointers. See the pinned toolchain's
[loader implementation](https://github.com/leanprover/lean4/blob/eb6cafb7290e8bd5f2937522d8d804f58f02bafc/src/library/module.cpp#L500).

This selects an existing I/O fallback; it changes no source or artifact bytes,
does not replace any compiler or kernel binary, and does not disable proof
checking. The official test driver, comparator, Lean kernel, and bundled
NanoDa remain unchanged. The restriction only affects the validation process
tree; no node sysctl was changed.

The launcher is recorded here as evidence and is not invoked by the submitted
Lake configuration. Its source and binary hashes are in
`local-loader-policy.json`. Local timings also reuse prior build artifacts
and independent smooth/topological allocations of 60,000 and 100,000 MiB,
respectively, so they do not establish cold hosted performance.
The fallback uses private read buffers instead of normal shared file mappings,
so these local memory measurements do not establish memory use on the hosted
32-GB runner either.
