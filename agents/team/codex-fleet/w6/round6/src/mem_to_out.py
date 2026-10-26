"""Convert programs with five loads and five stores into the out model.

A load must occur before that memory cell's store. Each input and output occurs
once. All loads must precede the first write to the loaded scratch register.
"""
from pathlib import Path
import sys,json
BASE=Path(__file__).resolve().parents[2]
sys.path[:0]=[str(BASE/'src'),str(BASE/'round3/src')]
from window_sat import OPS,GOALS,concrete,reg
from satrep import emit

def convert(source,target,evaluate=True,clean=False):
 lines=[]
 for l in Path(source).read_text().splitlines():
  l=l.split('#')[0].strip()
  if l:lines.append(tuple(l.replace(',',' ').split()))
 if clean:
  live={f'P{i}' for i in range(5)};flags=False;kept=[]
  for op,d,s in reversed(lines):
   if op=='cmp':
    if not flags:continue
    flags=False;live.update((d,s))
   elif d not in live:continue
   elif op=='mov':live.remove(d);live.add(s)
   else:live.add(s);flags=True
   kept.append((op,d,s))
  lines=list(reversed(kept))
 registers={};loaded=set();stored=set();core=[];snap=[];nextreg=5
 for op,d,s in lines:
  if d.startswith('P') or d.startswith('M'):
   if op!='mov' or d in stored or s not in registers:raise ValueError('not a simple store')
   stored.add(d);snap.append((int(d[1:]),len(core)-1,registers[s]));continue
  if s.startswith('P') or s.startswith('M'):
   if op!='mov' or s in loaded or s in stored or d in registers:raise ValueError('not an initial load')
   loaded.add(s);registers[d]=int(s[1:]);continue
  for r in (d,s):
   if r not in registers:registers[r]=nextreg;nextreg+=1
  core.append((OPS.index(op),registers[d],registers[s]))
 if len(loaded)!=5 or len(stored)!=5:raise ValueError('not five loads and stores')
 assert len(lines)==len(core)+10
 w=[None]*5
 for j,t,r in snap:w[j]=(t,r)
 emit(core,w,target)
 if not evaluate:return dict(file=str(target),source=str(source),k=len(core))
 cols,states=concrete(core,nextreg)
 actual=[states[t+1][0][r] for t,r in w]
 fail=sum(any(actual[j][t]!=GOALS[j][t] for j in range(5)) for t in range(541))
 return dict(file=str(target),source=str(source),k=len(core),failed_orders=fail,cmp=sum(x[0]==1 for x in core))
if __name__=='__main__':
 rows=[]
 for p in sorted(Path('round6/candidates').glob('mem*_near_*.s')):
  dest=p.with_name(p.stem+'_out.s')
  try:rows.append(convert(p,dest))
  except ValueError:pass
 Path('round6/artifacts/mem_near_out.json').write_text(json.dumps(rows,indent=2));print('Converted',len(rows))
