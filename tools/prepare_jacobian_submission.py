#!/usr/bin/env python3
"""Package an immutable Jacobian release in an unchanged LeanEval starter.

This checks packaging and preserves proof bodies. It does not claim successful
elaboration, Comparator acceptance, or compatibility across Lean versions.
"""
import argparse
import hashlib
import io
import json
from pathlib import Path
import re
import subprocess
import tarfile

PROBLEM = "jacobian_challenge_alggeo"
IMPORT = re.compile(rb"(?m)^[ \t]*(?:(?:public|private|meta)[ \t]+)*import[ \t]+[^\n]+")
TOKEN = re.compile(rb"[A-Za-z_][A-Za-z_0-9]*(?:\.[A-Za-z_][A-Za-z_0-9]*)*")


def masked(data):
    result = bytearray(data)
    depth = 0
    quoted = False
    i = 0
    while i < len(data):
        if depth:
            if data[i:i + 2] in (b"/-", b"-/"):
                depth += 1 if data[i:i + 2] == b"/-" else -1
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
            end = len(data) if end < 0 else end
            result[i:end] = b" " * (end - i)
            i = end
            continue
        elif data[i] == 34:
            quoted = True
            result[i] = 32
        i += 1
    return bytes(result)


def imports(data):
    return [token.decode() for line in IMPORT.findall(masked(data))
            for token in TOKEN.findall(line.split(b"import", 1)[1])]


def remap(data, mapping):
    edits = []
    code = masked(data)
    for line in IMPORT.finditer(code):
        for token in TOKEN.finditer(code, line.start(), line.end()):
            name = token[0].decode()
            if name in mapping:
                edits.append((token.start(), token.end(), mapping[name].encode()))
    for start, end, replacement in reversed(edits):
        data = data[:start] + replacement + data[end:]
    return data


def sha(data):
    return hashlib.sha256(data).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, required=True)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--benchmark", type=Path, required=True)
    parser.add_argument("--benchmark-commit", required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    for revision in [args.source_commit, args.benchmark_commit]:
        if not re.fullmatch(r"[0-9a-f]{40}", revision):
            parser.error("Use immutable 40-character revisions")
    if args.output.exists():
        parser.error("Refusing to overwrite an existing output")
    archive = subprocess.check_output(["git", "-C", str(args.source), "archive", args.source_commit])
    with tarfile.open(fileobj=io.BytesIO(archive)) as tar:
        files = {entry.name: tar.extractfile(entry).read() for entry in tar if entry.isfile()}
    modules = {p[:-5].replace("/", "."): p for p in files if p.endswith(".lean")}
    mapping = {m: "Submission.JacobianSolution" if m == "Solution" else "Submission." + m
               for m in modules}
    reachable = set()
    external = set()
    pending = ["Solution"]
    while pending:
        module = pending.pop()
        if module in reachable:
            continue
        if module == "Challenge":
            raise ValueError("The admitted source Challenge must not be a proof dependency")
        reachable.add(module)
        for imported in imports(files[modules[module]]):
            if imported in modules:
                pending.append(imported)
            elif imported.startswith("Jacobian."):
                raise ValueError("Missing local import: " + imported)
            else:
                external.add(imported)

    output = args.output
    workspace = output / "submissions" / PROBLEM
    workspace.mkdir(parents=True)
    starter = args.benchmark / "generated" / PROBLEM
    trusted = {}
    for path in starter.rglob("*"):
        if path.is_file():
            relative = path.relative_to(starter)
            dest = workspace / relative
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_bytes(path.read_bytes())
            if relative.as_posix() != "Submission.lean":
                trusted[relative.as_posix()] = sha(path.read_bytes())
    records = []
    for module in sorted(reachable):
        path = modules[module]
        original = files[path]
        data = remap(original, mapping)
        assert IMPORT.sub(b"", original) == IMPORT.sub(b"", data), path
        assert not re.search(rb"\b(sorry|admit|axiom)\b", masked(data)), path
        dest = workspace / (mapping[module].replace(".", "/") + ".lean")
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_bytes(data)
        records.append({"source": path, "packaged": dest.relative_to(output).as_posix(),
                        "source_sha256": sha(original), "packaged_sha256": sha(data)})

    bodies = [
        "_root_.AlgebraicGeometry.genus C",
        "_root_.AlgebraicGeometry.Jacobian C",
        "_root_.AlgebraicGeometry.Jacobian.instGrpObj (C := C)",
        "inferInstanceAs (SmoothOfRelativeDimension (_root_.AlgebraicGeometry.genus C)\n"
        "    (_root_.AlgebraicGeometry.Jacobian C).hom)",
        "inferInstanceAs (IsProper (_root_.AlgebraicGeometry.Jacobian C).hom)",
        "inferInstanceAs (GeometricallyIrreducible (_root_.AlgebraicGeometry.Jacobian C).hom)",
        "_root_.AlgebraicGeometry.Jacobian.ofCurve P",
        "_root_.AlgebraicGeometry.Jacobian.comp_ofCurve C P",
        "_root_.AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp C P f hf",
    ]
    submission = (starter / "Submission.lean").read_text()
    assert submission.count("  sorry") == len(bodies)
    submission = submission.replace("import Submission.Helpers\n",
        "import Submission.Helpers\nimport Submission.JacobianSolution\n")
    submission = submission.replace("namespace Submission\n",
        "noncomputable section\n\n"
        "set_option backward.isDefEq.respectTransparency false\n"
        "set_option backward.isDefEq.respectTransparency.types false\n\nnamespace Submission\n", 1)
    for body in bodies:
        submission = submission.replace("  sorry", "  " + body, 1)
    (workspace / "Submission.lean").write_text(submission)
    assert not re.search(rb"\b(sorry|admit|axiom)\b", masked(submission.encode()))
    packaged_modules = {p.relative_to(workspace).as_posix()[:-5].replace("/", ".")
                        for p in (workspace / "Submission").rglob("*.lean")}
    for path in [workspace / "Submission.lean", *(workspace / "Submission").rglob("*.lean")]:
        for name in imports(path.read_bytes()):
            if name.startswith("Submission."):
                assert name in packaged_modules, (path, name)
            else:
                assert name not in modules, (path, name)
    for path, digest in trusted.items():
        assert sha((workspace / path).read_bytes()) == digest, path
    for name in ["LICENSE", "NOTICE"]:
        (output / name).write_bytes(files[name])
    (output / ".gitignore").write_text(".lake/\n*.olean\n*.ilean\n*.trace\n")
    report = {
        "problem_id": PROBLEM,
        "source_repository": "https://github.com/frenzymath/Jacobian-Challenge",
        "source_commit": args.source_commit,
        "benchmark_repository": "https://github.com/leanprover/lean-eval",
        "benchmark_commit": args.benchmark_commit,
        "source_toolchain": files["lean-toolchain"].decode().strip(),
        "benchmark_toolchain": (starter / "lean-toolchain").read_text().strip(),
        "included_source_modules": len(reachable),
        "excluded_source_modules": sorted(set(modules) - reachable),
        "external_imports": sorted(external),
        "trusted_template_sha256": trusted,
        "all_nine_adapter_bodies_present": True,
        "library_changes": "Local import module paths only; proof bodies unchanged.",
        "validation": "Packaging checks passed. Lean elaboration and official Comparator not yet run.",
        "files": records,
    }
    (output / "packaging-provenance.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({k: report[k] for k in ["problem_id", "included_source_modules",
        "source_toolchain", "benchmark_toolchain", "validation"]}, indent=2))


if __name__ == "__main__":
    main()
