import sys, signal; sys.path.insert(0,'.')
import dag
from rsat import normalize, flag, COND
TY=dag.TY
prog=normalize(open(sys.argv[2]).read().splitlines()[1:])
reg={'P%d'%i: tuple(t[i] for t in TY) for i in range(5)}
j=0; known=set()
for l in prog:
    op,rest=l.split(None,1); d,sr=[x.strip() for x in rest.split(',')]
    if op=='out': continue
    if op=='cmp': j+=1; fl=[flag(a,b) for a,b in zip(reg[d],reg[sr])]; continue
    if op=='mov': reg[d]=reg[sr]; continue
    c=COND[op]
    M=tuple(sv if ((f=='l' and 'l' in c) or (f=='g' and 'g' in c) or (f=='e' and c.endswith('e'))) else dv for f,sv,dv in zip(fl,reg[sr],reg[d]))
    known.add((j,M)); reg[d]=M
s=dag.Search(dag.load(sys.argv[1]),int(sys.argv[3]),1,log=lambda x: print(x,flush=True))
orig=s.rec
def rec(stack):
    if stack and stack[-1][0]=='fin':
        g=stack[-1][1]; nd=s.nodes[g]
        ts=s.tset[(nd[1],nd[5])]; Dc,Sc=s.nodes[nd[3]][0],s.nodes[nd[4]][0]
        M=tuple(a if t else b for t,a,b in zip(ts,Sc,Dc))
        if (nd[1],M) not in known: return
    return orig(stack)
s.rec=rec
signal.signal(signal.SIGALRM,lambda *a: (print('calls',s.calls,'leaves',s.leaves),sys.exit(0))); signal.alarm(100)
def lf():
    G=list(range(5,len(s.nodes))); r=s.max_inplace(G,0); print("leaf gates",len(G),"inplace",None if r is None else len(r[0]), [(n[1],n[5],n[3],n[4]) for n in s.nodes[5:]], s.cmpuse)
s.leaf=lf
s.run(); print('RESULT calls',s.calls,'leaves',s.leaves,'sols',s.nsol)
