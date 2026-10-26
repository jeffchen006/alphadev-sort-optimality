#!/usr/bin/env python3
import itertools,pathlib,sys,functools,json
sys.path.insert(0,'src');import window
P=list(itertools.permutations(range(5)))
@functools.cache
def trees(lo,hi,dep):
 if lo==hi:return [None]
 if hi-lo+1>2**dep or dep==0:return []
 return [(q,l,g) for q in range(lo,hi) for l in trees(lo,q,dep-1) for g in trees(q+1,hi,dep-1)]
def networks():
 pairs=list(itertools.combinations(range(4),2));v=[]
 for seq in itertools.product(pairs,repeat=5):
  ok=True
  for x in itertools.product(range(2),repeat=4):
   x=list(x)
   for a,b in seq:x[a],x[b]=min(x[a],x[b]),max(x[a],x[b])
   if x!=sorted(x):ok=False;break
  if ok:v.append(seq)
 return v

def generate():
 base=pathlib.Path('sk/insertion');base.mkdir(exist_ok=True)
 nets=networks();ts=trees(0,4,3);print('networks',len(nets),'trees',len(ts))
 count=0
 for ni,net in enumerate(nets):
  # Orientations retain either original comparator operand in each scratch.
  for ori in range(32):
   pref=[]
   for i,(a,b) in enumerate(net):
    a,b='P'+str(a),'P'+str(b);s='S'+str(i)
    if ori>>i&1:pref.extend([('cmp',a,b),('mov',s,b),('cmovg',b,a),('cmovg',a,s)])
    else:pref.extend([('cmp',a,b),('mov',s,a),('cmovg',a,b),('cmovg',b,s)])
   tag=f'n{ni:02}_o{ori:02}';names=['P'+str(i) for i in range(5)]+['S'+str(i) for i in range(5)]
   traces=[window.run(pref,{},ty,names)[1] for ty in P];initial=[tr[-1][0] for tr in traces]
   window.write(base/(tag+'.s'),pref,{})
   with open(base/(tag+'.initial'),'w') as f:
    for r in names:f.write(r+' ='+''.join(str(st[r]) for st in initial)+'\n')
   with open(base/(tag+'.history'),'w') as f:
    for i in [1,5,9,13,17]:f.write(''.join(str({-1:1,0:0,1:2}[tr[i][1]]) for tr in traces)+'\n')
  # Tree skeleton depends only on sorted four, so share across all prefix orientations/networks.
 for ti,tree in enumerate(ts):
  for pad in range(4):
   ca=[[] for _ in range(3)];cb=[[] for _ in range(3)]
   for ty in P:
    vals=sorted(ty[:4]);e=ty[4];node=tree
    for level in range(3):
     if node is None:q=pad
     else:q,l,g=node;node=l if e<vals[q] else g
     ca[level].append(e);cb[level].append(vals[q])
   with open(base/f't{ti:02}_p{pad}.txt','w') as f:
    for a,b in zip(ca,cb):f.write('='+''.join(map(str,a))+':='+''.join(map(str,b))+'\n')
 print('prefixes',len(nets)*32,'skeletons',len(ts)*4)
if __name__=='__main__':generate()
