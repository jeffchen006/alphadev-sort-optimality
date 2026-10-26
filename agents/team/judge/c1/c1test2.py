import random, sys
from c1test import *
def reads_garbage(prog):
    w=set(range(N))
    for op,a,b in prog:
        if b not in w: return True
        if op=='mov': w.add(a)
        elif op!='cmp' and a not in w: return True
        elif op=='cmp' and a not in w: return True
    return False
seed=int(sys.argv[1]); cnt=int(sys.argv[2]); L=int(sys.argv[3])
rnd=random.Random(seed); acc=bad=nontriv=gread=short=0
OPS=['mov','cmp','cmovl','cmovle','cmovg','cmovge']
for _ in range(cnt):
    prog=[]
    for _ in range(rnd.randint(3,L)):
        op=rnd.choice(OPS)
        if op=='cmp': a,b=rnd.sample(range(R),2)
        else:
            a=rnd.choice(list(range(N))+list(range(R))); b=rnd.choice([x for x in range(R) if x!=a])
        prog.append((op,a,b))
    ref=accept(prog)
    if ref is None: continue
    acc+=1
    nt = any(ref[w]!=w for w in ORD); nontriv+=nt
    gr=reads_garbage(prog); gread+=gr
    res=compile_c1(prog)
    if res[0] is None: print('FAIL unbound',prog); bad+=1; continue
    Q,outs,nphys=res
    ok=len(Q)<=len(prog) and garbage_free(Q)
    for w in ORD:
        for gv in [(a1,a2,a3) for a1 in (-1,1,3) for a2 in (-1,2) for a3 in (0,3)]:
            for f0 in (-1,0,1):
                if runQ(Q,outs,w,gv,f0,nphys)!=ref[w]: ok=False
    if nt and gr and len(Q)>=len(prog)-0: short+=0
    if not ok: bad+=1; print('FAIL',prog,Q)
print('seed',seed,'acc',acc,'nontrivial',nontriv,'reads-garbage',gread,'bad',bad)
