import json,itertools,hashlib
from pathlib import Path
HERE=Path(__file__).resolve().parent
WORK=HERE.parent
OPS=['mov','cmp','cmovl','cmovle','cmovg','cmovge']
CASES=[w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(max(w)+1))]
def load(path):
 names=[f'P{i}' for i in range(5)]; code=[];outs={}
 for ln in path.read_text().splitlines():
  if not ln or ln.startswith('#'):continue
  op,a,b=ln.replace(',',' ').split()
  for r in ([b] if op=='out' else [a,b]):
   if r not in names:names.append(r)
  if op=='out':outs[int(a)]=(len(code),names.index(b))
  else:code.append((OPS.index(op),names.index(a),names.index(b)))
 return names,code,outs
def cond(op,flag):
 lt,eq=flag
 return op==0 or (lt if op==2 else lt or eq if op==3 else not(lt or eq) if op==4 else not lt if op==5 else False)
def sim(code,w,r):
 regs=list(w)+[5]*(r-5);flag=(False,True);snaps=[list(regs)]
 for op,a,b in code:
  if op==1:flag=(regs[a]<regs[b],regs[a]==regs[b])
  elif op!=6 and cond(op,flag):regs[a]=regs[b]
  snaps.append(list(regs))
 return snaps

def cones(code,outs):
 # Include flag producers and both value alternatives of each cmov.
 deps=[set() for _ in range(20)];flag=set(); cs=[set() for _ in range(5)]
 for t in range(len(code)+1):
  for j,(ot,r) in outs.items():
   if ot==t:cs[j]=set(deps[r])
  if t==len(code):break
  op,a,b=code[t]
  if op==1:flag=deps[a]|deps[b]|{t}
  elif op==0:deps[a]=deps[b]|{t}
  else:deps[a]=deps[a]|deps[b]|flag|{t}
 return cs

def main():
 ledger=json.loads((WORK/'round6/pass_ledger.json').read_text()); bases=[]
 for i in range(16):
  row=next(x for x in ledger if x['model']=='out' and Path(x['path']).name.endswith(f'b{i:02d}.s') and 'fixed_' in x['path'])
  path=Path(row['path']);names,code,outs=load(path);cs=cones(code,outs)
  med=cs[2];other=set.union(*(cs[j] for j in (0,1,3,4)));exc=med-other
  assert len(code)==32
  assert all(all(sim(code,w,len(names))[t][r]==sorted(w)[j] for j,(t,r) in outs.items()) for w in CASES)
  writes=sorted(t for t in med if code[t][0]!=1)
  base=dict(id=i,path=str(path),sha256=hashlib.sha256(path.read_bytes()).hexdigest(),names=names,code=code,outs=outs,median_cone=sorted(med),exclusive=sorted(exc),writes=writes)
  bases.append(base)
  print(i,'median',len(med),'exclusive',sorted(exc),'writes',writes,flush=True)
 (HERE/'bases.json').write_text(json.dumps(bases,indent=2)+'\n')
if __name__=='__main__':main()
