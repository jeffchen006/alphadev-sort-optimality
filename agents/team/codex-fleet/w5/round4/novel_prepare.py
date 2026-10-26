"""Freeze one saved k=32 program for each new full comparison-column class."""
from pathlib import Path
import hashlib,json
HERE=Path(__file__).resolve().parent
(HERE/'novel_seeds').mkdir(exist_ok=True)
rows=json.loads((HERE/'comparison_structures.json').read_text())['rows']
seen=set();seeds=[]
for row in rows:
    if not row['new_full'] or row['signature']in seen:continue
    seen.add(row['signature']);source=Path(row['file'])
    registers={f'P{i}':i for i in range(5)};body=[]
    for line in source.read_text().splitlines():
        line=line.split('#')[0].strip()
        if not line or line.startswith('out '):continue
        op,d,s=line.replace(',','').split()
        for r in(d,s):
            if r not in registers:registers[r]=len(registers)
        body.append(f'{op} {registers[d]} {registers[s]}')
    assert len(body)==32
    target=HERE/'novel_seeds'/f'{len(seeds):03d}.txt'
    target.write_text(f'{len(registers)} 32\n'+'\n'.join(body)+'\n')
    seeds.append(dict(source=str(source),seed=str(target),signature=row['signature'],registers=len(registers),sha256=hashlib.sha256(source.read_bytes()).hexdigest()))
(HERE/'novel_manifest.json').write_text(json.dumps(seeds,indent=2)+'\n')
(HERE/'novel_seed_list.txt').write_text(''.join(r['seed']+'\n' for r in seeds))
print(json.dumps(dict(seeds=len(seeds))))
