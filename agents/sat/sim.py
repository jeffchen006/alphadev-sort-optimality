"""Own parser + simulator for the register model of shared/MODEL.md (sat agent; independent of other agents).

Registers: P0..P{n-1} (inputs/outputs), S0.. (scratch). Instruction tuples: (op, d, s), registers as ints
(P_i = i, S_j = n + j). Ops: mov cmp cmovl cmovg cmovle cmovge nop.
"""
import itertools, random, re, sys

OPS = ['mov', 'cmp', 'cmovl', 'cmovg', 'cmovle', 'cmovge', 'nop']
CMOVS = {'cmovl', 'cmovg', 'cmovle', 'cmovge'}


def weak_orders(n):
    """All weak order types of n items, as rank tuples with ranks 0..m-1 (surjective)."""
    out = []
    for m in range(1, n + 1):
        for rk in itertools.product(range(m), repeat=n):
            if len(set(rk)) == m:
                out.append(rk)
    return out


def total_orders(n):
    return [tuple(p) for p in itertools.permutations(range(n))]


def reg_name(r, n):
    return 'P%d' % r if r < n else 'S%d' % (r - n)


def parse_reg(tok, n):
    m = re.fullmatch(r'([PS])(\d+)', tok.strip())
    if not m:
        raise ValueError('bad register %r' % tok)
    return int(m.group(2)) if m.group(1) == 'P' else n + int(m.group(2))


def parse(text, n):
    prog = []
    for line in text.splitlines():
        line = line.split('#', 1)[0].strip()
        if not line:
            continue
        op, rest = (line.split(None, 1) + [''])[:2]
        op = op.lower()
        if op == 'nop':
            continue
        a, b = [x.strip() for x in rest.split(',')]
        prog.append((op, parse_reg(a, n), parse_reg(b, n)))
    return prog


def fmt(prog, n, header=None):
    lines = [header] if header else []
    for op, d, s in prog:
        if op == 'nop':
            continue
        lines.append('%s %s, %s' % (op, reg_name(d, n), reg_name(s, n)))
    return '\n'.join(lines) + '\n'


def run(prog, vals, flags=(False, False)):
    """Concrete run. vals: list of comparable values for all registers. Returns final register list."""
    v = list(vals)
    lt, gt = flags
    for op, d, s in prog:
        if op == 'mov':
            v[d] = v[s]
        elif op == 'cmp':
            lt, gt = v[d] < v[s], v[d] > v[s]
        elif op == 'cmovl':
            if lt: v[d] = v[s]
        elif op == 'cmovg':
            if gt: v[d] = v[s]
        elif op == 'cmovle':
            if not gt: v[d] = v[s]
        elif op == 'cmovge':
            if not lt: v[d] = v[s]
        elif op == 'nop':
            pass
        else:
            raise ValueError(op)
    return v


def trace(prog, vals, flags=(False, False)):
    """States: trace[0] = initial registers, trace[i+1] = registers after step i."""
    out = [list(vals)]
    lt, gt = flags
    for ins in prog:
        v = run([ins], out[-1], (lt, gt))
        if ins[0] == 'cmp':
            lt, gt = out[-1][ins[1]] < out[-1][ins[2]], out[-1][ins[1]] > out[-1][ins[2]]
        out.append(v)
    return out


def nregs(prog, n):
    return max([n] + [max(d, s) + 1 for _, d, s in prog])


INF = float('inf')  # the symbol T of MODEL.md section 2 (larger than every input)


def check_relaxed(prog, n, outmode='fixed', types=None, outmap=None):
    """Relaxed model: scratch = T, flags = eq. Returns list of failing order types ([] = correct).
    outmode free: with outmap (list of registers) the output j is read from outmap[j]; without it,
    any injective choice of registers is accepted."""
    R = nregs(prog, n)
    bad = []
    for rk in (types or weak_orders(n)):
        fin = run(prog, list(rk) + [INF] * (R - n))
        want = sorted(rk)
        if outmode == 'fixed':
            ok = fin[:n] == want
        elif outmode == 'snap':
            tr = trace(prog, list(rk) + [INF] * (R - n))
            if outmap is not None:
                ok = [tr[t][r] for t, r in outmap] == want
            else:  # some injective choice of (time, register) cells; distinct cells may hold equal values
                cells = set((t, r) for t in range(len(tr)) for r in range(R))
                ok = all(sum(1 for t, r in cells if tr[t][r] == w) >= want.count(w) for w in set(want))
        elif outmap is not None:
            ok = [fin[r] for r in outmap] == want
        else:  # free: some injective choice of registers holds the sorted values (multiset check suffices)
            ok = all(fin.count(w) >= want.count(w) for w in set(want))
        if not ok:
            bad.append(rk)
    return bad


def taint_ok(prog, n):
    """Conservative check that outputs never depend on initial scratch values or initial flags."""
    R = nregs(prog, n)
    t = [False] * n + [True] * (R - n)
    ft = True
    for op, d, s in prog:
        if op == 'mov':
            t[d] = t[s]
        elif op == 'cmp':
            ft = t[d] or t[s]
        elif op in CMOVS:
            t[d] = t[d] or t[s] or (ft and d != s)
    return not any(t[:n])


def check_strict(prog, n, trials=2000, seed=1):
    """Strict model (fixed outputs): all weak orders x all initial flags x garbage samples.
    Exact if taint_ok holds; otherwise random garbage (including extremes) is a test only."""
    R = nregs(prog, n)
    rnd = random.Random(seed)
    exact = taint_ok(prog, n)
    for rk in weak_orders(n):
        x = [10 * r - 20 for r in rk]
        want = sorted(x)
        gs = [[INF] * (R - n), [-INF] * (R - n)]
        if not exact:
            gs += [[rnd.choice([-INF, INF, rnd.randint(-30, 30)]) for _ in range(R - n)] for _ in range(trials // 50)]
        for g in gs:
            for fl in [(False, False), (True, False), (False, True)]:
                if run(prog, x + g, fl)[:n] != want:
                    return False, exact
    return True, exact


def main():
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument('file')
    ap.add_argument('-n', type=int, required=True)
    ap.add_argument('--outmode', default='fixed')
    a = ap.parse_args()
    prog = parse(open(a.file).read(), a.n)
    bad = check_relaxed(prog, a.n, a.outmode)
    print('length', len(prog), 'relaxed', 'OK' if not bad else 'FAIL %d types e.g. %s' % (len(bad), bad[0]))
    if a.outmode == 'fixed':
        ok, exact = check_strict(prog, a.n)
        print('strict', 'OK' if ok else 'FAIL', '(exact)' if exact else '(tested, taint present)')


if __name__ == '__main__':
    main()
