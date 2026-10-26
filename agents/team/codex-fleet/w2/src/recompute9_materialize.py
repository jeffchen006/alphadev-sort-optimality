#!/usr/bin/env python3
"""Rebuild mutation traces and select free outputs on the 120 strict orders.

The strict judge must check every trace which supplies all five outputs.
"""
import csv
import itertools
from pathlib import Path
import re
import subprocess
import sys

folder = Path(sys.argv[1])
seeds = Path('/path/to/repo/agents/team/d7-structure/fam32')
perms = list(itertools.permutations(range(5)))
def rid(x):
    return int(x[1:]) + (5 if x[0] == 'S' else 0)
def rn(x):
    return ('P'+str(x)) if x < 5 else ('S'+str(x-5))
def active(op, f):
    return {'cmovl': f < 0, 'cmovg': f > 0,
            'cmovle': f <= 0, 'cmovge': f >= 0}[op]

summary = []
for row in csv.DictReader((folder/'manifest.tsv').open(), delimiter='\t'):
    core = []
    for line in (seeds/row['seed']).read_text().splitlines():
        m = re.fullmatch(r'(mov|cmp|cmovl|cmovg|cmovle|cmovge) (\w+), (\w+)', line)
        if m:
            op,d,s=m.groups()
            core.append((op,rid(d),rid(s)))
    omit = {int(row['removed_move_a']), int(row['removed_move_b'])}
    alias = list(range(16))
    trace = []
    for i,(op,d,s) in enumerate(core):
        if i in omit:
            assert op == 'mov'
            alias[d] = alias[s]
        else:
            trace.append((op,alias[d],alias[s]))
    trace.insert(int(row['insertion']),
                 ({2:'cmovl',3:'cmovg',4:'cmovle',5:'cmovge'}[int(row['op'])],
                  int(row['dest']),int(row['source'])))
    r = [[p[i] if i < 5 else None for i in range(16)] for p in perms]
    flags = [None]*120
    done = set()
    output = ['# model=out iset=I1 n=5 source=w2_recompute9 '+row['file']]
    for op,d,s in trace:
        output.append(f'{op} {rn(d)}, {rn(s)}')
        for t in range(120):
            if op == 'mov':
                r[t][d] = r[t][s]
            elif op == 'cmp':
                flags[t] = (r[t][d] > r[t][s]) - (r[t][d] < r[t][s])
            elif active(op,flags[t]):
                r[t][d] = r[t][s]
        for j in range(5):
            if j in done:
                continue
            for reg in range(16):
                if all(r[t][reg] == j for t in range(120)):
                    done.add(j)
                    output.append(f'out {j}, {rn(reg)}')
                    break
    path = Path('programs')/(folder.name+'_trace_'+row['file'].replace('.txt','.s'))
    path.write_text('\n'.join(output)+'\n')
    record = dict(file=str(path), available_outputs=sorted(done), core=len(trace))
    if len(done) == 5:
        result = subprocess.run([sys.executable,'src/verify_log.py',str(path),path.stem+'_verified'], capture_output=True,text=True)
        record['strict_check'] = result.stdout+result.stderr
        print(result.stdout+result.stderr, end='', flush=True)
    summary.append(record)
    print(record, flush=True)
import json
(folder/'trace_checks.json').write_text(json.dumps(summary,indent=2)+'\n')
