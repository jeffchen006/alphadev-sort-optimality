"""Depth of AlphaDev sort3/4/5 (asm from AlphaDev repo sort_functions_test.cc) in models U and E."""
import sys
from prog import *
SRC = '../spec/ext/alphadev/sort_functions_test.cc'
for n in (3, 4, 5):
    p = parse_att_function(SRC, 'Sort%dAlphaDev' % n)
    ok, cex = check(p, n)
    c = counts(p)
    k = len(p) - c.get('load', 0) - c.get('store', 0)
    print('sort%d: L=%d (reg instrs k=%d) counts=%s strict-correct=%s' % (n, len(p), k, c, ok))
    for m in ('U', 'E', 'Z2'):
        D, o, per = depth(p, LAT[m])
        print('   model %s: depth=%d per-output=%s' % (m, D, o))
    if '-v' in sys.argv:
        dU = depth(p, LAT['U'])[2]; dE = depth(p, LAT['E'])[2]
        for ins, a, b in zip(p, dU, dE):
            print('     %-28s U=%s E=%s' % (' '.join(map(str, ins)), a, b))
