#!/usr/bin/env python3
"""Transfer the checked class-21 selector bound by initial-pool inclusion.

Free copies make duplicate register columns irrelevant. Free predicates make
the last prefix flags irrelevant. Any initial pool contained in the checked
pool has no circuit with eight selectors. Input renaming preserves sort5.
"""
import itertools
import json
import os
from pathlib import Path
import resource
import sys
import time

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'round4/src'))
from insertion_sat import parse,run

def main():
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    start=time.monotonic()
    assert 's VERIFIED' in (ROOT/'round5/logs/class21_gate8.drat_check').read_text()
    classes=json.loads((ROOT/'round5/logs/classes.json').read_text())
    preflight={r['class_id']:r for r in json.loads((ROOT/'round5/logs/preflight.json').read_text())}
    perms=list(itertools.permutations(range(4)));index={p:i for i,p in enumerate(perms)}
    orderings=[[index[tuple(p[i] for i in rename)] for p in perms] for rename in perms]
    def pool(cl):
        prefix=parse(ROOT/f'round5/classes/p{cl["representative"]}.s')
        rows=[run(prefix,p+(4,))[0] for p in perms]
        names=sorted(set().union(*rows)-{'P4'})
        return {tuple(row[n] for row in rows) for n in names}|{(5,)*24}
    reference=pool(classes[21]);assert classes[21]['id']==21
    covered=[];uncovered=[]
    for cl in classes:
        if preflight[cl['id']]['missing_input']:continue
        cols=pool(cl);witness=None
        for rename,order in enumerate(orderings):
            transformed={tuple(col[i] for i in order) for col in cols}
            if transformed<=reference:
                witness=perms[rename];break
        if witness is None:uncovered.append(cl['id'])
        else:covered.append(dict(class_id=cl['id'],representative=cl['representative'],
                                 programs=cl['programs'],input_renaming=witness,
                                 unique_prefix_columns=len(cols)))
    bounds={str(row['class_id']):9 for row in covered}
    (ROOT/'round5/logs/checked_gate_bounds.json').write_text(json.dumps(bounds,indent=2)+'\n')
    result=dict(reference_class=21,reference_unique_prefix_columns=len(reference),
                covered_preserved_classes=len(covered),covered_programs=sum(r['programs'] for r in covered),
                uncovered_preserved_classes=len(uncovered),covered=covered,uncovered=uncovered,
                seconds=round(time.monotonic()-start,3),peak_rss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss)
    (ROOT/'round5/logs/gate_bound_transfer.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ('covered','uncovered')}),flush=True)

if __name__=='__main__':main()
