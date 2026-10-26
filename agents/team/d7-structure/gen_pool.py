#!/usr/bin/env python3
# d7: write pool file (541 ints per term) from decide_N.pkl pool (+ optional extra terms as hex fams)
import sys, pickle
from decide import evcol
G, dec, pool = pickle.load(open(sys.argv[1], 'rb'))
pool = pool[:23] + [int(x, 16) for x in sys.argv[3:]]
with open(sys.argv[2], 'w') as f:
    for t in pool: f.write(' '.join(map(str, evcol(t))) + '\n')
