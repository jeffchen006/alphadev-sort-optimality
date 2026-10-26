#!/usr/bin/env python3
"""Physical-register SAT with a fixed number of operations after each comparison.

Data values name their original input. Values with the same canonical comparison
history share variables. All scratch reads require an earlier unconditional write.
Comparison operands may reverse independently for each prior history.
"""
import argparse,itertools,json,sys,time,random,subprocess
from pathlib import Path
from ssa_orient import CNF,P,solve
from experiments import ROOT,skeleton,trace_inputs
from trees import trees
from pysat.card import CardEnc,EncType

class RegEnc(CNF):
 def __init__(self,ob,profile,R,movbound=None,fixed=None,activebudget=None,partial_init=False):
  super().__init__();self.R=R;self.profile=profile;self.m=sum(profile);self.C=len(profile)
  self.F=[[(u>v)-(u<v) for u,v in row] for row in ob]
  self.hist=[];self.reps=[]
  for j in range(self.C+1):
   ids={};hh=[];rr=[]
   for t in range(120):
    k=tuple(self.F[q][t] for q in range(j))
    if k not in ids:ids[k]=len(ids);rr.append(t)
    hh.append(ids[k])
   self.hist.append(hh);self.reps.append(rr)
  self.phase=[b for b,n in enumerate(profile) for q in range(n)]
  self.mov=self.vec(self.m);self.inv=self.vec(self.m)
  self.active=self.vec(self.m) if activebudget is not None else [True]*self.m
  if activebudget is not None:
   ca=CardEnc.atmost(self.active,bound=activebudget,top_id=self.nv,encoding=EncType.seqcounter);self.nv=ca.nv;self.cs+=ca.clauses
   for g in range(self.m):
    self.cl(self.active[g],-self.mov[g])
    if g and self.phase[g]==self.phase[g-1]:self.cl(self.active[g-1],-self.active[g])
  if self.C==7:
   for b in range(self.C):
    used=[]
    for g in range(self.m):
     if self.phase[g]!=b:continue
     q=self.new();used.append(q)
     self.cl(-q,self.active[g]);self.cl(-q,-self.mov[g])
     self.cl(q,self.neg(self.active[g]),self.mov[g])
    self.cl(*used)
   if not partial_init:self.cl(self.mov[0])
  self.dst=[self.vec(R) for g in range(self.m)];self.src=[self.vec(R) for g in range(self.m)]
  self.cmps=[[self.vec(R),self.vec(R)] for j in range(self.C)]
  self.out=[self.vec((self.m+1)*R) for j in range(5)]
  for ls in self.dst+self.src+self.out+[ss for pair in self.cmps for ss in pair]:self.eo(ls)
  if not partial_init:
   for r in range(5):self.cl(-self.dst[0][r])
  for g in range(self.m):
   for r in range(R):self.cl(self.neg(self.active[g]),-self.dst[g][r],-self.src[g][r])
  if movbound is not None:
   ca=CardEnc.atmost(self.mov,bound=movbound,top_id=self.nv,encoding=EncType.seqcounter);self.nv=ca.nv;self.cs+=ca.clauses
  self.states=[[[bool(((r if r<5 else 5)>>b)&1) for b in range(3)] for r in range(R)]]
  # A state has an origin-bit vector for each type and register.
  self.states=[[[list(v) for v in self.states[0]] for t in range(120)]]
  self.defined=[[r<5 for r in range(R)]]
  self.flips=[];g=0
  for j in range(self.C):
   reps=self.reps[j];after=self.reps[j+1]
   flip=self.vec(len(reps));self.flips.append(flip)
   # Reversing both cmp operands and every predicate in its phase preserves
   # values. Select one global orientation per phase, unless a control fixes it.
   if not fixed:self.cl(-flip[0])
   for side in range(2):
    for r,pick in enumerate(self.cmps[j][side]):
     if not partial_init:self.cl(-pick,self.defined[g][r])
    for cid,t in enumerate(reps):
     a,b=ob[j][t];aa=P[t].index(a);bb=P[t].index(b)
     # Pairs must be functions of the preceding canonical history.
     for tt in range(120):
      if self.hist[j][tt]==cid:
       assert tuple(P[tt].index(v) for v in ob[j][tt])==(aa,bb)
     want=(aa,bb) if side==0 else (bb,aa)
     for r,pick in enumerate(self.cmps[j][side]):
      for bit in range(3):
       val=self.states[g][t][r][bit]
       self.cl(-pick,flip[cid],val if (want[0]>>bit)&1 else self.neg(val))
       self.cl(-pick,-flip[cid],val if (want[1]>>bit)&1 else self.neg(val))
   for q in range(profile[j]):
    # Global initialized-register tracking excludes reads of scratch garbage.
    nd=self.vec(R)
    for r in range(R):
     if not partial_init:
      self.cl(-self.src[g][r],self.defined[g][r])
      self.cl(self.mov[g],-self.dst[g][r],self.defined[g][r])
     self.cl(self.neg(self.active[g]),-self.dst[g][r],nd[r])
     self.eq(nd[r],self.defined[g][r],self.dst[g][r])
     self.eq(nd[r],self.defined[g][r],self.active[g])
    self.defined.append(nd)
    values=[]
    for cid,t in enumerate(after):
     newregs=[self.vec(3) for r in range(R)]
     sval=self.vec(3);dval=self.vec(3);nval=self.vec(3)
     for r in range(R):
      for bit in range(3):
       self.eq(sval[bit],self.states[g][t][r][bit],-self.src[g][r])
       self.eq(dval[bit],self.states[g][t][r][bit],-self.dst[g][r])
       self.eq(newregs[r][bit],nval[bit],-self.dst[g][r],self.neg(self.active[g]))
       self.eq(newregs[r][bit],self.states[g][t][r][bit],self.dst[g][r])
       self.eq(newregs[r][bit],self.states[g][t][r][bit],self.active[g])
     # If flip differs from the canonical less-than outcome, actual flag is lt.
     f=self.F[j][t];ori=flip[self.hist[j][t]]
     assert f in (-1,1)
     take=self.new()
     # take = (inv XOR flip) == (canonical flag is gt)
     for inv,fl in itertools.product([False,True],repeat=2):
      tv=(inv!=fl) if f>0 else (inv==fl)
      self.cl(-self.inv[g] if inv else self.inv[g],-ori if fl else ori,take if tv else -take)
     for bit in range(3):
      self.eq(nval[bit],sval[bit],-self.mov[g])
      self.eq(nval[bit],sval[bit],self.mov[g],-take)
      self.eq(nval[bit],dval[bit],self.mov[g],take)
     values.append(newregs)
    self.states.append([values[cid] for cid in self.hist[j+1]])
    g+=1
  earliest_output = [next(p for p in range(self.C+1) if all(
      len({P[t].index(out) for t in range(120) if self.hist[p][t] == cid}) == 1
      for cid in range(len(self.reps[p])))) for out in range(5)]
  for out,ls in enumerate(self.out):
   for k,pick in enumerate(ls):
    step,r=divmod(k,R)
    # A register can depend only on comparison results already available.
    # If two orders in one history need different input origins for this rank,
    # no register in that state can yet supply this output.
    phase = 0 if step == 0 else self.phase[step-1]+1
    if phase < earliest_output[out]:self.cl(-pick)
    if step:
     # Record a rank at the operation which first creates that value.
     # An unchanged register or a copy can use an earlier snapshot instead.
     self.cl(-pick,self.active[step-1])
     self.cl(-pick,self.dst[step-1][r])
     self.cl(-pick,-self.mov[step-1])
    if not partial_init:self.cl(-pick,self.defined[step][r])
    for t in range(120):
     want=P[t].index(out)
     for bit in range(3):
      v=self.states[step][t][r][bit]
      self.cl(-pick,v if (want>>bit)&1 else self.neg(v))
  # A lost input value cannot be restored. Before rank j is recorded, every
  # tested order must still have its supplying input in at least one register.
  done=[]
  for out in range(5):
   row=[]
   for step in range(self.m+1):
    d=self.new();row.append(d)
    picks=self.out[out][step*R:(step+1)*R]
    prev=row[step-1] if step else False
    self.cl(-d,prev,*picks)
    self.cl(self.neg(prev),d)
    for pick in picks:self.cl(-pick,d)
   done.append(row)
  origin_cache={}
  def holds(bits,origin):
   key=(tuple(bits),origin)
   if key in origin_cache:return origin_cache[key]
   lits=[v if (origin>>b)&1 else self.neg(v) for b,v in enumerate(bits)]
   if any(v is False for v in lits):return False
   if all(v is True for v in lits):return True
   q=self.new()
   for v in lits:self.cl(-q,v)
   self.cl(q,*(self.neg(v) for v in lits))
   origin_cache[key]=q
   return q
  for step in range(self.m+1):
   for t,ty in enumerate(P):
    for origin,rank in enumerate(ty):
     self.cl(done[rank][step],*(holds(self.states[step][t][r],origin) for r in range(R)))
  if fixed:self.fix(fixed)
  else:
   for g in range(self.m):
    # Inactive slots have no semantic operands or predicate.
    self.cl(self.active[g],self.dst[g][0])
    self.cl(self.active[g],self.src[g][0])
    self.cl(self.active[g],-self.inv[g])
    self.cl(-self.mov[g],-self.inv[g])
    # Scratch registers are interchangeable. Their first writes can be named
    # in ascending order. Include conditional writes in partial-init models.
    for r in range(6,R):
     self.cl(-self.dst[g][r],*(self.dst[h][r-1] for h in range(g)))
 def fix(self,program):
  reg=lambda s:int(s[1:])+(5 if s.startswith('S') else 0)
  g=0;j=-1
  for line in program:
   if not line or line.startswith('#'):continue
   op,rest=line.split(None,1);d,s=[x.strip() for x in rest.split(',')]
   if op=='cmp':
    while g<sum(self.profile[:j+1]):
     self.cl(self.neg(self.active[g]));g+=1
    j+=1;self.cl(self.cmps[j][0][reg(d)]);self.cl(self.cmps[j][1][reg(s)])
   elif op=='out':self.cl(self.out[int(d)][g*self.R+reg(s)])
   else:
    self.cl(self.active[g])
    self.cl(self.src[g][reg(s)]);self.cl(self.dst[g][reg(d)]);self.cl(self.mov[g] if op=='mov' else -self.mov[g])
    if op!='mov':self.cl(self.inv[g] if op in ('cmovg','cmovge') else -self.inv[g])
    g+=1
  while g<self.m:
   self.cl(self.neg(self.active[g]));g+=1
 def decode(self,model):
  yes=set(model);idx=lambda ls:next(i for i,v in enumerate(ls) if v in yes)
  reg=lambda r:f'P{r}' if r<5 else f'S{r-5}'
  outs={j:divmod(idx(ls),self.R) for j,ls in enumerate(self.out)}
  lines=[f'# n=5 R={self.R} iset=I1 model=out source=w3_round3_register_sat']
  g=0
  def emitouts(step):
   for j,(st,r) in outs.items():
    if st==step:lines.append(f'out {j}, {reg(r)}')
  emitouts(0)
  for j,n in enumerate(self.profile):
   a,b=[idx(ls) for ls in self.cmps[j]];lines.append(f'cmp {reg(a)}, {reg(b)}')
   for q in range(n):
    if self.active[g] is not True and self.active[g] not in yes:
     g+=1;emitouts(g);continue
    d,s=idx(self.dst[g]),idx(self.src[g])
    op='mov' if self.mov[g] in yes else ('cmovge' if self.inv[g] in yes else 'cmovl')
    lines.append(f'{op} {reg(d)}, {reg(s)}');g+=1;emitouts(g)
  return lines

def main():
 if (ROOT/'RESULTS.md').read_text().startswith('FOUND '):
  print('TARGET_ALREADY_FOUND',flush=True);return
 ap=argparse.ArgumentParser();ap.add_argument('--tag',required=True);ap.add_argument('--profile',default='3,3,4,4,4,3,3');ap.add_argument('--registers',type=int,default=7);ap.add_argument('--tree',type=int,default=5);ap.add_argument('--mask',type=int,default=0);ap.add_argument('--adaptive',action='store_true');ap.add_argument('--movbound',type=int);ap.add_argument('--control',action='store_true');ap.add_argument('--timeout',type=int,default=120);ap.add_argument('--phasecap',type=int);ap.add_argument('--partial-init',action='store_true');a=ap.parse_args()
 fixed=None
 if a.control:
  fixed=(ROOT/'programs/construct_fj_k53.s').read_text().splitlines()
  if a.partial_init:
   k=fixed.index('mov S0, P1');fixed[k]='cmovl S0, P1';fixed[k+1]='cmovge S0, P0'
  profile=[]
  for line in fixed:
   if line.startswith('cmp '):profile.append(0)
   elif line and not line.startswith(('#','out ')):profile[-1]+=1
  if a.phasecap:profile=[n+1 for n in profile]
  ob=list(map(list,zip(*(trace_inputs(fixed,p) for p in P))))
  a.registers=21
 else:
  profile=[a.phasecap]*7 if a.phasecap else list(map(int,a.profile.split(',')));assert len(profile)==7 and (a.phasecap or sum(profile)==24)
  ob=skeleton(trees(tuple(range(15)),4)[a.tree],a.mask,a.adaptive)
 start=time.monotonic();e=RegEnc(ob,profile,a.registers,a.movbound,fixed=fixed,activebudget=(46 if a.control else 24) if a.phasecap else None,partial_init=a.partial_init)
 print(json.dumps(dict(event='ENC',tag=a.tag,profile=profile,registers=a.registers,vars=e.nv,clauses=len(e.cs),elapsed=time.monotonic()-start)),flush=True)
 st,model=solve(e,str(ROOT/'round3/logs'/a.tag),a.timeout)
 print(json.dumps(dict(event='RESULT',tag=a.tag,status=st,elapsed=time.monotonic()-start)),flush=True)
 if st=='SATISFIABLE':
  path=ROOT/'round3/programs'/f'{a.tag}.s';path.write_text('\n'.join(e.decode(model))+'\n')
  jr=subprocess.run(['nice','-n','19','python3',str(ROOT.parents[3]/'shared/judge.py'),str(path),'--strict','--model','out'],capture_output=True,text=True)
  print('JUDGE',jr.stdout,jr.stderr,flush=True)
  from candidate import check
  check(path,jr.stdout+jr.stderr)
if __name__=='__main__':main()
