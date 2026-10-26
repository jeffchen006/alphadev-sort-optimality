#!/usr/bin/env python3
# d7: mkpool_nbr.py NBR.pkl OUT i [j..]
import sys, pickle
pool, ex = pickle.load(open(sys.argv[1], 'rb'))
with open(sys.argv[2], 'w') as f:
    for c in pool + [ex[int(i)] for i in sys.argv[3:]]: f.write(' '.join(map(str, c)) + '\n')
