# Independent review: mmap fallback shim

Result: PASS. Reviewed `/gpfs/share/home/2301110044/.horizon/development-tmp/poincare-leaneval-port/mmap-fallback.c` (SHA-256 `2f35ff7e7022ef7c125caaae992ee16ae82425677ab0a9d977c80cf9b2405076`) against pinned Lean 4.35.0-rc3 loader code. No source edits were made.

The current shim denies only file descriptors whose `/proc/self/fd` target ends in `.olean`, `.olean.server`, `.olean.private`, `.ir`, or `.ir.sig`, and only with `MAP_FIXED_NOREPLACE`. Anonymous and ordinary file mappings forward to the real `mmap`; atomic acquire/release lookup and the ENOSYS guard handle concurrent resolution and symbol failure.

The pinned loader validates the olean header first. A denied mapping follows the existing `malloc(size)`, `lseek(fd, 0)`, `readn(fd, buffer, size)` fallback; the same `region_reader` performs relocation and pointer fixup, and the existing `is_mmap=false` free path calls `free_sized`. Bytes, kernel elaboration and theorem checking remain unchanged.

OS smoke checks passed with and without preload: anonymous/fixed-anonymous forwarding, ordinary private/fixed-file forwarding, preservation of ordinary and Lean artifact contents, and EEXIST denial for a `.olean` fixed mapping under preload. Full data is in the JSON receipt.

The process-wide preload should be restricted to the controlled Lean process. The path filter is fail-open for unusual unnamed or differently suffixed descriptors; normal Lake artifact paths use the listed suffixes.
