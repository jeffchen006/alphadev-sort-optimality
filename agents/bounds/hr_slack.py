#!/usr/bin/env python3
"""(c) of SORT5_PLAN: slack of h_R along optimal sort-n programs (n = 4 analog of sort5's h_R).
For a register program: map it to a set-model program with enum's Lemma S (cost g_t after t instructions), giving set
states s_t. For each s_t and each restriction r (x_i = max / min) restrict s_t to the permutations of r (x_i = sentinel),
compute the exact remaining set cost dist^e_{n-1}(r(s_t)) with `rsearch` mode 7, h_R(s_t) = max_r dist. Slack =
(C - g_t) - h_R, C = total set cost of the program (= k if the program is optimal).
usage: hr_slack.py n PROGRAM.s [restrictions, default all 2n]
"""
import sys, itertools, subprocess, os, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
BIG = 10 ** 6


def parse(path):
    prog = []
    for line in open(path):
        s = line.split('#')[0].strip()
        if s:
            o, rest = s.split(None, 1)
            a, b = [x.strip() for x in rest.split(',')]
            prog.append((o, a, b))
    return prog


def cond(o, lt, gt):
    return {'cmovl': lt, 'cmovg': gt, 'cmovle': not gt, 'cmovge': not lt}[o]


def set_trace(prog, n):
    """Lemma S image: list of (t, g, A(set of columns over all perms), f(flag tuple), done) after each real instruction."""
    perms = list(itertools.permutations(range(n)))
    T = n
    val = lambda p, s: BIG if s == T else p[s]
    regs = {f'P{i}': tuple(i for _ in perms) for i in range(n)}
    get = lambda r: regs.get(r, tuple(T for _ in perms))
    A = set(regs.values()); f = tuple(0 for _ in perms); g = 0; done = set()
    tgt = [tuple(sorted(range(n), key=lambda q: p[q])[j] for p in perms) for j in range(n)]
    trace = [(0, 0, frozenset(A), f, frozenset(done))]
    t = 0
    for o, a, b in prog:
        if o == 'out':
            done.add(int(a)); trace[-1] = (trace[-1][0], trace[-1][1], trace[-1][2], trace[-1][3], frozenset(done))
            continue
        t += 1
        if o == 'cmp':
            x, y = get(a), get(b)
            f = tuple((val(p, x[q]) < val(p, y[q])) - (val(p, x[q]) > val(p, y[q])) for q, p in enumerate(perms))
            g += 1
        elif o == 'mov':
            regs[a] = get(b)
        else:
            X = get(a); S = get(b)
            M = tuple(S[q] if cond(o, f[q] == 1, f[q] == -1) else X[q] for q in range(len(perms)))
            regs[a] = M
            allT = all(v == T for v in M)
            if M != X and M not in A and not allT:
                if all(v == T for v in X):
                    A.add(M); g += 1
                elif any(r != a and v == X for r, v in regs.items()):
                    A.add(M); g += 2
                else:
                    A.discard(X); A.add(M); g += 1
        for j in range(n):
            if tgt[j] in A:
                done.add(j)
        trace.append((t, g, frozenset(A), f, frozenset(done)))
    return perms, trace


def dist_restricted(n, perms, A, f, done, mode, i, maxc=30):
    keep = [q for q, p in enumerate(perms) if p[i] == (n - 1 if mode == 'max' else 0)]
    cols = sorted({tuple(c[q] for q in keep) for c in A})
    dm = 0
    for j in done:
        dm |= 1 << j
    dm |= 1 << (n - 1 if mode == 'max' else 0)
    with tempfile.NamedTemporaryFile('w', delete=False, suffix='.st') as fh:
        fh.write(' '.join(str(f[q]) for q in keep) + '\n' + str(dm) + '\n')
        for c in cols:
            fh.write(' '.join(map(str, c)) + '\n')
        name = fh.name
    env = dict(os.environ, RESTRICT=f'{mode}:{i}')
    out = subprocess.run([os.path.join(HERE, 'rsearch'), '7', str(n), '1', str(maxc), name], env=env,
                         capture_output=True, text=True).stdout
    os.unlink(name)
    line = [l for l in out.splitlines() if l.startswith('DIST')][0]
    d = int(line.split()[1]) if not line.split()[1].startswith('>') else 99
    nonT = [c for c in A if any(v != n for v in c)]
    dup = len(nonT) - len({tuple(c[q] for q in keep) for c in nonT})   # columns merged by the restriction
    return d, dup


if __name__ == '__main__':
    n = int(sys.argv[1]); prog = parse(sys.argv[2])
    perms, trace = set_trace(prog, n)
    C = trace[-1][1]
    k = sum(1 for o, _, _ in prog if o != 'out')
    print(f'# {sys.argv[2]}: register length {k}, set cost C = {C}')
    print('t g  rem  ' + ' '.join(f'{m}{i}(d/dup)' for m in ('max', 'min') for i in range(n)) + '  h_R slack   h_R-dup slack')
    for (t, g, A, f, done) in trace:
        ds = [dist_restricted(n, perms, A, f, done, m, i) for m in ('max', 'min') for i in range(n)]
        hR = max(d for d, _ in ds); hC = max(d - u for d, u in ds)
        print(f'{t:2d} {g:2d} {C - g:3d}  ' + ' '.join(f'{d:2d}/{u}' for d, u in ds) + f'  {hR:3d} {C - g - hR:3d}   {hC:3d} {C - g - hC:3d}')
