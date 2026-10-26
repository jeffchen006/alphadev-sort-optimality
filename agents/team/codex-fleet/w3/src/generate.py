#!/usr/bin/env python3
import sys,json,itertools
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent))
from trees import trees,PS
P=list(itertools.permutations(range(5)))

def prefix(x):
 logs=[]
 def cmp(i,j):logs.append((x[i],x[j]));return x[i]<x[j]
 a,b=(0,1) if cmp(0,1) else (1,0)
 c,d=(2,3) if cmp(2,3) else (3,2)
 if cmp(b,d):pass
 else:a,b,c,d=c,d,a,b
 return [a,b,c,d,4],logs

def run(x,tree,pad='last',orient='common'):
 lab,logs=prefix(x);last=None
 while len(logs)<7:
  if tree is None:
   if pad=='last':ia,ib=last
   elif pad=='eq':ia=ib=last[0]
   else:
    v=int(pad);ia,ib=divmod(v,5)
  else:ia,ib=tree[:2]
  last=(ia,ib)
  lt=x[lab[ia]]<x[lab[ib]]
  a,b=ia,ib
  if orient=='common':
   # Keep e on the left for insertion, c on the left for partner insertion.
   if b==4 or b==2:a,b=b,a
  logs.append((x[lab[a]],x[lab[b]]))
  if tree is not None:tree=tree[2 if lt else 3]
 return logs

def write(logs,fn):
 with open(fn,'w') as f:
  f.write('# w3 enumerated Ford-Johnson residual tree\n')
  for j in range(7):
   f.write('='+''.join(str(log[j][0]) for log in logs)+':='+''.join(str(log[j][1]) for log in logs)+'\n')
if __name__=='__main__':
 ts=trees(tuple(range(15)),4)
 for i,tree in enumerate(ts):
  for orient in ['common','canonical']:
   for pad in ['last','eq']+[str(i*5+j) for i,j in itertools.combinations(range(5),2)]:
    logs=[run(x,tree,pad,orient) for x in P]
    # Validate that seven outcomes distinguish all 120 orders.
    sigs=[tuple((a>b)-(a<b) for a,b in log) for log in logs]
    assert len(set(sigs))==120
    write(logs,f'sk/t{i}_{orient}_{pad}.txt')
 print('generated',len(list(Path('sk').glob('t*.txt'))),'skeletons')
