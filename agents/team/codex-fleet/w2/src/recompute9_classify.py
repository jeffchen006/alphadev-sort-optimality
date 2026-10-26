#!/usr/bin/env python3
"""Distinguish repeated values from new values in retained mutation traces."""
import collections
import csv
import itertools
import json
from pathlib import Path
import re
import sys

seeds=Path('/path/to/repo/agents/team/d7-structure/fam32')
folder=Path(sys.argv[1])
perms=list(itertools.permutations(range(5)))
def rid(x):return int(x[1:])+(5 if x[0]=='S' else 0)
def active(op,f):return {'cmovl':f<0,'cmovg':f>0,'cmovle':f<=0,'cmovge':f>=0}[op]
def initial():return [tuple(t[i] for t in perms) if i<5 else None for i in range(16)]
def lattice_column(col):
    """Check whether one monotone Boolean table represents this column."""
    table={0:False,31:True}
    for t,v in zip(perms,col):
        for threshold in range(1,5):
            mask=sum(1<<i for i in range(5) if t[i]>=threshold)
            bit=v>=threshold
            if mask in table and table[mask]!=bit:return False
            table[mask]=bit
    return all(not table[mask] or table[mask|1<<i] for mask in range(32) for i in range(5))
def step(r,flags,x):
    op,d,s=x
    if op=='mov':r[d]=r[s]
    elif op=='cmp':return tuple((a>b)-(a<b) for a,b in zip(r[d],r[s]))
    else:r[d]=tuple(sv if active(op,f) else dv for dv,sv,f in zip(r[d],r[s],flags))
    return flags
records=[]
for row in csv.DictReader((folder/'manifest.tsv').open(),delimiter='\t'):
    code=[]
    for line in (seeds/row['seed']).read_text().splitlines():
        m=re.fullmatch(r'(mov|cmp|cmovl|cmovg|cmovle|cmovge) (\w+), (\w+)',line)
        if m:
            op,d,s=m.groups();code.append((op,rid(d),rid(s)))
    omit={int(row['removed_move_a']),int(row['removed_move_b'])}
    original=initial();flags=None;copied=[]
    for i,x in enumerate(code):
        if i in omit:copied.append(original[x[2]])
        flags=step(original,flags,x)
    alias=list(range(16));mutated=[]
    for i,(op,d,s) in enumerate(code):
        if i in omit:alias[d]=alias[s]
        else:mutated.append((op,alias[d],alias[s]))
    r=initial();history=set(r)-{None};flags=None
    for x in mutated[:int(row['insertion'])]:
        flags=step(r,flags,x);history.update(v for v in r if v is not None)
    present=set(r)-{None}
    x=({2:'cmovl',3:'cmovg',4:'cmovle',5:'cmovge'}[int(row['op'])],int(row['dest']),int(row['source']))
    step(r,flags,x);value=r[x[1]]
    kind=('duplicate_existing' if value in present else 'recomputed_lost' if value in history else 'new_value')
    sk=[]
    for line in (folder/row['file']).read_text().splitlines():
        if line and line[0]!='#':sk.extend(tuple(map(int,x[1:])) for x in line.split(':'))
    required=set(sk)|{(i,)*120 for i in range(5)}
    inputs=set(initial())-{None}
    records.append(dict(file=row['file'],kind=kind,recovers_omitted_copy=value in copied,
                        nonlattice_operands=sum(not lattice_column(c) for c in set(sk)),
                        required_noninput_columns=len(required-inputs)))
result=dict(counts=dict(collections.Counter(x['kind'] for x in records)),
            recovers_omitted_copy=sum(x['recovers_omitted_copy'] for x in records),
            nonlattice_skeletons=sum(x['nonlattice_operands']>0 for x in records),records=records)
(folder/'recompute_classes.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k!='records'}),flush=True)
