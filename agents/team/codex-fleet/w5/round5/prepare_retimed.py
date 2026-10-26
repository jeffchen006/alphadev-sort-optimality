from pathlib import Path
import hashlib,json
HERE=Path(__file__).resolve().parent
OPS=['mov','cmp','cmovl','cmovle','cmovg','cmovge']
rows=[]
for source in sorted((HERE/'candidates').glob('retime_*_neutral.s')):
    regs={f'P{i}':i for i in range(5)};p=[]
    for line in source.read_text().splitlines():
        line=line.split('#')[0].strip()
        if not line or line.startswith('out '):continue
        op,d,s=line.replace(',','').split()
        for r in (d,s):
            if r not in regs:regs[r]=len(regs)
        p.append((OPS.index(op),regs[d],regs[s]))
    i=len(rows);seed=HERE/'seeds'/f'retimed_{i:03}.txt'
    seed.write_text(f'{len(regs)} {len(p)}\n'+''.join(f'{OPS[o]} {d} {s}\n' for o,d,s in p))
    rows.append(dict(index=i,source=str(source),sha256=hashlib.sha256(source.read_bytes()).hexdigest(),seed=str(seed),program=p,registers=len(regs)))
assert len(rows)==144
(HERE/'retimed_manifest.json').write_text(json.dumps(rows,indent=2)+'\n')
(HERE/'retimed_list.txt').write_text(''.join(r['seed']+'\n' for r in rows))
print(json.dumps(dict(retimed_seeds=len(rows))))
