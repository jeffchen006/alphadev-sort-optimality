#!/usr/bin/env python3
"""Free-copy insertion relaxation with a free predicate for every data gate.

Each gate selects two existing columns, and each input row independently chooses
one of them. There is no restriction on predicates or comparisons. Thus UNSAT is
a lower bound on the number of conditional moves for append-only insertion.
"""
import argparse,itertools,json,os,resource,time
from pathlib import Path
from insertion_sat import CNF, ROOT, PERMS, solve

class Circuit(CNF):
    def __init__(self,gates,control=False):
        super().__init__()
        self.types=[p for p in PERMS if list(p[:4])==sorted(p[:4])]
        self.gates=gates
        T=len(self.types)
        B=6
        self.src=[self.vec(B+g) for g in range(gates)]
        self.dst=[self.vec(B+g) for g in range(gates)]
        self.take=[self.vec(T) for g in range(gates)]
        self.out=[self.vec(B+gates) for j in range(5)]
        self.val=[[[bool(((p[x] if x<5 else 5)>>b)&1) for b in range(3)] for p in self.types] for x in range(B)]
        self.val += [[self.vec(3) for t in range(T)] for g in range(gates)]
        for ls in self.src+self.dst+self.out:self.eo(ls)
        for g in range(gates):
            d=[self.vec(3) for t in range(T)]
            s=[self.vec(3) for t in range(T)]
            for x in range(B+g):
                for t in range(T):
                    for bit in range(3):
                        self.eq(d[t][bit],self.val[x][t][bit],-self.dst[g][x])
                        self.eq(s[t][bit],self.val[x][t][bit],-self.src[g][x])
            for t in range(T):
                for bit in range(3):
                    self.eq(self.val[B+g][t][bit],d[t][bit],self.take[g][t])
                    self.eq(self.val[B+g][t][bit],s[t][bit],-self.take[g][t])
        for j,ls in enumerate(self.out):
            for x,pick in enumerate(ls):
                for t in range(T):
                    for bit in range(3):
                        v=self.val[x][t][bit]
                        self.cl(-pick,v if (j>>bit)&1 else self.neg(v))
        if control:
            assert gates==8
            prior=4
            for j in range(4):
                low,high=2*j,2*j+1
                for g in (low,high):
                    self.cl(self.dst[g][prior]);self.cl(self.src[g][j])
                self.cl(self.out[j][B+low])
                prior=B+high
            self.cl(self.out[4][prior])
        else:
            # Gate operands are unordered when each row has a free predicate.
            for g in range(gates):
                for d in range(B+g):
                    for s in range(d+1):self.cl(-self.dst[g][d],-self.src[g][s])
            # Every gate must lead to an output, directly or through a later gate.
            # A smaller circuit can be extended with self gates, so do not impose
            # dead-code restrictions here.

    def check(self,model):
        yes=set(v for v in model if v>0)
        idx=lambda ls:next(i for i,v in enumerate(ls) if v in yes)
        cols=[tuple(p[x] if x<5 else 5 for p in self.types) for x in range(6)]
        graph=[]
        for g in range(self.gates):
            d,s=idx(self.dst[g]),idx(self.src[g])
            mask=[v in yes for v in self.take[g]]
            vals=tuple(cols[s][t] if mask[t] else cols[d][t] for t in range(5))
            cols.append(vals);graph.append(dict(default=d,source=s,take=mask,column=vals))
        outputs=[idx(ls) for ls in self.out]
        assert all(cols[x]==(j,)*5 for j,x in enumerate(outputs))
        return dict(graph=graph,outputs=outputs,types=self.types)

def main():
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    ap=argparse.ArgumentParser();ap.add_argument('--gates',type=int,default=7)
    ap.add_argument('--control',action='store_true');ap.add_argument('--timeout',type=int,default=300)
    ap.add_argument('--solver',default='kissat');ap.add_argument('--tag',required=True)
    ap.add_argument('--proof',action='store_true')
    a=ap.parse_args();start=time.monotonic();enc=Circuit(a.gates,a.control)
    print(json.dumps(dict(event='ENC',gates=a.gates,variables=enc.nv,clauses=len(enc.cs))),flush=True)
    status,model,elapsed=solve(enc,ROOT/'round4/logs'/a.tag,a.timeout,1,a.solver,a.proof)
    print(json.dumps(dict(event='RESULT',result=status,solve_seconds=elapsed,seconds=time.monotonic()-start)),flush=True)
    if status=='SATISFIABLE':
        graph=enc.check(model)
        (ROOT/'round4/logs'/f'{a.tag}.json').write_text(json.dumps(graph,indent=2))
        print('INDEPENDENT_CIRCUIT_CHECK PASS',flush=True)

if __name__=='__main__':main()
