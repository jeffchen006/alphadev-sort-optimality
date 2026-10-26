#!/usr/bin/env python3
"""Check the output-sink transformation on a saved positive circuit.

This is a finite control check. It does not prove the general transformation.
All predicates stay fixed during the transformation.
"""
import json
import os
from pathlib import Path
import resource
import sys
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'round4/src'))
from insertion_sat import parse,run

def evaluate(initial,graph):
    cols=list(initial)
    for gate in graph:
        d=cols[gate['default']];s=cols[gate['source']]
        cols.append(tuple(b if take else a for a,b,take in zip(d,s,gate['take'])))
    return cols

def transform(initial,graph,outputs):
    B=len(initial);targets=set(outputs)
    assert len(targets)==5 and all(x>=B for x in targets)
    permutation=[B+i for i in range(len(graph)) if B+i not in targets]+list(outputs)
    index={i:i for i in range(B)}
    index.update({old:B+i for i,old in enumerate(permutation)})
    transformed=[];replaced=0
    for old in permutation:
        gate=graph[old-B]
        operands=[]
        for side in ('default','source'):
            x=gate[side]
            if x in targets:x=0;replaced+=1
            operands.append(index[x])
        transformed.append(dict(default=operands[0],source=operands[1],take=gate['take']))
    return transformed,[index[x] for x in outputs],replaced

def main():
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    saved=json.loads((ROOT/'round5/logs/gate_control12.graph.json').read_text())
    graph=saved['graph'];outputs=saved['outputs']
    matching=[]
    for name in ('p0','p37'):
        states=[run(parse(ROOT/f'round5/classes/{name}.s'),ty)[0] for ty in saved['types']]
        initial=[tuple(st.get(n,5) for st in states) for n in saved['names']]
        columns=evaluate(initial,graph)
        if all(columns[len(initial)+i]==tuple(g['column']) for i,g in enumerate(graph)):
            matching.append((name,states,initial))
    assert len(matching)==1,matching
    prefix_name,states,initial=matching[0]
    cols=evaluate(initial,graph)
    assert all(cols[x]==(j,)*len(states) for j,x in enumerate(outputs))
    transformed,newouts,replaced=transform(initial,graph,outputs)
    newcols=evaluate(initial,transformed)
    assert all(newcols[x]==(j,)*len(states) for j,x in enumerate(newouts))
    assert newouts==list(range(len(newcols)-5,len(newcols)))
    assert all(gate[side]<len(newcols)-5 for gate in transformed[-5:] for side in ('default','source'))
    for i,gate in enumerate(transformed):
        assert gate['default']<len(initial)+i and gate['source']<len(initial)+i
    # Force more outgoing output edges while preserving every current column.
    # A selector may choose an earlier constant output only where its value
    # equals the old edge value. The inserted node then duplicates that edge.
    augmented=[];mapping={i:i for i in range(len(initial))};available=[]
    T=len(states)
    for i,gate in enumerate(graph):
        operands=[]
        for side in ('default','source'):
            x=gate[side]
            if available:
                out=available[-1];rank=outputs.index(out)
                mix=dict(default=mapping[x],source=mapping[out],
                         take=[cols[x][t]==rank for t in range(T)])
                augmented.append(mix);operands.append(len(initial)+len(augmented)-1)
            else:operands.append(mapping[x])
        augmented.append(dict(default=operands[0],source=operands[1],take=gate['take']))
        mapping[len(initial)+i]=len(initial)+len(augmented)-1
        if len(initial)+i in outputs:available.append(len(initial)+i)
    augmentedouts=[mapping[x] for x in outputs]
    acols=evaluate(initial,augmented)
    assert all(acols[x]==(j,)*T for j,x in enumerate(augmentedouts))
    altered,alteredouts,more=transform(initial,augmented,augmentedouts)
    alteredcols=evaluate(initial,altered)
    assert all(alteredcols[x]==(j,)*T for j,x in enumerate(alteredouts))
    result=dict(status='PASS',prefix=prefix_name,types=T,original_gates=len(graph),original_outgoing_edges_replaced=replaced,
                augmented_gates=len(augmented),augmented_outgoing_edges_replaced=more,
                note='Finite control checks; general soundness uses the rank-trace argument.')
    (ROOT/'round6/logs/sink_transform_audit.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result),flush=True)

if __name__=='__main__':main()
