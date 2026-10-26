#!/usr/bin/env python3
"""Reference judge for sorting kernels (owner: spec). Model: shared/MODEL.md.

Usage:  python3 shared/judge.py FILE.s [--strict] [--model reg|mem|memplus|out] [--iset I0|I1|I2] [--seeds N] [-q]
Isets: I0 = mov cmp cmovl cmovg; I1 = I0 + cmovle cmovge; I2 = I1 + cmove cmovne xchg (register forms; MODEL §4.6).

Models (MODEL.md §1, §4): reg = registers only, outputs = final P0..P{n-1};
  mem = AlphaDev: P = memory, P only as mov operand, no mov P,P; L counts every instruction;
  memplus = mem + x86 memory SOURCE operands (MM+, MODEL §4.5): cmp S,P / cmp P,S / cmovX S,P; never two P operands,
    never a P destination of cmov;
  out = reg + pseudo-instruction 'out j, S' (cost 0): output j = value of S at the last 'out j', else final Pj.

Checks, in order (stops at the first FAIL, prints a counterexample):
  1. parse + iset check (+ operand rules if model=mem, i.e. AlphaDev memory model)
  2. relaxed lower-bound model: all weak order types (Fubini 13/75/541/...), scratch = T (> all inputs), flags = eq
  --strict adds:
  3. strict symbolic: all order types, scratch = distinct garbage symbols, initial flags in all 4 x86 states
     (ZF, SF!=OF); a cmp that reads garbage branches over lt/eq/gt (over-approximation: PASS here is a proof of
     correctness for ALL garbage; FAIL is confirmed by step 4 if possible)
  4. random concrete 32-bit tests: INT_MIN/INT_MAX/duplicates, random garbage, random initial flags

Flags are stored as (zf, lt): l = lt, le = zf|lt, g = !zf & !lt, ge = !lt. cmp A, B sets zf = (A == B), lt = (A < B)
(signed). After a real cmp the state (zf=1, lt=1) is impossible, but it is a legal initial state.
"""
import itertools
import random
import re
import sys

I1_OPS = {'mov', 'cmp', 'cmovl', 'cmovle', 'cmovg', 'cmovge'}
OPS = I1_OPS | {'cmove', 'cmovne', 'xchg'}
ISETS = {'I0': {'mov', 'cmp', 'cmovl', 'cmovg'}, 'I1': I1_OPS, 'I2': OPS}  # I2: MODEL.md §4.6
INT_MIN, INT_MAX = -2 ** 31, 2 ** 31 - 1
FLAG_STATES = [(1, 0), (0, 1), (0, 0), (1, 1)]  # eq, lt, gt, (zf=1,lt=1: initial only)
RELAXED_FLAGS = (1, 0)  # eq


class JudgeError(Exception):
    pass


def cond(op, flags):
    zf, lt = flags
    return {'cmovl': lt, 'cmovle': zf or lt, 'cmovg': (not zf) and (not lt), 'cmovge': not lt,
            'cmove': zf, 'cmovne': not zf}[op]


def parse(text):
    hdr, prog = {}, []
    for lineno, line in enumerate(text.splitlines(), 1):
        if line.lstrip().startswith('#') and not prog and not hdr:
            for k, v in re.findall(r'(\w+)=(\S+)', line):
                hdr[k] = v
        code = line.split('#', 1)[0].strip()
        if not code:
            continue
        m = re.fullmatch(r'([a-z]+)\s+([PS]\d+|\d+)\s*,\s*([PS]\d+)', code)
        if not m or (m.group(1) == 'out') != m.group(2).isdigit():
            raise JudgeError('line %d: cannot parse %r' % (lineno, code))
        op, a, b = m.groups()
        if op not in OPS | {'out'}:
            raise JudgeError('line %d: unknown opcode %r' % (lineno, op))
        prog.append((op, a, b, lineno))
    return hdr, prog


def check_static(prog, n, R, iset, model):
    allowed = ISETS[iset]
    for op, a, b, ln in prog:
        if op == 'out':
            if model != 'out':
                raise JudgeError('line %d: out only in model=out' % ln)
            if int(a) >= n:
                raise JudgeError('line %d: output index %s out of range' % (ln, a))
            continue
        if op not in allowed:
            raise JudgeError('line %d: opcode %s not in %s' % (ln, op, iset))
        for r in (a, b):
            i = int(r[1:])
            if r[0] == 'P' and i >= n:
                raise JudgeError('line %d: %s out of range (n=%d)' % (ln, r, n))
            if r[0] == 'S' and R is not None and n + i >= R:
                raise JudgeError('line %d: %s out of range (R=%d)' % (ln, r, R))
        if model in ('mem', 'memplus'):
            if a[0] == 'P' and b[0] == 'P':
                raise JudgeError('line %d: model=%s forbids two memory operands' % (ln, model))
            if model == 'mem' and op != 'mov' and (a[0] == 'P' or b[0] == 'P'):
                raise JudgeError('line %d: model=mem forbids %s on memory operand (MM-1)' % (ln, op))
            if op == 'xchg' and (a[0] == 'P' or b[0] == 'P'):
                raise JudgeError('line %d: xchg only in register form (I2, MODEL §4.6)' % ln)
            if model == 'memplus' and op.startswith('cmov') and a[0] == 'P':
                raise JudgeError('line %d: model=memplus forbids a memory DESTINATION in %s' % (ln, op))


def ad_legality(prog):
    """AlphaDev action-pruning legality (Methods + SI Assumption 1); reported, not enforced."""
    notes, init, seen_cmp, prev = [], set(), False, None
    for op, a, b, ln in prog:
        if op == 'out':
            continue
        srcs = [b] if op == 'mov' else ([a, b] if op == 'cmp' else [a, b])
        for r in srcs:
            if r[0] == 'S' and r not in init:
                notes.append('line %d: reads uninitialized %s' % (ln, r))
        if op.startswith('cmov') and not seen_cmp:
            notes.append('line %d: cmov before first cmp' % ln)
        if op == 'cmp' and prev == 'cmp':
            notes.append('line %d: consecutive cmp' % ln)
        if op == 'cmp':
            seen_cmp = True
        if op == 'mov':
            init.add(a)
        prev = op
        if op == 'xchg':
            init.update((a, b))
    return notes


def weak_orders(n):
    """All weak order types as rank vectors (values 0..m-1, all used)."""
    out = []
    for m in range(1, n + 1):
        for v in itertools.product(range(m), repeat=n):
            if len(set(v)) == m:
                out.append(v)
    return out


def regs(n, prog):
    s = {int(r[1:]) for _, a, b, _ in prog for r in (a, b) if r[0] == 'S'}
    return ['P%d' % i for i in range(n)] + ['S%d' % i for i in range(max(s) + 1 if s else 0)]


def outputs(st, outs, n):
    """Output j = value of the last 'out j, S' (model=out), else final register Pj."""
    return [outs.get(str(j), st['P%d' % j]) for j in range(n)]


def run_concrete(prog, state, flags):
    st = dict(state)
    st['_out'] = {}
    for op, a, b, _ in prog:
        if op == 'out':
            st['_out'] = dict(st['_out'])
            st['_out'][a] = st[b]
        elif op == 'mov':
            st[a] = st[b]
        elif op == 'xchg':
            st[a], st[b] = st[b], st[a]
        elif op == 'cmp':
            flags = (int(st[a] == st[b]), int(st[a] < st[b]))
        elif cond(op, flags):
            st[a] = st[b]
    return st


def relaxed(prog, n):
    """Relaxed model: inputs = order type ranks, scratch = T (= n, larger than every rank), flags = eq."""
    T = n
    names = regs(n, prog)
    for v in weak_orders(n):
        st = {r: (v[int(r[1:])] if r[0] == 'P' else T) for r in names}
        out = run_concrete(prog, st, RELAXED_FLAGS)
        got = outputs(out, out['_out'], n)
        if got != sorted(v):
            return 'order type %s -> output %s (T=%d means scratch value), expected %s' % (
                list(v), got, T, sorted(v))
    return None


def strict_symbolic(prog, n):
    """Values: ('x', rank) or ('g', id). Garbage cmps branch over lt/eq/gt; initial flags branch over 4 states."""
    names = regs(n, prog)
    for v in weak_orders(n):
        init = {r: (('x', v[int(r[1:])]) if r[0] == 'P' else ('g', int(r[1:]))) for r in names}
        init['_out'] = {}
        stack = [(0, init, ('init', f)) for f in FLAG_STATES]
        while stack:
            pc, st, flags = stack.pop()
            dead = False
            while pc < len(prog):
                op, a, b, _ = prog[pc]
                pc += 1
                if op == 'out':
                    st = dict(st)
                    st['_out'] = dict(st['_out'])
                    st['_out'][a] = st[b]
                elif op == 'mov':
                    st = dict(st)
                    st[a] = st[b]
                elif op == 'xchg':
                    st = dict(st)
                    st[a], st[b] = st[b], st[a]
                elif op == 'cmp':
                    x, y = st[a], st[b]
                    if x[0] == 'x' and y[0] == 'x':
                        flags = ('c', (int(x[1] == y[1]), int(x[1] < y[1])))
                    elif x == y:
                        flags = ('c', (1, 0))
                    else:
                        for f in [(1, 0), (0, 1), (0, 0)]:
                            stack.append((pc, st, ('g', f, a, b)))
                        dead = True
                        break
                else:
                    if cond(op, flags[1]):
                        st = dict(st)
                        st[a] = st[b]
            if dead:
                continue
            got = outputs(st, st['_out'], n)
            if any(g[0] != 'x' for g in got) or [g[1] for g in got] != sorted(v):
                return 'order type %s, flag path %s -> output %s, expected ranks %s' % (
                    list(v), flags[0], got, sorted(v))
    return None


def random_tests(prog, n, seeds, rng):
    names = regs(n, prog)
    special = [INT_MIN, INT_MIN + 1, -1, 0, 1, INT_MAX - 1, INT_MAX]
    for t in range(seeds):
        kind = t % 4
        if kind == 0:
            x = [rng.randint(INT_MIN, INT_MAX) for _ in range(n)]
        elif kind == 1:
            x = [rng.choice(special) for _ in range(n)]
        elif kind == 2:
            pool = [rng.randint(INT_MIN, INT_MAX) for _ in range(rng.randint(1, n))]
            x = [rng.choice(pool) for _ in range(n)]
        else:
            x = [rng.randint(-3, 3) for _ in range(n)]
        st = {}
        for r in names:
            if r[0] == 'P':
                st[r] = x[int(r[1:])]
            else:
                st[r] = rng.choice([rng.randint(INT_MIN, INT_MAX), rng.choice(special), rng.choice(x)])
        flags = rng.choice(FLAG_STATES)
        out = run_concrete(prog, st, flags)
        got = outputs(out, out['_out'], n)
        if got != sorted(x):
            return 'input %s, scratch %s, initial flags (zf,lt)=%s -> output %s, expected %s' % (
                x, {k: v for k, v in st.items() if k[0] == 'S'}, flags, got, sorted(x))
    return None


def judge(text, strict=False, model=None, iset=None, seeds=20000, seed=1, quiet=False):
    hdr, prog = parse(text)
    if 'n' not in hdr:
        raise JudgeError('header must give n=')
    n = int(hdr['n'])
    R = int(hdr['R']) if 'R' in hdr else None
    model = model or hdr.get('model', 'reg')
    iset = iset or hdr.get('iset', 'I1')
    check_static(prog, n, R, iset, model)
    L = sum(op != 'out' for op, _, _, _ in prog)
    info = 'n=%d L=%d R=%d iset=%s model=%s' % (n, L, len(regs(n, prog)), iset, model)
    err = relaxed(prog, n)
    if err:
        return False, info, 'relaxed model: ' + err
    if strict:
        err = strict_symbolic(prog, n)
        rerr = random_tests(prog, n, seeds, random.Random(seed))
        if rerr:
            return False, info, 'strict random test: ' + rerr
        if err:
            return False, info, 'strict symbolic (garbage-dependent path; no concrete counterexample found): ' + err
    notes = ad_legality(prog)
    if notes and not quiet:
        info += '\n  AlphaDev-pruning notes (not enforced): ' + '; '.join(notes)
    return True, info, None


def main(argv):
    args = argv[1:]
    if not args or args[0] in ('-h', '--help'):
        print(__doc__)
        return 2
    strict = '--strict' in args
    quiet = '-q' in args
    model = args[args.index('--model') + 1] if '--model' in args else None
    iset = args[args.index('--iset') + 1] if '--iset' in args else None
    seeds = int(args[args.index('--seeds') + 1]) if '--seeds' in args else 20000
    path = args[0]
    try:
        ok, info, err = judge(open(path).read(), strict, model, iset, seeds, quiet=quiet)
    except JudgeError as e:
        print('FAIL %s: %s' % (path, e))
        return 1
    mode = 'relaxed+strict' if strict else 'relaxed'
    if ok:
        print('PASS %s [%s] %s' % (path, mode, info))
        return 0
    print('FAIL %s [%s] %s\n  counterexample: %s' % (path, mode, info, err))
    return 1


if __name__ == '__main__':
    sys.exit(main(sys.argv))
