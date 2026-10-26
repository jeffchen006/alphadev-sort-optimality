# like moncirc.py + symmetry breaking. usage: moncirc2.py n G
# min number of 2-input AND/OR gates computing all thresholds T_k = [sum x >= k] (= min/max gates to sort n, 0-1 principle)
import sys
from pysat.solvers import Cadical153
n=int(sys.argv[1]); G=int(sys.argv[2])
R=[r for r in range(1<<n) if 0<r<(1<<n)-1]
cnt=[0]
def new(): cnt[0]+=1; return cnt[0]
cl=[]; val={}
for i in range(n): val[i]=[bool((r>>i)&1) for r in R]
def gate_clauses(cond,v,va,vb,tt):
    if isinstance(va,bool) and isinstance(vb,bool):
        f=(va and vb) if tt else (va or vb); return [cond+[v if f else -v]]
    if isinstance(va,bool): va,vb=vb,va
    if isinstance(vb,bool):
        if (tt and vb) or (not tt and not vb): return [cond+[-v,va],cond+[v,-va]]
        if tt: return [cond+[-v]]
        return [cond+[v]]
    if tt: return [cond+[-v,va],cond+[-v,vb],cond+[v,-va,-vb]]
    return [cond+[v,-va],cond+[v,-vb],cond+[-v,va,vb]]
SEL=[]; TY=[]
for g in range(G):
    node=n+g; v=[new() for _ in R]; t=new(); TY.append(t); sels={}
    for a in range(node):
        for b in range(a+1,node):
            s=new(); sels[(a,b)]=s
            for k in range(len(R)):
                for tt in (0,1): cl+=gate_clauses([-s,(-t if tt else t)],v[k],val[a][k],val[b][k],tt)
    L=list(sels.values()); cl.append(L)
    for i1 in range(len(L)):
        for i2 in range(i1+1,len(L)): cl.append([-L[i1],-L[i2]])
    SEL.append(sels); val[node]=v
# first gate = x0 AND x1 (input symmetry + AND/OR duality, thresholds are closed under both)
cl.append([SEL[0][(0,1)]]); cl.append([TY[0]])
OUT=[]
for k in range(1,n+1):
    T=[bin(r).count('1')>=k for r in R]; eqs=[]
    for g in range(G):
        e=new(); eqs.append(e)
        for idx in range(len(R)): cl.append([-e, val[n+g][idx] if T[idx] else -val[n+g][idx]])
    cl.append(eqs); OUT.append(eqs)
# every gate used (operand of a later gate, or an output)
for g in range(G):
    node=n+g; uses=[OUT[k][g] for k in range(n)]
    for h in range(g+1,G):
        for (a,b),s in SEL[h].items():
            if a==node or b==node: uses.append(s)
    cl.append(uses)
# canonical topological order: if gate g+1 does not read gate g, its pair (b,a) is > gate g's pair, or equal with AND before OR
for g in range(G-1):
    node=n+g
    for (a1,b1),s1 in SEL[g].items():
        for (a2,b2),s2 in SEL[g+1].items():
            if a2==node or b2==node: continue
            if (b2,a2)<(b1,a1): cl.append([-s1,-s2])
            elif (b2,a2)==(b1,a1): cl.append([-s1,-s2,TY[g]]); cl.append([-s1,-s2,-TY[g+1]])  # same pair: AND then OR
s=Cadical153(bootstrap_with=cl)
res=s.solve(); print(n,G,'SAT' if res else 'UNSAT',flush=True)
if res:
    m=set(x for x in s.get_model() if x>0); name=lambda x: f"x{x}" if x<n else f"g{x-n}"
    for g in range(G):
        for (a,b),sv in SEL[g].items():
            if sv in m: print(f"g{g} = {name(a)} {'AND' if TY[g] in m else 'OR'} {name(b)}")
    for k in range(n):
        print(f"T{k+1} =", [f"g{g}" for g in range(G) if OUT[k][g] in m])
