#!/usr/bin/env python3
"""Conditional-move bound after a fixed fourteen-instruction prefix.

Copies are free. Every selector has an independent predicate on every test.
All historical values remain available. An UNSAT result is a gate-count bound
for this relaxed prefix model, including new common-high scratch values.
"""
import argparse
import itertools
import json
import os
from pathlib import Path
import resource
import sys
import time

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'round4/src'))
from insertion_sat import CNF,PERMS,OPS,parse,run,solve

class Circuit(CNF):
    def __init__(self,prefix,gates,types,fixed=None):
        super().__init__()
        self.types=types;self.prefix=prefix;self.gates=gates
        states=[run(prefix,ty)[0] for ty in types]
        for st in states:st['S99']=5
        self.names=sorted(set().union(*(st for st in states)))
        # Retain names in the control encoding. Search symmetry can identify
        # duplicate initial columns by using their first representative only.
        B=self.B=len(self.names);T=len(types)
        self.src=[self.vec(B+g) for g in range(gates)]
        self.dst=[self.vec(B+g) for g in range(gates)]
        self.take=[self.vec(T) for g in range(gates)]
        self.out=[self.vec(B+gates) for _ in range(5)]
        self.val=[[[bool((st[n]>>b)&1) for b in range(3)] for st in states] for n in self.names]
        self.val += [[self.vec(3) for ty in types] for _ in range(gates)]
        for ls in self.src+self.dst+self.out:self.eo(ls)
        for g in range(gates):
            d=[self.vec(3) for _ in types];s=[self.vec(3) for _ in types]
            for x in range(B+g):
                for t in range(T):
                    for b in range(3):
                        self.eq(d[t][b],self.val[x][t][b],-self.dst[g][x])
                        self.eq(s[t][b],self.val[x][t][b],-self.src[g][x])
            for t in range(T):
                for b in range(3):
                    self.eq(self.val[B+g][t][b],d[t][b],self.take[g][t])
                    self.eq(self.val[B+g][t][b],s[t][b],-self.take[g][t])
        for j,ls in enumerate(self.out):
            for x,pick in enumerate(ls):
                for t in range(T):
                    for b in range(3):
                        v=self.val[x][t][b]
                        self.cl(-pick,v if(j>>b)&1 else self.neg(v))
        if fixed:self.fix(fixed)
        else:
            for g in range(gates):
                for d in range(B+g):
                    for s in range(d+1):self.cl(-self.dst[g][d],-self.src[g][s])
            columns={}
            for x,n in enumerate(self.names):
                col=tuple(st[n] for st in states)
                if col in columns:
                    for g in range(gates):
                        self.cl(-self.dst[g][x]);self.cl(-self.src[g][x])
                    for ls in self.out:self.cl(-ls[x])
                else:columns[col]=x

    def fix(self,program):
        cur={n:x for x,n in enumerate(self.names)}
        flags=[run(self.prefix,ty)[1] for ty in self.types]
        regs=[run(self.prefix,ty)[0] for ty in self.types]
        g=0
        for op,d,s in program:
            if op=='out':self.cl(self.out[int(d)][cur[s]])
            elif op=='mov':
                cur[d]=cur.get(s,self.names.index('S99'))
                for st in regs:st[d]=st.get(s,5)
            elif op=='cmp':
                flags=[(st.get(d,5)>st.get(s,5))-(st.get(d,5)<st.get(s,5)) for st in regs]
            else:
                x=cur.get(d,self.names.index('S99'));y=cur.get(s,self.names.index('S99'))
                self.cl(self.dst[g][x]);self.cl(self.src[g][y])
                for t,flag in enumerate(flags):
                    take=(flag<0,flag<=0,flag>0,flag>=0)[OPS.index(op)]
                    self.cl(self.take[g][t] if take else -self.take[g][t])
                    regs[t][d]=regs[t].get(s,5) if take else regs[t].get(d,5)
                cur[d]=self.B+g;g+=1
        assert g==self.gates

    def check(self,model):
        yes={x for x in model if x>0}
        idx=lambda xs:next(i for i,x in enumerate(xs) if x in yes)
        cols=[tuple(run(self.prefix,ty)[0].get(n,5) for ty in self.types) for n in self.names]
        graph=[]
        for g in range(self.gates):
            d,s=idx(self.dst[g]),idx(self.src[g]);take=[x in yes for x in self.take[g]]
            col=tuple(cols[s][t] if take[t] else cols[d][t] for t in range(len(self.types)))
            cols.append(col);graph.append(dict(default=d,source=s,take=take,column=col))
        outs=[idx(xs) for xs in self.out]
        assert all(cols[x]==(j,)*len(self.types) for j,x in enumerate(outs))
        return dict(types=self.types,names=self.names,graph=graph,outputs=outs)

def main():
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    ap=argparse.ArgumentParser();ap.add_argument('prefix');ap.add_argument('--gates',type=int,required=True)
    ap.add_argument('--tag',required=True);ap.add_argument('--timeout',type=int,default=60)
    ap.add_argument('--solver',default='cadical');ap.add_argument('--fix');ap.add_argument('--proof',action='store_true')
    args=ap.parse_args();start=time.monotonic()
    enc=Circuit(parse(args.prefix),args.gates,PERMS,parse(args.fix) if args.fix else None)
    print(json.dumps(dict(event='ENC',gates=args.gates,base=enc.B,types=len(PERMS),variables=enc.nv,
                         clauses=len(enc.cs),encode_seconds=round(time.monotonic()-start,3))),flush=True)
    tag=ROOT/'round5/logs'/args.tag
    status,model,elapsed=solve(enc,tag,args.timeout,1,args.solver,args.proof)
    print(json.dumps(dict(event='RESULT',result=status,solve_seconds=elapsed)),flush=True)
    if status=='SATISFIABLE':
        graph=enc.check(model);Path(str(tag)+'.graph.json').write_text(json.dumps(graph,indent=2)+'\n')
        print('INDEPENDENT_CIRCUIT_CHECK PASS',flush=True)

if __name__=='__main__':main()
