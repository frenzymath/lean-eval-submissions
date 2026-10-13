#!/usr/bin/env python3
"""Package the Poincare sources for LeanEval without altering the source checkout.

Only import paths change in library files. No proof bodies or statements change.
The resulting archive is a draft source snapshot, not verification evidence.
"""
import argparse
import concurrent.futures
import hashlib
import io
import json
from pathlib import Path
import re
import subprocess
import tarfile
import urllib.request

PROBLEMS = ("poincare_3d_smooth", "poincare_3d_topological")
ENDPOINT = "PoincareLib.Topology.Manifold.Poincare"
IMPORT = re.compile(rb"(?m)^[ \t]*(?:(?:public|private|meta)[ \t]+)*import[ \t]+[^\n]+")
TOKEN = re.compile(rb"[A-Za-z_][A-Za-z_0-9]*(?:\.[A-Za-z_][A-Za-z_0-9]*)*")
CAP = 100_000_000


def git(source, *args):
    return subprocess.check_output(["git", "-C", str(source), *args])


def mask_comments(data):
    """Keep byte offsets while masking nested Lean comments and string literals."""
    result = bytearray(data)
    depth = 0
    quoted = False
    i = 0
    while i < len(data):
        if depth:
            if data[i:i + 2] == b"/-":
                depth += 1
                result[i:i + 2] = b"  "
                i += 2
                continue
            if data[i:i + 2] == b"-/":
                depth -= 1
                result[i:i + 2] = b"  "
                i += 2
                continue
            if data[i] != 10:
                result[i] = 32
        elif quoted:
            if data[i] == 92 and i + 1 < len(data):
                result[i:i + 2] = b"  "
                i += 2
                continue
            if data[i] == 34:
                quoted = False
            if data[i] != 10:
                result[i] = 32
        elif data[i:i + 2] == b"/-":
            depth = 1
            result[i:i + 2] = b"  "
            i += 2
            continue
        elif data[i:i + 2] == b"--":
            end = data.find(b"\n", i)
            if end < 0:
                end = len(data)
            result[i:end] = b" " * (end - i)
            i = end
            continue
        elif data[i] == 34:
            quoted = True
            result[i] = 32
        i += 1
    return bytes(result)


def imports(data):
    result = []
    for line in IMPORT.findall(mask_comments(data)):
        # Strip the import keyword and any trailing comment before tokenizing.
        names = line.split(b"import", 1)[1].split(b"--", 1)[0]
        result.extend(x.decode() for x in TOKEN.findall(names))
    return result


def remap(data, local_modules):
    masked = mask_comments(data)
    edits = []
    for match in IMPORT.finditer(masked):
        # Only module tokens outside comments/strings are rewritten.
        for token in TOKEN.finditer(masked, match.start(), match.end()):
            if token[0].decode() in local_modules:
                edits.append((token.start(), token.end(), b"Submission." + token[0]))
    for start, end, replacement in reversed(edits):
        data = data[:start] + replacement + data[end:]
    return data


def fetch(commit, problem, filename):
    path = f"generated/{problem}/{filename}"
    url = f"https://raw.githubusercontent.com/leanprover/lean-eval/{commit}/{path}"
    with urllib.request.urlopen(url, timeout=30) as response:
        return problem, filename, response.read()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, required=True)
    parser.add_argument("--benchmark-commit", required=True)
    parser.add_argument("--archive", type=Path, required=True)
    args = parser.parse_args()
    source = args.source.resolve()
    if not re.fullmatch(r"[0-9a-f]{40}", args.benchmark_commit):
        parser.error("--benchmark-commit must be an immutable full SHA")
    if args.archive.exists():
        parser.error("Refusing to overwrite an existing archive")
    head = git(source, "rev-parse", "HEAD").decode().strip()
    paths = [p.decode() for p in git(source, "ls-files", "-z").split(b"\0") if p]
    modules = {
        p[:-5].replace("/", "."): p for p in paths
        if p.endswith(".lean") and (p.startswith("PoincareLib/") or p.startswith("Mathlib/"))
    }
    notices = [p for p in paths if any(
        part.startswith(("LICENSE", "LICENCE", "COPYING", "PUBLIC-SNAPSHOT-LICENSE"))
        for part in Path(p).parts
    )]
    wanted = sorted(set(modules.values()) | set(notices) | {"comparator/Solution.lean"})
    process = subprocess.Popen(
        ["git", "-C", str(source), "archive", "HEAD", "--",
         "PoincareLib", "Mathlib", "comparator/Solution.lean", *notices], stdout=subprocess.PIPE
    )
    files = {}
    with tarfile.open(fileobj=process.stdout, mode="r|") as archive:
        for entry in archive:
            if entry.isfile():
                files[entry.name] = archive.extractfile(entry).read()
    if process.wait():
        raise RuntimeError("Source archive failed")
    dirty = [p.decode() for p in git(source, "diff", "HEAD", "--name-only", "-z").split(b"\0") if p]
    overrides = {}
    for path in dirty:
        if path not in files:
            continue
        original = source / path
        if not original.is_file() or original.is_symlink():
            raise RuntimeError(f"Unsupported source override: {path}")
        files[path] = original.read_bytes()
        overrides[path] = hashlib.sha256(files[path]).hexdigest()
    reachable = set()
    pending = [ENDPOINT]
    external = set()
    while pending:
        module = pending.pop()
        if module in reachable:
            continue
        reachable.add(module)
        for imported in imports(files[modules[module]]):
            if imported in modules:
                pending.append(imported)
            elif imported.startswith("PoincareLib."):
                raise RuntimeError(f"Missing local dependency: {imported}")
            else:
                external.add(imported)
    renamed = {module: remap(files[modules[module]], modules) for module in reachable}
    for module, data in renamed.items():
        assert IMPORT.sub(b"", data) == IMPORT.sub(b"", files[modules[module]])
        for imported in imports(data):
            if imported.startswith("Submission.") and imported[len("Submission."):] not in reachable:
                raise RuntimeError(f"Unpackaged import in {module}: {imported}")
            if imported in modules:
                raise RuntimeError(f"Untranslated local import in {module}: {imported}")
    expected_prefixes = ("Mathlib", "Lean", "Std", "Batteries", "Aesop", "Qq", "ProofWidgets", "ImportGraph", "LeanSearchClient", "Plausible", "LeanPool")
    unsupported = sorted(m for m in external if not any(m == p or m.startswith(p + ".") for p in expected_prefixes))
    if unsupported:
        raise RuntimeError(f"Review external dependencies not provided by the official workspace: {unsupported}")

    template_names = ("lakefile.toml", "lean-toolchain", "Challenge.lean", "Solution.lean", "config.json", "WorkspaceTest.lean", "Submission.lean", "Submission/Helpers.lean")
    with concurrent.futures.ThreadPoolExecutor(max_workers=8) as pool:
        fetched = list(pool.map(lambda task: fetch(args.benchmark_commit, *task),
                                ((p, f) for p in PROBLEMS for f in template_names)))
    templates = {(p, f): data for p, f, data in fetched}
    original_solution = files["comparator/Solution.lean"].decode()
    theorem_blocks = re.split(r"(?m)(?=^theorem )", original_solution)[1:]
    bodies = {}
    for block in theorem_blocks:
        name = re.match(r"theorem (\w+)", block)[1]
        bodies[name] = block.split(":= by\n", 1)[1].rstrip() + "\n"
    outputs = {}
    template_hashes = {}
    for problem in PROBLEMS:
        prefix = f"submissions/{problem}/"
        for filename in template_names:
            data = templates[problem, filename]
            template_hashes[problem + "/" + filename] = hashlib.sha256(data).hexdigest()
            if filename == "Submission.lean":
                text = data.decode()
                assert text.count("  sorry") == 1
                text = text.replace("import Submission.Helpers\n", "import Submission.Helpers\nimport Submission." + ENDPOINT + "\n")
                text = text.replace("  sorry\n", bodies[problem])
                data = text.encode()
            outputs[prefix + filename] = data
        for module, data in renamed.items():
            outputs[prefix + "Submission/" + modules[module]] = data
    for path in notices:
        outputs["source-notices/" + path] = files[path]
    manifest = {
        "status": "draft; import closure packaged; LeanEval toolchain build and Comparator not run",
        "source_head": head, "source_working_tree_overrides": overrides,
        "benchmark_repository": "https://github.com/leanprover/lean-eval",
        "benchmark_commit": args.benchmark_commit,
        "problems": list(PROBLEMS), "endpoint": ENDPOINT,
        "helper_modules_per_workspace": len(reachable),
        "source_helper_bytes_per_workspace": sum(len(files[modules[m]]) for m in reachable),
        "transformation": "Prefix imports of packaged local modules with Submission.; preserve all other library bytes, including proof bodies and statements",
        "source_modules": {m: {"source_sha256": hashlib.sha256(files[modules[m]]).hexdigest(),
                               "packaged_sha256": hashlib.sha256(renamed[m]).hexdigest()} for m in sorted(reachable)},
        "official_template_sha256": template_hashes,
        "external_imports": sorted(external),
        "validation": {"local_import_closure_complete": True, "symlinks": False,
                       "current_toolchain_build": False, "comparator": False},
    }
    outputs["packaging-provenance.json"] = (json.dumps(manifest, indent=2) + "\n").encode()
    outputs["tools/prepare_submission.py"] = Path(__file__).read_bytes()
    outputs["README.md"] = f"""# Poincare LeanEval submission draft

This draft contains two self-contained submission workspaces for the
Poincare source library. The normal library remains in its development
repository; this is a lean source snapshot for evaluation, excluding
reference PDFs and build artifacts.

## Current status

**Packaged draft, not yet accepted by LeanEval.** The original source checkout
passed `lake build` on Lean 4.33.1. These workspaces use the official benchmark
templates at `{args.benchmark_commit}`, including their own pinned toolchain
and Mathlib. They have NOT yet been built on that toolchain or checked by
Comparator/Nanoda. Toolchain compatibility and transitive admissions remain
verification questions. No successful submission is claimed.

## Layout and imports

- `submissions/poincare_3d_smooth/`: smooth benchmark workspace.
- `submissions/poincare_3d_topological/`: topological benchmark workspace.
- `source-notices/`: original license notices retained with their source paths.
- `packaging-provenance.json`: input revisions, overrides, file hashes and checks.
- `tools/prepare_submission.py`: reproducible import-closure packager.

Each workspace contains its own `Submission.lean` and
`Submission/PoincareLib/` helpers. Library declaration namespaces and proof
bodies are preserved; local import module names gain the `Submission.` prefix.
Any reachable local Mathlib compatibility module is likewise packaged beneath
`Submission/Mathlib/`, without shadowing the trusted Mathlib module name.
This duplication is required because the evaluator creates a fresh workspace
per problem and copies only `Submission.lean` and `Submission/**/*.lean`.
Sibling/root library imports and symlinks escaping `Submission/` do not work.
Git stores identical helper blobs once even though both snapshots contain them.
Source comments, author credits, and notices are retained; this draft does not
relicense third-party material. Review provenance/licensing before submission.

## Validation and submission

Follow the official [solver instructions](https://github.com/leanprover/lean-eval#quick-start-for-solvers)
to install the exact pinned verification tools outside the writable workspace.
Then, from either problem directory, run `lake update`, obtain dependency
caches, and run `lake test` to check Comparator and Nanoda. This is a separate
validation objective from the existing Horizon run's `lake-build-only` policy.
Treat version errors, resource limits, and rejected proofs separately.

Once verified, install the required GitHub Apps and use
[the submission service](https://lean-lang.org/eval/submit/) with the hosting
repository and its exact source commit. Make one request for each problem ID.
The current evaluation code requires private source for the
`formalization-evaluation` group, despite the more permissive repository README:
see [fetch_submission.py](https://github.com/leanprover/lean-eval-submissions/blob/0c5ad9e534a976c764b1c08c90edfe817cd6ff95/scripts/fetch_submission.py#L745).
Installing Apps, accepting terms and choosing publication are separate
submitter actions; no submission has been sent.

Regenerate from a chosen source checkout, without changing that checkout:

```bash
python3 tools/prepare_submission.py --source /path/to/poincare \\
  --benchmark-commit {args.benchmark_commit} --archive /path/to/new-draft.tar.gz
```

The packager includes tracked source plus relevant working-tree edits, records
those overrides, checks local import closure, preserves official trusted files,
and enforces the 100,000,000-byte compressed archive cap. It does not compile
the proof or run any verifier. This is an evaluation layout, not a library
replacement.
""".encode()
    # Detect source changes during packaging; include only the recorded snapshot.
    if git(source, "rev-parse", "HEAD").decode().strip() != head:
        raise RuntimeError("Source HEAD changed during packaging")
    final_dirty = [p.decode() for p in git(source, "diff", "HEAD", "--name-only", "-z").split(b"\0") if p]
    if final_dirty != dirty:
        raise RuntimeError("Source edits changed during packaging")
    for path in overrides:
        if (source / path).read_bytes() != files[path]:
            raise RuntimeError(f"Source changed during packaging: {path}")
    args.archive.parent.mkdir(parents=True, exist_ok=True)
    with tarfile.open(args.archive, "w:gz", compresslevel=6) as archive:
        for path, data in sorted(outputs.items()):
            entry = tarfile.TarInfo(path)
            entry.size = len(data)
            entry.mode = 0o755 if path == "tools/prepare_submission.py" else 0o644
            archive.addfile(entry, io.BytesIO(data))
    size = args.archive.stat().st_size
    if size > CAP:
        raise RuntimeError(f"Archive exceeds LeanEval cap: {size} > {CAP}")
    print(json.dumps({"archive": str(args.archive), "archive_bytes": size,
                      "helper_modules_per_workspace": len(reachable),
                      "files": len(outputs), "status": manifest["status"]}), flush=True)


if __name__ == "__main__":
    main()
