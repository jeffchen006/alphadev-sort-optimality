"""Write full (all order types) CNFs for rule variants. usage: gen_full.py n k iset outmode types(w|t) tag=rules ..."""
import sys
from encode import Enc, ALL_RULES
import sim
n, k, iset, outmode, tt = int(sys.argv[1]), int(sys.argv[2]), sys.argv[3], sys.argv[4], sys.argv[5]
import os
MC, MV = int(os.environ.get('MINCMP', 0)), int(os.environ.get('MINCMOV', 0))
CE = int(os.environ['CMPEQ']) if os.environ.get('CMPEQ') else None
MM = int(os.environ['MAXMOV']) if os.environ.get('MAXMOV') else None
BL = tuple(int(x) for x in os.environ['BLOCKS'].split('-')) if os.environ.get('BLOCKS') else None
for spec in sys.argv[6:]:
    tag, rules = spec.split('=')
    rules = [r for r in ALL_RULES if outmode != 'fixed' or r != 'pcanon'] if rules == 'all' else [r for r in rules.split(',') if r]
    if rules and rules[0].startswith('-'):
        drop = set(r[1:] for r in rules)
        rules = [r for r in ALL_RULES if r not in drop]
    e = Enc(n, k, None, iset, outmode, rules, bool(set(rules) - {'canon', 'pcanon', 'comm', 'snapcmov'}) or 'nop' in tag, MC, MV, cmpeq=CE, maxmov=MM, blocks=BL)
    types = sim.weak_orders(n) if tt == 'w' else sim.total_orders(n)
    for t in types:
        e.add_type(t)
    if 'hcmp' in rules and tt == 't' and not os.environ.get('NOCLASS'):
        e.add_class_cuts()
    path = 'cnf/f%d_%s_%s_k%d_%s_%s%s.cnf' % (n, iset, outmode, k, tag, tt, ('_c%d' % CE if CE is not None else '') + ('_v%d' % MM if MM is not None else '') + ('_b' + '-'.join(map(str, BL)) if BL else ''))
    e.dimacs(path, 'n=%d k=%d R=%d iset=%s outmode=%s rules=%s nop=%s types=%s mincmp=%d mincmov=%d' % (n, k, e.R, iset, outmode, ','.join(rules), e.nop, tt, MC, MV) + (' cmpeq=%d' % CE if CE is not None else '') + (' maxmov=%d' % MM if MM is not None else '') + (' blocks=%s' % '-'.join(map(str, BL)) if BL else ''))
    print(path, e.nvars, len(e.clauses))
