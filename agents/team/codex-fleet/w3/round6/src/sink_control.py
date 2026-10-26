#!/usr/bin/env python3
"""Fix the independently transformed positive circuit in the search encoding."""
import argparse
import json
import os
from pathlib import Path
import resource
import sys
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'round4/src'))
from insertion_sat import parse,run
from gate_bound import Circuit
from solver import solve
from audit_sinks import evaluate,transform

def main():
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    ap=argparse.ArgumentParser();ap.add_argument('--reference',action='store_true');args=ap.parse_args()
    saved=json.loads((ROOT/'round5/logs/gate_control12.graph.json').read_text())
    source_prefix=parse(ROOT/'round5/classes/p0.s');types=saved['types']
    prefix=parse(ROOT/'round5/classes/p37.s') if args.reference else source_prefix
    permutation=(2,0,1,3) if args.reference else (0,1,2,3)
    renamed=[tuple(t[i] for i in permutation)+(t[4],) for t in types]
    source_order={tuple(t):i for i,t in enumerate(types)}
    rows=[source_order[t] for t in renamed]
    states=[run(source_prefix,t)[0] for t in renamed]
    initial=[tuple(st.get(n,5) for st in states) for n in saved['names']]
    source_graph=[dict(g,take=[g['take'][i] for i in rows]) for g in saved['graph']]
    graph,outputs,_=transform(initial,source_graph,saved['outputs'])
    enc=Circuit(prefix,len(graph),types)
    B=enc.B;assert B==len(saved['names'])
    representatives={};mapping={}
    reference_states=[run(prefix,t)[0] for t in types]
    reference_initial=[tuple(st.get(n,5) for st in reference_states) for n in enc.names]
    for x,col in enumerate(reference_initial):representatives.setdefault(col,x)
    for x,col in enumerate(initial):mapping[x]=representatives[col]
    oldcolumns=evaluate(initial,graph)
    for g,gate in enumerate(graph):
        d,s=mapping[gate['default']],mapping[gate['source']]
        take=list(gate['take'])
        if d==s:
            s=next(x for x in sorted(set(mapping.values())) if x<B and x!=d)
            take=[False]*len(types)
        if d>s:d,s=s,d;take=[not b for b in take]
        enc.cl(enc.dst[g][d]);enc.cl(enc.src[g][s])
        for t,bit in enumerate(take):enc.cl(enc.take[g][t] if bit else -enc.take[g][t])
        mapping[B+g]=B+g
    for j,out in enumerate(outputs):enc.cl(enc.out[j][out])
    first=len(graph)-5
    for j in range(5):
        assert outputs[j]==B+first+j
        for prior in range(first,first+j):
            enc.cl(-enc.dst[first+j][B+prior]);enc.cl(-enc.src[first+j][B+prior])
    tag=ROOT/('round6/logs/sink_reference12' if args.reference else 'round6/logs/sink_control12')
    print(json.dumps(dict(event='ENC',gates=len(graph),types=len(types),variables=enc.nv,clauses=len(enc.cs))),flush=True)
    status,model,elapsed=solve(enc,tag,60,1,'kissat')
    print(json.dumps(dict(event='RESULT',result=status,solve_seconds=elapsed)),flush=True)
    assert status=='SATISFIABLE'
    enc.check(model)
    print('INDEPENDENT_SINK_CONTROL PASS',flush=True)

if __name__=='__main__':main()
