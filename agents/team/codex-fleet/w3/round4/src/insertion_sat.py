#!/usr/bin/env python3
"""Append-only sort4 insertion synthesis, without a physical register bound.

Data instructions use SSA nodes. A conditional move consumes its default node.
A copy creates a fresh register. Historical nodes may supply output snapshots.
The physical-routing mode excludes untouched scratch registers. The free-copy
mode adds a common high scratch origin and keeps every old node available. It
relaxes arbitrary-scratch programs on one permitted scratch assignment.
"""
import argparse
import itertools
import json
import os
from pathlib import Path
import random
import resource
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[2]
PROJECT = ROOT.parents[3]
sys.path.insert(0, str(ROOT / 'src'))
from ssa_sat import CNF

PERMS = list(itertools.permutations(range(5)))
OPS = ['cmovl', 'cmovle', 'cmovg', 'cmovge']

def parse(path):
    out = []
    for line in Path(path).read_text().splitlines():
        line = line.split('#')[0].strip()
        if not line:
            continue
        op, args = line.split(None, 1)
        d, s = [x.strip() for x in args.split(',')]
        out.append((op, d, s))
    return out

def run(prog, ty, trace=False):
    regs = {f'P{i}': ty[i] for i in range(5)}
    flag = 0
    outs = {}
    states = []
    for op, d, s in prog:
        if op == 'out':
            outs[int(d)] = regs[s]
        elif op == 'cmp':
            a, b = regs.get(d, 5), regs.get(s, 5)
            flag = (a > b) - (a < b)
        elif op == 'mov' or (op == 'cmovl' and flag < 0) or (op == 'cmovle' and flag <= 0) or (op == 'cmovg' and flag > 0) or (op == 'cmovge' and flag >= 0):
            regs[d] = regs.get(s, 5)
        elif op.startswith('cmov'):
            regs.setdefault(d, 5)
        if trace:
            states.append((dict(regs), flag))
    return regs, flag, outs, states

class Enc(CNF):
    def __init__(self, prefix, types, comparisons, data, fixed=None, free_copies=False, origin=False):
        super().__init__()
        self.prefix = prefix
        self.types = types
        self.c = comparisons
        self.m = data
        self.free_copies = free_copies
        self.origin = origin
        rows = [run(prefix, ty) for ty in types]
        if free_copies:
            for row in rows:
                row[0]['S99'] = 5
        self.names = sorted(set().union(*(r[0] for r in rows)))
        B = self.B = len(self.names)
        T = len(types)
        C = comparisons + 1
        M = data
        self.mov = self.vec(M)
        self.dst = [self.vec(B + g) for g in range(M)]
        self.src = [self.vec(B + g) for g in range(M)]
        self.blk = [self.vec(C) for g in range(M)]
        self.op = [self.vec(4) for g in range(M)]
        self.cmps = [[self.vec(B + M), self.vec(B + M)] for j in range(comparisons)]
        self.out = [self.vec(B + M) for j in range(5)]
        def value(t,name):
            v=rows[t][0][name]
            return types[t].index(v) if origin and v<5 else v
        self.val = [[[bool((value(t,name) >> b) & 1) for b in range(3)] for t in range(T)] for name in self.names]
        self.val += [[self.vec(3) for t in range(T)] for g in range(M)]
        self.flags = [[[rows[t][1] == f for f in (-1, 0, 1)] for t in range(T)]]
        self.flags += [[self.vec(3) for t in range(T)] for j in range(comparisons)]
        for j in range(1, C):
            for row in self.flags[j]:
                self.eo(row)
        for g in range(M):
            for ls in (self.dst[g], self.src[g], self.blk[g], self.op[g]):
                self.eo(ls)
            self.cl(-self.mov[g], self.dst[g][0])
            self.cl(-self.mov[g], self.op[g][0])
            if g:
                for j in range(C):
                    for k in range(j):
                        self.cl(-self.blk[g - 1][j], -self.blk[g][k])
            # Reading a consumed node is forbidden. A copied node stays live.
            if not free_copies:
                for x, dst in enumerate(self.dst[g]):
                    for h in range(g + 1, M):
                        self.cl(self.mov[g], -dst, -self.src[h][x])
                        self.cl(self.mov[g], -dst, self.mov[h], -self.dst[h][x])
                    for j in range(comparisons):
                        for phase in range(j + 1):
                            for side in range(2):
                                self.cl(self.mov[g], -dst, -self.blk[g][phase], -self.cmps[j][side][x])
        # Comparison j occurs between data phases j and j+1.
        for j in range(comparisons):
            cv = [[self.vec(3) for t in range(T)] for side in range(2)]
            for side in range(2):
                self.eo(self.cmps[j][side])
                for x, pick in enumerate(self.cmps[j][side]):
                    if x >= B:
                        self.cl(-pick, *self.blk[x - B][:j + 1])
                    for t in range(T):
                        for b in range(3):
                            self.eq(cv[side][t][b], self.val[x][t][b], -pick)
            # Compare both selected values. All ranks lie in 0..4.
            for t in range(T):
                for u, v in itertools.product(range(6), repeat=2):
                    guard = [self.neg(cv[0][t][b]) if (u >> b) & 1 else cv[0][t][b] for b in range(3)]
                    guard += [self.neg(cv[1][t][b]) if (v >> b) & 1 else cv[1][t][b] for b in range(3)]
                    au=types[t][u] if origin and u<5 else u
                    av=types[t][v] if origin and v<5 else v
                    f = (au > av) - (au < av)
                    self.cl(*guard, self.flags[j + 1][t][f + 1])
        for g in range(M):
            dv = [self.vec(3) for t in range(T)]
            sv = [self.vec(3) for t in range(T)]
            for x in range(B + g):
                for t in range(T):
                    for b in range(3):
                        self.eq(dv[t][b], self.val[x][t][b], -self.dst[g][x])
                        self.eq(sv[t][b], self.val[x][t][b], -self.src[g][x])
            for t in range(T):
                for b in range(3):
                    self.eq(self.val[B + g][t][b], sv[t][b], -self.mov[g])
                for j in range(C):
                    for f in range(3):
                        flag = self.flags[j][t][f]
                        if flag is False:
                            continue
                        for op in range(4):
                            take = (f < 1, f <= 1, f > 1, f >= 1)[op]
                            vv = sv[t] if take else dv[t]
                            guard = [self.mov[g], -self.blk[g][j], self.neg(flag), -self.op[g][op]]
                            for b in range(3):
                                self.eq(self.val[B + g][t][b], vv[b], *guard)
        for j, ls in enumerate(self.out):
            self.eo(ls)
            for x, pick in enumerate(ls):
                for t, ty in enumerate(types):
                    target = ty.index(j) if origin else sorted(ty)[j]
                    for b in range(3):
                        self.cl(-pick, self.val[x][t][b] if (target >> b) & 1 else self.neg(self.val[x][t][b]))
        if fixed:
            self.fix(fixed)

    def fix(self, program):
        cur = {name: x for x, name in enumerate(self.names)}
        j = g = 0
        for op, d, s in program:
            if op == 'out':
                self.cl(self.out[int(d)][cur[s]])
            elif op == 'cmp':
                self.cl(self.cmps[j][0][cur[d]])
                self.cl(self.cmps[j][1][cur[s]])
                j += 1
            else:
                if self.free_copies and op=='mov':
                    cur[d]=cur[s]
                    continue
                self.cl(self.mov[g] if op == 'mov' else -self.mov[g])
                self.cl(self.blk[g][j])
                self.cl(self.src[g][cur[s]])
                if op != 'mov':
                    self.cl(self.dst[g][cur[d]])
                    self.cl(self.op[g][OPS.index(op)])
                cur[d] = self.B + g
                g += 1
        assert g == self.m and j == self.c

    def decode(self, model):
        yes = set(x for x in model if x > 0)
        idx = lambda xs: next(i for i, x in enumerate(xs) if x in yes)
        reg = {i: n for i, n in enumerate(self.names)}
        outputs = {j: idx(xs) for j, xs in enumerate(self.out)}
        lines = ['# n=5 model=out iset=I1 source=w3_sort4_insertion']
        lines += [f'{op} {d}, {s}' for op, d, s in self.prefix if op != 'out']
        for j, x in outputs.items():
            if x < self.B:
                lines.append(f'out {j}, {reg[x]}')
        g = 0
        for phase in range(self.c + 1):
            if phase:
                d, s = [idx(xs) for xs in self.cmps[phase - 1]]
                lines.append(f'cmp {reg[d]}, {reg[s]}')
            while g < self.m and idx(self.blk[g]) == phase:
                d, s = idx(self.dst[g]), idx(self.src[g])
                ismov = self.mov[g] in yes
                if ismov or self.free_copies:
                    name = f'S{100 + g}'
                    if self.free_copies and not ismov:
                        lines.append(f'mov {name}, {reg[d]}')
                else:
                    name = reg[d]
                lines.append(f'{"mov" if ismov else OPS[idx(self.op[g])]} {name}, {reg[s]}')
                reg[self.B + g] = name
                for j, x in outputs.items():
                    if x == self.B + g:
                        lines.append(f'out {j}, {name}')
                g += 1
        assert g == self.m
        return '\n'.join(lines) + '\n'

def solve(enc, tag, timeout, seed, solver, proof=False):
    cnf = str(tag) + '.cnf'
    log = str(tag) + '.solver'
    enc.dimacs(cnf)
    command = ['timeout', str(timeout), str(PROJECT / 'bin' / solver), '-q']
    if solver == 'kissat':
        command += [f'--seed={seed}']
    command += [cnf]
    if proof:
        command += [str(tag)+'.drat']
    start = time.monotonic()
    with open(log, 'w') as f:
        p = subprocess.run(command, stdout=f, stderr=subprocess.STDOUT)
    model = []
    status = 'TIMEOUT' if p.returncode == 124 else 'UNKNOWN'
    for line in Path(log).read_text().splitlines():
        if line.startswith('s '):
            status = line[2:]
        elif line.startswith('v '):
            model += [int(x) for x in line[2:].split() if int(x)]
    if proof and status=='UNSATISFIABLE':
        checklog=str(tag)+'.drat_check'
        with open(checklog,'w') as f:
            check=subprocess.run(['timeout','120',str(PROJECT/'bin/drat-trim'),
                    cnf,str(tag)+'.drat','-t','110'],stdout=f,stderr=subprocess.STDOUT)
        checked=Path(checklog).read_text()
        if check.returncode or 's VERIFIED' not in checked:
            raise RuntimeError('DRAT certificate check failed: '+checklog)
        print('CNF_CERTIFICATE_VERIFIED',checklog,flush=True)
    if not proof:
        os.unlink(cnf)
    return status, model, round(time.monotonic() - start, 3)

def main():
    resource.setrlimit(resource.RLIMIT_AS, (2900 * 1024**2,) * 2)
    os.sched_setaffinity(0, {min(os.sched_getaffinity(0))})
    ap = argparse.ArgumentParser()
    ap.add_argument('prefix')
    ap.add_argument('--tag', required=True)
    ap.add_argument('--comparisons', type=int, default=3)
    ap.add_argument('--data', type=int, default=8)
    ap.add_argument('--timeout', type=int, default=120)
    ap.add_argument('--all', action='store_true')
    ap.add_argument('--weak', action='store_true')
    ap.add_argument('--fix')
    ap.add_argument('--seed', type=int, default=1)
    ap.add_argument('--free-copies', action='store_true')
    ap.add_argument('--solver', default='kissat')
    ap.add_argument('--ordered-first4', action='store_true')
    ap.add_argument('--ordered-normalize', action='store_true')
    ap.add_argument('--first-pivot', type=int, choices=[0,1,2,3])
    ap.add_argument('--origin', action='store_true')
    ap.add_argument('--history', action='store_true')
    ap.add_argument('--proof', action='store_true')
    args = ap.parse_args()
    prefix = [row for row in parse(args.prefix) if row[0] != 'out']
    alltypes = [p for p in itertools.product(range(5), repeat=5) if set(p) == set(range(max(p) + 1))] if args.weak else PERMS
    if args.ordered_first4:
        alltypes = [p for p in alltypes if list(p[:4]) == sorted(p[:4])]
    rng = random.Random(args.seed)
    current = list(alltypes) if args.all else sorted(rng.sample(alltypes, min(15,len(alltypes))))
    start = time.monotonic()
    for iteration in range(100):
        tag = ROOT / 'round4/logs' / (args.tag + f'_i{iteration}')
        enc = Enc(prefix, current, args.comparisons, args.data,
                  parse(args.fix) if args.fix else None, args.free_copies,args.origin)
        if args.ordered_normalize:
            assert args.ordered_first4 and args.free_copies and not prefix
            # A free copy can be represented by a value alias. Remove copies
            # and constant-predicate operations before the first comparison.
            for g in range(enc.m):
                enc.cl(-enc.mov[g])
                enc.cl(-enc.blk[g][0])
                # Invert the predicate when swapping gate operands.
                for d in range(enc.B+g):
                    for s in range(d+1):
                        enc.cl(-enc.dst[g][d],-enc.src[g][s])
            # Swapping comparison operands and all phase predicates preserves
            # the circuit. Choose operands by node index.
            for pair in enc.cmps:
                for d in range(enc.B+enc.m):
                    for s in range(d+1):
                        enc.cl(-pair[0][d],-pair[1][s])
            if args.comparisons==3:
                # Three comparisons must distinguish five insertion positions.
                # The first useful comparison is e against a sorted value.
                # Test all four pivot positions. Value reversal is not used:
                # the garbage relaxation has a high sentinel only.
                enc.cl(enc.cmps[0][1][enc.names.index('P4')])
                pivots=[args.first_pivot] if args.first_pivot is not None else [0,1,2,3]
                enc.cl(*(enc.cmps[0][0][enc.names.index(f'P{i}')] for i in pivots))
                for phase in range(1,4):
                    enc.cl(*(enc.blk[g][phase] for g in range(enc.m)))
        if args.history:
            assert args.origin and args.ordered_first4
            # Registers can select an input origin only from the flag history.
            # Equal histories must give equal origins in every created node.
            pairs=list(itertools.combinations(range(len(current)),2))
            histories={pair:True for pair in pairs}
            for phase in range(1,args.comparisons+1):
                now={}
                for a,b in pairs:
                    same=enc.new()
                    for fa in range(3):
                        for fb in range(3):
                            enc.cl(enc.neg(enc.flags[phase][a][fa]),enc.neg(enc.flags[phase][b][fb]),same if fa==fb else -same)
                    h=enc.new();prev=histories[a,b]
                    enc.cl(-h,prev);enc.cl(-h,same)
                    enc.cl(h,enc.neg(prev),-same)
                    now[a,b]=h
                    for g in range(enc.m):
                        for bit in range(3):
                            enc.eq(enc.val[enc.B+g][a][bit],enc.val[enc.B+g][b][bit],-h,-enc.blk[g][phase])
                    if phase==args.comparisons:enc.cl(-h)
                if phase==args.comparisons-1:
                    # One binary comparison cannot distinguish three orders
                    # that share all preceding flags.
                    for a,b,c in itertools.combinations(range(len(current)),3):
                        enc.cl(-now[a,b],-now[a,c])
                histories=now
        print(json.dumps(dict(event='ENC', tag=args.tag, iteration=iteration,
              types=len(current), comparisons=args.comparisons, data=args.data,
              base=enc.B, variables=enc.nv, clauses=len(enc.cs),
              seconds=round(time.monotonic()-start,3))), flush=True)
        status, model, elapsed = solve(enc, tag, args.timeout, args.seed, args.solver,args.proof)
        print(json.dumps(dict(event='RESULT', tag=args.tag, iteration=iteration,
              result=status, solve_seconds=elapsed,
              seconds=round(time.monotonic()-start,3))), flush=True)
        if status != 'SATISFIABLE':
            return
        text = enc.decode(model)
        candidate = ROOT / 'round4/programs' / (args.tag + f'_i{iteration}.s')
        candidate.write_text(text)
        prog = parse(candidate)
        bad = []
        for ty in alltypes:
            outs = run(prog,ty)[2]
            if [outs[j] for j in range(5)] != sorted(ty):
                bad.append(ty)
        judge = subprocess.run(['python3', str(PROJECT/'shared/judge.py'), str(candidate),
                 '--strict','--model','out'], text=True, stdout=subprocess.PIPE,
                 stderr=subprocess.STDOUT)
        Path(str(candidate)+'.judge.txt').write_text(judge.stdout)
        print('JUDGE', judge.stdout.strip(), flush=True)
        if not bad:
            print('ALL_TYPES_CANDIDATE',candidate,flush=True)
            return
        current = sorted(set(current + rng.sample(bad,min(8,len(bad)))))
        print('COUNTEREXAMPLES',len(bad),flush=True)

if __name__ == '__main__':
    main()
