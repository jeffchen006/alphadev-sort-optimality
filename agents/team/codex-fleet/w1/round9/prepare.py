"""Prepare new median families. Read old ledgers without rerunning old searches."""
import hashlib,json,os
from collections import Counter
from pathlib import Path
from analyze import load,cones,sim,CASES
HERE=Path(__file__).resolve().parent
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
old=json.loads((HERE.parent/'round4/manifest.json').read_text())
near=json.loads((HERE.parent/'round6/analysis.json').read_text())
rows=[]
for source in [r for r in old if r['cmp']==9]+[r for r in old if r['cmp']==8]:
 path=Path(source['path']);assert hashlib.sha256(path.read_bytes()).hexdigest()==source['sha256']
 names,code,outs=load(path);cs=cones(code,outs)
 assert len(code)==32
 assert all(all(ss[t][r]==sorted(w)[j] for j,(t,r) in outs.items()) for w in CASES for ss in [sim(code,w,len(names))])
 c=sum(z[0]==1 for z in code);kind='c9' if c==9 else 'c8'
 ident=sum(b['kind']==kind for b in rows)
 exclusive=cs[2]-set.union(*(cs[j] for j in (0,1,3,4)))
 rows.append(dict(id=ident,kind=kind,key=f'{kind}_b{ident:02d}',path=str(path),sha256=source['sha256'],
  names=names,code=code,outs=outs,median_cone=sorted(cs[2]),exclusive=sorted(exclusive),
  writes=sorted(t for t in cs[2] if code[t][0]!=1),
  seed_cases=[]))
assert Counter(b['kind'] for b in rows)==dict(c9=26,c8=144)
(HERE/'bases.json').write_text(json.dumps(rows,indent=2)+'\n')
for kind in ('c9','c8'):
 b=[z for z in rows if z['kind']==kind]
 print(kind,'bases',len(b),'exclusive sizes',dict(Counter(len(z['exclusive']) for z in b)),
  'cone sizes',dict(Counter(len(z['median_cone']) for z in b)),flush=True)
