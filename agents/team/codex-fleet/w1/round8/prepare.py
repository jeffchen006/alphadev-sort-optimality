"""Build two-output rewrite families from both requested base collections."""
import hashlib,json
from collections import Counter
from pathlib import Path
from analyze import load,cones,sim,CASES
HERE=Path(__file__).resolve().parent
repairs=json.loads((HERE.parent/'round7/bases.json').read_text())
near=json.loads((HERE.parent/'round6/manifest.json').read_text())[:15]
rows=[]
for kind,collection in [('repair',repairs),('near',near)]:
 for entry in collection:
  path=Path(entry['path']);names,code,outs=load(path)
  assert hashlib.sha256(path.read_bytes()).hexdigest()==entry['sha256']
  cs=cones(code,outs)
  ident=entry['id'] if kind=='repair' else entry['index']
  failures=Counter()
  for w in CASES:
   ss=sim(code,w,len(names))
   for j,(t,r) in outs.items():
    if ss[t][r]!=sorted(w)[j]:failures[j]+=1
  assert len(code)==(32 if kind=='repair' else 31)
  assert not failures if kind=='repair' else failures=={2:9}
  for neighbour in (1,3):
   pair={2,neighbour};union=cs[2]|cs[neighbour]
   other=set.union(*(cs[j] for j in range(5) if j not in pair))
   exclusive=union-other
   b=dict(id=ident,kind=kind,key=f'{kind}_b{ident:02d}_p{neighbour}2',path=str(path),
    sha256=hashlib.sha256(path.read_bytes()).hexdigest(),names=names,code=code,outs=outs,
    free_outputs=sorted(pair),pair_cone=sorted(union),exclusive=sorted(exclusive),
    pair_writes=sorted(t for t in union if code[t][0]!=1),failures=dict(failures))
   rows.append(b)
(HERE/'bases.json').write_text(json.dumps(rows,indent=2)+'\n')
for kind in ('repair','near'):
 for neighbour in (1,3):
  subset=[b for b in rows if b['kind']==kind and neighbour in b['free_outputs']]
  print(kind,neighbour,'bases',len(subset),'exclusive',dict(Counter(len(b['exclusive']) for b in subset)),
   'comparisons',dict(Counter(sum(b['code'][t][0]==1 for t in b['exclusive']) for b in subset)),flush=True)
