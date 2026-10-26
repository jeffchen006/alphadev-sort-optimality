from pathlib import Path
import sys,json,itertools,hashlib
BASE=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(BASE/'src'))
from window_sat import read,concrete,CASES,GOALS
strict=[t for t,a in enumerate(CASES) if len(set(a))==5]
def lattice(col):
 phi={}
 for i in strict:
  a=CASES[i];v=col[i]
  if v is None:return None
  for t in range(1,5):
   mask=sum(1<<j for j,x in enumerate(a) if x>=t);b=v>=t
   if mask in phi and phi[mask]!=b:return False
   phi[mask]=b
 for s,b in phi.items():
  for t,c in phi.items():
   if s&t==s and b and not c:return False
 return True
rows=[]
for src in sorted(Path('round6/seeds').glob('*_out.s')):
 p,nr=read(src);cols,states=concrete(p,nr)
 nlat=[]
 for i,(op,d,s) in enumerate(p):
  if op!=1:continue
  for side,r in enumerate((d,s)):
   value=lattice(states[i][0][r])
   if value is False:nlat.append([i,side])
 selected=[min(cols,key=lambda x:sum(a!=b for a,b in zip(x[2],g))) for g in GOALS]
 fail=sum(any(selected[j][2][t]!=GOALS[j][t] for j in range(5)) for t in range(541))
 rows.append(dict(file=str(src),k=len(p),cmp=sum(x[0]==1 for x in p),failed_orders=fail,nonlattice_operands=nlat))
Path('round6/artifacts/seed_analysis.json').write_text(json.dumps(rows,indent=2))
print(json.dumps(rows,indent=2))
