#!/usr/bin/env python3
# d7: mkpool_swap.py SWAP.pkl OUT i
import sys, pickle
pool, ex = pickle.load(open(sys.argv[1], 'rb'))
with open(sys.argv[2], 'w') as f:
    for c in pool + ex[int(sys.argv[3])][1]: f.write(' '.join(map(str, c)) + '\n')
