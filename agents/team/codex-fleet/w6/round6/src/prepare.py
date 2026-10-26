from pathlib import Path
import sys, random, json
BASE=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(BASE/'src'));sys.path.insert(0,str(BASE/'round3/src'))
from window_sat import read, concrete, GOALS, OPS, reg
from satrep import emit

def score(p,nr):
 cols,_=concrete(p,nr);selected=[min(cols,key=lambda x:sum(a!=b for a,b in zip(x[2],g))) for g in GOALS]
 err=[sum(a!=b for a,b in zip(x[2],g)) for x,g in zip(selected,GOALS)]
 fail=sum(any(selected[j][2][t]!=GOALS[j][t] for j in range(5)) for t in range(541))
 return fail,sum(err),[(t,r) for t,r,_ in selected]
def tomem(src,dst):
 regs={f'P{i}':f'S{i}' for i in range(5)};body=[f'mov S{i}, P{i}' for i in range(5)]
 for l in Path(src).read_text().splitlines():
  l=l.split('#')[0].strip()
  if not l:continue
  op,d,s=l.replace(',',' ').split()
  if op=='out':body.append(f'mov P{d}, {regs[s]}');continue
  for r in (d,s):
   if r not in regs:regs[r]=f'S{len(regs)}'
  body.append(f'{op} {regs[d]}, {regs[s]}')
 Path(dst).write_text('# n=5 model=mem iset=I1 source=w6-round6\n'+'\n'.join(body)+'\n')
 return len(regs),len(body)
if __name__=='__main__':
 root=BASE.parents[3];rnd=random.Random(62601);rows=[]
 sources=[('net41',root/'agents/team/d7-structure/fam32/net9_41_k32.s'),('near9',BASE/'round5/candidates/fresh31_near.s'),('triple',BASE/'round5/candidates/triple_extrema_13_R6_c3.s'),('c8',BASE/'candidates/c8c_len32_c29288.s')]
 for tag,path in sources:
  p,nr=read(path)
  choices=[]
  for d in range(len(p)) if len(p)==32 else [-1]:
   q=p[:d]+p[d+1:] if d>=0 else p[:]
   sc=score(q,nr);nc=sum(x[0]==1 for x in q);choices.append((sc[1],sc[0],d,nc,q,sc[2]))
  choices.sort(key=lambda x:x[:3])
  for c in (7,8,9):
   cand=[x for x in choices if x[3]==c]
   for i,(err,fail,d,nc,q,w) in enumerate(cand[:2]):
    name=f'{tag}_c{c}_{i}';out=BASE/'round6/seeds'/f'{name}_out.s';mem=BASE/'round6/seeds'/f'{name}_mem.s';emit(q,w,out);r,L=tomem(out,mem)
    rows.append(dict(name=name,out=str(out.relative_to(BASE)),mem=str(mem.relative_to(BASE)),registers=r,L=L,cmp=nc,deleted=d,fail=fail,error=err))
 # Partner-select seeds: alter a select's source to one of an earlier comparison's operands.
 p,nr=read(sources[0][1]);new=[];history=[]
 for t,(op,d,s) in enumerate(p):
  if op==1:history.append((d,s));continue
  if op<2 or len(history)<2:continue
  for a,b in history[:-1]:
   for v in (a,b):
    if v==s or v==d:continue
    q=p[:];q[t]=(op,d,v)
    for delete in [i for i,x in enumerate(q) if x[0]!=1]:
     z=q[:delete]+q[delete+1:];sc=score(z,nr)
     new.append((sc[1],sc[0],t,v,delete,z,sc[2]))
 new.sort(key=lambda x:x[:5]);seen=set()
 for err,fail,t,v,d,q,w in new:
  key=tuple(q)
  if key in seen:continue
  seen.add(key);i=len(seen)-1
  if i>=12:break
  name=f'partner_{i}';out=BASE/'round6/seeds'/f'{name}_out.s';mem=BASE/'round6/seeds'/f'{name}_mem.s';emit(q,w,out);r,L=tomem(out,mem)
  rows.append(dict(name=name,out=str(out.relative_to(BASE)),mem=str(mem.relative_to(BASE)),registers=r,L=L,cmp=9,changed_select=t,newsource=v,deleted=d,fail=fail,error=err))
 (BASE/'round6/artifacts/seeds.json').write_text(json.dumps(rows,indent=2));print(json.dumps(rows,indent=2))
