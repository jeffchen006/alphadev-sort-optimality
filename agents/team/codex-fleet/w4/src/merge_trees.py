#!/usr/bin/env python3
import functools,itertools
# Identities 0,1 in A, identities 2,3,4 in B.
orders=[p for p in itertools.permutations(range(5)) if p.index(0)<p.index(1) and p.index(2)<p.index(3)<p.index(4)]
pairs=[(a,b) for a in [0,1] for b in [2,3,4]]
truth=[]
for a,b in pairs:truth.append(sum((p.index(a)<p.index(b))<<i for i,p in enumerate(orders)))
@functools.cache
def count(mask,depth):
 if mask.bit_count()==1:return 1
 if mask.bit_count()>2**depth or depth==0:return 0
 return sum(count(mask&t,depth-1)*count(mask&~t,depth-1) for t in truth if mask&t and mask&~t)
if __name__=='__main__':
 print(orders)
 print('depth4 count',count(1023,4))
 print('states',count.cache_info())

@functools.cache
def trees(mask,depth):
 if mask.bit_count()==1:return [None]
 if mask.bit_count()>2**depth or depth==0:return []
 out=[]
 for qi,t in enumerate(truth):
  if not(mask&t and mask&~t):continue
  for l in trees(mask&t,depth-1):
   for g in trees(mask&~t,depth-1):out.append((qi,l,g))
 return out

def generate():
 import pathlib,sys
 sys.path.insert(0,str(pathlib.Path(__file__).parent));import window
 base=pathlib.Path('sk/merge');base.mkdir(exist_ok=True)
 p,outs,names=window.read('candidates/seed33.s');perms=list(itertools.permutations(range(5)))
 initnames=['P0','P1','P2','P3','P4','S5','S10']
 traces=[window.run(p,outs,ty,names)[1] for ty in perms]
 initial=[tr[15][0] for tr in traces]
 with open(base/'initial.txt','w') as f:
  for n in initnames:f.write(n+' ='+''.join(str(st[n]) for st in initial)+'\n')
 with open(base/'history.txt','w') as f:
  for i in [1,5,9,13]:f.write(''.join(str({-1:1,0:0,1:2}[tr[i][1]]) for tr in traces)+'\n')
 mapping=['P0','P1','P2','S10','P4']
 for ti,tree in enumerate(trees(1023,4)):
  ca=[[] for _ in range(4)];cb=[[] for _ in range(4)]
  for ty,st in zip(perms,initial):
   node=tree
   for level in range(4):
    if node is None:a=b=ty[0]
    else:
     qi,l,g=node;ai,bi=pairs[qi];a,b=st[mapping[ai]],st[mapping[bi]];node=l if a<b else g
    ca[level].append(a);cb[level].append(b)
  with open(base/f't{ti:03}.txt','w') as f:
   for a,b in zip(ca,cb):f.write('='+''.join(map(str,a))+':='+''.join(map(str,b))+'\n')
 print('generated',len(trees(1023,4)))
if __name__=='__main__':generate()
