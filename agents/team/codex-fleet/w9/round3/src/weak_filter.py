"""Necessary comparison-history test on all 541 weak orders.

Within one flag history, each input-derived register holds one fixed original
input identity. This test permits arbitrary data instructions and registers.
It rejects a required comparison if no input-identity pair can give its flag
column on every order in one history class. Both operand directions are tried.
"""
import argparse
from collections import Counter
import json
import os
from pathlib import Path
import resource
import sys

sys.dont_write_bytecode=True
HERE=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(HERE.parent/'round2/src'))
from order_kissat import CASES,evaluate
from control import transformed

ALL=(1<<541)-1
PAIRS=[bytes((w[i]>w[j])-(w[i]<w[j])+1 for w in CASES)
       for i in range(5) for j in range(5)]


def filter_order(flags):
    parts=[ALL]
    for j,f in enumerate(flags):
        masks=[sum(1<<t for t,x in enumerate(f) if x==v) for v in range(3)]
        matches=[sum(1<<t for t,(x,y) in enumerate(zip(f,pair)) if x==y) for pair in PAIRS]
        for part in parts:
            if any(part&~m==0 for m in matches):continue
            # A compact witness eliminates every possible input-identity pair.
            candidates=list(range(25));witness=[]
            cases=[t for t in range(541) if part>>t&1]
            while candidates:
                t=min(cases,key=lambda t:sum(bool(matches[i]>>t&1) for i in candidates))
                witness.append(t)
                candidates=[i for i in candidates if matches[i]>>t&1]
            assert all(any(not(m>>t&1) for t in witness) for m in matches)
            assert len({tuple(g[t] for g in flags[:j]) for t in witness})==1
            return {'valid':False,'first_bad_comparison':j,'witness_cases':witness,
                    'history_class_size':part.bit_count()}
        parts=[part&m for part in parts for m in masks if part&m]
    return {'valid':True,'final_history_classes':len(parts)}


def main():
    ap=argparse.ArgumentParser();ap.add_argument('queue',choices=['unknown','median']);a=ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    tasks=json.loads((HERE/'artifacts'/f'{a.queue}_queue.json').read_text());cache={};records=[]
    for index,task in enumerate(tasks):
        row=task['row'];source=row['source']
        if source not in cache:
            p,R,old=transformed(row);_,columns=evaluate(p,R)
            cache[source]={j:columns[i] for i,j in enumerate(old)}
        order=task['previous']['order'] if a.queue=='unknown' else task['order']
        flags=[cache[source][j] for j in order]
        record=filter_order(flags)
        record.update(queue_index=index,family=row['id'],order=order,source=source)
        records.append(record)
    dest=HERE/'artifacts'/f'{a.queue}_weak_filter.json'
    dest.write_text(json.dumps(records,indent=2)+'\n')
    print(json.dumps({'queue':a.queue,'orders':len(records),
                      'valid':sum(r['valid'] for r in records),
                      'rejected':sum(not r['valid'] for r in records),
                      'first_bad_comparison':dict(Counter(r['first_bad_comparison'] for r in records if not r['valid']))}),flush=True)


if __name__=='__main__':main()
