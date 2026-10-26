from pathlib import Path
import json

ROOT = Path('/path/to/repo')
HERE = Path(__file__).resolve().parents[1]
paths = sorted((ROOT/'agents/team/d7-structure/fam32').glob('*.s'))
paths += sorted((ROOT/'programs/found').glob('upper_sort5_*k32*'))
paths += [ROOT/'programs/found/sat_sort5_k32.s']
manifest = []
for i, p in enumerate(paths):
    ins = []
    regs = {f'P{j}':j for j in range(5)}
    for line in p.read_text().splitlines():
        line = line.split('#')[0].strip()
        if not line or line.startswith('out '): continue
        op, a, b = line.replace(',', '').split()
        for r in (a,b):
            if r not in regs: regs[r] = len(regs)
        ins.append((op, regs[a], regs[b]))
    if len(ins) != 32: raise ValueError((p,len(ins)))
    dest = HERE/'seeds'/f'{i:02d}_{p.stem}.txt'
    dest.write_text(f'{len(regs)} {len(ins)}\n' + ''.join(f'{o} {a} {b}\n' for o,a,b in ins))
    manifest.append({'index':i,'source':str(p),'seed':str(dest),'registers':len(regs)})
(HERE/'seeds/manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(f'Prepared {len(paths)} seeds')
