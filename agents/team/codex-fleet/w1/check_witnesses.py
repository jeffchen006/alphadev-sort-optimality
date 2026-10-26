#!/usr/bin/env python3
"""Parse, simulate and convert the four example programs without judge imports."""
import itertools
import re
from collections import Counter
from pathlib import Path

orders = [w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(len(set(w))))]
assert len(orders)==541
for copies in (5,6,7,8):
    source=Path(f'witness_q{copies}_out.s')
    instructions=[]
    for line in source.read_text().splitlines():
        text=line.split('#',1)[0].strip()
        if not text:
            continue
        op,a,b=re.fullmatch(r'(\w+)\s+(\w+),\s*(\w+)',text).groups()
        instructions.append((op,a,b))
    counts=Counter(op for op,_,_ in instructions)
    assert counts['cmp']==9 and counts['mov']==copies
    assert sum(v for op,v in counts.items() if op.startswith('cmov'))==18
    assert counts['out']==5
    for w in orders:
        for initial in (-1,0,1):
            registers={f'P{i}':v for i,v in enumerate(w)}
            registers.update({f'S{i}':(-47 if i%2 else 103) for i in range(copies)})
            output={}
            flag=initial
            for op,a,b in instructions:
                if op=='out':output[int(a)]=registers[b]
                elif op=='mov':registers[a]=registers[b]
                elif op=='cmp':flag=(registers[a]>registers[b])-(registers[a]<registers[b])
                elif {'cmovl':flag<0,'cmovle':flag<=0,'cmovg':flag>0,'cmovge':flag>=0}[op]:registers[a]=registers[b]
            assert [output[i] for i in range(5)]==sorted(w),(source,w,initial)
    def register(r):return f'S{int(r[1:])+(5 if r.startswith("S") else 0)}'
    memory=[f'# n=5 R={10+copies} iset=I1 model=mem source=w1_exhaustive_copy_reuse']
    memory.extend(f'mov S{i}, P{i}' for i in range(5))
    for op,a,b in instructions:
        memory.append(f'mov P{a}, {register(b)}' if op=='out' else f'{op} {register(a)}, {register(b)}')
    destination=Path(f'witness_q{copies}_mem.s')
    destination.write_text('\n'.join(memory)+'\n')
    assert len(memory)-1==37+copies
    print(f'INDEPENDENT SIMULATION OK {source}: 541 weak orders x 3 initial flags; core={27+copies}; memory={37+copies}')
