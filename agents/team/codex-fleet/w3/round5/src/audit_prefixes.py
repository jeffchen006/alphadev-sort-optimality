#!/usr/bin/env python3
"""Check every saved raw class using explicit row permutations.

This check does not use the byte-table translation used by merge_classes.py.
It checks state-key mappings, multiplicities, and the lost-input exclusion.
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
    perms=list(itertools.permutations(range(4)))
    pindex={p:i for i,p in enumerate(perms)}
    mapping=json.loads((ROOT/'round5/logs/raw_class_map.json').read_text())
    expected={r['class_id']:r['missing_input'] for r in json.loads((ROOT/'round5/logs/preflight.json').read_text())}
    counts={int(a):int(b) for a,b,c in (line.split() for line in (ROOT/'round5/logs/prefix_classes.tsv').read_text().splitlines())}
    canonical={};missing_raw=0;missing_programs=0
    for m in mapping:
        prefix=parse(ROOT/f'round5/classes/p{m["raw"]}.s')
        assert len(prefix)==14 and all(d!='P4' and s!='P4' for op,d,s in prefix)
        rows=[run(prefix,p+(4,)) for p in perms]
        names=sorted(set().union(*(r[0] for r in rows))-{'P4'})
        lost=any(any(j not in r[0].values() for j in range(4)) for r in rows)
        assert lost==expected[m['class_id']],m
        if lost:missing_raw+=1;missing_programs+=counts[m['raw']]
        rename=perms[m['canonical_input_permutation']]
        transformed=[rows[pindex[tuple(p[i] for i in rename)]] for p in perms]
        columns=tuple(sorted(tuple(r[0][n] for r in transformed) for n in names))
        flags=tuple((-r[1] if m['canonical_last_flag_flip'] else r[1]) for r in transformed)
        key=(columns,flags)
        if m['class_id'] in canonical:assert canonical[m['class_id']]==key,m
        else:canonical[m['class_id']]=key
    assert missing_programs==213484
    result=dict(raw_classes_checked=len(mapping),merged_classes_checked=len(canonical),
                collection_programs=sum(counts.values()),missing_raw_classes=missing_raw,
                missing_merged_classes=sum(expected.values()),missing_programs=missing_programs,
                seconds=round(time.monotonic()-start,3),
                peak_rss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
                result='PASS')
    (ROOT/'round5/logs/prefix_audit.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result),flush=True)

if __name__=='__main__':main()
