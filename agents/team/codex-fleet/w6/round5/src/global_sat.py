"""Synthesize a fresh fixed-block 31-instruction core. No edit-distance bound."""
import argparse,itertools,json,random,sys,time
from pathlib import Path
HERE=Path(__file__).resolve().parents[2]
ROOT=HERE.parents[3]
sys.path[:0]=[str(ROOT/'agents/sat'),str(HERE/'src'),str(HERE/'round3/src')]
from rank_encode import RankEnc
from window_sat import OPS,CASES,GOALS,concrete,read
from satrep import emit
from pysat.solvers import Solver
ap=argparse.ArgumentParser();ap.add_argument('output');ap.add_argument('--registers',type=int,default=7);ap.add_argument('--cmps',default='0,4,8,12,16,20,24,28');ap.add_argument('--prefix',type=int,default=4);ap.add_argument('--seed',type=int,default=5);ap.add_argument('--control');ap.add_argument('--solver',default='cadical195');a=ap.parse_args()
k=31;nr=a.registers;start=time.monotonic();cmp=set(map(int,a.cmps.split(',')))
first=[(1,0,1),(0,5,0),(4,0,1),(4,1,5), (1,2,3),(0,5,2),(4,2,3),(4,3,5)]
control=None
if a.control:
 control,_=read(a.control); k=len(control)
e=RankEnc(5,k,R=nr,iset='I1',outmode='snap',rules=())
domains=[];destinations=[];sources=[]
for i in range(k):
 fixed=control[i] if control else first[i] if i<a.prefix else None
 domain=[OPS[fixed[0]]] if fixed else ['cmp'] if i in cmp else [o for o in OPS if o!='cmp']
 domains.append(domain);destinations.append(fixed[1] if fixed else None);sources.append(fixed[2] if fixed else None)
 e.cl(*[e.op[i][o] for o in domain])
 if fixed:e.cl(e.d[i][fixed[1]]);e.cl(e.s[i][fixed[2]])
 # These are search restrictions, not a completeness claim.
 if not fixed:
  for r in range(nr): e.cl(-e.d[i][r],-e.s[i][r])
  if i in cmp:
   for r in range(nr):
    for s in range(r):e.cl(-e.d[i][r],-e.s[i][s])
e.configure([],domains,destinations,sources)
rng=random.Random(a.seed)
strict=[i for i,c in enumerate(CASES) if len(set(c))==5]
chosen=set(rng.sample(strict,6)+rng.sample(range(541),4))
if control:chosen=set(range(541))
for t in sorted(chosen):e.add_type(CASES[t])
with Solver(name=a.solver) as solver:
 pushed=0
 for iteration in itertools.count():
  solver.append_formula(e.clauses[pushed:]);pushed=len(e.clauses)
  print(json.dumps({'step':'solve','iteration':iteration,'cases':len(chosen),'variables':e.nvars,'clauses':pushed,'seconds':time.monotonic()-start}),flush=True)
  if not solver.solve():
   print(json.dumps({'status':'UNSAT','seconds':time.monotonic()-start}),flush=True);break
  program,out=e.decode(solver.get_model());q=[(OPS.index(o),d,s) for o,d,s in program]
  cols,_=concrete(q,nr);witness=[];added=set();errors=[]
  for j,goal in enumerate(GOALS):
   exact=[(t,r) for t,r,col in cols if col==goal];witness.append(exact[0] if exact else None)
   errors.append(min(sum(x!=y for x,y in zip(col,goal)) for t,r,col in cols))
   eligible=[col for t,r,col in cols if all(col[t]==goal[t] for t in chosen)]
   for _ in range(3):
    if exact or not eligible:break
    counts={t:sum(col[t]!=goal[t] for col in eligible) for t in range(541) if t not in chosen|added}
    if not counts or max(counts.values())==0:break
    t=max(counts,key=counts.get);added.add(t);eligible=[col for col in eligible if col[t]==goal[t]]
  print(json.dumps({'step':'candidate','iteration':iteration,'errors':errors,'added':sorted(added)}),flush=True)
  if all(w is not None for w in witness):
   emit(q,witness,a.output);print(json.dumps({'status':'CANDIDATE','file':a.output}),flush=True);break
  if not added:
   emit(q,[(t-1,r) for t,r in out],str(Path(a.output).with_suffix('.relaxed.s')))
   e.cl(*[-v for i,(o,d,s) in enumerate(q) for v in(e.op[i][OPS[o]],e.d[i][d],e.s[i][s])])
  for t in sorted(added):e.add_type(CASES[t])
  chosen|=added
