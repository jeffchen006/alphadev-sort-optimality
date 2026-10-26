"""Freeze current seeds. All writes stay in round4."""
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
OPS = ['mov', 'cmp', 'cmovl', 'cmovle', 'cmovg', 'cmovge']
sources = sorted((ROOT.parent/'w6/round2/verified').glob('*.s'))
sources += sorted((ROOT.parent/'w6/round3/verified').glob('nomov_*.s'))
sources += [ROOT/'verified/palette_c8_k32.s']
rows = []
seen = set()
for source in sources:
    if source.stem.endswith('_mem'):
        continue
    registers = {f'P{i}': i for i in range(5)}
    program = []
    for line in source.read_text().splitlines():
        line = line.split('#')[0].strip()
        if not line or line.startswith('out '):
            continue
        op, d, s = line.replace(',', '').split()
        for r in (d, s):
            if r not in registers:
                registers[r] = len(registers)
        program.append((OPS.index(op), registers[d], registers[s]))
    signature = tuple(program)
    if signature in seen:
        continue
    seen.add(signature)
    index = len(rows)
    target = HERE/'seeds'/f'{index:03d}.txt'
    target.write_text(f'{len(registers)} {len(program)}\n'+''.join(
        f'{OPS[op]} {d} {s}\n' for op, d, s in program))
    rows.append(dict(index=index, source=str(source), seed=str(target),
                     sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
                     program=program, registers=len(registers)))
(HERE/'manifest.json').write_text(json.dumps(rows, indent=2)+'\n')
print(f'frozen_seeds={len(rows)}')
