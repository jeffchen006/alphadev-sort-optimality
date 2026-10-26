"""Finite SAT synthesis for a noncontiguous median dependency cone.
Scratch registers start at concrete value 5: UNSAT relaxes strict correctness.
"""
import argparse,itertools,json,os,resource,time
from pathlib import Path
from pysat.card import CardEnc,EncType
from pysat.formula import IDPool
from pysat.solvers import Solver
from analyze import OPS,CASES,cond,sim,load
HERE=Path(__file__).resolve().parent
class Synth:
 def __init__(self,base,editable,extra=2,drop=1,median_free=True,solver='cadical195'):
  self.base=base;self.code=[tuple(z) for z in base['code']];self.editable=set(editable)
  self.names=base['names']+[f'S{990+i}' for i in range(extra)];self.r=len(self.names)
  self.pool=IDPool();self.solver=Solver(name=solver);self.clauses=0;self.used=[];self.choice={};self.median_free=median_free
  for t in editable:
   ops,dst,src=self.vars(7),self.vars(self.r),self.vars(self.r)
   for row in (ops,dst,src):self.one(row)
   self.choice[t]=(ops,dst,src)
   # Canonical NOP operands eliminate irrelevant register choices.
   self.add(-ops[6],dst[0]);self.add(-ops[6],src[0])
   # A write to itself can always become NOP without changing flags.
   for op in (0,2,3,4,5):
    for r in range(self.r):self.add(-ops[op],-dst[r],-src[r])
  self.adds(CardEnc.atleast([self.choice[t][0][6] for t in editable],bound=drop,vpool=self.pool,encoding=EncType.seqcounter).clauses)
  self.goals=[[self.vars(self.r) for t in range(len(self.code)+1)] for j in [2]] if median_free else []
  if median_free:self.add(*(v for row in self.goals[0] for v in row))
 def vars(self,n):return [self.pool.id() for _ in range(n)]
 def add(self,*c):self.solver.add_clause(list(c));self.clauses+=1
 def adds(self,cs):
  for c in cs:self.add(*c)
 def one(self,row):
  self.add(*row)
  for a,b in itertools.combinations(row,2):self.add(-a,-b)
 def eqif(self,g,a,b):self.add(-g,-a,b);self.add(-g,a,-b)
 def vector(self):
  vs=self.vars(6);self.one(vs);return vs
 def fixed(self,regs,fl,z):
  op,a,b=z
  if op==0:
   new=regs.copy();new[a]=regs[b];return new,fl
  if op==1:
   nf=self.vars(2)
   for x,y in itertools.product(range(6),repeat=2):
    self.add(-regs[a][x],-regs[b][y],nf[0] if x<y else -nf[0]);self.add(-regs[a][x],-regs[b][y],nf[1] if x==y else -nf[1])
   return regs,nf
  take=self.pool.id();self.take(op,take,fl)
  out=self.vector()
  for v in range(6):self.eqif(take,out[v],regs[b][v]);self.eqif(-take,out[v],regs[a][v])
  new=regs.copy();new[a]=out;return new,fl
 def take(self,op,take,fl,guard=None):
  lt,eq=fl;pre=[] if guard is None else [-guard]
  lits={2:[lt],3:[lt,eq],4:[-lt,-eq],5:[-lt]}[op]
  if op==4:
   for lit in lits:self.add(*pre,-take,lit)
   self.add(*pre,take,*[-x for x in lits])
  else:
   self.add(*pre,-take,*lits)
   for lit in lits:self.add(*pre,take,-lit)
 def free(self,regs,fl,t):
  ops,dst,src=self.choice[t];left,right=self.vector(),self.vector()
  for r in range(self.r):
   for v in range(6):self.eqif(dst[r],left[v],regs[r][v]);self.eqif(src[r],right[v],regs[r][v])
  take=self.pool.id();self.add(-ops[0],take);self.add(-ops[1],-take);self.add(-ops[6],-take)
  for op in range(2,6):self.take(op,take,fl,ops[op])
  nf=self.vars(2)
  for i in range(2):self.eqif(-ops[1],nf[i],fl[i])
  for x,y in itertools.product(range(6),repeat=2):
   self.add(-ops[1],-left[x],-right[y],nf[0] if x<y else -nf[0]);self.add(-ops[1],-left[x],-right[y],nf[1] if x==y else -nf[1])
  new=[]
  for r in range(self.r):
   wr=self.pool.id();self.add(-wr,take);self.add(-wr,dst[r]);self.add(wr,-take,-dst[r])
   out=self.vector()
   for v in range(6):self.eqif(wr,out[v],right[v]);self.eqif(-wr,out[v],regs[r][v])
   new.append(out)
  return new,nf
 def case(self,w):
  assert w not in self.used;self.used.append(w)
  regs=[self.vector() for _ in range(self.r)]
  for r in range(self.r):self.add(regs[r][w[r] if r<5 else 5])
  fl=self.vars(2);self.add(-fl[0]);self.add(fl[1]);ss=[regs]
  for t,z in enumerate(self.code):
   regs,fl=self.free(regs,fl,t) if t in self.editable else self.fixed(regs,fl,z)
   ss.append(regs)
  if self.median_free:
   for st in range(len(self.code)+1):
    for rr in range(self.r):self.add(-self.goals[0][st][rr],ss[st][rr][sorted(w)[2]])
  for jj,(t,r) in self.base['outs'].items():
   j=int(jj)
   if j!=2 or not self.median_free:self.add(ss[t][r][sorted(w)[j]])
 def decode(self):
  model=set(v for v in self.solver.get_model() if v>0);q=self.code.copy();one=lambda row:next(i for i,v in enumerate(row) if v in model)
  for t,(o,d,s) in self.choice.items():q[t]=(one(o),one(d),one(s))
  outs={int(j):tuple(z) for j,z in self.base['outs'].items()}
  if self.median_free:outs[2]=next((t,r) for t in range(len(self.code)+1) for r in range(self.r) if self.goals[0][t][r] in model)
  return q,outs
 def run(self,cpu,control=False,all_cases=False):
  start=time.process_time();rounds=0
  if control:
   for t in self.editable:
    op,a,b=self.code[t];o,d,s=self.choice[t]
    self.add(o[op]);self.add(d[a]);self.add(s[b])
  # Seeds from the specific failure class, plus strict and tied input orders.
  seeds=[(0,0,0,0,0),(0,1,2,3,4),(4,3,2,1,0)]
  near=json.loads((HERE.parent/'round6/analysis.json').read_text())[self.base['id']]
  seeds += [tuple(f['input']) for f in near['failures']]
  for w in (CASES if all_cases else dict.fromkeys(seeds)):self.case(w)
  while time.process_time()-start<cpu:
   self.solver.conf_budget(1000);result=self.solver.solve_limited()
   if result is False:return dict(status='UNSAT',cpu=time.process_time()-start,cases=len(self.used),rounds=rounds)
   if result is None:continue
   rounds+=1;q,outs=self.decode();bad=[]
   for w in CASES:
    snapshots=sim(q,w,self.r)
    if any(snapshots[t][r]!=sorted(w)[j] for j,(t,r) in outs.items()):bad.append(w)
   assert not set(bad)&set(self.used)
   print('MODEL',rounds,'bad',len(bad),'cases',len(self.used),'cpu',round(time.process_time()-start,3),flush=True)
   if not bad:return dict(status='CANDIDATE',cpu=time.process_time()-start,cases=len(self.used),rounds=rounds,code=q,outs=outs,names=self.names)
   for w in bad[:8]:self.case(w)
  return dict(status='UNKNOWN',cpu=time.process_time()-start,cases=len(self.used),rounds=rounds)
 def emit(self,result,path):
  q=result['code'];outs=result['outs'];lines=['# n=5 model=out iset=I1 source=w1-round7-median-path']
  for t in range(len(self.code)+1):
   for j,(ot,r) in outs.items():
    if ot==t:lines.append(f'out {j}, {self.names[r]}')
   if t<len(self.code):
    op,a,b=q[t]
    if op!=6:lines.append(f'{OPS[op]} {self.names[a]}, {self.names[b]}')
  path.write_text('\n'.join(lines)+'\n')
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--base',type=int,default=0);ap.add_argument('--mode',choices=['exclusive','tail','all'],default='exclusive');ap.add_argument('--tail',type=int,default=6);ap.add_argument('--cpu',type=float,default=60);ap.add_argument('--extra',type=int,default=2);ap.add_argument('--control',action='store_true');ap.add_argument('--all-cases',action='store_true');ap.add_argument('--stem',default='pilot');args=ap.parse_args()
 os.sched_setaffinity(0,{min(os.sched_getaffinity(0))});resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
 base=json.loads((HERE/'bases.json').read_text())[args.base]
 editable=base['exclusive'] if args.mode=='exclusive' else sorted(set(base['exclusive'])|set(base['writes'][-args.tail:])) if args.mode=='tail' else base['median_cone']
 s=Synth(base,editable,args.extra,drop=0 if args.control else 1);res=s.run(args.cpu,args.control,args.all_cases)
 res.update(args=vars(args),editable=editable,vars=s.pool.top,clauses=s.clauses,stats=s.solver.accum_stats());print('RESULT',res,flush=True)
 if res['status']=='CANDIDATE':s.emit(res,HERE/(args.stem+'.s'))
 (HERE/(args.stem+'.json')).write_text(json.dumps(res,indent=2)+'\n')
if __name__=='__main__':main()
