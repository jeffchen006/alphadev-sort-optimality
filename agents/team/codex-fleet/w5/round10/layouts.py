"""Optimize copies in each source DAG. This fixes the source value graph."""
from pathlib import Path
import collections,json,sys
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE/'src'))
from fixed_route import route
from route import verify

steps=[]
for a in range(5):
 for b in range(a+1,5):
  perm=list(range(5));perm[a],perm[b]=b,a;steps.append((a,b,perm))
  for c in range(5):
   for d in range(c+1,5):
    if c in (a,b) or d in (a,b):continue
    p=perm.copy();p[c],p[d]=d,c;steps.append((a,b,p))
for a in range(5):
 for b in range(a+1,5):
  r=[i for i in range(5) if i not in (a,b)]
  for rot in (1,2):
   p=list(range(5));p[a],p[b]=b,a
   p[r[0]],p[r[1]],p[r[2]]=(r[1],r[2],r[0]) if rot==1 else (r[2],r[0],r[1])
   steps.append((a,b,p))
for a,b,perm in steps.copy():
 if any(perm[i]!=i for i in range(5) if i not in (a,b)):
  p=perm.copy();p[a],p[b]=a,b;steps.append((a,b,p))

def graph(recipe):
 wires=list(range(5));code=[];nn=5
 for op in recipe:
  a,b,perm=steps[op];code.append((1,wires[a],wires[b]));old=wires.copy()
  for d,s in enumerate(perm):
   if d==s:continue
   code.append((3,old[d],old[s]));wires[d]=nn;nn+=1
 return code

tag=sys.argv[1] if len(sys.argv)>1 else 'layouts'
manifest=json.loads((HERE/'generated_manifest.json').read_text());unique={}
for row in manifest:unique.setdefault(row['canonical_sha256'],row)
records=[];hist=collections.Counter();best=None
for row in unique.values():
 for fold in (False,True):
  result=route(graph(row['ops']),fold);assert result is not None,row['file']
  rec=dict(source=row['file'],canonical_sha256=row['canonical_sha256'],fold=fold,**result)
  records.append(rec);hist[result['cost']]+=1
  if best is None or result['cost']<best['cost']:best=rec
  if result['cost']<=31:rec['verification']=verify(result['lines'],f'{tag}_target_{len(records)}')
if best:
 best['verification']=verify(best['lines'],f'{tag}_control_k{best["cost"]}')
(HERE/(tag+'_records.json')).write_text(json.dumps(records,indent=2)+'\n')
summary=dict(skeletons=len(unique),layouts=len(records),histogram=dict(sorted(hist.items())),best=best)
(HERE/(tag+'_summary.json')).write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='best'},indent=2))
print('BEST',best['cost'],best['source'],best['verification'])
