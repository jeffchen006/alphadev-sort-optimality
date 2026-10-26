"""Rename scratch registers, then lower free outputs to counted memory stores."""
import collections
import json
from pathlib import Path
import re
import sys

source, output = map(Path, sys.argv[1:])
instructions = []
scratch = {}
for line in source.read_text().splitlines():
    line = line.split("#")[0].strip()
    if not line:
        continue
    def rename(match):
        old = match.group()
        if old not in scratch:
            scratch[old] = f"S{len(scratch)}"
        return scratch[old]
    instructions.append(re.sub(r"S\d+", rename, line))
counts = collections.Counter(line.split()[0] for line in instructions)
k = sum(counts.values()) - counts["out"]
out_path = Path(str(output) + "_out.s")
out_path.write_text(
    f"# n=5 model=out iset=I1 source=w6 k={k}\n"
    + "\n".join(instructions) + "\n"
)
mem = [f"mov S{i}, P{i}" for i in range(5)]
for line in instructions:
    line = re.sub(r"S(\d+)", lambda m: f"S{5+int(m[1])}", line)
    line = re.sub(r"P(\d+)", lambda m: f"S{m[1]}", line)
    if line.startswith("out "):
        j, register = line[4:].split(", ")
        line = f"mov P{j}, {register}"
    mem.append(line)
mem_path = Path(str(output) + "_mem.s")
mem_path.write_text(
    f"# n=5 model=mem iset=I1 source=w6 L={len(mem)} core={k}\n"
    + "\n".join(mem) + "\n"
)
print(json.dumps({"source": str(source), "core": k, "total": len(mem),
                  "counts": dict(counts), "out_file": str(out_path),
                  "mem_file": str(mem_path)}, indent=2))
