#!/usr/bin/env python3
# judge's own A10 checker: min #mov for network+reuse family (rules from w1 METHODS.md), written from scratch.
import sys, itertools, random
W1='/path/to/repo/agents/team/codex-fleet/w1/'
M32=0xffffffff
DEBUG=False
WO=[w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(len(set(w))))]
assert len(WO)==541
ALL=(1<<541)-1
THR=[[sum(1<<k for k in range(5) if w[k]>=h) for h in range(1,5)] for w in WO]
def vals(tab):  # term value on each weak order
    return [sum((tab>>m)&1 for m in THR[i]) for i in range(541)]
INP=[sum(1<<i for i in range(32) if (i>>k)&1) for k in range(5)]
def solve(seq, cap=8):
    """seq: list of (A,B) truth tables. returns min moves or None (> cap)"""
    chan=list(INP)
    terms=list(INP); tid={t:i for i,t in enumerate(terms)}
    comps=[]
    for A,B in seq:
        assert A in chan and B in chan and A!=B
        chan.remove(A); chan.remove(B)
        mn,mx=A&B,A|B
        chan+= [mn,mx]
        for t in (mn,mx):
            assert t not in tid, 'term repeats'   # w1 claim: 18 distinct new terms
            tid[t]=len(terms); terms.append(t)
        comps.append((tid[A],tid[B],tid[mn],tid[mx]))
    # final must be the 5 order statistics
    for j in range(5):
        pass
    srt=sorted(chan, key=lambda t: bin(t).count('1'))
    # order statistic j has truth table: vectors with >= (5-j) ones
    os_=[sum(1<<i for i in range(32) if bin(i).count('1')>=5-j) for j in range(5)]
    if sorted(chan)!=sorted(os_): return 'notsort'
    nt=len(terms)
    V=[vals(t) for t in terms]
    EQ=[[sum(1<<c for c in range(541) if V[a][c]==V[b][c]) for b in range(nt)] for a in range(nt)]
    LT=lambda a,b: sum(1<<c for c in range(541) if V[a][c]<V[b][c])
    EQM=lambda a,b: EQ[a][b]
    need_after=[set() for _ in comps]  # terms that later comparators use as operands
    for j in range(len(comps)):
        s=set()
        for (a,b,_,_) in comps[j+1:]:
            for x in (a,b):
                if x < 5+2*(j+1): s.add(x)
        need_after[j]=s
    start=tuple(1 if i<5 else 0 for i in range(nt))
    layer={start:0}
    for j,(a,b,mn,mx) in enumerate(comps):
        lt=LT(a,b); eq=EQ[a][b]; gt=ALL&~lt&~eq
        conds=[lt,lt|eq,gt,gt|eq]
        nxt={}
        def step(st,cost,outs):
            # apply the outputs list in order; yields new states
            if not outs:
                if all(st[t]>0 for t in need_after[j]):
                    if nxt.get(st,99)>cost: nxt[st]=cost
                return
            T=outs[0]
            seen=set()
            for cm in conds:
                notc=ALL&~cm
                Ds=[d for d in range(nt) if st[d]>0 and (notc&~EQ[d][T])==0]
                Ss=[s for s in range(nt) if st[s]>0 and (cm&~EQ[s][T])==0]
                for d in Ds:
                    for s in Ss:
                        if d==s and st[d]<2: continue
                        for cp in (0,1):
                            if cost+cp>cap: continue
                            l=list(st)
                            if cp==0: l[d]-=1
                            l[T]+=1
                            key=(tuple(l),cp)
                            if key in seen: continue
                            seen.add(key)
                            step(tuple(l),cost+cp,outs[1:])
        for st,cost in layer.items():
            for outs in ((mn,mx),(mx,mn)):
                step(st,cost,list(outs))
        layer=nxt
        if DEBUG: print('after comp',j,len(layer))
        if not layer: return None
    return min(layer.values())
def load():
    nets=[]
    for l in open(W1+'networks.txt'):
        nets.append([(int(x.split(':')[0],16),int(x.split(':')[1],16)) for x in l.split()])
    mm=[int(l.split()[1]) for l in list(open(W1+'minimum_moves.tsv'))[1:]]
    return nets,mm
if __name__=='__main__':
    nets,mm=load()
    print(len(nets),len(mm))
    mode=sys.argv[1]
    if mode=='sample':
        n=int(sys.argv[2]); seed=int(sys.argv[3]); random.seed(seed)
        idx=random.sample(range(len(nets)),n)
    else:
        idx=[int(x) for x in sys.argv[2:]]
    bad=0
    for i in idx:
        r=solve(nets[i])
        ok = r==mm[i]
        bad+= (not ok)
        print(i,r,mm[i],'OK' if ok else 'DISAGREE',flush=True)
    print('disagree',bad,'of',len(idx))
