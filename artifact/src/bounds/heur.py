#!/usr/bin/env python3
"""Admissible heuristic H for IDA*/enum (bounds agent).  Proof: BOUNDS.md §H.
Model: M_out (snapshot outputs), I1, T-relaxed; uses only the n! permutations (sound subset).

State = for each permutation s: register file (symbols 0..n-1 or T=n) + flags (lt, gt); plus D = set of outputs
already taken (out j done).  h(state, D) = c_lb + max(c_lb, a):
  c_lb = max over classes C (permutations with identical registers AND flags) of ceil(log2 #distinct
         remaining-requirement vectors (y_j(s))_{j not in D} in C)        -> lower bound on remaining cmp
  a    = #{j not in D : no register holds y_j(s) for every s}           -> lower bound on remaining cmov
  each remaining cmp needs its own later cmov (shortest completion)     -> remaining cmov >= c_lb

usage: heur.py file.s    (prints h at every prefix and checks h <= remaining length)
"""
import sys, itertools, math

T = None


def parse(path):
    prog = []
    for line in open(path):
        line = line.split('#')[0].strip()
        if not line:
            continue
        o, rest = line.split(None, 1)
        a, b = [x.strip() for x in rest.split(',')]
        prog.append((o, a, b))
    return prog


def init_state(n, regs):
    st = {}
    for s in itertools.permutations(range(n)):
        f = {r: (int(r[1:]) if r.startswith('P') else n) for r in regs}
        st[s] = [f, (False, False)]
    return st


def val(s, n, v):
    return 10 ** 6 if v == n else s[v]


def step(st, n, ins):
    o, a, b = ins
    for s, (f, (lt, gt)) in st.items():
        if o == 'mov':
            f[a] = f[b]
        elif o == 'cmp':
            x, y = val(s, n, f[a]), val(s, n, f[b])
            st[s][1] = (x < y, x > y)
        elif o.startswith('cmov'):
            c = {'cmovl': lt, 'cmovg': gt, 'cmovle': not gt, 'cmovge': not lt}[o]
            if c:
                f[a] = f[b]


def h(st, n, done):
    rem = [j for j in range(n) if j not in done]
    req = lambda s: tuple(sorted(range(n), key=lambda i: s[i])[j] for j in rem)
    classes = {}
    for s, (f, fl) in st.items():
        key = (tuple(sorted(f.items())), fl)
        classes.setdefault(key, set()).add(req(s))
    c_lb = max(math.ceil(math.log2(len(v))) for v in classes.values()) if classes else 0
    regs = next(iter(st.values()))[0].keys()
    a = 0
    for j in rem:
        if not any(all(f[r] == sorted(range(n), key=lambda i: s[i])[j] for s, (f, _) in st.items()) for r in regs):
            a += 1
    hf = huff_part(st, n, rem)
    if hf is None:
        return 10 ** 9, c_lb, a          # a needed value is lost: dead state
    return c_lb + max(c_lb, a, math.ceil(hf - 1e-9)), c_lb, a, round(hf, 3)


def huffman_cost(ws):
    import heapq
    ws = [w for w in ws if w > 0]
    if len(ws) <= 1:
        return 0.0
    heapq.heapify(ws)
    c = 0.0
    while len(ws) > 1:
        x = heapq.heappop(ws); y = heapq.heappop(ws)
        c += x + y
        heapq.heappush(ws, x + y)
    return c


def huff_part(st, n, rem):
    """lower bound on remaining cmov: sum_j E_s[len of output-j path to a current value] (BOUNDS.md H3)."""
    perms = list(st)
    regs = list(next(iter(st.values()))[0].keys())
    funcs = {}
    for r in regs:
        funcs.setdefault(tuple(st[s][0][r] for s in perms), r)
    F = list(funcs)
    total = 0.0
    for j in rem:
        holders = []
        for i, s in enumerate(perms):
            yj = sorted(range(n), key=lambda q: s[q])[j]
            hs = [fi for fi, f in enumerate(F) if f[i] == yj]
            if not hs:
                return None
            holders.append(hs)
        if any(all(fi in hs for hs in holders) for fi in range(len(F))):
            continue                       # some current value is y_j everywhere: 0 cmov needed
        if all(len(hs) == 1 for hs in holders):
            cnt = {}
            for hs in holders:
                cnt[hs[0]] = cnt.get(hs[0], 0) + 1
            total += huffman_cost([c / len(perms) for c in cnt.values()])
        else:
            total += 1.0
    return total


def check(path):
    prog = parse(path)
    n = int([l for l in open(path) if l.startswith('#')][0].split('n=')[1].split()[0])
    regs = sorted({r for _, a, b in prog for r in (a, b) if not r.isdigit()} | {f'P{i}' for i in range(n)})
    st = init_state(n, regs)
    real = [i for i in prog if i[0] != 'out']
    k = len(real)
    done, t, ok, hs = set(), 0, True, []
    for ins in prog + [('end', '', '')]:
        if ins[0] == 'out':
            done.add(int(ins[1]))
            continue
        hv = h(st, n, done)
        hs.append(hv[0])
        if hv[0] > k - t:
            ok = False
            print('VIOLATION at t', t, hv, 'remaining', k - t)
        if ins[0] == 'end':
            break
        step(st, n, ins)
        t += 1
    return ok, k, hs


if __name__ == '__main__':
    for p in sys.argv[1:]:
        ok, k, hs = check(p)
        print(('OK ' if ok else 'BAD'), p.split('/')[-1], 'k=', k, 'h(prefix)=', hs)
