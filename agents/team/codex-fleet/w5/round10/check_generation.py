"""Independent exact path counts for the bounded pair-swap action family."""
from functools import cache
from itertools import permutations,combinations
from pathlib import Path
import json,time,sys,re

P=list(permutations(range(5)));index={p:i for i,p in enumerate(P)}
actions=[];recipes=[]
for a,b in combinations(range(5),2):
 rest=[i for i in range(5) if i not in (a,b)]
 for companion in (None,*combinations(rest,2)):
  perm=list(range(5));perm[a],perm[b]=b,a
  if companion:
   c,d=companion;perm[c],perm[d]=d,c
  recipes.append((a,b,perm,companion is not None))
  mapping=[]
  for p in P:
   q=list(p)
   if q[a]>q[b]:
    q[a],q[b]=q[b],q[a]
    if companion:
     c,d=companion;q[c],q[d]=q[d],q[c]
   mapping.append(index[tuple(q)])
  actions.append((companion is not None,mapping))

if '--rotations' in sys.argv or '--partner-only' in sys.argv:
 for a,b in combinations(range(5),2):
  c,d,e=[i for i in range(5) if i not in (a,b)]
  for rot in (1,2):
   perm=list(range(5));perm[a],perm[b]=b,a
   perm[c],perm[d],perm[e]=(d,e,c) if rot==1 else (e,c,d)
   recipes.append((a,b,perm,True))
   mapping=[]
   for p in P:
    q=list(p)
    if q[a]>q[b]:
     q[a],q[b]=q[b],q[a];x,y,z=q[c],q[d],q[e]
     q[c],q[d],q[e]=(y,z,x) if rot==1 else (z,x,y)
    mapping.append(index[tuple(q)])
   actions.append((True,mapping))

if '--partner-only' in sys.argv:
 for a,b,perm,special in recipes:
  if not special:continue
  perm=perm.copy();perm[a],perm[b]=a,b
  mapping=[]
  for p in P:
   q=tuple(p[i] for i in perm) if p[a]>p[b] else p
   mapping.append(index[q])
  actions.append((True,mapping))

def advance(mask,mapping):
 out=0
 while mask:
  low=mask&-mask;t=low.bit_length()-1;mask-=low;out|=1<<mapping[t]
 return out

@cache
def count(mask,left,partners):
 size=mask.bit_count()
 if partners<0 or partners>left or size>2**left:return 0
 if left==0:return int(size==1 and partners==0)
 if size==1:return 0
 n=0
 for special,mapping in actions:
  if special>partners or partners-special>left-1:continue
  q=advance(mask,mapping)
  if q!=mask:n+=count(q,left-1,partners-special)
 return n

first=1 if '--start-pair' in sys.argv else 40 if '--start-rotate' in sys.argv else 0
initial=advance((1<<120)-1,actions[first][1]);results={};start=time.monotonic()
for np in range(9 if first else 8):results[np]=count(initial,7,np-int(first!=0))
if first:
 tag='firstpair' if first==1 else 'firstrot';expected={}
 for n in range(2,9):
  log=(Path(__file__).resolve().parent/f'logs/{tag}_generate_{n}.log').read_text()
  expected[n]=int(re.search(r'RESULT .* paths=(\d+)',log)[1])
elif '--partner-only' in sys.argv:
 expected={}
 for n in range(2,8):
  log=(Path(__file__).resolve().parent/f'logs/only_generate_{n}.log').read_text()
  expected[n]=int(re.search(r'RESULT .* paths=(\d+)',log)[1])
else:expected=({2:966,3:744,4:180,5:0,6:0,7:0} if '--rotations' in sys.argv else {2:582,3:444,4:108,5:0,6:0,7:0})
assert all(results[k]==v for k,v in expected.items()),results
summary=dict(path_counts=results,cache=str(count.cache_info()),wall_seconds=time.monotonic()-start,
             compared_counts=expected,matched=True)
name=(('firstpair_crosscheck.json' if first==1 else 'firstrot_crosscheck.json') if first else 'partner_only_crosscheck.json' if '--partner-only' in sys.argv else 'rotation_crosscheck.json' if '--rotations' in sys.argv else 'generation_crosscheck.json')
path=Path(__file__).resolve().parent/name;path.write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(summary,indent=2))
