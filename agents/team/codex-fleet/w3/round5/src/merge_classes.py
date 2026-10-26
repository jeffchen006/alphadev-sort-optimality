#!/usr/bin/env python3
"""Merge prefix states under input renaming and last-flag complementation.

State keys retain duplicate register columns. No value-order reversal is used.
This class relation concerns the 24 strict sort4 orders and one common high
scratch assignment. It is not an arbitrary-garbage equivalence result.
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
    perms=list(itertools.permutations(range(4)))
    index={p:i for i,p in enumerate(perms)}
    translations=[bytes(index[tuple(p[i] for i in rename)] for p in perms) for rename in perms]
    # bytes.translate maps an index-valued lookup table in C. It implements
    # each row permutation without a Python loop over its 24 entries.
    seen={};classes=[];raw=[]
    counts={int(a):(int(b),int(c)) for a,b,c in (l.split() for l in (ROOT/'round5/logs/prefix_classes.tsv').read_text().splitlines())}
    start=time.monotonic()
    for id in range(len(counts)):
        path=ROOT/f'round5/classes/p{id}.s'
        prefix=parse(path)
        rows=[run(prefix,p+(4,)) for p in perms]
        names=sorted(set().union(*(r[0] for r in rows))-{'P4'})
        cols=[bytes(r[0][n] for r in rows) for n in names]
        flags=bytes(r[1]+1 for r in rows)
        coltables=[col+bytes(256-len(col)) for col in cols]
        flagtable=flags+bytes(256-len(flags))
        best=None;best_rename=None;best_flip=None
        for rename,tr in enumerate(translations):
            state=tuple(sorted(tr.translate(tab) for tab in coltables))
            fl=tr.translate(flagtable)
            flipped=fl.translate(bytes([2,1,0])+bytes(253))
            flip=flipped<fl
            key=state+(min(fl,flipped),)
            if best is None or key<best:
                best=key;best_rename=rename;best_flip=flip
        if best not in seen:
            seen[best]=len(classes)
            classes.append(dict(id=len(classes),representative=id,raw_classes=[],programs=0,
                                prefix_comparisons=counts[id][1],register_columns=len(names)))
        cl=classes[seen[best]]
        cl['raw_classes'].append(id);cl['programs']+=counts[id][0]
        raw.append(dict(raw=id,class_id=cl['id'],canonical_input_permutation=best_rename,
                        canonical_last_flag_flip=best_flip))
        if id%1000==0:print('PROGRESS',id,'classes',len(classes),'seconds',round(time.monotonic()-start,3),flush=True)
    for name,obj in [('classes.json',classes),('raw_class_map.json',raw)]:
        (ROOT/'round5/logs'/name).write_text(json.dumps(obj,indent=2)+'\n')
    summary=dict(raw_classes=len(counts),merged_classes=len(classes),programs=sum(c['programs'] for c in classes),
                 seconds=round(time.monotonic()-start,3),peak_rss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss)
    (ROOT/'round5/logs/merge_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps(summary),flush=True)

if __name__=='__main__':main()
