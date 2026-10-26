#!/usr/bin/env python3
"""SAT instruction-window synthesis with free register comparisons.

Values use three bits and one defined bit. An undefined value cannot feed a
comparison (except cmp r,r), or a recorded output. Conditional writes can
initialize scratch values separately on different cases. No initial sentinel
value is available to the synthesized program. This is a conservative strict
semantics, not a complete model of arbitrary garbage comparisons.

Modes: free chooses every instruction; class preserves the instruction classes
of a deletion template; dest also preserves write destinations. In every mode,
both comparison operands range over every register. Outputs select any write
snapshot, including the fixed suffix. CEGIS adds failing weak orders.
"""
import argparse
import itertools
import json
import random
import resource
import time
from pathlib import Path
from pysat.solvers import Solver

OPS = ['mov', 'cmp', 'cmovl', 'cmovle', 'cmovg', 'cmovge']
CASES = [x for x in itertools.product(range(5), repeat=5)
         if set(x) == set(range(max(x)+1))]


def read(path):
    names = [f'P{i}' for i in range(5)]
    core = []
    for line in Path(path).read_text().splitlines():
        line = line.split('#')[0].strip()
        if not line:
            continue
        op, a, b = line.replace(',', ' ').split()
        if op == 'out':
            continue
        for r in (a, b):
            if r not in names:
                names.append(r)
        core.append((OPS.index(op), names.index(a), names.index(b)))
    return core, names


def read_outputs(path, names):
    t = 0
    outs = {}
    for line in Path(path).read_text().splitlines():
        line = line.split('#')[0].strip()
        if not line:
            continue
        op, a, b = line.replace(',', ' ').split()
        if op == 'out':
            outs[int(a)] = (t, names.index(b))
        else:
            t += 1
    return outs


def concrete(core, case, nr):
    st = list(case) + [None]*(nr-5)
    flag = None
    states = [(st[:], flag)]
    columns = [(-1, r, v) for r, v in enumerate(st)]
    for t, (op, d, s) in enumerate(core):
        a, b = st[d], st[s]
        if op == 1:
            flag = 0 if d == s else None if a is None or b is None else (a>b)-(a<b)
        elif op == 0:
            st[d] = b
        elif flag is None:
            st[d] = a if a == b else None
        elif (flag < 0 if op == 2 else flag <= 0 if op == 3 else
              flag > 0 if op == 4 else flag >= 0):
            st[d] = b
        if op != 1:
            columns.append((t, d, st[d]))
        states.append((st[:], flag))
    return states, columns


class CNF:
    def __init__(self, solver):
        self.solver = solver
        self.nv = self.nc = 0
        self.cache = {}
        self.true = self.var()
        self.solver.add_clause([self.true])
        self.nc += 1

    def var(self):
        self.nv += 1
        return self.nv

    def add(self, *args):
        args = set(args)
        if self.true in args or any(-x in args for x in args):
            return
        args.discard(-self.true)
        self.solver.add_clause(list(args))
        self.nc += 1

    def const(self, b):
        return self.true if b else -self.true

    def land(self, *xs):
        xx = set(xs)
        if -self.true in xx or any(-x in xx for x in xx):
            return -self.true
        xx.discard(self.true)
        if not xx:
            return self.true
        if len(xx) == 1:
            return next(iter(xx))
        key = ('and', *sorted(xx))
        if key not in self.cache:
            z = self.var()
            for x in xx:
                self.add(-z, x)
            self.add(z, *[-x for x in xx])
            self.cache[key] = z
        return self.cache[key]

    def lor(self, *xs):
        return -self.land(*[-x for x in xs])

    def ite(self, c, a, b):
        if c == self.true or a == b:
            return a
        if c == -self.true:
            return b
        if a == self.true:
            return self.lor(c, b)
        if a == -self.true:
            return self.land(-c, b)
        if b == self.true:
            return self.lor(-c, a)
        if b == -self.true:
            return self.land(c, a)
        key = ('ite', c, a, b)
        if key not in self.cache:
            z = self.var()
            self.add(-c, -a, z)
            self.add(-c, a, -z)
            self.add(c, -b, z)
            self.add(c, b, -z)
            self.cache[key] = z
        return self.cache[key]

    def onehot(self, n):
        xs = [self.var() for _ in range(n)]
        self.add(*xs)
        # Pairwise clauses are small here (at most eleven registers).
        for i, x in enumerate(xs):
            for y in xs[:i]:
                self.add(-x, -y)
        return xs

    def choose(self, selected, values):
        pairs = [(s, v) for s, v in zip(selected, values) if s != -self.true]
        for sel, val in pairs:
            if sel == self.true:
                return val
        selected, values = zip(*pairs)
        if all(v == values[0] for v in values):
            return values[0]
        z = self.var()
        for sel, val in zip(selected, values):
            self.add(-sel, -val, z)
            self.add(-sel, val, -z)
        return z

    def less(self, a, b):
        v = -self.true
        for x, y in zip(a, b):
            v = self.ite(x, self.land(y, v), self.lor(y, v))
        return v


class Window:
    def __init__(self, core, names, args):
        self.core, self.names, self.args = core, names, args
        self.nr = len(names)
        self.a, self.b = args.a, args.b
        self.m = args.b-args.a-args.delta
        self.solver = Solver(name=args.solver)
        self.c = c = CNF(self.solver)
        self.choices = []
        template = core[args.a:args.b]
        if args.delta:
            for d in sorted(args.delete, reverse=True):
                template.pop(d)
        assert len(template) == self.m
        for t in range(self.m):
            oldop, oldd, olds = template[t]
            constchoice = lambda n, v: [c.const(i == v) for i in range(n)]
            if args.control:
                op, dst, src = constchoice(6, oldop), constchoice(self.nr, oldd), constchoice(self.nr, olds)
            else:
                allowed = list(range(6))
                if args.mode != 'free':
                    if oldop == 1:
                        allowed = [1]
                    elif args.mode == 'cmp':
                        allowed = [0, 2, 3, 4, 5]
                    else:
                        allowed = [0] if oldop == 0 else [2, 3, 4, 5]
                if len(allowed) == 1:
                    op = constchoice(6, allowed[0])
                else:
                    op = [-c.true]*6
                    for index, selector in zip(allowed, c.onehot(len(allowed))):
                        op[index] = selector
                dst = constchoice(self.nr, oldd) if args.mode == 'dest' and oldop != 1 else c.onehot(self.nr)
                src = c.onehot(self.nr)
            self.choices.append((op, dst, src))
            if args.cmp_order:
                for d in range(self.nr):
                    for s in range(d):
                        c.add(-op[1], -dst[d], -src[s])
            if args.no_self_write:
                for d, s in zip(dst, src):
                    c.add(op[1], -d, -s)
        if args.prefer_seed:
            phases = {}
            phase_template = []
            invert = False
            for op, d, s in template:
                if args.cmp_order and op == 1:
                    invert = d > s
                    if invert:
                        d, s = s, d
                elif invert and op >= 2:
                    op = {2:4, 3:5, 4:2, 5:3}[op]
                phase_template.append((op, d, s))
            for choice, original in zip(self.choices, phase_template):
                for selected, wanted in zip(choice, original):
                    for i, literal in enumerate(selected):
                        if abs(literal) != c.true:
                            phases[abs(literal)] = literal if i == wanted else -literal
            self.solver.set_phases(list(phases.values()))
        if args.comparisons >= 0:
            from pysat.card import CardEnc, EncType
            card = CardEnc.equals([o[1] for o, d, s in self.choices],
                                  args.comparisons, top_id=c.nv, encoding=EncType.seqcounter)
            for clause in card.clauses:
                c.add(*clause)
            c.nv = max(c.nv, card.nv)
        self.prefix = [concrete(core[:self.a], case, self.nr) for case in CASES]
        # Only globally valid prefix snapshots can serve as outputs.
        prefix_good = {}
        for j in range(5):
            for index, (t, r, v) in enumerate(self.prefix[0][1]):
                if all(p[1][index][2] == sorted(case)[j]
                       for case, p in zip(CASES, self.prefix)):
                    prefix_good[j] = (t, r)
                    break
        self.prefix_good = prefix_good
        # A synthesized cmp slot can still be a snapshot of an unchanged value.
        # Each (time, register) choice is common to all cases.
        self.witnesses = [(self.a, r) for r in range(self.nr)]
        # Negative register codes select the instruction's decoded destination.
        self.witnesses += [(self.a+t+1, -t-1) for t in range(self.m)]
        self.witnesses += [(self.a+self.m+t+1, d)
                           for t, (op, d, _) in enumerate(core[self.b:]) if op != 1]
        self.seed_witness = {}
        self.seed_extra = []
        if args.outputs != 'free':
            for j, (t, r) in read_outputs(args.seed, names).items():
                if j in prefix_good:
                    continue
                if t > self.b:
                    t -= args.delta
                elif t > self.a:
                    t -= sum(self.a+d < t for d in args.delete)
                self.seed_witness[j] = []
                for reg in ([r] if args.outputs == 'seed' else range(self.nr)):
                    self.seed_witness[j].append(len(self.witnesses))
                    self.witnesses.append((t, reg))
                    self.seed_extra.append((t, reg))
        self.outputs = {}
        for j in range(5):
            if j not in prefix_good:
                self.outputs[j] = [c.var() for _ in self.witnesses]
                c.add(*self.outputs[j])
                if args.outputs != 'free':
                    c.add(*[self.outputs[j][index] for index in self.seed_witness[j]])
        if args.prefer_seed:
            phases = []
            for j, (time_, reg) in read_outputs(args.seed, names).items():
                if j not in self.outputs:
                    continue
                if time_ > self.b:
                    time_ -= args.delta
                elif time_ > self.a:
                    time_ -= sum(self.a+d < time_ for d in args.delete)
                allowed = self.seed_witness.get(j, range(len(self.witnesses)))
                candidates = []
                for index in allowed:
                    t, r = self.witnesses[index]
                    r = template[-r-1][1] if r < 0 else r
                    if r == reg and t <= time_:
                        candidates.append((t, index))
                chosen = max(candidates)[1] if candidates else next(iter(allowed))
                phases.extend(sel if i == chosen else -sel for i, sel in enumerate(self.outputs[j]))
            self.solver.set_phases(phases)
        self.used = set()

    def batch(self, indices):
        c = self.c
        def val(v):
            return [c.const(bool(((v or 0) >> b) & 1)) for b in range(3)] + [c.const(v is not None)]
        for ix in indices:
            assert ix not in self.used
            self.used.add(ix)
            st0, flag = self.prefix[ix][0][-1]
            st = [val(v) for v in st0]
            lt, gt = c.const(flag == -1), c.const(flag == 1)
            flagdef = c.const(flag is not None)
            snapshots = [v for v in st]
            hist = {self.a: st[:]}
            for t, (op, dst, src) in enumerate(self.choices, self.a+1):
                av = [c.choose(dst, [v[b] for v in st]) for b in range(4)]
                bv = [c.choose(src, [v[b] for v in st]) for b in range(4)]
                if op[1] != -c.true:
                    same = c.lor(*[c.land(d, s) for d, s in zip(dst, src)])
                    c.add(-op[1], c.lor(same, c.land(av[3], bv[3])))
                take = c.lor(op[0], c.land(op[2], lt), c.land(op[3], -gt),
                             c.land(op[4], gt), c.land(op[5], -lt))
                # Conditional execution must not depend on unknown initial flags.
                c.add(c.lor(op[0], op[1], flagdef))
                writeval = [c.ite(take, bv[b], av[b]) for b in range(4)]
                st = [[c.ite(c.land(d, take), bv[b], old[b]) for b in range(4)]
                      for d, old in zip(dst, st)]
                if op[1] != -c.true:
                    lt = c.ite(op[1], c.less(av[:3], bv[:3]), lt)
                    gt = c.ite(op[1], c.less(bv[:3], av[:3]), gt)
                flagdef = c.lor(op[1], flagdef)
                snapshots.append(writeval)
                hist[t] = st[:]
            for t, (op, d, s) in enumerate(self.core[self.b:], self.a+self.m+1):
                av, bv = st[d], st[s]
                if op == 1:
                    c.add(c.lor(c.const(d == s), c.land(av[3], bv[3])))
                    lt, gt = c.less(av[:3], bv[:3]), c.less(bv[:3], av[:3])
                    flagdef = c.true
                else:
                    if op == 0:
                        st[d] = bv
                    else:
                        c.add(flagdef)
                        take = [lt, -gt, gt, -lt][op-2]
                        st[d] = [c.ite(take, bv[b], av[b]) for b in range(4)]
                    snapshots.append(st[d])
                hist[t] = st[:]
            for t, r in self.seed_extra:
                snapshots.append(hist[t][r])
            assert len(snapshots) == len(self.witnesses)
            for j, selected in self.outputs.items():
                wanted = sorted(CASES[ix])[j]
                for sel, v in zip(selected, snapshots):
                    c.add(-sel, v[3])
                    for b in range(3):
                        c.add(-sel, v[b] if (wanted >> b) & 1 else -v[b])

    def decode(self):
        model = set(x for x in self.solver.get_model() if x > 0)
        get = lambda ss: next(i for i, s in enumerate(ss) if s in model)
        replacement = [tuple(get(ss) for ss in choice) for choice in self.choices]
        core = self.core[:self.a] + replacement + self.core[self.b:]
        outs = {j: (t+1, r) for j, (t, r) in self.prefix_good.items()}
        for j, sels in self.outputs.items():
            allowed = self.seed_witness.get(j, range(len(sels)))
            selected = next(i for i in allowed if sels[i] in model)
            t, r = self.witnesses[selected]
            outs[j] = (t, replacement[-r-1][1] if r < 0 else r)
        return core, outs


def write(path, core, names, outs):
    lines = [f'# n=5 model=out iset=I1 source=w4-round2-cnf k={len(core)}']
    for t in range(len(core)+1):
        for j, (time_, r) in sorted(outs.items()):
            if time_ == t:
                lines.append(f'out {j}, {names[r]}')
        if t < len(core):
            op, d, s = core[t]
            lines.append(f'{OPS[op]} {names[d]}, {names[s]}')
    Path(path).write_text('\n'.join(lines)+'\n')


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('seed')
    ap.add_argument('--a', type=int, required=True)
    ap.add_argument('--b', type=int, required=True)
    ap.add_argument('--delta', type=int, default=1)
    ap.add_argument('--delete', type=int, nargs='*', default=[])
    ap.add_argument('--mode', choices=['free','cmp','class','dest'], default='free')
    ap.add_argument('--outputs', choices=['free','seed','times'], default='free')
    ap.add_argument('--cmp-order', action='store_true',
                    help='Normalize cmp operand order; only safe when the suffix does not use window flags.')
    ap.add_argument('--no-self-write', action='store_true', help='Exclude writes from a register to itself.')
    ap.add_argument('--prefer-seed', action='store_true', help='Use seed instructions as initial SAT phases only.')
    ap.add_argument('--comparisons', type=int, default=-1)
    ap.add_argument('--control', action='store_true')
    ap.add_argument('--wrong-output', action='store_true')
    ap.add_argument('--extra', type=int, default=0)
    ap.add_argument('--cases', type=int, default=12)
    ap.add_argument('--case-set', choices=['random','binary','ternary','strict'], default='random')
    ap.add_argument('--case-file', help='Append weak-order indices from a JSON list to the initial set.')
    ap.add_argument('--refine', type=int, default=12, help='Maximum counterexamples added per iteration.')
    ap.add_argument('--all-cases', action='store_true')
    ap.add_argument('--seconds', type=float, default=300)
    ap.add_argument('--random-seed', type=int, default=0)
    ap.add_argument('--solver', default='cadical195')
    ap.add_argument('--out', required=True)
    args = ap.parse_args()
    if not args.delete:
        args.delete = list(range(args.b-args.a-args.delta, args.b-args.a))
    assert len(args.delete) == args.delta
    core, names = read(args.seed)
    for i in range(args.extra):
        names.append(f'S{100+i}')
    start = time.monotonic()
    w = Window(core, names, args)
    if args.wrong_output:
        # Force minimum to the untouched P0 at window entry.
        assert 0 in w.outputs
        w.c.add(w.outputs[0][0])
    rng = random.Random(args.random_seed)
    strict = [i for i, case in enumerate(CASES) if len(set(case)) == 5]
    if args.all_cases:
        selected = list(range(541))
    elif args.case_set in ('binary', 'ternary'):
        maximum = 1 if args.case_set == 'binary' else 2
        selected = [i for i, case in enumerate(CASES) if max(case) <= maximum]
    elif args.case_set == 'strict':
        selected = strict
    else:
        selected = rng.sample(strict, args.cases)
    if args.case_file:
        extra_cases = json.loads(Path(args.case_file).read_text())
        assert all(isinstance(i, int) and 0 <= i < 541 for i in extra_cases)
        selected = list(dict.fromkeys(selected+extra_cases))
    iteration = 0
    best = 542
    heartbeat = time.monotonic()
    while True:
        w.batch(selected)
        iteration += 1
        print(json.dumps({'phase':'built', 'iteration':iteration, 'cases':len(w.used),
                          'variables':w.c.nv, 'clauses':w.c.nc,
                          'seconds':round(time.monotonic()-start,3)}), flush=True)
        while True:
            if time.monotonic()-start >= args.seconds:
                status = None
                break
            w.solver.conf_budget(2000)
            status = w.solver.solve_limited()
            if time.monotonic()-heartbeat >= 30:
                print(json.dumps({'phase':'working', 'iteration':iteration,
                                  'cases':len(w.used), 'seconds':round(time.monotonic()-start,3),
                                  'stats':w.solver.accum_stats()}), flush=True)
                heartbeat = time.monotonic()
            if status is not None:
                break
        print(json.dumps({'phase':'solve','iteration':iteration, 'status':str(status),
                          'cases':len(w.used), 'seconds':round(time.monotonic()-start,3),
                          'stats':w.solver.accum_stats()}), flush=True)
        if status is not True:
            break
        candidate, outs = w.decode()
        failing = []
        for ix, case in enumerate(CASES):
            states, _ = concrete(candidate, case, len(names))
            if any(states[t][0][r] != sorted(case)[j] for j, (t, r) in outs.items()):
                failing.append(ix)
        if not failing:
            write(args.out, candidate, names, outs)
            print(json.dumps({'status':'CANDIDATE', 'path':args.out, 'k':len(candidate)}), flush=True)
            break
        if len(failing) < best:
            best = len(failing)
            near = str(Path(args.out).with_name(Path(args.out).stem+'_near.s'))
            write(near, candidate, names, outs)
            print(json.dumps({'phase':'near', 'path':near, 'k':len(candidate),
                              'failing_weak_orders':best}), flush=True)
        assert not set(failing).intersection(w.used), 'Encoding accepted a failing included case'
        selected = rng.sample(failing, min(args.refine, len(failing)))
        print(json.dumps({'phase':'refine','failures':len(failing),'added':selected}), flush=True)
    w.solver.delete()
    print(json.dumps({'phase':'resources', 'cpu_seconds':round(time.process_time(),3),
                      'peak_rss_kib':resource.getrusage(resource.RUSAGE_SELF).ru_maxrss}), flush=True)


if __name__ == '__main__':
    main()
