#!/usr/bin/env python3
"""SAT synthesis of garbage-free register programs for fixed comparison flags.

Each counted data instruction creates one SSA node. A mov allocates a new
register. A cmov consumes a live default node in place. No later instruction
can read that old node. Comparisons select two live nodes at stage boundaries.
Outputs can select any historical node, and decode snapshots its value at creation.
The slot budget counts mov/cmov only; comparisons have their own fixed stages.
Rank values are bit vectors. Full permutation testing is an independent simulator.
"""
import argparse,itertools,json,os,random,subprocess,time
from pathlib import Path
from pysat.card import CardEnc, EncType

P=list(itertools.permutations(range(5)))
class CNF:
 def __init__(self): self.nv=0; self.cs=[]
 def new(self): self.nv+=1; return self.nv
 def vec(self,n): return [self.new() for _ in range(n)]
 def cl(self,*lits):
  if any(x is True for x in lits): return
  xs=[x for x in lits if x is not False]
  self.cs.append(xs)
 def neg(self,x): return not x if isinstance(x,bool) else -x
 def eq(self,a,b,*guard):
  self.cl(*guard,self.neg(a),b);self.cl(*guard,a,self.neg(b))
 def eo(self,x):
  self.cl(*x)
  if len(x)<7:
   for a,b in itertools.combinations(x,2):self.cl(-a,-b)
  else:
   ca=CardEnc.atmost(x,bound=1,top_id=self.nv,encoding=EncType.seqcounter)
   self.nv=ca.nv;self.cs+=ca.clauses
 def dimacs(self,fn):
  with open(fn,'w') as f:
   f.write(f'p cnf {self.nv} {len(self.cs)}\n')
   for c in self.cs:f.write(' '.join(map(str,c))+' 0\n')
class Enc(CNF):
 def __init__(self,F,types,m, operands=None, fixed=None,free_last=(),dynamic=False,paired=False,onehot=False,gates=False,copybound=None,origin=False,alternatives=None,orient=False,movbound=None,prefixdepth=3):
  super().__init__();self.F=F;self.types=types;self.m=m;self.c=len(F);self.fixed=fixed;self.dynamic=dynamic
  T=len(types); C=self.c
  self.onehot=onehot; self.gatemode=gates; self.origin=origin; NB=5 if onehot else 3
  self.mov=self.vec(m)
  if movbound is not None:
   ca=CardEnc.atmost(self.mov,bound=movbound,top_id=self.nv,encoding=EncType.seqcounter)
   self.nv=ca.nv;self.cs+=ca.clauses
  self.copy=self.vec(m) if gates else self.mov
  if gates:
   for x in self.mov:self.cl(-x)
   if copybound is None:
    for x in self.copy:self.cl(x)
   if copybound is not None:
    ca=CardEnc.atmost(self.copy,bound=copybound,top_id=self.nv,encoding=EncType.seqcounter)
    self.nv=ca.nv;self.cs+=ca.clauses
  if paired:
   self.cl(-self.mov[-1])
   for g in range(m-1):
    self.cl(-self.mov[g],-self.mov[g+1])
  self.dst=[self.vec(5+g) for g in range(m)]
  self.src=[self.vec(5+g) for g in range(m)]
  self.blk=[self.vec(C) for g in range(m)]
  self.inv=self.vec(m) # false: low, true: high
  self.inc=self.vec(m) # include equality for cmovle/cmovge
  if all(v is not None and v!=0 for row in F for v in row):
   for x in self.inc:self.cl(-x)
  self.cmps=[[self.vec(5+m) for _ in range(2)] for j in range(C)]
  self.out=[self.vec(5+m) for j in range(5)]
  if paired:
   for g in range(m-1):
    self.cl(-self.mov[g],self.dst[g+1][5+g])
    for b in range(C):self.cl(-self.mov[g],-self.blk[g][b],self.blk[g+1][b])
  # unused D of mov canonicalized to P0; adjacent mov copies are permitted.
  for g in range(m):
   for ls in [self.dst[g],self.src[g],self.blk[g]]:self.eo(ls)
   self.cl(-self.mov[g],self.dst[g][0])
   if g:
    for b in range(C):
     for bb in range(b):self.cl(-self.blk[g-1][b],-self.blk[g][bb])
   # SSA node consumed by a cmov must stay dead after that cmov.
   for x,d in enumerate(self.dst[g]):
    for h in range(g+1,m):
     self.cl(self.copy[g],-d,-self.src[h][x])
     self.cl(self.copy[g],-d,self.mov[h],-self.dst[h][x])
    for j in range(C):
     for b in range(j):
      for side in range(2):self.cl(self.copy[g],-d,-self.blk[g][b],-self.cmps[j][side][x])
  if C==7:
   # A correct sort5 needs all seven comparison results. A phase with no
   # conditional move discards that result before any instruction uses it.
   for b in range(C):
    used=[]
    for g in range(m):
     q=self.new();used.append(q)
     self.cl(-q,-self.mov[g]);self.cl(-q,self.blk[g][b])
     self.cl(q,self.mov[g],-self.blk[g][b])
    self.cl(*used)
   if not gates:self.cl(self.mov[0])
  # comparison input nodes must exist strictly before that comparison.
  for j in range(C):
   for side in range(2):
    self.eo(self.cmps[j][side])
    for g in range(m):
     self.cl(-self.cmps[j][side][5+g],*self.blk[g][:j])
   for x in range(5+m):self.cl(-self.cmps[j][0][x],-self.cmps[j][1][x])
  for ls in self.out:self.eo(ls)
  for x in range(5+m):
   for a,b in itertools.combinations(range(5),2):self.cl(-self.out[a][x],-self.out[b][x])
  for j in range(5):
   for g in range(m):self.cl(-self.out[j][5+g],-self.mov[g])
  # Value bits are ranks 0..4, never unconstrained garbage.
  self.val=[[[((x if origin else ty[x])==b if onehot else bool(((x if origin else ty[x])>>b)&1)) for b in range(NB)] for ty in types] for x in range(5)]
  self.val += [[[self.new() for b in range(NB)] for ty in types] for g in range(m)]
  if onehot:
   for x in range(5,5+m):
    for row in self.val[x]:self.eo(row)
  hist=[]
  for j in range(C+1):
   if any(F[q][t] is None for q in range(j) for t in range(T)):hist.append(None);continue
   ids={};hist.append([ids.setdefault(tuple(F[q][t] for q in range(j)),len(ids)) for t in range(T)])
  if origin:
   for g in range(m):
    for j in range(C):
     if hist[j+1] is None:continue
     rep={}
     for t,cl in enumerate(hist[j+1]):
      if cl in rep:
       for b in range(NB):self.eq(self.val[5+g][t][b],self.val[5+g][rep[cl]][b],-self.blk[g][j])
      else:rep[cl]=t
  self.orientation=[]
  for j in range(C):
   if orient and hist[j] is not None:
    byclass={cl:self.new() for cl in set(hist[j])}
    self.orientation.append([byclass[cl] for cl in hist[j]])
   else:self.orientation.append([False]*T)
  self.fl=[] # per comparison/type: one-hot lt,eq,gt; known flags are constants.
  for j in range(C):
   row=[]
   for t,ty in enumerate(types):
    fj=F[j][t]
    if fj is None:
     rr=self.vec(3);self.eo(rr);row.append(rr)
    elif orient and fj:
     flip=self.orientation[j][t]
     row.append([flip if fj>0 else -flip,False,flip if fj<0 else -flip])
    else: row.append([fj==q for q in (-1,0,1)])
   self.fl.append(row)
  if alternatives:
   groups={}
   for t in range(T):groups.setdefault(tuple(F[j][t] for j in range(prefixdepth)),[]).append(t)
   self.tree_choices={}
   for history,grp in groups.items():
    choices=self.vec(len(alternatives));self.eo(choices);self.tree_choices[history]=choices
    for opt,prof in zip(choices,alternatives):
     flips={}
     for j in range(C):
      for t in grp:
       f=prof[j][t]
       if orient:
        if j<prefixdepth:continue
        if f is None:continue
        if f==0:self.cl(-opt,self.fl[j][t][1]);continue
        history=tuple(prof[q][t] for q in range(j))
        key=(j,history)
        if key not in flips:flips[key]=self.new()
        flip=flips[key]
        self.cl(-opt,self.neg(self.fl[j][t][1]))
        self.eq(self.fl[j][t][0],flip if f>0 else -flip,-opt)
        self.eq(self.fl[j][t][2],flip if f<0 else -flip,-opt)
       elif f is not None:self.cl(-opt,self.fl[j][t][f+1])
  # Selected operands and comparison relation.
  self.cmpval=[]
  for j in range(C):
   if origin and hist[j] is not None:
    cv=[]
    for side in range(2):
     rows={};vv=[]
     for cl in hist[j]:
      if cl not in rows:rows[cl]=self.vec(NB)
      vv.append(rows[cl])
     cv.append(vv)
   else:cv=[[[self.new() for b in range(NB)] for t in range(T)] for side in range(2)]
   self.cmpval.append(cv)
   for side in range(2):
    if onehot:
     for row in cv[side]:self.eo(row)
    for x,pick in enumerate(self.cmps[j][side]):
     for t in range(T):
      for b in range(NB):self.eq(cv[side][t][b],self.val[x][t][b],-pick)
   for t in range(T):
    if operands is not None:
     for side in range(2):
      v=operands[j][t][side]
      if v is not None and origin:v=self.types[t].index(v)
      if v is not None:
       if orient:
        ov=operands[j][t][1-side]
        if origin:ov=self.types[t].index(ov)
        flip=self.orientation[j][t]
        for b in range(NB):
         self.cl(flip,cv[side][t][b] if (v==b if onehot else (v>>b)&1) else -cv[side][t][b])
         self.cl(-flip,cv[side][t][b] if (ov==b if onehot else (ov>>b)&1) else -cv[side][t][b])
       else:
        for b in range(NB):self.cl(cv[side][t][b] if (v==b if onehot else (v>>b)&1) else -cv[side][t][b])
    for u,v in itertools.product(range(5),repeat=2):
     f=((self.types[t][u]>self.types[t][v])-(self.types[t][u]<self.types[t][v])) if origin else (u>v)-(u<v)
     # If both selected values have these ranks, the flag must agree.
     if onehot:guard=[-cv[0][t][u],-cv[1][t][v]]
     else:
      guard=[-cv[0][t][b] if (u>>b)&1 else cv[0][t][b] for b in range(NB)]
      guard += [-cv[1][t][b] if (v>>b)&1 else cv[1][t][b] for b in range(NB)]
     self.cl(*guard,self.fl[j][t][f+1])
  for g in range(m):
   dv=[[self.new() for b in range(NB)] for t in range(T)]
   sv=[[self.new() for b in range(NB)] for t in range(T)]
   if onehot:
    for row in dv+sv:self.eo(row)
   for x in range(5+g):
    for t in range(T):
     for b in range(NB):
      self.eq(dv[t][b],self.val[x][t][b],-self.dst[g][x])
      self.eq(sv[t][b],self.val[x][t][b],-self.src[g][x])
   for t in range(T):
    for b in range(NB):self.eq(self.val[5+g][t][b],sv[t][b],-self.mov[g])
    for j in range(C):
     for f in range(3):
      fl=self.fl[j][t][f]
      if fl is False:continue
      guard=[self.mov[g],-self.blk[g][j],self.neg(fl)]
      for inv in (0,1):
       # I0 predicates: take iff lt without inv, gt with inv.
       take = f==(2 if inv else 0)
       gg=guard+([-self.inv[g]] if inv else [self.inv[g]])
       if f==1:
        for inc in (0,1):
         vv=sv[t] if inc else dv[t]
         for b in range(NB):self.eq(self.val[5+g][t][b],vv[b],*gg,*([-self.inc[g]] if inc else [self.inc[g]]))
       else:
        vv=sv[t] if take else dv[t]
        for b in range(NB):self.eq(self.val[5+g][t][b],vv[b],*gg)
  for j in range(5):
   for x,pick in enumerate(self.out[j]):
    for t in range(T):
     target=self.types[t].index(j) if origin else j
     for b in range(NB):self.cl(-pick,self.val[x][t][b] if (target==b if onehot else (target>>b)&1) else self.neg(self.val[x][t][b]))
  # A rank cannot be output before its input origin is determined by history.
  # Use only fully specified canonical histories. Reversals preserve classes.
  for j in range(5):
   for x in range(5):
    if any(ty.index(j)!=x for ty in types):self.cl(-self.out[j][x])
   for b in range(C):
    if hist[b+1] is None:continue
    origins={};impossible=False
    for t,cl in enumerate(hist[b+1]):
     want=types[t].index(j)
     if cl in origins and origins[cl]!=want:impossible=True;break
     origins[cl]=want
    if impossible:
     for g in range(m):self.cl(-self.out[j][5+g],-self.blk[g][b])
  if not (gates and copybound is None):self.add_liveness()
  if fixed:self.fix(fixed)
 def add_liveness(self):
  # This is a redundant necessary condition for every valid out program.
  # Once a value disappears from all live nodes, it cannot be recovered.
  m=self.m;T=len(self.types)
  alive=[[True]*5]
  for g in range(m):
   row=[]
   for x,old in enumerate(alive[-1]):
    q=self.new()
    # q = old AND (copy[g] OR NOT dst[g][x]). A copy allocates a new
    # node; a destructive conditional move consumes its default node.
    self.cl(-q,old)
    self.cl(-q,self.copy[g],-self.dst[g][x])
    self.cl(q,self.neg(old),-self.copy[g])
    self.cl(q,self.neg(old),self.dst[g][x])
    row.append(q)
   row.append(True);alive.append(row)
  done=[]
  for rank in range(5):
   row=[]
   for step in range(m+1):
    q=self.new();row.append(q)
    picks=self.out[rank][:5] if step==0 else [self.out[rank][4+step]]
    prev=row[step-1] if step else False
    self.cl(-q,prev,*picks);self.cl(self.neg(prev),q)
    for pick in picks:self.cl(-pick,q)
   done.append(row)
  matches={}
  def holds(x,t,origin):
   key=(x,t,origin)
   if key in matches:return matches[key]
   val=origin if self.origin else self.types[t][origin]
   bits=self.val[x][t]
   lits=[bits[val]] if self.onehot else [v if (val>>b)&1 else self.neg(v) for b,v in enumerate(bits)]
   if any(v is False for v in lits):return False
   if all(v is True for v in lits):return True
   q=self.new()
   for v in lits:self.cl(-q,v)
   self.cl(q,*(self.neg(v) for v in lits));matches[key]=q
   return q
  for step in range(m+1):
   for t,ty in enumerate(self.types):
    for origin,rank in enumerate(ty):
     options=[]
     for x,live in enumerate(alive[step]):
      match=holds(x,t,origin)
      if live is False or match is False:continue
      if live is True:options.append(match)
      elif match is True:options.append(live)
      else:
       q=self.new();self.cl(-q,live);self.cl(-q,match);self.cl(q,-live,-match)
       options.append(q)
     self.cl(done[rank][step],*options)
 def fix(self,prog):
  cur={f'P{i}':i for i in range(5)};g=0;j=-1;pending=None
  for line in prog:
   if not line.strip() or line.lstrip().startswith('#'):continue
   op,rest=line.split(None,1);d,s=[p.strip() for p in rest.split(',')]
   if op=='out':self.cl(self.out[int(d)][cur[s]]);continue
   if op=='cmp':
    j+=1;self.cl(self.cmps[j][0][cur[d]]);self.cl(self.cmps[j][1][cur[s]]);continue
   assert op in ('mov','cmovl','cmovg','cmovle','cmovge'),op
   if self.gatemode and op=='mov':
    cur[d]=cur[s];pending=d;continue
   if self.gatemode:
    self.cl(self.copy[g] if pending==d else -self.copy[g]);pending=None
   self.cl(self.mov[g] if op=='mov' else -self.mov[g]);self.cl(self.blk[g][j])
   self.cl(self.src[g][cur[s]])
   if op!='mov':
    self.cl(self.dst[g][cur[d]]);self.cl(self.inv[g] if op in ('cmovg','cmovge') else -self.inv[g]);self.cl(self.inc[g] if op.endswith('e') else -self.inc[g])
   cur[d]=5+g;g+=1
  assert g<=self.m
 def decode(self,model):
  yes=set(x for x in model if x>0)
  idx=lambda ls:next(i for i,v in enumerate(ls) if v in yes)
  reg={i:f'P{i}' for i in range(5)};nr=0
  outnodes={j:idx(ls) for j,ls in enumerate(self.out)}
  lines=['# n=5 R=50 iset=I1 model=out source=w3_ssa_sat']
  for j,x in outnodes.items():
   if x<5:lines.append(f'out {j}, {reg[x]}')
  g=0
  for b in range(self.c):
   a,s=[idx(ls) for ls in self.cmps[b]]
   lines.append(f'cmp {reg[a]}, {reg[s]}')
   while g<self.m and idx(self.blk[g])==b:
    s=idx(self.src[g]);d=idx(self.dst[g])
    if self.mov[g] in yes:
     dest=f'S{nr}';nr+=1;lines.append(f'mov {dest}, {reg[s]}')
    else:
     if self.gatemode and self.copy[g] in yes:
      dest=f'S{nr}';nr+=1;lines.append(f'mov {dest}, {reg[d]}')
     else:dest=reg[d]
     op=('cmovg' if self.inv[g] in yes else 'cmovl')+('e' if self.inc[g] in yes else '');lines.append(f'{op} {dest}, {reg[s]}')
    reg[5+g]=dest
    for j,x in outnodes.items():
     if x==5+g:lines.append(f'out {j}, {dest}')
    g+=1
  assert g==self.m
  return lines

def simulate(lines,ty):
 r={f'P{i}':ty[i] for i in range(5)};outs={};fl=0;trace=[]
 for line in lines:
  if not line or line.startswith('#'):continue
  op,rest=line.split(None,1);d,s=[q.strip() for q in rest.split(',')]
  if op=='out':outs[int(d)]=r[s]
  elif op=='cmp':fl=(r[d]>r[s])-(r[d]<r[s]);trace.append(fl)
  elif op=='mov' or op=='cmovl' and fl<0 or op=='cmovg' and fl>0 or op=='cmovle' and fl<=0 or op=='cmovge' and fl>=0:r[d]=r[s]
 return [outs.get(j,r[f'P{j}']) for j in range(5)]==sorted(ty),trace

def solve(enc,tag,timeout,solver='kissat',seed=0):
 solver=os.environ.get('W3_ROUND3_SOLVER',solver)
 print('SOLVER',solver,flush=True)
 cnf=f'{tag}.cnf';log=f'{tag}.solver';enc.dimacs(cnf)
 bin='/path/to/repo/bin/'+solver
 cmd=['nice','-n','19','timeout',str(timeout),bin]
 if solver=='kissat':cmd+=['--seed='+str(seed)]
 cmd.append(cnf)
 def solver_memory_limit():
  import resource
  resource.setrlimit(resource.RLIMIT_AS,(1800*1024**2,1800*1024**2))
 with open(log,'w') as f:p=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,
     preexec_fn=solver_memory_limit if solver=='cadical' else None)
 model=[];st='TIMEOUT' if p.returncode==124 else 'UNKNOWN'
 for line in open(log):
  if line.startswith('s '):st=line[2:].strip()
  if line.startswith('v '):model += [int(x) for x in line[2:].split() if int(x)]
 if p.returncode==124 and st not in ('SATISFIABLE','UNSATISFIABLE'):st='TIMEOUT'
 os.unlink(cnf)
 return st,model

def loadsk(fn):
 ob=[]
 for line in open(fn):
  if line.startswith('#') or not line.strip():continue
  a,b=line.strip().split(':');ob.append([(int(u),int(v)) for u,v in zip(a[1:],b[1:])])
 return ob

def main():
 ap=argparse.ArgumentParser();ap.add_argument('skel');ap.add_argument('--k',type=int,default=31);ap.add_argument('--tag',default='logs/sat');ap.add_argument('--timeout',type=int,default=300);ap.add_argument('--init',type=int,default=12);ap.add_argument('--seed',type=int,default=1);ap.add_argument('--exact',action='store_true');ap.add_argument('--fix');ap.add_argument('--free-last',action='store_true');ap.add_argument('--all-types',action='store_true');ap.add_argument('--solver',default='kissat');ap.add_argument('--paired',action='store_true');ap.add_argument('--dynamic-from',type=int);ap.add_argument('--onehot',action='store_true');ap.add_argument('--gates',type=int);ap.add_argument('--free-copy',action='store_true');ap.add_argument('--origin',action='store_true');ap.add_argument('--union',action='store_true');a=ap.parse_args()
 ob=loadsk(a.skel);c=len(ob);F=[[(u>v)-(u<v) for u,v in row] for row in ob]
 free=[];alternatives=None
 if a.union:
  import re
  alternatives=[]
  for q in range(6):
   path=re.sub(r't[0-9]+_',f't{q}_',a.skel,count=1)
   pp=loadsk(path);prof=[[(u>v)-(u<v) for u,v in row] for row in pp]
   groups={}
   for t in range(120):groups.setdefault(tuple(prof[j][t] for j in range(c-1)),[]).append(t)
   for grp in groups.values():
    if len(grp)==1:prof[-1][grp[0]]=None
   alternatives.append(prof)
  for j in range(4,c):F[j]=[None]*120
 if a.dynamic_from:
  for j in range(a.dynamic_from-1,c):F[j]=[None]*120
 if a.free_last:
  groups={}
  for t in range(120):groups.setdefault(tuple(F[j][t] for j in range(c-1)),[]).append(t)
  for grp in groups.values():
   if len(grp)==1:free+=grp
  for t in free:F[-1][t]=None
 fixed=open(a.fix).read().splitlines() if a.fix else None
 rng=random.Random(a.seed);cur=list(range(120)) if a.all_types else sorted(rng.sample(range(120),a.init));start=time.time()
 if a.gates:print(f'GATE_MODEL gates={a.gates} copy_bound={None if a.free_copy else a.k-c-a.gates}',flush=True)
 for it in range(100):
  ff=[[row[t] for t in cur] for row in F]
  oo=[[row[t] for t in cur] for row in ob] if a.exact else None
  enc=Enc(ff,[P[t] for t in cur],a.gates or a.k-c,operands=oo,fixed=fixed,paired=a.paired,onehot=a.onehot,gates=bool(a.gates),copybound=None if a.free_copy else a.k-c-a.gates if a.gates else None,origin=a.origin,alternatives=[[[row[t] for t in cur] for row in prof] for prof in alternatives] if alternatives else None)
  print(f'ENC it={it} types={len(cur)} k={a.k} vars={enc.nv} clauses={len(enc.cs)} time={time.time()-start:.1f}',flush=True)
  st,model=solve(enc,a.tag+f'_i{it}',a.timeout,a.solver,a.seed)
  print(f'RESULT it={it} {st} time={time.time()-start:.1f}',flush=True)
  if st!='SATISFIABLE':return
  prog=enc.decode(model);Path(a.tag+f'_i{it}.s').write_text('\n'.join(prog)+'\n')
  bad=[]
  for t,ty in enumerate(P):
   ok,trace=simulate(prog,ty)
   if not ok or any(F[j][t] is not None and trace[j]!=F[j][t] for j in range(c)):bad.append(t)
  if not bad:
   print('PERMUTATION_CANDIDATE',a.tag+f'_i{it}.s',flush=True);return
  print('COUNTEREXAMPLES',len(bad),flush=True)
  cur=sorted(set(cur+rng.sample(bad,min(len(bad),6))))
if __name__=='__main__':main()
