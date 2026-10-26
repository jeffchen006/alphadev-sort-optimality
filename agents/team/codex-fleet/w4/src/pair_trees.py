#!/usr/bin/env python3
import itertools,functools,pathlib,sys,json
sys.path.insert(0,'src');import window
P=list(itertools.permutations(range(5)))
orders=[p for p in P if p.index(0)<p.index(1)<p.index(3) and p.index(2)<p.index(3)]
pairs=list(itertools.combinations(range(5),2));truth=[sum((p.index(a)<p.index(b))<<i for i,p in enumerate(orders)) for a,b in pairs]
@functools.cache
def trees(mask,d):
 if mask.bit_count()==1:return (None,)
 if mask.bit_count()>2**d or d==0:return ()
 return tuple((qi,l,g) for qi,t in enumerate(truth) if mask&t and mask&~t for l in trees(mask&t,d-1) for g in trees(mask&~t,d-1))

def main():
 depth=int(sys.argv[1]);base=pathlib.Path(f'sk/pairs{depth}');base.mkdir(exist_ok=True)
 pref=[]
 for a,b,tmp in [('P0','P1','S0'),('P2','P3','S1')]:pref.extend([('cmp',a,b),('mov',tmp,a),('cmovg',a,b),('cmovg',b,tmp)])
 pref.extend([('cmp','P1','P3'),('mov','S2','P0'),('mov','S3','P1'),('cmovg','P0','P2'),('cmovg','P2','S2'),('cmovg','P1','P3'),('cmovg','P3','S3')])
 window.write(base/'prefix.s',pref,{})
 names=['P'+str(i) for i in range(5)]+['S'+str(i) for i in range(4)]
 traces=[window.run(pref,{},ty,names)[1] for ty in P];initial=[tr[-1][0] for tr in traces]
 with open(base/'initial.txt','w') as f:
  for r in names:f.write(r+' ='+''.join(str(st[r]) for st in initial)+'\n')
 with open(base/'history.txt','w') as f:
  for i in [1,5,9]:f.write(''.join(str({-1:1,0:0,1:2}[tr[i][1]]) for tr in traces)+'\n')
 alltrees=trees((1<<15)-1,depth);print('depth',depth,'trees',len(alltrees),flush=True)
 for ti,tree in enumerate(alltrees):
  for pad in range(3):
   ca=[[] for _ in range(depth)];cb=[[] for _ in range(depth)]
   for ty,st in zip(P,initial):
    vals=[st['P'+str(i)] for i in range(5)];node=tree
    for lev in range(depth):
     if node is None:a,b=(vals[0],vals[0]) if pad==0 else (vals[0],vals[1]) if pad==1 else (vals[1],vals[0])
     else:
      qi,l,g=node;ai,bi=pairs[qi];a,b=vals[ai],vals[bi];node=l if a<b else g
     ca[lev].append(a);cb[lev].append(b)
   with open(base/f't{ti:04}_p{pad}.txt','w') as f:
    for a,b in zip(ca,cb):f.write('='+''.join(map(str,a))+':='+''.join(map(str,b))+'\n')
if __name__=='__main__':main()
