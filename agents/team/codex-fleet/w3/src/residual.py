from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
from generate import *
PS=list(PS)
for i,tree in enumerate(trees(tuple(range(15)),4)):
 for orient in ['common','canonical']:
  for pad in ['last','eq']:
   logs=[]
   for x in PS:
    lab=list(range(5));log=[];last=None;t=tree
    while len(log)<4:
     if t is None:ia,ib=last if pad=='last' else (last[0],last[0])
     else:ia,ib=t[:2]
     last=ia,ib;lt=x[ia]<x[ib];a,b=ia,ib
     if orient=='common' and (b==4 or b==2):a,b=b,a
     log.append((x[a],x[b]))
     if t is not None:t=t[2 if lt else 3]
    logs.append(log)
   with open(f'sk/r{i}_{orient}_{pad}.txt','w') as f:
    for j in range(4):f.write('='+''.join(str(l[j][0]) for l in logs)+':='+''.join(str(l[j][1]) for l in logs)+'\n')
s=Path('src/dagx.cpp').read_text()
s=s.replace('static const int N = NN, NT = (NN == 5 ? 120 : NN == 4 ? 24 : 6);','static const int N = NN, NT = 15;')
s=s.replace('do TY.push_back(p); while (next_permutation(p.begin(), p.end()));','do { if (p[0] < p[1] && p[1] < p[3] && p[2] < p[3]) TY.push_back(p); } while (next_permutation(p.begin(), p.end()));')
s=s.replace('return (int)G.size() - total;  // copies among resolved gates','return 0;  // RELAXATION: copies are free')
s=s.replace('emit(order, inpl);','/* no program: copies are free in this relaxation */')
s=s.replace('SOLUTION cost=', 'RELAXED_SOLUTION cost=')
Path('src/dag_relaxed.cpp').write_text(s)
print('generated residual skeletons and free-copy search')
