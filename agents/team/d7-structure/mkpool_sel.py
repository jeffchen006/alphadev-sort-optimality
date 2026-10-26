#!/usr/bin/env python3
# d7: mkpool_sel.py OUT i [j..]: base pool + sels.pkl[i] ...
import sys, pickle
base = pickle.load(open('pool_base_cols.pkl', 'rb')); S = pickle.load(open('sels.pkl', 'rb'))
with open(sys.argv[1], 'w') as f:
    for c in base + [S[int(i)] for i in sys.argv[2:]]: f.write(' '.join(map(str, c)) + '\n')
