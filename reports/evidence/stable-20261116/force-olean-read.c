/* Local resource workaround: select Lean's existing read/malloc loader fallback.
 * No file bytes, compiler binary, or kernel-checking rules are changed.
 * Only the child process tree is affected; the node's sysctls are untouched.
 */
#define _GNU_SOURCE
#include <errno.h>
#include <stddef.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/prctl.h>
#include <sys/syscall.h>
#include <linux/filter.h>
#include <linux/seccomp.h>
#include <sys/mman.h>

int main(int argc, char **argv) {
    if (argc < 2) return 2;
    struct sock_filter code[] = {
        BPF_STMT(BPF_LD | BPF_W | BPF_ABS, offsetof(struct seccomp_data, nr)),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, SYS_mmap, 0, 4),
        BPF_STMT(BPF_LD | BPF_W | BPF_ABS, offsetof(struct seccomp_data, args[3])),
        BPF_STMT(BPF_ALU | BPF_AND | BPF_K, MAP_FIXED_NOREPLACE),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, 0, 1, 0),
        BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ERRNO | EEXIST),
        BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW),
    };
    struct sock_fprog program = { .len = sizeof(code) / sizeof(code[0]), .filter = code };
    if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) ||
        prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &program)) {
        perror("install resource-only mmap restriction");
        return 2;
    }
    fprintf(stderr, "LOCAL RESOURCE POLICY: MAP_FIXED_NOREPLACE returns EEXIST; "
                    "stock Lean uses its read/malloc fallback.\n");
    execvp(argv[1], argv + 1);
    perror("exec");
    return 2;
}
