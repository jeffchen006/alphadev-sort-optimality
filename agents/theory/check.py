#!/usr/bin/env python3
"""theory's independent checker (critic tool). Not the reference judge (that is shared/judge.py, owner spec).

usage: check.py PROG.s [--n N] [--iset I0|I1]

Prints, for the program:
  - relaxed (T-relaxed, lemmas.md L2) correctness in RF / RE / RS output modes, over all weak orders (L1);
  - strict correctness: joint weak orders of (inputs, garbage of scratch registers read before written) x 3 initial flags;
  - garbage reads (scratch read before written, cmov before first cmp).
Semantics: Intel order, dest first. cmp A,B: lt iff A<B. cmovl/g/le/ge.
"""
import sys, re, itertools

COND = {'cmovl': ('lt',), 'cmovg': ('gt',), 'cmovle': ('lt', 'eq'), 'cmovge': ('gt', 'eq')}


def parse(path):
    prog, meta, outs = [], {}, {}
    for line in open(path):
        if line.lstrip().startswith('#'):
            for k, v in re.findall(r'(\w+)=(\S+)', line):
                meta[k] = v
        line = line.split('#')[0].strip()
        if not line:
            continue
        op, rest = line.split(None, 1)
        a = [x.strip() for x in rest.split(',')]
        if op == 'out':  # snapshot pseudo-instruction (cost 0); the last 'out j' counts
            outs[int(a[0])] = (a[1], len(prog))
            continue
        assert op in ('mov', 'cmp') or op in COND, op
        assert len(a) == 2 and all(re.fullmatch(r'[PS]\d+', x) for x in a), line
        prog.append((op, a[0], a[1]))
    return prog, meta, outs


def weak_orders(m):
    """all weak orders of m items as rank tuples (rank 0 = smallest; ties share rank)."""
    out = []
    def rec(i, ranks):
        if i == m:
            used = sorted(set(ranks))
            if used == list(range(len(used))):
                out.append(tuple(ranks))
            return
        for r in range(m):
            rec(i + 1, ranks + [r])
    rec(0, [])
    return out


def run(prog, regs0, flag0):
    """regs0: dict reg -> comparable value. returns list of states (dict) at positions 0..k."""
    regs, f = dict(regs0), flag0
    trace = [dict(regs)]
    for op, d, s in prog:
        if op == 'mov':
            regs[d] = regs[s]
        elif op == 'cmp':
            a, b = regs[d], regs[s]
            f = 'lt' if a < b else ('gt' if a > b else 'eq')
        else:
            if f in COND[op]:
                regs[d] = regs[s]
        trace.append(dict(regs))
    return trace


def garbage_reads(prog):
    written, issues, seen_cmp = set(), [], False
    for t, (op, d, s) in enumerate(prog, 1):
        reads = [s] + ([d] if op != 'mov' else [])
        for r in reads:
            if r.startswith('S') and r not in written:
                issues.append(f'line {t}: reads {r} before write')
        if op in COND and not seen_cmp:
            issues.append(f'line {t}: {op} before first cmp (reads initial flags)')
        if op == 'cmp':
            seen_cmp = True
        elif op == 'mov':
            written.add(d)
    return issues


def main():
    path = sys.argv[1]
    prog, meta, outs = parse(path)
    n = int(meta.get('n', 0))
    if '--n' in sys.argv:
        n = int(sys.argv[sys.argv.index('--n') + 1])
    iset = meta.get('iset', 'I1')
    if '--iset' in sys.argv:
        iset = sys.argv[sys.argv.index('--iset') + 1]
    if iset == 'I0':
        bad = [i for i in prog if i[0] in ('cmovle', 'cmovge')]
        if bad:
            print('NOT in I0:', bad[0])
    regs = sorted({r for _, d, s in prog for r in (d, s)} | {f'P{i}' for i in range(n)} | {r for r, _ in outs.values()},
                  key=lambda r: (r[0], int(r[1:])))
    scratch = [r for r in regs if r[0] == 'S']
    k = len(prog)
    print(f'n={n} k={k} registers={len(regs)} scratch={len(scratch)} iset={iset}')
    gr = garbage_reads(prog)
    print('garbage reads:', gr if gr else 'none')

    # relaxed: scratch = +inf, flags eq, all weak orders of inputs
    INF = 10 ** 9
    W = weak_orders(n)
    ok = {'RF': True, 'OUT': bool(outs) and len(outs) == n}
    cand = None  # set of (r,t) correct for each j
    for w in W:
        r0 = {r: (w[int(r[1:])] if r[0] == 'P' else INF) for r in regs}
        tr = run(prog, r0, 'eq')
        srt = sorted(w)
        if any(tr[-1][f'P{j}'] != srt[j] for j in range(n)):
            ok['RF'] = False
        if outs and any(tr[t][r] != srt[j] for j, (r, t) in outs.items()):
            ok['OUT'] = False
        c = [{(r, t) for t in range(k + 1) for r in regs if tr[t][r] == srt[j]} for j in range(n)]
        cand = c if cand is None else [a & b for a, b in zip(cand, c)]
    ok['RE'] = all(any(t == k for r, t in cj) for cj in cand)
    ok['RS'] = all(cj for cj in cand)
    print(f'relaxed ({len(W)} weak orders): RF={ok["RF"]} RE={ok["RE"]} RS={ok["RS"]}'
          + (f' given-outs={ok["OUT"]}' if outs else ''))
    if ok['RE'] and not ok['RF']:
        print('  RE outputs at end:', [sorted(r for r, t in cj if t == k) for cj in cand])

    # strict: joint weak orders of inputs + garbage of scratch read-before-written; all 3 initial flags
    gread = sorted({m.group(1) for m in (re.search(r'reads (S\d+)', x) for x in gr) if m},
                   key=lambda r: int(r[1:]))
    flag_matters = any('initial flags' in x for x in gr)
    flags = ['lt', 'eq', 'gt'] if flag_matters else ['eq']
    Wj = weak_orders(n + len(gread))
    sok = {'RF': True, 'RE': True, 'OUT': bool(outs) and len(outs) == n}
    scand = None
    for w in Wj:
        for f in flags:
            r0 = {r: INF for r in regs}
            for i in range(n):
                r0[f'P{i}'] = w[i]
            for g, r in enumerate(gread):
                r0[r] = w[n + g]
            tr = run(prog, r0, f)
            srt = sorted(w[:n])
            if any(tr[-1][f'P{j}'] != srt[j] for j in range(n)):
                sok['RF'] = False
            if outs and any(tr[t][r] != srt[j] for j, (r, t) in outs.items()):
                sok['OUT'] = False
            c = [{(r, t) for t in range(k + 1) for r in regs if tr[t][r] == srt[j]} for j in range(n)]
            scand = c if scand is None else [a & b for a, b in zip(scand, c)]
    sok['RE'] = all(any(t == k for r, t in cj) for cj in scand)
    sok['RS'] = all(cj for cj in scand)
    print(f'strict ({len(Wj)} joint orders x {len(flags)} flags): RF={sok["RF"]} RE={sok["RE"]} RS={sok["RS"]}'
          + (f' given-outs={sok["OUT"]}' if outs else ''))


if __name__ == '__main__':
    main()
