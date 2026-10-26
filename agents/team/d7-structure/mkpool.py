#!/usr/bin/env python3
# d7: mkpool.py OUT i [j ...] : base pool + extras1[i], extras1[j] ...
import sys, pickle
from decide import evcol
base = pickle.load(open('pool_base_cols.pkl', 'rb')); ex = pickle.load(open('extras1.pkl', 'rb'))
with open(sys.argv[1], 'w') as f:
    for c in base + [evcol(ex[int(i)]) for i in sys.argv[2:]]: f.write(' '.join(map(str, c)) + '\n')
