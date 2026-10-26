#!/usr/bin/env python3
import pathlib,itertools,sys,json
sys.path.insert(0,'src');import window
perms=list(itertools.permutations(range(5)));root=pathlib.Path('/path/to/repo/programs/out');base=pathlib.Path('sk/insertion_alpha');base.mkdir(exist_ok=True)
meta=[]
for fn in root.glob('alphadev_sort4*.s'):
 p,o,n=window.read(fn)
 if sum(op=='cmp' for op,_,_ in p)!=5:continue
 traces=[window.run(p,o,ty,n)[1] for ty in perms];initial=[tr[-1][0] for tr in traces]
 initialized=set('P'+str(i) for i in range(5))
 for op,a,b in p:
  if op=='mov':initialized.add(a)
 names=[r for r in n if r in initialized]
 tag=fn.stem
 window.write(base/(tag+'.s'),p,{})
 with open(base/(tag+'.initial'),'w') as f:
  for r in names:f.write(r+' ='+''.join(str(st[r]) for st in initial)+'\n')
 with open(base/(tag+'.history'),'w') as f:
  for i,(op,_,_) in enumerate(p,1):
   if op=='cmp':f.write(''.join(str({-1:1,0:0,1:2}[tr[i][1]]) for tr in traces)+'\n')
 meta.append({'name':tag,'length':len(p)})
(base/'meta.json').write_text(json.dumps(meta,indent=2));print(meta)
