#!/usr/bin/env python3
"""Check the constraint test against an explicit finite lattice-term catalog."""
import json
from pathlib import Path
import random

import numpy as np
from analyze import lattice_completion

reference=Path('/path/to/repo/agents/team/d1-skeleton/out/lat_cols.npy')
cols=np.load(reference)
assert cols.shape==(7579,120),cols.shape
support=[[0]*5 for _ in range(120)]
for row,c in enumerate(cols):
    bit=1<<row
    for w,v in enumerate(c):
        support[w][int(v)] |= bit
rng=random.Random(101010)
tested=0;possible_count=0
for mode in range(3):
    for _ in range(1000):
        a,b=cols[rng.randrange(len(cols))],cols[rng.randrange(len(cols))]
        c=tuple(None if rng.random()<0.65 else int((a if mode==0 or rng.randrange(2) else b)[w])
                for w in range(120))
        possible=(1<<len(cols))-1
        for w,v in enumerate(c):
            if v is not None:
                possible &= support[w][v]
        actual,_=lattice_completion(c)
        assert actual==bool(possible),(c,actual)
        tested+=1;possible_count+=actual
print(json.dumps({'catalog_columns':len(cols),'partial_cases':tested,
                  'possible_cases':possible_count,'disagreements':0},indent=2))
