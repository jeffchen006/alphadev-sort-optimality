"""Prepare immutable base manifests and the router data without rerunning old searches."""
import hashlib
import importlib.util
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[5]
HERE=Path(__file__).resolve().parent
WORK=HERE.parent
spec=importlib.util.spec_from_file_location('analyze', WORK/'round3/analyze.py')
analyze=importlib.util.module_from_spec(spec)
spec.loader.exec_module(analyze)
paths=sorted((WORK.parent/'w6/round2/verified').glob('*.s'))
paths.append(WORK.parent/'w6/candidates/c8c_len32_c29288.s')
paths+=sorted((ROOT/'agents/team/d7-structure/fam32').glob('*k32.s'))
assert len(paths)==170,(ROOT,len(paths))
rows=[]
for p in paths:
    lines=[]
    regs={f'P{i}':i for i in range(5)}
    names=list(regs)
    for raw in p.read_text().splitlines():
        z=raw.split('#')[0].replace(',',' ').split()
        if not z: continue
        if z[0]=='out':
            lines.append((6,int(z[1]),regs[z[2]]))
        else:
            for r in z[1:]:
                if r not in regs:
                    regs[r]=len(names)
                    names.append(r)
            lines.append((analyze.OPS.index(z[0]),regs[z[1]],regs[z[2]]))
    k=sum(op!=6 for op,d,s in lines)
    assert k==32,(p,k)
    assert 'S999' not in names and len(names)<39
    rows.append(dict(path=str(p),name=p.stem,sha256=hashlib.sha256(p.read_bytes()).hexdigest(),
                     registers=names,code=lines,cmp=sum(op==1 for op,d,s in lines)))
(HERE/'manifest.json').write_text(json.dumps(rows,indent=2)+'\n')
with (HERE/'bases.txt').open('w') as f:
    print(len(rows),file=f)
    for r in rows:
        print(r['name'],len(r['registers']),len(r['code']),file=f)
        print(*r['registers'],file=f)
        for ins in r['code']: print(*ins,file=f)
print('BASES',len(rows),'c8',sum(r['cmp']==8 for r in rows),'c9',sum(r['cmp']==9 for r in rows))
