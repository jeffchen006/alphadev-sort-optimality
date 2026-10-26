# extract value skeletons (cmp operand columns over 120 permutations, lex order) -> d1-skeleton dagx format
import sys, itertools, os; sys.path.insert(0, '../../sort5-lab/tools'); import d4eval as E
PERMS = list(itertools.permutations(range(5)))
outdir = sys.argv[1]; os.makedirs(outdir, exist_ok=True)
seen = {}; n = 0; bad = 0
for fn in sys.argv[2:]:
    for p in E.parse_text(open(fn).read()):
        cols = []  # per cmp: (a column, b column)
        cmps = [i for i, x in enumerate(p) if x[0] == 'cmp']
        ca = [[] for _ in cmps]; cb = [[] for _ in cmps]; ok = True
        for x in PERMS:
            regs = {'P%d' % i: x[i] for i in range(5)}; f = 0; ci = 0
            for op, a, b in p:
                if op == 'out': continue
                if op == 'mov': regs[a] = regs.get(b, E.T)
                elif op == 'cmp':
                    u, w = regs.get(a, E.T), regs.get(b, E.T)
                    if u == E.T or w == E.T: ok = False
                    ca[ci].append(u); cb[ci].append(w); ci += 1
                    f = 1 if u < w else 2 if u > w else 0
                elif E.COND[op](f): regs[a] = regs.get(b, E.T)
        if not ok: bad += 1; continue
        key = tuple(tuple(c) for c in ca + cb)
        if key in seen: continue
        s = E.score(p, 5); seen[key] = 1; n += 1
        with open('%s/d4_%04d.txt' % (outdir, n), 'w') as f:
            f.write('# d4 near-miss k=%d c=%d fail_weak=%d src=%s\n' % (s['k'], s['c'], s['fail_weak'], os.path.basename(fn)))
            for a, b in zip(ca, cb):
                f.write('=' + ''.join(map(str, a)) + ':=' + ''.join(map(str, b)) + '\n')
print('skeletons', n, 'with garbage cmp', bad)
