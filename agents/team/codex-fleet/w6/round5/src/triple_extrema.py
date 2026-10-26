"""Synthesize a triple prefix with two minima, a median, and two maxima."""
import argparse,itertools,json,sys,time,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parents[2];ROOT=HERE.parents[3]
sys.path[:0]=[str(ROOT/"agents/sat"),str(HERE/"src"),str(HERE/"round3/src")]
from triple_encode import TripleRankEnc as RankEnc
from pysat.card import CardEnc,EncType
from pysat.solvers import Solver
from window_sat import OPS,concrete,GOALS
from satrep import emit
ap=argparse.ArgumentParser();ap.add_argument("--registers",type=int,default=6);ap.add_argument("--control",action="store_true");ap.add_argument("--comparisons",type=int,default=3);ap.add_argument("--first",action="store_true");ap.add_argument("--safe",action="store_true");a=ap.parse_args()
control=[("mov",3,0),("cmp",1,2),("cmovle",4,2),("cmovg",4,1),("cmovl",2,1),("cmp",0,2),("cmovge",0,2),("cmovge",2,3),("cmp",2,4),("cmovle",3,4),("cmovl",4,2),("mov",1,0),("mov",5,3)]
k=13 if a.control else 12;nr=a.registers;start=time.monotonic();e=RankEnc(3,k,R=nr,iset="I1",outmode="snap",rules=() if a.control else ("canon",))
domains=[OPS]*k;dest=[None]*k;src=[None]*k
if a.control:
 for i,(op,d,s) in enumerate(control):
  e.cl(e.op[i][op]);e.cl(e.d[i][d]);e.cl(e.s[i][s]);domains[i]=[op];dest[i]=d;src[i]=s
else:
 cmpvars=[e.op[i]["cmp"] for i in range(k)]
 for method in (CardEnc.atleast,CardEnc.atmost):
  card=method(cmpvars,a.comparisons,top_id=e.nvars,encoding=EncType.seqcounter);e.nvars=card.nv;e.clauses.extend(card.clauses)
 if a.first:
  e.cl(e.op[0]["cmp"]);e.cl(e.d[0][0]);e.cl(e.s[0][1]);domains[0]=["cmp"];dest[0]=0;src[0]=1
 for i in range(k):
  for r in range(nr):e.cl(e.neg(e.d[i][r]),e.neg(e.s[i][r]))
targets=[[e.new() for r in range(nr)] for j in range(5)]
for row in targets:e.exactly_one(row)
for r in range(nr):
 for i in range(5):
  for j in range(i):e.cl(-targets[i][r],-targets[j][r])
for first,last in ((0,1),(3,4)):
 for r in range(nr):
  for s in range(r+1):e.cl(-targets[first][r],-targets[last][s])
e.safe_compare=a.safe
e.configure([],domains,dest,src);e.role_targets=list(zip((0,0,1,2,2),targets))
if a.control:
 for j,r in enumerate((0,1,4,3,5)):e.cl(targets[j][r])
for case in itertools.product(range(3),repeat=3):
 if set(case)==set(range(max(case)+1)):e.add_type(case)
print(json.dumps({"k":k,"registers":nr,"comparisons":a.comparisons,"cases":len(e.types),"variables":e.nvars,"clauses":len(e.clauses)}),flush=True)
with Solver(name="cadical195",bootstrap_with=e.clauses) as solver:
 for iteration in itertools.count():
  if not solver.solve():print(json.dumps({"status":"UNSAT","seconds":time.monotonic()-start}),flush=True);break
  model=solver.get_model();modelset=set(model);p,_=e.decode(model);roles=[next(r for r in range(nr) if row[r] in modelset) for row in targets]
  print(json.dumps({"status":"SAT","program":p,"roles":roles,"iteration":iteration,"seconds":time.monotonic()-start}),flush=True)
  # Keep P2 and P4 for the unrelated pair. Map triple symbols to other registers.
  mapping={0:0,1:1,2:3}
  for r in range(3,nr):mapping[r]=r+2
  body=[(OPS.index(op),mapping[d],mapping[s]) for op,d,s in p]
  low,lowcopy,mid,high,highcopy=[mapping[r] for r in roles]
  d=max(mapping.values())+1;v=4
  body += [(1,2,4),(4,d,4),(3,d,2),(4,4,2)]
  # Five-comparison merge. lowcopy holds X; highcopy holds min(c,X).
  body += [(1,low,d),(5,low,d),(3,lowcopy,d),(1,high,d),(5,d,high),(5,highcopy,lowcopy),(1,v,high),(4,high,v),(3,d,v),(1,v,mid),(3,d,mid),(5,v,mid),(1,v,highcopy),(5,highcopy,v),(3,lowcopy,v)]
  columns,_=concrete(body,d+1);witness=[]
  for goal in GOALS:
   matches=[(t,r) for t,r,col in columns if col==goal];witness.append(matches[0] if matches else None)
  if all(w is not None for w in witness):
   path=f"round5/candidates/triple_extrema_{k}_R{nr}_c{a.comparisons}.s";emit(body,witness,path)
   subprocess.run(["nice","-n","19","python3","-B","round5/src/verify.py",path],check=True)
   if a.control or Path("round5/artifacts/FOUND").exists():break
  solver.add_clause([-v for i,(op,d,s) in enumerate(p) for v in(e.op[i][op],e.d[i][d],e.s[i][s])]+[-targets[j][r] for j,r in enumerate(roles)])
