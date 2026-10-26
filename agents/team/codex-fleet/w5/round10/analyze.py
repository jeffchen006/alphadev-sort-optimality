"""Independent trace, symmetry, and overlap checks for partner8 output."""
import os
os.environ.update(OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1',MKL_NUM_THREADS='1')
from pathlib import Path
from itertools import permutations,product
import json,hashlib,re
import numpy as np

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[5]
P=np.array(list(permutations(range(5))),dtype=np.uint8)
W=np.array([x for x in product(range(5),repeat=5) if set(x)==set(range(max(x)+1))],dtype=np.uint8)
pi={tuple(p):i for i,p in enumerate(P)}
maps=np.array([[pi[tuple(t[p])] for t in P] for p in P],dtype=np.int32)
steps=[]
for a in range(5):
 for b in range(a+1,5):
  steps.append((a,b,-1,-1))
  for c in range(5):
   for d in range(c+1,5):
    if c not in (a,b) and d not in (a,b):steps.append((a,b,c,d))
for a in range(5):
 for b in range(a+1,5):
  rest=tuple(i for i in range(5) if i not in (a,b))
  for rot in (1,2):steps.append((a,b,*rest,rot))
for step in steps.copy():
 if step[2]>=0:
  steps.append((*step,-1,0,False) if len(step)==4 else (*step,False))

def apply_step(r,op):
 step=steps[op];a,b,c,d=step[:4];m=r[:,a]>r[:,b]
 if len(step)<7 or step[6]:r[m,a],r[m,b]=r[m,b].copy(),r[m,a].copy()
 if c<0:return
 if len(step)==4 or step[5]==0:r[m,c],r[m,d]=r[m,d].copy(),r[m,c].copy()
 else:
  e,rot=step[4:6];old=r[m][:,[c,d,e]].copy()
  r[m,c],r[m,d],r[m,e]=(old[:,1],old[:,2],old[:,0]) if rot==1 else (old[:,2],old[:,0],old[:,1])

def ordered(sk):
 out=np.array(sk,dtype=np.uint8).copy()
 for j in range(len(out)):
  if out[j,1].tobytes()<out[j,0].tobytes():out[j]=out[j,::-1]
 return out

def orbit(sk):
 a=np.array(sk)
 ans=[]
 for m in maps:
  ans.append(ordered(a[:,:,m]))
  ans.append(ordered(4-a[:,:,119-m]))
 return ans

def canonical(sk):return min((x+48).tobytes() for x in orbit(sk))
def sha(b):return hashlib.sha256(b).hexdigest()

def program_trace(path):
 ops=[]
 for line in path.read_text().splitlines():
  line=line.split('#')[0].strip()
  if not line:continue
  op,a,b=line.replace(',','').split()
  if op!='out':ops.append((op,a,b))
 if sum(op=='cmp' for op,a,b in ops)!=8:return None
 reg={f'P{i}':P[:,i].copy() for i in range(5)}
 flags=np.zeros(120,dtype=np.int8);sk=[]
 for op,a,b in ops:
  x=reg.get(a,np.full(120,7,dtype=np.uint8));y=reg.get(b,np.full(120,7,dtype=np.uint8))
  if op=='cmp':
   if np.any(x==7)|np.any(y==7):raise ValueError(f'undefined comparison {path}')
   sk.append((x.copy(),y.copy()));flags=np.where(x<y,1,np.where(x>y,2,0))
  elif op=='mov':reg[a]=y.copy()
  else:
   active={'cmovl':flags==1,'cmovle':flags!=2,'cmovg':flags==2,'cmovge':flags!=1}[op]
   reg[a]=np.where(active,y,x)
 return np.array(sk,dtype=np.uint8)

def read_skeleton(path):
 rows=[]
 for line in path.read_text().splitlines():
  if line.startswith('#') or not line.strip():continue
  a,b=line.split(':');rows.append([[int(x) for x in a[1:]],[int(x) for x in b[1:]]])
 return np.array(rows,dtype=np.uint8)

sources={Path(x['source']) for x in json.loads((HERE.parent/'round5/manifest.json').read_text())}
sources.update((HERE.parent.parent/'w6/verified').glob('*.s'))
sources.update((HERE.parent/'verified').glob('*.s'))
sources.update(Path(x['source']) for x in json.loads((HERE.parent/'round4/novel_manifest.json').read_text()))
known={};source_records=[]
for source in sorted(sources):
 if '_mem' in source.stem:continue
 try:sk=program_trace(source)
 except Exception as e:
  source_records.append({'file':str(source),'error':str(e)});continue
 if sk is None:continue
 key=canonical(sk)
 known.setdefault(key,{'file':str(source),'sk':sk})
 source_records.append({'file':str(source),'sha256':sha(source.read_bytes()),'key':sha(key)})
(HERE/'known_manifest.json').write_text(json.dumps(source_records,indent=2)+'\n')

pairids={}
def ids(sk):
 out=[]
 for pair in ordered(sk):
  k=pair.tobytes()
  if k not in pairids:pairids[k]=len(pairids)
  out.append(pairids[k])
 return out
known_orbits=np.array([ids(x) for v in known.values() for x in orbit(v['sk'])],dtype=np.int32)
prior=set()
closed=HERE.parent.parent/'w13/closed.txt'
if closed.exists():prior=set(closed.read_text().split())
reserved={}
for mf in (HERE.parent.parent/'w13/sk').glob('c8*/manifest.jsonl'):
 for line in mf.read_text().splitlines():
  rr=json.loads(line);p=HERE.parent.parent/'w13'/rr['file']
  reserved[sha(canonical(read_skeleton(p)))]=str(p)
unique={};records=[]
for directory in sorted((HERE/'skeletons').iterdir()):
 for line in (directory/'manifest.jsonl').read_text().splitlines():
  rec=json.loads(line);path=directory/rec['file'];sk=read_skeleton(path)
  r=P.copy();calc=[]
  for op in rec['ops']:
   a,b=steps[op][:2];calc.append([r[:,a].copy(),r[:,b].copy()]);apply_step(r,op)
  assert np.array_equal(calc,sk),(path,'skeleton trace mismatch')
  assert np.all(r==r[0]),(path,'strict permutation failure')
  w=W.copy()
  for op in rec['ops']:
   apply_step(w,op)
  # The final wire permutation is fixed by the strict-order test.
  sorted_w=w[:,np.argsort(r[0])]
  ties_bad=int(np.count_nonzero(np.any(sorted_w!=np.sort(W,axis=1),axis=1)))
  key=canonical(sk);keyhash=sha(key);v=np.array(ids(sk),dtype=np.int32)
  distance=int(np.min(np.count_nonzero(known_orbits!=v,axis=1))) if len(known_orbits) else 8
  rec.update(file=str(path.relative_to(HERE)),sha256=sha(path.read_bytes()),canonical_sha256=keyhash,
             known_match=key in known,known_witness=known.get(key,{}).get('file'),
             min_block_distance=distance,weak_order_failures=ties_bad,
             w13_hash_match=keyhash in prior,w13_reserved=reserved.get(keyhash))
  if key in unique:rec['duplicate_of']=unique[key]['file']
  else:unique[key]=rec
  records.append(rec)
  if len(records)%100==0:print('TRACE_CHECKED',len(records),flush=True)
(HERE/'generated_manifest.json').write_text(json.dumps(records,indent=2)+'\n')
queue=[r for r in unique.values() if not r['known_match'] and not r['w13_hash_match'] and not r['w13_reserved']]
queue.sort(key=lambda r:(-r['min_block_distance'],r['required'],r['nonlattice'],r['file']))
for i,r in enumerate(queue):r['index']=i
(HERE/'queue.json').write_text(json.dumps(queue,indent=2)+'\n')
summary={'known_sources':len(source_records),'known_classes':len(known),'generated':len(records),
         'unique':len(unique),'known_matches':sum(r['known_match'] for r in unique.values()),
         'weak_order_failing_structures':sum(r['weak_order_failures']>0 for r in unique.values()),
         'queue':len(queue),'distance_histogram':{str(d):sum(r['min_block_distance']==d for r in queue) for d in range(9)},
         'w13_closed_exists':closed.exists(),'w13_reserved_classes':len(reserved),
         'w13_reserved_matches':sum(bool(r['w13_reserved']) for r in unique.values())}
(HERE/'analysis_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(summary,indent=2))
