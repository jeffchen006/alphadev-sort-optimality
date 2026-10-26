"""Normal form of an M_out (snapshot) program under the rules of RULES.md, then check that the encoder
(all rules + hcmp, all permutations) accepts it. Validates the rules on known optimal programs.

usage: python3 normalize.py FILE.s [-n N] [--blocks]   (FILE in 'model=out' format: 'out j, REG' = snapshot)
       --blocks: FILE holds many programs separated by lines '# prog ...'
"""
import argparse, sys
from pysat.solvers import Solver
import sim
from encode import Enc

ORDER = ['mov', 'cmp', 'cmovl', 'cmovg', 'cmovle', 'cmovge']
CMOV = {'cmovl', 'cmovg', 'cmovle', 'cmovge'}
FLIP = {'cmovl': 'cmovg', 'cmovg': 'cmovl', 'cmovle': 'cmovge', 'cmovge': 'cmovle'}


def parse_out(text, n):
    """-> prog [(op,d,s)], snaps [(t, r)] (t = number of steps before the snapshot; last 'out j' wins)."""
    prog, snaps = [], {}
    for line in text.splitlines():
        line = line.split('#', 1)[0].strip()
        if not line:
            continue
        op, rest = line.split(None, 1)
        a, b = [x.strip() for x in rest.split(',')]
        if op == 'out':
            snaps[int(a)] = (len(prog), sim.parse_reg(b, n))
        else:
            prog.append((op, sim.parse_reg(a, n), sim.parse_reg(b, n)))
    for j in range(n):
        if j not in snaps:
            snaps[j] = (len(prog), j)  # no 'out j': final value of Pj
    return prog, [snaps[j] for j in range(n)]


def writes(ins):
    return ins[0] == 'mov' or ins[0] in CMOV


def canon_slot(prog, t, r):
    """snapshot (t, r) -> slot ('in', r) or ('step', i) with d_i = r; follows mov slots to their source (snapcmov)."""
    while True:
        i = t - 1
        while i >= 0 and not (writes(prog[i]) and prog[i][1] == r):
            i -= 1
        if i < 0:
            return ('in', r)
        if prog[i][0] == 'mov':
            t, r = i, prog[i][2]  # value of the source just before step i
            continue
        return ('step', i)


def slots_to_snaps(prog, slots):
    return [(0, x[1]) if x[0] == 'in' else (x[1] + 1, prog[x[1]][1]) for x in slots]


class NF:
    def __init__(self, n, prog, snaps):
        self.n = n
        self.prog = list(prog)
        self.slots = [canon_slot(self.prog, t, r) for t, r in snaps]
        self.log = []

    # -- helpers --------------------------------------------------------------------------------
    def delete(self, i, why):
        ins = self.prog[i]
        # a snapshot on this step's slot: only allowed for value-preserving deletions -> previous write slot
        new = []
        for x in self.slots:
            if x == ('step', i):
                x = canon_slot(self.prog, i, ins[1])
            new.append(x)
        self.slots = [('step', x[1] - 1) if x[0] == 'step' and x[1] > i else x for x in new]
        del self.prog[i]
        self.log.append('del %d %s (%s)' % (i, ins, why))

    def live_after(self, i, r):
        """value of r written at step i is observed later (read before a mov to r) or snapshotted."""
        if ('step', i) in self.slots and self.prog[i][1] == r:
            return True
        for j in range(i + 1, len(self.prog)):
            op, d, s = self.prog[j]
            if s == r or (d == r and op != 'mov'):
                return True
            if d == r and op == 'mov':
                return False
        return False

    # -- rewriting steps (each returns True if it changed something) ------------------------------
    def step_dead(self):
        p = self.prog
        first_cmp = next((i for i, x in enumerate(p) if x[0] == 'cmp'), len(p))
        for i, (op, d, s) in enumerate(p):
            if writes(p[i]) and d == s:
                self.delete(i, 'self move'); return True
            if op in ('cmovl', 'cmovg') and i < first_cmp:
                self.delete(i, 'cmov before first cmp'); return True
            if op in ('cmovle', 'cmovge') and i < first_cmp:
                p[i] = ('mov', d, s); self.log.append('cmov->mov %d' % i); return True
            if writes(p[i]) and not self.live_after(i, d):
                self.delete(i, 'dead write'); return True
            if op == 'cmp':
                j = i + 1
                readers = []
                while j < len(p) and p[j][0] != 'cmp':
                    if p[j][0] in CMOV:
                        readers.append(j)
                    j += 1
                if not readers:
                    self.delete(i, 'dead cmp'); return True
                if d == s:  # flags eq
                    j = readers[0]
                    if p[j][0] in ('cmovl', 'cmovg'):
                        self.delete(j, 'cmov after cmp r,r')
                    else:
                        p[j] = ('mov', p[j][1], p[j][2]); self.log.append('cmov->mov %d (cmp r,r)' % j)
                    return True
        return False

    def step_movfresh(self):
        p, n = self.prog, self.n
        touched = set()
        for i, (op, d, s) in enumerate(p):
            if op == 'mov' and s >= n and s not in touched:
                self.delete(i, 'mov from untouched scratch'); return True
            if op == 'mov' and d in touched | set(range(n)):
                fresh = max([n - 1] + [max(x[1], x[2]) for x in p]) + 1
                # rename the web of d from step i to the next mov into d
                j = i + 1
                p[i] = ('mov', fresh, s)
                end = len(p)
                for jj in range(i + 1, len(p)):
                    if p[jj][0] == 'mov' and p[jj][1] == d:
                        end = jj
                        break
                for jj in range(i + 1, end):
                    o, a, b = p[jj]
                    p[jj] = (o, fresh if a == d else a, fresh if b == d else b)
                if end < len(p):  # the mov at 'end' writes d (not part of the web) but may read it
                    o, a, b = p[end]
                    p[end] = (o, a, fresh if b == d else b)
                self.log.append('movfresh %d: %d -> %d' % (i, d, fresh))
                return True
            touched |= {d, s}
        return False

    def step_rename(self):
        """canon (scratch) + pcanon (inputs) by first touch, dst before src."""
        p, n = self.prog, self.n
        order_s, order_p = [], []
        for op, d, s in p:
            for r in (d, s):
                if r >= n and r not in order_s:
                    order_s.append(r)
                if r < n and r not in order_p:
                    order_p.append(r)
        mp = {}
        for idx, r in enumerate(order_p + [r for r in range(n) if r not in order_p]):
            mp[r] = idx
        for idx, r in enumerate(order_s):
            mp[r] = n + idx
        if all(mp[r] == r for r in mp):
            return False
        self.prog = [(o, mp[a], mp[b]) for o, a, b in p]
        self.slots = [('in', mp[x[1]]) if x[0] == 'in' else x for x in self.slots]
        self.log.append('rename %s' % mp)
        return True

    def step_cmpord(self):
        p = self.prog
        for i, (op, d, s) in enumerate(p):
            if op == 'cmp' and d > s:
                p[i] = ('cmp', s, d)
                j = i + 1
                while j < len(p) and p[j][0] != 'cmp':
                    if p[j][0] in CMOV:
                        p[j] = (FLIP[p[j][0]], p[j][1], p[j][2])
                    j += 1
                self.log.append('flip cmp %d' % i)
                return True
        return False

    def step_comm(self):
        p, n = self.prog, self.n
        touched = set()
        for i in range(len(p) - 1):
            A, B = p[i], p[i + 1]
            ftA = bool({A[1], A[2]} - touched)
            ftB = bool({B[1], B[2]} - touched - {A[1], A[2]})
            touched |= {A[1], A[2]}
            dep = False
            if (A[0] == 'cmp' and (B[0] == 'cmp' or B[0] in CMOV)) or (B[0] == 'cmp' and A[0] in CMOV):
                dep = True
            if writes(A) and A[1] in (B[1], B[2]):
                dep = True
            if writes(B) and B[1] in (A[1], A[2]):
                dep = True
            if dep or (ftA and ftB):
                continue
            ca = (ORDER.index(A[0]), A[1], A[2])
            cb = (ORDER.index(B[0]), B[1], B[2])
            if ca > cb:
                p[i], p[i + 1] = B, A
                self.slots = [('step', i + 1) if x == ('step', i) else ('step', i) if x == ('step', i + 1) else x
                              for x in self.slots]
                self.log.append('swap %d' % i)
                return True
        return False

    def run(self, maxit=100000):
        steps = [self.step_dead, self.step_movfresh, self.step_rename, self.step_cmpord, self.step_comm]
        for _ in range(maxit):
            if not any(f() for f in steps):
                return
        raise RuntimeError('no fixpoint')


def check_encoder(n, prog, slots, rules, k=None):
    k = k or len(prog)
    e = Enc(n, k, None, 'I1', 'snap', rules, True)
    for t in sim.total_orders(n):
        e.add_type(t)
    if 'hcmp' in rules and n <= 4:  # class cuts (hcmp part 2) are too big to build for n = 5
        e.add_class_cuts()
    a = []
    for i in range(k):
        if i < len(prog):
            o, d, s = prog[i]
            a += [e.op[i][o], e.d[i][d], e.s[i][s]]
        else:
            a += [e.op[i]['nop']]
    for j, x in enumerate(slots):
        a.append(e.osnap[j][x[1] if x[0] == 'in' else n + x[1]])
    if any(l is False for l in a):
        return False
    s = Solver(name='cadical195', bootstrap_with=e.clauses)
    r = s.solve(assumptions=a)
    s.delete()
    return r


RULES = ['canon', 'pcanon', 'comm', 'dead', 'flags', 'cmpord', 'movfresh', 'snapcmov', 'hcmp']


def process(text, n, verbose=True):
    prog, snaps = parse_out(text, n)
    k0 = len(prog)
    assert not sim.check_relaxed(prog, n, 'snap', sim.total_orders(n), snaps), 'input program wrong'
    nf = NF(n, prog, snaps)
    nf.run()
    snaps2 = slots_to_snaps(nf.prog, nf.slots)
    ok_sim = not sim.check_relaxed(nf.prog, n, 'snap', sim.weak_orders(n), snaps2)
    ok_enc = check_encoder(n, nf.prog, nf.slots, RULES, k0)
    bad = []
    if not ok_enc:
        for r in RULES:
            rs = [x for x in RULES if x != r and not (r == 'flags' and x == 'hcmp') and not (r == 'snapcmov' and x == 'hcmp')
                  and not (r == 'canon' and x == 'movfresh')]
            if check_encoder(n, nf.prog, nf.slots, rs, k0):
                bad.append(r)
    if verbose:
        print('k %d -> %d, sim(weak orders) %s, encoder(all rules+hcmp) %s%s' % (
            k0, len(nf.prog), 'OK' if ok_sim else 'FAIL', 'SAT' if ok_enc else 'UNSAT',
            '' if ok_enc else ' (accepted when dropping %s)' % bad))
    return k0, len(nf.prog), ok_sim, ok_enc, nf


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('file')
    ap.add_argument('-n', type=int)
    ap.add_argument('--blocks', action='store_true')
    ap.add_argument('--max', type=int, default=20)
    ap.add_argument('--show', action='store_true')
    a = ap.parse_args()
    text = open(a.file).read()
    import re
    n = a.n or int(re.search(r'n=(\d+)', text).group(1))
    if a.blocks:
        blocks = [b for b in re.split(r'^# prog.*$', text, flags=re.M) if b.strip()][:a.max]
    else:
        blocks = [text]
    res = []
    for b in blocks:
        r = process(b, n)
        res.append(r)
        if a.show:
            print(sim.fmt(r[4].prog, n), r[4].slots)
    print('SUMMARY %d programs: sim OK %d, encoder SAT %d' % (len(res), sum(r[2] for r in res), sum(r[3] for r in res)))


if __name__ == '__main__':
    main()
