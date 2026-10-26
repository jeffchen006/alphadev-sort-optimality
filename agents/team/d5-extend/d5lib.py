"""d5-extend: own parser, 3-valued simulator, canonical form (dedupe up to input perm, S renaming, commutation)."""
import itertools, gzip
import numpy as np
OPS = ['mov', 'cmp', 'cmovl', 'cmovg', 'cmovle', 'cmovge']
# move masks over flag (0 eq, 1 lt, 2 gt)
MV = {'cmovl': (0, 1, 0), 'cmovg': (0, 0, 1), 'cmovle': (1, 1, 0), 'cmovge': (1, 0, 1)}
U = 9  # garbage

def read_progs(fn):
    op = gzip.open if fn.endswith('.gz') else open
    cur = None
    with op(fn, 'rt') as f:
        for line in f:
            line = line.split('#')[0].strip() if not line.startswith('#') else line.strip()
            if line.startswith('#'):
                if cur: yield cur
                cur = []
                continue
            if not line: continue
            o, rest = line.split(None, 1)
            a, b = [x.strip() for x in rest.split(',')]
            if o == 'out': continue
            if cur is None: cur = []
            cur.append((o, a, b))
    if cur: yield cur

def weak_orders(n):
    res = []
    for v in itertools.product(range(n), repeat=n):
        s = set(v)
        if s == set(range(len(s))): res.append(v)
    return np.array(res, dtype=np.int8)

def simulate(prog, n, tests=None):
    """returns list of states after each instruction: dict reg->array, flags array. strict 3-valued."""
    W = weak_orders(n) if tests is None else tests
    T = len(W)
    regs = {f'P{i}': W[:, i].copy() for i in range(n)}
    fl = np.full(T, 3, np.int8)
    hist = []
    for (o, d, s) in prog:
        dv = regs.get(d, np.full(T, U, np.int8)); sv = regs.get(s, np.full(T, U, np.int8))
        if o == 'mov': regs[d] = sv.copy()
        elif o == 'cmp':
            unk = (dv == U) | (sv == U)
            fl = np.where(unk, 3, np.where(dv < sv, 1, np.where(dv > sv, 2, 0))).astype(np.int8)
        else:
            m = MV[o]
            mv = ((fl == 0) & m[0]) | ((fl == 1) & m[1]) | ((fl == 2) & m[2])
            un = (fl == 3) & (dv != sv)
            regs[d] = np.where(mv, sv, np.where(un, U, dv)).astype(np.int8)
        hist.append(({r: v for r, v in regs.items()}, fl))
    return W, hist

def check_out(prog, n):
    W, hist = simulate(prog, n)
    exp = np.sort(W, axis=1)
    ok = []
    for j in range(n):
        ok.append(any((v == exp[:, j]).all() for regs, _ in hist for v in regs.values()) or (W[:, j] == exp[:, j]).all())
    return all(ok)

def rw(ins):
    o, d, s = ins
    if o == 'mov': return {s}, {d}
    if o == 'cmp': return {d, s}, {'F'}
    return {d, s, 'F'}, {d}

def dep(a, b):
    ra, wa = rw(a); rb, wb = rw(b)
    return bool(wa & rb or ra & wb or wa & wb)

def rename_s(prog):
    m = {}
    out = []
    for o, d, s in prog:
        r = []
        for x in (d, s):
            if x[0] == 'S':
                if x not in m: m[x] = 'S%d' % len(m)
                x = m[x]
            r.append(x)
        out.append((o, r[0], r[1]))
    return out

def foata(prog):
    n = len(prog)
    lvl = [0] * n
    for i in range(n):
        for j in range(i):
            if dep(prog[j], prog[i]): lvl[i] = max(lvl[i], lvl[j] + 1)
    mask = lambda p: tuple(x if x[0] != 'S' else 'S' for x in p)
    return [p for _, p in sorted(zip(lvl, prog), key=lambda t: (t[0], mask(t[1]), t[1]))]

def canon(prog, n=4):
    best = None
    for perm in itertools.permutations(range(n)):
        pm = {f'P{i}': f'P{perm[i]}' for i in range(n)}
        q = [(o, pm.get(d, d), pm.get(s, s)) for o, d, s in prog]
        for _ in range(4):
            q2 = foata(rename_s(q))
            if q2 == q: break
            q = q2
        key = ';'.join(f'{o} {d},{s}' for o, d, s in q)
        if best is None or key < best: best = key
    return best

def parse_key(key):
    return [(x.split()[0],) + tuple(x.split()[1].split(',')) for x in key.split(';')]
