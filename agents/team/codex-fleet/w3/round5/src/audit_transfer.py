#!/usr/bin/env python3
"""Check transferred pool inclusions on all 120 five-input permutations."""
import itertools
import json
import os
from pathlib import Path
import resource
import sys

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'round4/src'))
from insertion_sat import parse,run

def main():
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    transfer=json.loads((ROOT/'round5/logs/gate_bound_transfer.json').read_text())
    types=list(itertools.permutations(range(5)))
    def pool(path,ty):
        states=[run(parse(path),t)[0] for t in ty]
        names=set().union(*states)|{'S99'}
        return {tuple(st.get(n,5) for st in states) for n in names}
    reference=pool(ROOT/'round5/classes/p37.s',types)
    for row in transfer['covered']:
        rename=row['input_renaming']
        ty=[tuple(t[i] for i in rename)+(t[4],) for t in types]
        assert pool(ROOT/f'round5/classes/p{row["representative"]}.s',ty)<=reference,row
    result=dict(result='PASS',covered_classes=len(transfer['covered']),
                collection_programs=sum(r['programs'] for r in transfer['covered']),
                five_input_orders_per_class=len(types),
                method='direct simulation of all five-input permutations after input renaming')
    (ROOT/'round5/logs/gate_bound_transfer_audit.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result))

if __name__=='__main__':main()
