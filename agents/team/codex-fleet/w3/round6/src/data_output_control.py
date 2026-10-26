#!/usr/bin/env python3
"""Positive control for deleting output reads while preserving SSA lifetimes."""
import json
import os
from pathlib import Path
import resource
import sys
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'round4/src'))
from insertion_sat import parse,run
from data_bound import DataCircuit,restrict_output_reads
from solver import solve

def main():
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    saved=json.loads((ROOT/'round6/logs/data_control16.graph.json').read_text())
    graph=list(saved['graph']);outputs=saved['outputs'];T=len(saved['types']);B=len(saved['names'])
    sentinel=saved['names'].index('S99')
    graph += [dict(default=0,source=outputs[1],mov=True,take=[True]*T),
              dict(default=outputs[0],source=sentinel,mov=False,take=[False]*T),
              dict(default=outputs[2],source=outputs[3],mov=False,take=[bool(i%2) for i in range(T)])]
    enc=DataCircuit(parse(ROOT/'round5/classes/p0.s'),len(graph),saved['types'])
    assert enc.names==saved['names'];restrict_output_reads(enc)
    replaced=0
    for g,gate in enumerate(graph):
        d,s=gate['default'],gate['source'];mov=gate['mov'];take=gate['take']
        if s in outputs:s=sentinel;replaced+=1
        if not mov and d in outputs:d=sentinel;replaced+=1
        if not mov and d==s:mov=True;d=0;take=[True]*T
        enc.cl(enc.mov[g] if mov else -enc.mov[g]);enc.cl(enc.src[g][s])
        if not mov:enc.cl(enc.dst[g][d])
        for t,bit in enumerate(take):enc.cl(enc.take[g][t] if bit else -enc.take[g][t])
    for j,x in enumerate(outputs):enc.cl(enc.out[j][x])
    tag=ROOT/'round6/logs/data_output_control19'
    print(json.dumps(dict(event='ENC',slots=len(graph),types=T,replaced_edges=replaced,
                         variables=enc.nv,clauses=len(enc.cs))),flush=True)
    status,model,elapsed=solve(enc,tag,60,1,'kissat')
    print(json.dumps(dict(event='RESULT',result=status,solve_seconds=elapsed)),flush=True)
    assert status=='SATISFIABLE'
    enc.check(model)
    print('INDEPENDENT_DATA_OUTPUT_CONTROL PASS',flush=True)

if __name__=='__main__':main()
