"""Exact-column local synthesis. No garbage-valued intermediate registers.
CEGIS checks every candidate on all 541 weak orders; SAT is sent to the strict judge.
"""
import itertools,json,os,pathlib,random,sys,time,z3
from analyse import *
os.sched_setaffinity(0,{0,1});z3.set_param('parallel.enable',False)
base,rows=trace(readprog(DIR/'w6_c8_k32.s')); mode=sys.argv[1]; seconds=int(sys.argv[2]) if len(sys.argv)>2 else 180
if mode.startswith('tail'):startrow=26;C=2;writes=4;targets=[23,24,21]
elif mode.startswith('max'):startrow=20;C=3;writes=9;targets=[23,24,21,18]
else:raise ValueError(mode)
if len(sys.argv)>3:writes=int(sys.argv[3])
tag=mode+'_w'+str(writes)
partition=None
if len(sys.argv)>4:
    partition=list(map(int,sys.argv[4].split(',')));assert sum(partition)==writes and len(partition)==C
    tag+='_'+''.join(map(str,partition))
regmap=rows[startrow]['regs']; initial=list(dict.fromkeys(regmap.values()))
if mode.startswith('max'):initial=list(dict.fromkeys(initial)) # The duplicate E is removed at no cost in this local problem.
if mode=='maxcore':initial=[15,12,11,5]
garbage=None
if mode.endswith('g'):
    garbage=len(initial);initial.append(len(base));base.append((5,)*541)
N=len(initial); L=C+writes; bits=(N+L).bit_length();start=time.monotonic();solver=z3.SolverFor('QF_BV')
op=[z3.BitVec('o%d'%p,3) for p in range(L)]
d=[z3.BitVec('d%d'%p,bits) for p in range(L)];s=[z3.BitVec('s%d'%p,bits) for p in range(L)]
out=[z3.BitVec('out%d'%j,bits) for j in range(len(targets))]
for p in range(L):
    solver.add(z3.ULE(op[p],5),z3.ULT(d[p],N+p),z3.ULT(s[p],N+p))
    solver.add(z3.Implies(op[p]==0,z3.ULE(d[p],s[p])))
    solver.add(z3.Implies(op[p]==1,d[p]==0))
    solver.add(z3.Implies(z3.UGE(op[p],2),d[p]!=s[p]))
    for q in range(p):
        solver.add(z3.Implies(s[p]==N+q,op[q]!=0))
        solver.add(z3.Implies(z3.And(op[p]!=1,d[p]==N+q),op[q]!=0))
        kill=z3.UGE(op[q],2) if garbage is None else z3.And(z3.UGE(op[q],2),d[q]!=garbage)
        solver.add(z3.Implies(kill,s[p]!=d[q]))
        solver.add(z3.Implies(z3.And(op[p]!=1,kill),d[p]!=d[q]))
solver.add(z3.PbEq([(v==0,1) for v in op],C))
if partition:
    cp=[];p=0
    for nw in partition:cp.append(p);p+=1+nw
    for p in range(L):solver.add(op[p]==0 if p in cp else op[p]!=0)
    if mode.startswith('max'):
        aa,bb=sorted([initial.index(5),initial.index(11)])
        solver.add(d[0]==aa,s[0]==bb)
for o in out:
    solver.add(z3.ULT(o,N+L))
    for q in range(L):solver.add(z3.Implies(o==N+q,op[q]!=0))
V={};cases=set();
fl=rows[startrow]['flag'];flagcols=[base[i] for i in fl]
def addcase(k):
    cases.add(k);vs=[z3.BitVec('v%d_%d'%(p,k),3) for p in range(L)];V[k]=vs
    def look(ref,p):
        v=z3.BitVecVal(0,3)
        for j,t in enumerate(initial):v=z3.If(ref==j,z3.BitVecVal(base[t][k],3),v)
        for q in range(p):v=z3.If(ref==N+q,vs[q],v)
        return v
    eq=z3.BoolVal(flagcols[0][k]==flagcols[1][k]);lt=z3.BoolVal(flagcols[0][k]<flagcols[1][k])
    for p in range(L):
        a,b=look(d[p],p),look(s[p],p)
        cond=z3.If(op[p]==2,lt,z3.If(op[p]==3,z3.Or(lt,eq),z3.If(op[p]==4,z3.And(z3.Not(lt),z3.Not(eq)),z3.Not(lt))))
        solver.add(vs[p]==z3.If(op[p]==1,b,z3.If(cond,b,a)))
        eq=z3.If(op[p]==0,a==b,eq);lt=z3.If(op[p]==0,z3.ULT(a,b),lt)
    for o,t in zip(out,targets):solver.add(look(o,L)==base[t][k])
strict=[k for k,w in enumerate(W) if len(set(w))==5]
rng=random.Random(532);rng.shuffle(strict)
for k in strict[:12]:addcase(k)
iterations=0;result={}
while time.monotonic()-start<seconds:
    solver.set(timeout=max(1,int(1000*(seconds-(time.monotonic()-start)))))
    ans=solver.check();iterations+=1
    print(mode,iterations,len(cases),ans,round(time.monotonic()-start,1),flush=True)
    if ans!=z3.sat:
        result=dict(result=str(ans),reason=solver.reason_unknown() if ans==z3.unknown else '');break
    model=solver.model();prog=[tuple(model.eval(x).as_long() for x in (op[p],d[p],s[p])) for p in range(L)];oi=[model.eval(x).as_long() for x in out]
    vals=[base[t] for t in initial];f=tuple(flagcols)
    for o,a,b in prog:
        if o==0:f=(vals[a],vals[b]);v=vals[a]
        elif o==1:v=vals[b]
        else:v=sel(*f,vals[a],vals[b],list(CS)[o-2])
        vals.append(v)
    bad=[k for k in range(541) if any(vals[o][k]!=base[t][k] for o,t in zip(oi,targets))]
    if not bad:
        result=dict(result='SAT_ALL_541',program=prog,outputrefs=oi,initial=initial)
        pool=list(dict.fromkeys(v for v in base+vals if 5 not in v))
        if len(pool)<=27:writepool(DIR/f'pool_window_{tag}.txt',pool)
        prefix=readprog(DIR/'w6_c8_k32.s')[:startrow+1]
        if mode.startswith('max'):prefix=[p for p in prefix if p!='mov S6, S2']
        physical={i:next((k for k,v in regmap.items() if v==t),'S20') for i,t in enumerate(initial)}
        emitted=set();body=list(prefix);scratch=10
        for p,(o,a,b) in enumerate(prog):
            if o==0:body.append(f'cmp {physical[a]}, {physical[b]}')
            elif o==1:
                dst=f'S{scratch}';scratch+=1;body.append(f'mov {dst}, {physical[b]}');physical[N+p]=dst
            else:
                dst=physical[a]
                if a==garbage:dst=f'S{scratch}';scratch+=1
                body.append(f'{list(CS)[o-2]} {dst}, {physical[b]}');physical[N+p]=dst
            if o:
                for j,t in enumerate(targets):
                    if vals[N+p]==base[t] and j not in emitted:
                        emitted.add(j);body.append(f'out {[1,2,3,4][j]}, {physical[N+p]}')
        header='# n=5 model=out iset=I1 len=%d source=d7 local_window\n'%sum(not s.startswith('out') for s in body)
        (DIR/f'window_{tag}.s').write_text(header+'\n'.join(body)+'\n')
        break
    rng.shuffle(bad)
    for k in bad[:12]:
        if k not in cases:addcase(k)
else:result=dict(result='TIMEOUT')
result.update(mode=mode,c=C,writes=writes,initial=initial,cases=len(cases),iterations=iterations,seconds=time.monotonic()-start)
(DIR/f'window_{tag}.json').write_text(json.dumps(result,indent=2));print(result,flush=True)
