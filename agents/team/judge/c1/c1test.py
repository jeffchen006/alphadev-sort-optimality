#!/usr/bin/env python3
# judge's own differential test of w12's C1 lemma (written from lemma.md only, not w12's code).
# P: random straight-line program, n=3 inputs P0..P2, scratch S0..S2 (regs 3..5). Outputs = final P0..P2 (default snapshots).
# P accepted if outputs identical for ALL garbage in G^3 and ALL initial flags {lt,eq,gt}, on all weak orders (values 0..2).
# Q = compile(P) by the lemma; check: Q has no garbage reads (scratch read before write), len(Q)<=len(P),
# and Q gives the same outputs as P on all inputs, with arbitrary garbage/flags.
import itertools, random, sys
N=3; R=6
G=[-1,0,1,2,3]
ORD=[w for w in itertools.product(range(N),repeat=N) if set(w)==set(range(max(w)+1))]
CONDS={'cmovl':lambda f:f<0,'cmovle':lambda f:f<=0,'cmovg':lambda f:f>0,'cmovge':lambda f:f>=0}
def run(prog,w,gv,f0,regs=R):
    r=list(w)+list(gv)+[0]*(regs-N-len(gv)); f=f0
    for op,a,b in prog:
        if op=='mov': r[a]=r[b]
        elif op=='cmp': f=(r[a]>r[b])-(r[a]<r[b])
        elif CONDS[op](f): r[a]=r[b]
    return tuple(r[:N])
def accept(prog):
    ref={}
    for w in ORD:
        outs=set()
        for gv in itertools.product(G,repeat=3):
            for f0 in (-1,0,1):
                outs.add(run(prog,w,gv,f0))
                if len(outs)>1: return None
        ref[w]=next(iter(outs))
    return ref
def compile_c1(prog):
    # classes: cls[reg]=class id; info[class]=('def',phys) or ('unb',None)
    cls={i:i for i in range(R)}; info={i:('def',i) for i in range(N)}
    for i in range(N,R): info[i]=('unb',None)
    nid=R; nphys=R; Q=[]; const=True   # initial flags specialized to eq
    def members(c): return [r for r in cls if cls[r]==c]
    def merge(c1,c2):   # merge classes; result defined if either defined
        nonlocal info
        d=[c for c in (c1,c2) if info[c][0]=='def']
        keep=d[0] if d else c1
        for r in cls:
            if cls[r] in (c1,c2): cls[r]=keep
        return keep
    for op,a,b in prog:
        if op=='mov':
            cls[a]=cls[b]; continue
        if op=='cmp':
            ca,cb=cls[a],cls[b]
            if info[ca][0]=='def' and info[cb][0]=='def':
                Q.append(('cmp',info[ca][1],info[cb][1])); const=False
            else:
                if ca!=cb: merge(ca,cb)
                const=True
            continue
        cond=CONDS[op]
        if const:   # flags eq
            if cond(0): cls[a]=cls[b]
            continue
        ca,cb=cls[a],cls[b]
        if ca==cb: continue
        if info[ca][0]=='unb' or info[cb][0]=='unb':
            merge(ca,cb); continue
        # defined, different classes
        if len(members(ca))==1:
            Q.append((op,info[ca][1],info[cb][1]))
        else:
            t=nphys; nphys+=1
            Q.append(('mov',t,info[ca][1])); Q.append((op,t,info[cb][1]))
            nid+=1; cls[a]=nid; info[nid]=('def',t)
    outs=[]
    for j in range(N):
        c=cls[j]
        if info[c][0]!='def': return None,'unbound output'
        outs.append(info[c][1])
    return Q,outs,nphys
def runQ(Q,outs,w,gv,f0,nphys):
    r=list(w)+list(gv)+[0]*(nphys-N-len(gv)); f=f0
    for op,a,b in Q:
        if op=='mov': r[a]=r[b]
        elif op=='cmp': f=(r[a]>r[b])-(r[a]<r[b])
        elif CONDS[op](f): r[a]=r[b]
    return tuple(r[o] for o in outs)
def garbage_free(Q):
    written=set(range(N))
    for op,a,b in Q:
        if b not in written: return False
        if op=='mov': written.add(a)
        elif op!='cmp' and a not in written: return False
        elif op!='cmp': pass
    return True
if __name__=='__main__':
    seed=int(sys.argv[1]); cnt=int(sys.argv[2]); L=int(sys.argv[3])
    rnd=random.Random(seed); acc=0; bad=0; useful=0
    OPS=['mov','cmp','cmovl','cmovle','cmovg','cmovge']
    for _ in range(cnt):
        prog=[(rnd.choice(OPS),)+tuple(rnd.sample(range(R),2)) for _ in range(rnd.randint(2,L))]
        ref=accept(prog)
        if ref is None: continue
        acc+=1
        res=compile_c1(prog)
        if res[0] is None: print('FAIL unbound output',prog); bad+=1; continue
        Q,outs,nphys=res
        ok=len(Q)<=len(prog) and garbage_free(Q)
        for w in ORD:
            for gv in [(g1,g2,g3) for g1 in (-1,1,3) for g2 in (-1,2) for g3 in (0,3)]:
                for f0 in (-1,0,1):
                    if runQ(Q,outs,w,gv,f0,nphys)!=ref[w]: ok=False
        if any(op!='cmp' and False for op,a,b in prog): pass
        if len(Q)<len(prog): useful+=1
        if not ok:
            bad+=1; print('FAIL',prog,Q,len(Q),len(prog))
    print('seed',seed,'accepted',acc,'strictly-shorter',useful,'bad',bad)
