#!/usr/bin/env python3
"""Unbounded-register SSA routing for one fixed comparison-value skeleton.

A move allocates a fresh register. A conditional move destroys its old
version. Every later register read must use a live version. Columns cover
all strict orders. SAT candidates still need both independent strict judges.
"""
import argparse,itertools,json,math,os,re,resource,time
from pathlib import Path
import z3
p=argparse.ArgumentParser()
p.add_argument('skeleton');p.add_argument('cost',type=int);p.add_argument('output')
p.add_argument('--seconds',type=int,default=60);p.add_argument('--n',type=int,default=5)
p.add_argument('--hint');p.add_argument('--verify',action='store_true')
a=p.parse_args()
resource.setrlimit(resource.RLIMIT_AS,(2800000000,2800000000))
z3.set_param('parallel.enable',False)
started=time.monotonic();N=a.n
perms=list(itertools.permutations(range(N)));NT=len(perms)
value_bits=max(1,(N-1).bit_length());W=value_bits*NT

def ev(form):
 if form.startswith('='):return tuple(map(int,form[1:]))
 return tuple(max(min(t[int(d)] for d in term) for term in form.split('|')) for t in perms)
sk=[]
for line in Path(a.skeleton).read_text().splitlines():
 line=line.split('#')[0].strip()
 if not line:continue
 if ';' in line:raise SystemExit('ERROR: alternatives not supported; do not infer a negative')
 x,y=line.split(':');sk.append((ev(x),ev(y)))
C=len(sk);L=a.cost-C;S=N+L;IW=max(1,S.bit_length());BW=max(1,C.bit_length())
assert L>=0 and all(len(x)==NT and len(y)==NT for x,y in sk)

def pack(col):return sum(int(x)<<(t*value_bits) for t,x in enumerate(col))
def bv(x):return z3.BitVecVal(x,W)
def mux(idx,vals):
 out=vals[-1]
 for i in range(len(vals)-2,-1,-1):out=z3.If(idx==i,vals[i],out)
 return out
v=[bv(pack(tuple(t[i] for t in perms))) for i in range(N)]
v.extend(z3.BitVec(f'v_{n}',W) for n in range(L))
d=[z3.BitVec(f'd_{n}',IW) for n in range(L)]
s=[z3.BitVec(f's_{n}',IW) for n in range(L)]
b=[z3.BitVec(f'block_{n}',BW) for n in range(L)]
c=[z3.BitVec(f'condition_{n}',2) for n in range(L)]
mov=[z3.Bool(f'mov_{n}') for n in range(L)]
ca=[z3.BitVec(f'cmp_a_{j}',IW) for j in range(C)]
cb=[z3.BitVec(f'cmp_b_{j}',IW) for j in range(C)]
q=[z3.BitVec(f'out_{k}',IW) for k in range(N)]
solver=z3.Solver();solver.set(timeout=a.seconds*1000,threads=1)
mask_table=z3.K(z3.BitVecSort(BW+2),bv(0))
for j,(x,y) in enumerate(sk,1):
 for cond in range(4):
  mask=0
  for t,(vx,vy) in enumerate(zip(x,y)):
   take=(vx<vy if cond==0 else vx>vy if cond==1 else vx<=vy if cond==2 else vx>=vy)
   if take:mask|=((1<<value_bits)-1)<<(t*value_bits)
  mask_table=z3.Store(mask_table,z3.BitVecVal(j*4+cond,BW+2),bv(mask))
for n in range(L):
 solver.add(z3.ULT(d[n],N+n),z3.ULT(s[n],N+n),z3.ULE(b[n],C))
 if n:solver.add(z3.ULE(b[n-1],b[n]))
 solver.add(z3.Implies(z3.Not(mov[n]),b[n]!=0))
 solver.add(z3.Implies(mov[n],z3.And(c[n]==0,s[n]==d[n])))
 for m in range(n):solver.add(z3.Or(mov[m],d[n]!=d[m]),z3.Or(mov[m],s[n]!=d[m]))
 vd=mux(d[n],v[:N+n]);vs=mux(s[n],v[:N+n])
 mask=z3.Select(mask_table,z3.Concat(b[n],c[n]))
 solver.add(v[N+n]==z3.If(mov[n],vd,(vd & ~mask)|(vs & mask)))
for j,(x,y) in enumerate(sk,1):
 av,bv_=ca[j-1],cb[j-1]
 solver.add(z3.ULT(av,S),z3.ULT(bv_,S),mux(av,v)==bv(pack(x)),mux(bv_,v)==bv(pack(y)))
 for n in range(L):
  solver.add(z3.Implies(z3.Or(av==N+n,bv_==N+n),z3.ULT(b[n],j)))
  solver.add(z3.Implies(z3.And(z3.Not(mov[n]),z3.ULT(b[n],j)),z3.And(av!=d[n],bv_!=d[n])))
for k in range(N):solver.add(z3.ULT(q[k],S),mux(q[k],v)==bv(pack([k]*NT)))
inputs={tuple(t[i] for t in perms) for i in range(N)}
required={col for pair in sk for col in pair}|{tuple([k]*NT) for k in range(N)}
required-=inputs
if required:
 solver.add(z3.PbLe([(m,1) for m in mov],L-len(required)))
 for col in required:
  target=bv(pack(col));solver.add(z3.Or([z3.And(z3.Not(mov[n]),v[N+n]==target) for n in range(L)]))
# A fixed positive control tests all instruction, flag, and liveness fields.
if a.hint:
 reg={f'P{i}':i for i in range(N)};nc=0;ni=0
 for line in Path(a.hint).read_text().splitlines():
  line=line.split('#')[0].strip()
  if not line:continue
  op,args=line.split(None,1);x,y=map(str.strip,args.split(','))
  if op=='out':solver.add(q[int(x)]==reg[y]);continue
  if op=='cmp':solver.add(ca[nc]==reg[x],cb[nc]==reg[y]);nc+=1;continue
  solver.add(b[ni]==nc,mov[ni]==(op=='mov'))
  if op=='mov':solver.add(d[ni]==reg[y])
  else:solver.add(d[ni]==reg[x],s[ni]==reg[y],c[ni]==['cmovl','cmovg','cmovle','cmovge'].index(op))
  reg[x]=N+ni;ni+=1
 assert nc==C and ni==L,(nc,ni,C,L)
print(json.dumps(dict(phase='encoded',n=N,comparisons=C,noncmp=L,cost=a.cost,types=NT,bits=W,required_noninput=len(required),seconds=a.seconds,encoding_seconds=round(time.monotonic()-started,3))),flush=True)
result=solver.check()
print('SOLVER',result,'reason='+str(solver.reason_unknown()),'seconds=%.3f'%(time.monotonic()-started),flush=True)
print(solver.statistics(),flush=True)
if result==z3.sat:
 model=solver.model();iv=lambda x:model.eval(x,model_completion=True).as_long()
 mv=[z3.is_true(model.eval(x,model_completion=True)) for x in mov]
 dd=list(map(iv,d));ss=list(map(iv,s));bb=list(map(iv,b));cc=list(map(iv,c))
 aa=list(map(iv,ca));ab=list(map(iv,cb));qq=list(map(iv,q));regs={i:f'P{i}' for i in range(N)}
 code=[f'# n={N} iset=I1 model=out source=w2_ssa_exact']
 for block in range(C+1):
  if block:code.append(f'cmp {regs[aa[block-1]]}, {regs[ab[block-1]]}')
  for n in range(L):
   if bb[n]!=block:continue
   if mv[n]:
    dest=f'S{n}';code.append(f'mov {dest}, {regs[dd[n]]}')
   else:
    dest=regs[dd[n]];code.append(f'{["cmovl","cmovg","cmovle","cmovge"][cc[n]]} {dest}, {regs[ss[n]]}')
   regs[N+n]=dest
   for k,node in enumerate(qq):
    if node==N+n:code.append(f'out {k}, {dest}')
 Path(a.output).write_text('\n'.join(code)+'\n')
 print('RESULT FOUND',a.output,flush=True)
 if a.verify:
  import subprocess
  r=subprocess.run(['nice','-n','19','python3','src/verify_log.py',a.output,Path(a.output).stem+'_verified'],capture_output=True,text=True)
  print(r.stdout+r.stderr,end='',flush=True)
elif result==z3.unsat:print('RESULT UNSAT fixed_skeleton_SSA strict_orders_only',flush=True)
else:print('RESULT UNKNOWN',solver.reason_unknown(),flush=True)
print('PEAK_RSS_KIB',resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,flush=True)
