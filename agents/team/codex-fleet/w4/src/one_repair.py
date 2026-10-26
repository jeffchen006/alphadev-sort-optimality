#!/usr/bin/env python3
import sys,itertools,numpy as np,pathlib,subprocess
sys.path.insert(0,'src');import window
fn=sys.argv[1];p,o,n=window.read(fn);types=[v for v in itertools.product(range(5),repeat=5) if set(v)==set(range(max(v)+1))]
tr=[window.run(p,o,ty,n)[1] for ty in types];want=np.array([sorted(ty)[1] for ty in types]);count=0
for at in range(15,len(p)+1):
 states={r:np.array([t[at][0][r] for t in tr]) for r in n};fl=np.array([t[at][1] for t in tr]);conds={'cmovl':fl<0,'cmovle':fl<=0,'cmovg':fl>0,'cmovge':fl>=0,'mov':np.ones(len(types),bool)}
 for op,mask in conds.items():
  for a,b in itertools.permutations(n,2):
   v=np.where(mask,states[b],states[a])
   if not np.array_equal(v,want):continue
   q=p[:at]+[(op,a,b)]+p[at:];oo={t+(t>at):[(j,r) for j,r in os if j!=1] for t,os in o.items()};oo.setdefault(at+1,[]).append((1,a))
   if any(window.run(q,oo,ty,n)[0]!=sorted(ty) for ty in types):continue
   dest=f'candidates/repair32_{count}.s';window.write(dest,q,oo);jr=subprocess.run(['python3','/path/to/repo/shared/judge.py',dest,'--strict','--model','out'],capture_output=True,text=True);pathlib.Path(f'logs/repair32_{count}.judge').write_text(jr.stdout+jr.stderr);print(at,op,a,b,jr.stdout.strip(),flush=True);count+=1
print('repaired',count)
