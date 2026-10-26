#!/usr/bin/env python3
# mkskel.py "a:b a:b ..." weak(0/1) > file : flag vectors (enum order) for a formula skeleton
import sys, itertools
sys.path.insert(0, __import__('os').path.dirname(__file__))
from rsat import ev_formula
sk = [tuple(x.split(':')) for x in sys.argv[1].split()]
weak = int(sys.argv[2])
types = [v for v in itertools.product(range(5), repeat=5) if set(v) == set(range(max(v) + 1)) and (weak or len(set(v)) == 5)]
print('# ' + sys.argv[1])
for a, b in sk:
    print(''.join('1' if ev_formula(a, t) < ev_formula(b, t) else '2' if ev_formula(a, t) > ev_formula(b, t) else '0' for t in types))
