"""Group memory near misses by comparison operands on strict orders."""
from pathlib import Path
import sys,json,hashlib,itertools
import numpy as np
BASE=Path(__file__).resolve().parents[2]
sys.path[:0]=[str(BASE/'src'),str(BASE/'round6/src')]
from window_sat import CASES,OPS,reg
from mem_to_out import convert
A=np.asarray(CASES,dtype=np.int16);strict=np.flatnonzero(np.max(A,axis=1)==4);P=A[strict];goals=np.sort(A,axis=1).T
perms=list(itertools.permutations(range(5)));idx={tuple(a):i for i,a in enumerate(P)}
transforms=[np.array([idx[tuple((4-p if rev else p)[list(s)])] for p in P]) for rev in range(2) for s in perms]
def analyze(path):
 regs={f'P{i}':i for i in range(5)};vals=[A[:,i].copy() for i in range(5)];flag=np.full(541,3,dtype=np.int16);cmpcols=[];output=[None]*5;k=0
 for l in Path(path).read_text().splitlines():
  l=l.split('#')[0].strip()
  if not l:continue
  op,d,s=l.replace(',',' ').split()
  if op=='out':output[int(d)]=vals[regs[s]].copy();continue
  for r in (d,s):
   if r not in regs:regs[r]=len(vals);vals.append(np.full(541,255,dtype=np.int16))
  a,b=vals[regs[d]],vals[regs[s]];k+=1
  if op=='cmp':
   cmpcols.append(np.array([a[strict],b[strict]],dtype=np.uint8));flag=np.where((a==255)|(b==255),3,np.sign(a-b));continue
  if op=='mov':vals[regs[d]]=b.copy();continue
  yes={'cmovl':flag<0,'cmovle':flag<=0,'cmovg':flag==1,'cmovge':(flag==1)|(flag==0)}[op]
  vals[regs[d]]=np.where(flag==3,np.where(a==b,a,255),np.where(yes,b,a))
 output=np.array(output);failed=np.any(output!=goals,axis=0);errors=int(np.sum(output!=goals))
 raw=b''.join(c.tobytes() for c in cmpcols)
 return k,int(failed.sum()),errors,cmpcols,raw

def canonical(cols):
 best=None
 for n,mp in enumerate(transforms):
  out=[]
  for c in cols:
   x=c[:,mp]
   if n>=120:x=4-x
   a,b=x[0].tobytes(),x[1].tobytes();out.append(min(a,b)+max(a,b))
  key=b''.join(out)
  if best is None or key<best:best=key
 return hashlib.sha256(best).hexdigest()[:24]
clean='--clean' in sys.argv
rows=[];classes={};rawmap={};skipped=0
old=analyze('round5/candidates/fresh31_near.s');oldclass=canonical(old[3])
for source in sorted(Path('round6/candidates').glob('mem*_near_*.s')):
 if source.name.endswith('_out.s'):continue
 target=source.with_name(source.stem+('_clean_out.s' if clean else '_out.s'))
 try:convert(source,target,evaluate=False,clean=clean)
 except ValueError:skipped+=1;continue
 k,fail,error,cols,raw=analyze(target)
 sig=rawmap.get(raw)
 if sig is None:sig=rawmap[raw]=canonical(cols)
 row=dict(source=str(source),file=str(target),k=k,failed_orders=fail,error=error,signature=sig,old_signature=sig==oldclass);rows.append(row)
 if sig not in classes or (fail,error,str(target))<(classes[sig]['failed_orders'],classes[sig]['error'],classes[sig]['file']):classes[sig]=row
retained=sorted(classes.values(),key=lambda x:(x['failed_orders'],x['error'],x['old_signature'],x['signature']))
result=dict(clean=clean,scanned=len(rows)+skipped,converted=len(rows),skipped=skipped,raw_signatures=len(rawmap),classes=len(classes),old_signature=oldclass,representatives=retained)
Path('round6/artifacts/near_inventory_clean.json' if clean else 'round6/artifacts/near_inventory.json').write_text(json.dumps(result,indent=2));Path('round6/artifacts/near_representatives_clean.txt' if clean else 'round6/artifacts/near_representatives.txt').write_text(''.join(x['file']+'\n' for x in retained));print(json.dumps(result,indent=2))
