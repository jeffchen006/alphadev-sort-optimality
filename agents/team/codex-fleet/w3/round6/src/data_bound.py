#!/usr/bin/env python3
"""Count physical mov/cmov instructions after a fixed prefix.

Each cmov has a free predicate per test. Comparisons and their operands are
omitted. Copies cost one instruction. A non-sentinel cmov consumes its default
node. Common-high untouched scratch remains available without a copy. An UNSAT
result is a data-instruction bound for this relaxed fixed-prefix model.
"""
import argparse
import json
import os
from pathlib import Path
import resource
import sys
import time
from pysat.card import CardEnc,EncType
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'round4/src'))
from solver import solve
from insertion_sat import CNF,PERMS,parse,run

class DataCircuit(CNF):
    def __init__(self,prefix,slots,types,minimum_gates=0,fixed=None):
        super().__init__()
        self.prefix=prefix;self.types=types;self.m=slots
        states=[run(prefix,t)[0] for t in types]
        for st in states:st['S99']=5
        self.names=sorted(states[0]);B=self.B=len(self.names);T=len(types)
        self.sentinel=self.names.index('S99')
        self.mov=self.vec(slots)
        self.dst=[self.vec(B+g) for g in range(slots)]
        self.src=[self.vec(B+g) for g in range(slots)]
        self.take=[self.vec(T) for g in range(slots)]
        self.out=[self.vec(B+slots) for _ in range(5)]
        self.val=[[[bool((st[n]>>b)&1) for b in range(3)] for st in states] for n in self.names]
        self.val += [[self.vec(3) for _ in types] for _ in range(slots)]
        for xs in self.dst+self.src+self.out:self.eo(xs)
        for g in range(slots):
            self.cl(-self.mov[g],self.dst[g][0])
            d=[self.vec(3) for _ in types];s=[self.vec(3) for _ in types]
            for x in range(B+g):
                for t in range(T):
                    for b in range(3):
                        self.eq(d[t][b],self.val[x][t][b],-self.dst[g][x])
                        self.eq(s[t][b],self.val[x][t][b],-self.src[g][x])
                if x!=self.sentinel:
                    for h in range(g+1,slots):
                        self.cl(self.mov[g],-self.dst[g][x],-self.src[h][x])
                        self.cl(self.mov[g],-self.dst[g][x],self.mov[h],-self.dst[h][x])
                # A self-cmov can be replaced by a same-cost copy.
                self.cl(self.mov[g],-self.dst[g][x],-self.src[g][x])
            for t in range(T):
                for b in range(3):
                    self.eq(self.val[B+g][t][b],s[t][b],-self.mov[g])
                    self.eq(self.val[B+g][t][b],d[t][b],self.mov[g],self.take[g][t])
                    self.eq(self.val[B+g][t][b],s[t][b],self.mov[g],-self.take[g][t])
        for j,xs in enumerate(self.out):
            for x,pick in enumerate(xs):
                for t in range(T):
                    for b in range(3):
                        self.cl(-pick,self.val[x][t][b] if (j>>b)&1 else self.neg(self.val[x][t][b]))
        if minimum_gates:
            if slots<minimum_gates:self.cl()
            else:
                ca=CardEnc.atmost(self.mov,bound=slots-minimum_gates,top_id=self.nv,encoding=EncType.seqcounter)
                self.nv=max(self.nv,ca.nv);self.cs+=ca.clauses
        if fixed:self.fix(fixed)

    def fix(self,program):
        cur={n:x for x,n in enumerate(self.names)}
        states=[run(self.prefix,t)[0] for t in self.types]
        flags=[run(self.prefix,t)[1] for t in self.types]
        g=0
        for op,d,s in program:
            if op=='out':self.cl(self.out[int(d)][cur[s]])
            elif op=='cmp':flags=[(st.get(d,5)>st.get(s,5))-(st.get(d,5)<st.get(s,5)) for st in states]
            else:
                self.cl(self.mov[g] if op=='mov' else -self.mov[g])
                self.cl(self.src[g][cur.get(s,self.sentinel)])
                if op!='mov':
                    self.cl(self.dst[g][cur.get(d,self.sentinel)])
                    for t,flag in enumerate(flags):
                        yes={'cmovl':flag<0,'cmovle':flag<=0,'cmovg':flag>0,'cmovge':flag>=0}[op]
                        self.cl(self.take[g][t] if yes else -self.take[g][t])
                for t,st in enumerate(states):
                    yes=op=='mov' or {'cmovl':flags[t]<0,'cmovle':flags[t]<=0,'cmovg':flags[t]>0,'cmovge':flags[t]>=0}.get(op,False)
                    if yes:st[d]=st.get(s,5)
                    else:st.setdefault(d,5)
                cur[d]=self.B+g;g+=1
        assert g==self.m

    def check(self,model):
        yes=set(x for x in model if x>0)
        idx=lambda xs:next(i for i,x in enumerate(xs) if x in yes)
        cols=[tuple(run(self.prefix,t)[0].get(n,5) for t in self.types) for n in self.names]
        alive=set(range(self.B));graph=[]
        for g in range(self.m):
            d,s=idx(self.dst[g]),idx(self.src[g]);mov=self.mov[g] in yes
            assert s in alive
            if not mov:assert d in alive
            take=[mov or x in yes for x in self.take[g]]
            cols.append(tuple(cols[s][t] if take[t] else cols[d][t] for t in range(len(self.types))))
            if not mov and d!=self.sentinel:alive.remove(d)
            alive.add(self.B+g)
            graph.append(dict(default=d,source=s,mov=mov,take=take,column=cols[-1]))
        outs=[idx(xs) for xs in self.out]
        assert all(cols[x]==(j,)*len(self.types) for j,x in enumerate(outs))
        return dict(types=self.types,names=self.names,graph=graph,outputs=outs)

def restrict_output_reads(enc):
    for out in enc.out:
        for x,pick in enumerate(out):
            first=max(0,x-enc.B+1)
            for h in range(first,enc.m):
                enc.cl(-pick,-enc.src[h][x])
                enc.cl(-pick,enc.mov[h],-enc.dst[h][x])


def main():
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    ap=argparse.ArgumentParser();ap.add_argument('prefix');ap.add_argument('--slots',type=int,required=True)
    ap.add_argument('--tag',required=True);ap.add_argument('--minimum-gates',type=int,default=0)
    ap.add_argument('--timeout',type=int,default=1200);ap.add_argument('--solver',default='kissat')
    ap.add_argument('--fix');ap.add_argument('--proof',action='store_true')
    ap.add_argument('--no-output-reads',action='store_true');args=ap.parse_args()
    start=time.monotonic()
    enc=DataCircuit(parse(args.prefix),args.slots,PERMS,args.minimum_gates,parse(args.fix) if args.fix else None)
    if args.no_output_reads:
        assert args.fix is None
        # Output rank j cannot be on a selected trace to any other output.
        # In this free-predicate model its outgoing sources can be replaced by
        # the persistent sentinel. An outgoing default can instead allocate a
        # fresh scratch register at the same cmov cost. Outputs stay in place;
        # moving an output could otherwise make its source unavailable.
        restrict_output_reads(enc)
    print(json.dumps(dict(event='ENC',slots=args.slots,minimum_gates=args.minimum_gates,base=enc.B,
                         no_output_reads=args.no_output_reads,
                         types=len(PERMS),variables=enc.nv,clauses=len(enc.cs),
                         encode_seconds=round(time.monotonic()-start,3))),flush=True)
    tag=ROOT/'round6/logs'/args.tag
    status,model,elapsed=solve(enc,tag,args.timeout,1,args.solver,args.proof)
    print(json.dumps(dict(event='RESULT',result=status,solve_seconds=elapsed,
                         peak_self_rss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
                         peak_child_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss)),flush=True)
    if status=='SATISFIABLE':
        graph=enc.check(model);Path(str(tag)+'.graph.json').write_text(json.dumps(graph,indent=2)+'\n')
        print('INDEPENDENT_DATA_CIRCUIT_CHECK PASS',flush=True)

if __name__=='__main__':main()
