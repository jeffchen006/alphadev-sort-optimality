"""Freeze the requested 143 w6 variants and the w5 palette form."""
from pathlib import Path
import json, hashlib
HERE=Path(__file__).resolve().parent
ROOT=HERE.parent
OPS=['mov','cmp','cmovl','cmovle','cmovg','cmovge']
sources=sorted((ROOT.parent/'w6/round2/verified').glob('*.s'))+[ROOT/'verified/palette_c8_k32.s']
rows=[]
for source in sources:
    if source.stem.endswith('_mem'):continue
    regs={f'P{i}':i for i in range(5)};p=[]
    for line in source.read_text().splitlines():
        line=line.split('#')[0].strip()
        if not line or line.startswith('out '):continue
        op,d,s=line.replace(',','').split()
        for r in (d,s):
            if r not in regs:regs[r]=len(regs)
        p.append((OPS.index(op),regs[d],regs[s]))
    i=len(rows);seed=HERE/'seeds'/f'{i:03}.txt'
    seed.write_text(f'{len(regs)} {len(p)}\n'+''.join(f'{OPS[o]} {d} {s}\n' for o,d,s in p))
    rows.append(dict(index=i,source=str(source),sha256=hashlib.sha256(source.read_bytes()).hexdigest(),seed=str(seed),registers=len(regs),program=p))
assert len(rows)==144,len(rows)
(HERE/'manifest.json').write_text(json.dumps(rows,indent=2)+'\n')
(HERE/'seed_list.txt').write_text(''.join(r['seed']+'\n' for r in rows))
print(json.dumps(dict(seeds=len(rows),cores=sorted(set(len(r['program']) for r in rows)))))
