# min number of 2-input AND/OR gates computing all thresholds T_k(x) = [sum x >= k], k=1..n (= min/max gates to sort n)
import sys, itertools
from pysat.solvers import Cadical153
from pysat.card import CardEnc
n=int(sys.argv[1]); G=int(sys.argv[2])
R=[r for r in range(1<<n) if 0<r<(1<<n)-1]
cnt=[0]; new=lambda:(cnt.__setitem__(0,cnt[0]+1),cnt[0])[1]
cl=[]
val={}  # node -> list of literals per row (inputs constant)
for i in range(n): val[i]=[bool((r>>i)&1) for r in R]  # ints 0/1 = constants
def lit(x): return x  # constants handled below
for g in range(G):
    node=n+g; v=[new() for _ in R]; t=new(); sels=[]
    for a in range(node):
        for b in range(a+1,node):
            s=new(); sels.append(s); A=val[a]; B=val[b]
            for k,r in enumerate(R):
                # AND: v = A&B ; OR: v = A|B
                for tt in (0,1):
                    va,vb=A[k],B[k]
                    def L(x,pos):  # literal "x is true" (pos) / false; x int const or var
                        return x if pos else -x
                    # build clauses generically with constants
                    cond=[-s, (-t if tt else t)]
                    # v <-> f(va,vb)
                    if isinstance(va,bool) and isinstance(vb,bool):
                        f=(va&vb) if tt else (va|vb); cl.append(cond+[v[k] if f else -v[k]])
                    else:
                        if isinstance(va,bool): va,vb=vb,va
                        if isinstance(vb,bool):
                            if tt: # v = va & c
                                if vb: cl.append(cond+[-v[k],va]); cl.append(cond+[v[k],-va])
                                else: cl.append(cond+[-v[k]])
                            else:
                                if vb: cl.append(cond+[v[k]])
                                else: cl.append(cond+[-v[k],va]); cl.append(cond+[v[k],-va])
                        else:
                            if tt: cl+= [cond+[-v[k],va],cond+[-v[k],vb],cond+[v[k],-va,-vb]]
                            else: cl+= [cond+[v[k],-va],cond+[v[k],-vb],cond+[-v[k],va,vb]]
    cl.append(sels)
    for i1 in range(len(sels)):
        for i2 in range(i1+1,len(sels)): cl.append([-sels[i1],-sels[i2]])
    val[node]=v
for k in range(1,n+1):
    T=[1 if bin(r).count('1')>=k else 0 for r in R]; eqs=[]
    for g in range(G):
        e=new(); eqs.append(e)
        for idx,r in enumerate(R): cl.append([-e, val[n+g][idx] if T[idx] else -val[n+g][idx]])
    cl.append(eqs)
s=Cadical153(bootstrap_with=cl)
print(n,G,'SAT' if s.solve() else 'UNSAT',flush=True)
