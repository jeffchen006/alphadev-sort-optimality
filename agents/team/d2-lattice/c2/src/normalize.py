#!/usr/bin/env python3
"""Liveness-aware experiments. A result is not accepted without shared/judge.py."""
import argparse
from collections import Counter
import itertools
import json
from pathlib import Path

from analyze import PERMS, CONDS, parse, dump, collection, trace, summary, lattice_completion

WEAK=tuple(p for p in itertools.product(range(5),repeat=5)
           if set(p)==set(range(max(p)+1)))

def run_detail(prog,cases=PERMS):
    unknown=(None,)*len(cases)
    regs={f'P{i}':tuple(p[i] for p in cases) for i in range(5)}
    flags=(0,)*len(cases)
    details=[]
    for op,a,b in prog:
        x,y=regs.get(a,unknown),regs.get(b,unknown)
        if op=='out':
            details.append((x,y,flags,y))
        elif op=='cmp':
            assert all(u is not None and v is not None for u,v in zip(x,y)), 'garbage comparison'
            flags=tuple((u>v)-(u<v) for u,v in zip(x,y))
            details.append((x,y,flags,None))
        else:
            col=y if op=='mov' else tuple(v if CONDS[op](f) else u for u,v,f in zip(x,y,flags))
            regs[a]=col
            details.append((x,y,flags,col))
    return details

def liveness(prog,cases=PERMS):
    detail=run_detail(prog,cases)
    live={}
    flive=set()
    result_live=[set() for _ in prog]
    flags_after=[set() for _ in prog]
    # Explicit out snapshots are required for these experiments.
    assert set(a for op,a,b in prog if op=='out')==set(map(str,range(5)))
    seen_outputs=set()
    for t in range(len(prog)-1,-1,-1):
        op,a,b=prog[t]
        x,y,f,col=detail[t]
        flags_after[t]=set(flive)
        if op=='out':
            if a not in seen_outputs:
                live.setdefault(b,set()).update(range(len(cases)))
                seen_outputs.add(a)
            continue
        if op=='cmp':
            live.setdefault(a,set()).update(flive)
            live.setdefault(b,set()).update(flive)
            flive=set()
            continue
        needed=live.pop(a,set())
        result_live[t]=needed
        if op=='mov':
            live.setdefault(b,set()).update(needed)
        else:
            yes={i for i in needed if CONDS[op](f[i])}
            no=needed-yes
            live.setdefault(b,set()).update(yes)
            live.setdefault(a,set()).update(no)
            flive.update(i for i in needed if x[i]!=y[i])
    return detail,result_live,flags_after

def movify(prog):
    """Make every locally safe conditional write unconditional, simultaneously.

    Backward dependencies include both compare operands whenever a flag matters.
    Thus all changed entries are dead in the original value/flag dependency DAG.
    The driver independently checks the output and then invokes the strict judge.
    """
    detail,needed,flive=liveness(prog,WEAK)
    result=[]; changed=[]
    for t,ins in enumerate(prog):
        op,a,b=ins
        if op in CONDS:
            x,y,f,col=detail[t]
            if all(y[i]==col[i] for i in needed[t]):
                ins=('mov',a,b)
                changed.append(t+1)
        result.append(ins)
    return result,changed

def assess(prog):
    before=summary(prog)
    d,live,flags=liveness(prog)
    noncomplete=[]
    for t,((op,a,b),(_,_,_,col)) in enumerate(zip(prog,d)):
        if col is None or op=='out' or all(v is not None for v in col):
            continue
        partial=tuple(v if i in live[t] else None for i,v in enumerate(col))
        ok,witness=lattice_completion(partial)
        if not ok:
            noncomplete.append({'step':t+1,'witness':witness})
    q,changed=movify(prog)
    return {'before':before,'after':summary(q),'changes':changed,
            'live_partial_noncompletable':noncomplete},q

if __name__=='__main__':
    ap=argparse.ArgumentParser()
    ap.add_argument('path')
    ap.add_argument('--collection',action='store_true')
    ap.add_argument('--limit',type=int,default=5000)
    ap.add_argument('--out')
    args=ap.parse_args()
    if not args.collection:
        p=parse(Path(args.path).read_text())
        report,q=assess(p)
        if args.out:
            dump(q,args.out,source='w10_liveness_movification')
        print(json.dumps(report,indent=2))
    else:
        totals=Counter(); exceptions=[]
        for i,p in enumerate(itertools.islice(collection(args.path),args.limit)):
            try:
                report,q=assess(p)
            except (AssertionError,KeyError) as e:
                totals['unsupported']+=1
                continue
            b,a=report['before'],report['after']
            totals['analyzed']+=1
            if b['partial_columns']:
                totals['with_partial']+=1
                if not b['nonlattice_full']:
                    totals['full_lattice_plus_partial']+=1
                    if a['nonlattice_full'] or a['partial_columns']:
                        totals['normalization_failure']+=1
                        if len(exceptions)<10:
                            exceptions.append({'index':i,**report})
                            dump(p,f'programs/norm_failure_{i}.s',source='w10_normalization_failure_sample')
                    else:
                        totals['normalization_success']+=1
                if report['live_partial_noncompletable']:
                    totals['noncompletable_live_partial']+=1
            if not a['correct_120']:
                totals['output_changed_or_original_wrong']+=1
        print(json.dumps({'counts':dict(totals),'exceptions':exceptions},indent=2))
