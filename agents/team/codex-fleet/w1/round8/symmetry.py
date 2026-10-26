"""Canonical exact instruction families under finite machine symmetries.

This is a strict-program implication, not equivalence of the scratch=5 tests.
"""
import hashlib,itertools,json,os
from collections import Counter,defaultdict
from pathlib import Path
from search import family
HERE=Path(__file__).resolve().parent
FLIP={0:0,1:1,2:4,3:5,4:2,5:3,6:6}
def canonical(base,editable,extra=2):
 edit=set(editable);best=None;witness=None
 for perm,rev,orientation in itertools.product(itertools.permutations(range(5)),range(2),range(2)):
  rename={r:perm[r] for r in range(5)}
  def reg(r):
   if r not in rename:rename[r]=len(rename)
   return rename[r]
  free=tuple(sorted(4-j if rev else j for j in base['free_outputs']))
  events=[]
  for t in range(len(base['code'])+1):
   outs=[]
   for jj,(ot,r) in base['outs'].items():
    j=int(jj)
    if ot==t and j not in base['free_outputs']:outs.append((4-j if rev else j,r))
   for j,r in sorted(outs):events.append((7,j,reg(r)))
   if t==len(base['code']):break
   if t in edit:events.append((6,));continue
   op,a,b=base['code'][t]
   if op==1 and orientation:a,b=b,a
   if rev^orientation:op=FLIP[op]
   events.append((op,reg(a),reg(b)))
  result=(len(base['names'])+extra,0 if base['kind']=='near' else 1,free,tuple(events))
  if best is None or result<best:best=result;witness=dict(perm=perm,reverse_values=rev,reverse_comparisons=orientation)
 return best,witness
def main():
 os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
 if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
 bases=json.loads((HERE/'bases.json').read_text());groups=defaultdict(list);records=[]
 for i,b in enumerate(bases):
  key,w=canonical(b,b['exclusive']);digest=hashlib.sha256(repr(key).encode()).hexdigest()
  groups[digest].append(i);records.append(dict(index=i,key=b['key'],canonical=digest,witness=w))
 out=dict(scope='exclusive',classes=list(groups.values()),records=records)
 (HERE/'symmetry.json').write_text(json.dumps(out,indent=2)+'\n')
 print('CLASSES',len(groups),'sizes',dict(Counter(map(len,groups.values()))),flush=True)
if __name__=='__main__':main()
