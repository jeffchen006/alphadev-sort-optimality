"""Unbounded-register SSA synthesis, relaxed garbage=T, all initial flags.
UNSAT would exclude strict programs; SAT requires strict-judge validation.
Every mov gets a fresh register, which preserves more old values at no cost.
Each cmov consumes its destination version; uninitialized destinations use G.
"""
import os,itertools,time,json,sys
import z3
ROOT='codex_work/r4'
try:os.sched_setaffinity(0,set(sorted(os.sched_getaffinity(0))[:2]))
except (AttributeError,OSError):pass
z3.set_param('parallel.enable',False)
n=int(sys.argv[1]);C=int(sys.argv[2]);W=int(sys.argv[3]);seconds=int(sys.argv[4]) if len(sys.argv)>4 else 480
L=C+W;G=n;B=5 if n+1+L<=32 else 6
solver=z3.SolverFor('QF_BV');solver.set(timeout=seconds*1000)
op=[z3.BitVec('op%d'%p,3) for p in range(L)]
d=[z3.BitVec('d%d'%p,B) for p in range(L)];s=[z3.BitVec('s%d'%p,B) for p in range(L)]
for p in range(L):
    solver.add(z3.ULE(op[p],5),z3.ULT(d[p],n+1+p),z3.ULT(s[p],n+1+p))
    solver.add(z3.Implies(op[p]==1,d[p]==G))
    solver.add(z3.Implies(op[p]==0,z3.ULE(d[p],s[p])))
    for q in range(p):
        solver.add(z3.Implies(s[p]==n+1+q,op[q]!=0))
        solver.add(z3.Implies(z3.And(op[p]!=1,d[p]==n+1+q),op[q]!=0))
        killed=z3.And(z3.UGE(op[q],2),d[q]!=G)
        solver.add(z3.Implies(killed,s[p]!=d[q]))
        solver.add(z3.Implies(z3.And(op[p]!=1,killed),d[p]!=d[q]))
solver.add(z3.PbEq([(o==0,1) for o in op],C))
cases=[(w,fl) for w in itertools.permutations(range(n)) for fl in [(False,False),(False,True),(True,False),(True,True)]]
V=[[z3.BitVec('v%d_%d'%(p,k),3) for k in range(len(cases))] for p in range(L)]
def lookup(ref,p,k):
    w,_=cases[k];v=z3.BitVecVal(n,3)
    for a in range(n):v=z3.If(ref==a,z3.BitVecVal(w[a],3),v)
    for q in range(p):v=z3.If(ref==n+1+q,V[q][k],v)
    return v
for k,(w,fl) in enumerate(cases):
    eq,lt=map(z3.BoolVal,fl)
    for p in range(L):
        D,S=lookup(d[p],p,k),lookup(s[p],p,k)
        cond=z3.If(op[p]==2,lt,z3.If(op[p]==3,z3.Or(lt,eq),z3.If(op[p]==4,z3.And(z3.Not(lt),z3.Not(eq)),z3.Not(lt))))
        solver.add(V[p][k]==z3.If(op[p]==1,S,z3.If(cond,S,D)))
        eq,lt=z3.If(op[p]==0,D==S,eq),z3.If(op[p]==0,z3.ULT(D,S),lt)
for rank in range(n):
    solver.add(z3.Or([z3.And(op[p]!=0,*[V[p][k]==rank for k in range(len(cases))]) for p in range(L)]))
tag='ssa_n%d_c%d_w%d'%(n,C,W);start=time.monotonic()
print(tag,'built cases',len(cases),'assertions',len(solver.assertions()),flush=True)
ans=solver.check();elapsed=time.monotonic()-start
result={'n':n,'c':C,'w':W,'L':L,'cases':len(cases),'result':str(ans),'seconds':elapsed,'scope':'unbounded SSA; all strict permutations; all four initial flags; common garbage=n'}
if ans==z3.unknown:result['reason']=solver.reason_unknown()
if ans==z3.sat:
    model=solver.model();result['program']=[tuple(model.eval(v).as_long() for v in (op[p],d[p],s[p])) for p in range(L)]
json.dump(result,open(ROOT+'/'+tag+'.json','w'),indent=2);print(result,flush=True)
