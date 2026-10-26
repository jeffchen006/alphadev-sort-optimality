#!/usr/bin/env python3
"""Construct ordered mux circuits for fixed comparison operand columns.
Then find the best in-place schedule for each constructed circuit.
No search result from this file is a general lower bound.
"""
from pathlib import Path
import itertools,random,time,sys,copy
sys.path.insert(0,str(Path(__file__).resolve().parent))
from ssa_sat import P,loadsk,simulate
from dag_reference import Search
IDX=[[ty.index(v) for v in range(5)] for ty in P]

def one(sk,seed,preseed=False):
 rng=random.Random(seed);ob=loadsk(sk);c=len(ob)
 F=[[(a>b)-(a<b) for a,b in row] for row in ob]
 cls=[]
 for j in range(c+1):
  codes={};cls.append([codes.setdefault(tuple(F[i][t] for i in range(j)),len(codes)) for t in range(120)])
 nodes=[[tuple(ty[i] for ty in P),0,'in',None,None,None] for i in range(5)]
 def match(col,req):return all(p is None or v==p for v,p in zip(col,req))
 def consistent(req,j):
  known={}
  for t,p in enumerate(req):
   if p is None:continue
   key=cls[j][t];v=IDX[t][p]
   if key in known and known[key]!=v:return False
   known[key]=v
  return True
 mode=seed%3
 def need(req,dl):
  opts=[i for i,n in enumerate(nodes) if n[1]<=dl and match(n[0],req)]
  if opts:
   if seed%2==0:return min(opts,key=lambda i:nodes[i][1])
   return rng.choice(opts)
  stages=[j for j in range(1,dl+1) if consistent(req,j)]
  assert stages
  if mode==0:j=stages[0]
  elif mode==1:j=stages[-1]
  else:j=rng.choice(stages)
  mask=[f<0 for f in F[j-1]]
  rs=tuple(p if b else None for p,b in zip(req,mask));rd=tuple(None if b else p for p,b in zip(req,mask))
  if all(p is None for p in rs):return need(rd,j-1)
  if all(p is None for p in rd):return need(rs,j-1)
  if rng.randrange(2):s=need(rs,j-1);d=need(rd,j-1)
  else:d=need(rd,j-1);s=need(rs,j-1)
  col=tuple(sv if b else dv for b,sv,dv in zip(mask,nodes[s][0],nodes[d][0]))
  opts=[i for i,n in enumerate(nodes) if n[1]<=j and n[0]==col]
  if opts:return opts[0]
  if rng.randrange(2):s,d=d,s;cond='cmovge'
  else:cond='cmovl'
  nodes.append([col,j,'gate',d,s,cond]);return len(nodes)-1
 cmpuse={}
 startcmp=1
 if preseed:
  cur={f'P{i}':i for i in range(5)};b=0
  for line in Path('programs/prefix_fj.s').read_text().splitlines():
   if not line.strip() or line.startswith('#'):continue
   op,rest=line.split(None,1);d,s=[x.strip() for x in rest.split(',')]
   if op=='mov':cur[d]=cur[s]
   elif op=='cmp':b+=1;cmpuse[b]=(cur[d],cur[s])
   else:
    D,S=cur[d],cur[s];mask=[f>0 for f in F[b-1]]
    col=tuple(sv if yes else dv for yes,sv,dv in zip(mask,nodes[S][0],nodes[D][0]))
    nodes.append([col,b,'gate',D,S,op]);cur[d]=len(nodes)-1
  startcmp=4
 for j in range(startcmp,c+1):
  row=ob[j-1]
  cmpuse[j]=tuple(need(tuple(ab[s] for ab in row),j-1) for s in (0,1))
 tg=[tuple([j]*120) for j in range(5)]
 outs=list(range(5));rng.shuffle(outs)
 for j in outs:need(tg[j],c)
 dummy=Search.__new__(Search);dummy.nodes=nodes;dummy.cmpuse=cmpuse;dummy.c=c;dummy.tg=tg
 # Use the exact scheduler on the constructed graph.
 ip=[];order=[]
 for b in range(1,c+1):
  gg=[g for g in range(5,len(nodes)) if nodes[g][1]==b]
  res=dummy.max_inplace(gg,0)
  if res is None:raise RuntimeError('infeasible greedy graph')
  ip+=res[0];order+=res[1]
 prog=dummy.emit(ip,order);cost=sum(not l.startswith('out') for l in prog)
 assert all(simulate(prog,ty)[0] for ty in P)
 return cost,prog,len(nodes)-5,len(nodes)-5-len(ip)

if __name__=='__main__':
 sk=sys.argv[1];n=int(sys.argv[2]) if len(sys.argv)>2 else 100;best=100000;start=time.time()
 for seed in range(n):
  k,prog,ng,nm=one(sk,seed,preseed='--preseed' in sys.argv)
  if k<best:
   best=k;tag=f'programs/greedy_{Path(sk).stem}_{"prefix_" if "--preseed" in sys.argv else ""}k{k}.s';Path(tag).write_text('# n=5 R=100 iset=I1 model=out source=w3_greedy\n'+'\n'.join(prog)+'\n');print(f'seed={seed} k={k} gates={ng} mov={nm} time={time.time()-start:.1f} file={tag}',flush=True)
