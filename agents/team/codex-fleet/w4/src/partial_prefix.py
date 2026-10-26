#!/usr/bin/env python3
import sys,itertools,pathlib
sys.path.insert(0,'src');import window
n=int(sys.argv[1]);p,outs,names=window.read('candidates/seed33.s');ps=list(itertools.permutations(range(5)))
traces=[window.run(p,outs,ty,names)[1] for ty in ps]
ini=set('P'+str(i) for i in range(5))
for op,d,s in p[:n]:
 if op=='mov':ini.add(d)
ini=[r for r in names if r in ini];base=pathlib.Path(f'sk/prefix{n}');base.mkdir(exist_ok=True)
with open(base/'initial.txt','w') as f:
 for r in ini:f.write(r+' ='+''.join(str(tr[n][0][r]) for tr in traces)+'\n')
with open(base/'history.txt','w') as f:
 for i,(op,_,_) in enumerate(p[:n],1):
  if op=='cmp':f.write(''.join(str({-1:1,0:0,1:2}[tr[i][1]]) for tr in traces)+'\n')
with open(base/'skel.txt','w') as f:
 for i,(op,a,b) in enumerate(p[n:],n):
  if op=='cmp':f.write('='+''.join(str(tr[i][0][a]) for tr in traces)+':='+''.join(str(tr[i][0][b]) for tr in traces)+'\n')
