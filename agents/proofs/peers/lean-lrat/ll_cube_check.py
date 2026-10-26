"""ll_cube_check.py — cake_lpr re-check of lean-lrat's cube run (full binary tree over split variables).

  python3 -I ll_cube_check.py CUBEDIR BASE.cnf VAR_IDS(comma) [--jobs J]
Checks: (1) the leaves are exactly the 2^m sign patterns of VAR_IDS (cover: every assignment satisfies one cube);
        (2) leaf <bits>.cnf has the clauses of BASE.cnf plus exactly the units of its cube (multiset);
        (3) cake_lpr <bits>.cnf <bits>.lrat prints "s VERIFIED UNSAT".
(1)+(2)+(3) => BASE UNSAT. BASE must be a fresh 'lrat-tool dimacs n k I types' export (compare its sha256).
"""
import collections, hashlib, itertools, os, subprocess, sys
from concurrent.futures import ThreadPoolExecutor

P = os.path.dirname(os.path.abspath(__file__))
CAKE = os.path.join(P, '..', '..', 'tools', 'bin', 'cake_lpr')
d, basep, vids = sys.argv[1], sys.argv[2], [int(x) for x in sys.argv[3].split(',')]
jobs = int(sys.argv[sys.argv.index('--jobs') + 1]) if '--jobs' in sys.argv else 1


def clauses(p):
    out, cur = [], []
    for line in open(p):
        if line[:1] in 'cp' or not line.strip():
            continue
        for t in line.split():
            v = int(t)
            if v == 0:
                out.append(tuple(sorted(cur))); cur = []
            else:
                cur.append(v)
    return collections.Counter(out)


def sha(p):
    h = hashlib.sha256()
    with open(p, 'rb') as f:
        for b in iter(lambda: f.read(1 << 20), b''):
            h.update(b)
    return h.hexdigest()


base = clauses(basep)
print('base %s sha256=%s clauses=%d' % (basep, sha(basep), sum(base.values())))
want = [''.join(b) for b in itertools.product('10', repeat=len(vids))]
ok = True


def check(bits):
    c, l = os.path.join(d, bits + '.cnf'), os.path.join(d, bits + '.lrat')
    if not (os.path.exists(c) and os.path.exists(l)):
        return bits, False, 'MISSING'
    units = collections.Counter((v if b == '1' else -v,) for v, b in zip(vids, bits))
    if clauses(c) != base + units:
        return bits, False, 'GLUE-FAIL (leaf CNF != base + cube units)'
    r = subprocess.run(['nice', '-n', '10', CAKE, '--CML_HEAP_SIZE=32768', c, l], capture_output=True, text=True)
    out = r.stdout.strip()
    return bits, out == 's VERIFIED UNSAT', 'cnf %s lrat %s cake_lpr: %s' % (sha(c)[:16], sha(l)[:16], out)


with ThreadPoolExecutor(jobs) as ex:
    for bits, good, msg in ex.map(check, want):
        ok &= good
        print('leaf %s %s %s' % (bits, 'OK' if good else 'FAIL', msg), flush=True)
print('LL_CUBE_CHECK %s: %d leaves, cover = all sign patterns of %s' % ('PASS' if ok else 'FAIL', len(want), vids))
sys.exit(0 if ok else 1)
