"""d5-extend: sort5 programs of length <= K (M_out snap, I1, relaxed model of MODEL.md §2) that contain the DATAFLOW of a
fixed sort4 core: every core instruction appears once, at a step chosen by SAT, in an order that keeps the core's
dataflow (each read sees the core version it read in the core; cmovs between their cmp and the next core cmp);
core value ranges (live ranges, a mov starts a new one) are mapped to registers by SAT; core inputs map to 4 of the 5
inputs (injective); each core cmp may be mirrored (operands swapped, its cmovs l<->g, le<->ge).
This space is closed under the normal-form steps of agents/sat/RULES.md except deletions (dead / flags / snapcmov
may delete a dead core instruction; then a shorter program exists), so all rules r8 + hcmp are used.
Encoder base: agents/sat/encode.py (read-only import). CEGIS: permutations first, then weak-order counterexamples."""
import sys, time, random, argparse, json
sys.path.insert(0, '/path/to/repo/agents/sat')
sys.path.insert(0, '/path/to/repo/agents/team/d5-extend')
from encode import Enc
import sim as satsim
from pysat.solvers import Solver
MIR = {'cmovl': 'cmovg', 'cmovg': 'cmovl', 'cmovle': 'cmovge', 'cmovge': 'cmovle'}
RULES = ('canon', 'pcanon', 'comm', 'dead', 'flags', 'cmpord', 'movfresh', 'snapcmov', 'hcmp')


def core_dataflow(core):
    """core: list of (op, d, s) with names P0..P3, S*. Returns per instruction: op, dst range, src range, and the
    precedence pairs (a, b): a before b."""
    cur = {}       # reg name -> (range id, version)
    ranges = []    # range id -> ('in', i) | ('S0',) | ('w',)
    writer = {}    # (range, version) -> instruction index
    readers = {}   # (range, version) -> list of instruction indices
    def get(x):
        if x not in cur:
            ranges.append(('in', int(x[1:])) if x[0] == 'P' else ('init',))
            cur[x] = (len(ranges) - 1, 0)
        return cur[x]
    info, prec = [], set()
    flagv, cmps, cmovs_of = -1, [], {}
    for c, (o, d, s) in enumerate(core):
        sv = get(s)
        if o == 'mov':
            ranges.append(('w',)); cur[d] = (len(ranges) - 1, 0); dv = cur[d]
            reads = [sv]; writer[dv] = c
        elif o == 'cmp':
            dv = get(d); reads = [dv, sv]
            flagv += 1; cmps.append(c); cmovs_of[flagv] = []
        else:
            dv0 = get(d); reads = [dv0, sv]
            dv = (dv0[0], dv0[1] + 1); cur[d] = dv; writer[dv] = c
            assert flagv >= 0, 'cmov before first cmp in core'
            cmovs_of[flagv].append(c)
        for rv in reads:
            readers.setdefault(rv, []).append(c)
        info.append((o, dv[0], sv[0], flagv if o != 'mov' else None, reads))
    for c, (o, dr, sr, fv, reads) in enumerate(info):
        for rv in reads:
            if rv in writer and writer[rv] != c: prec.add((writer[rv], c))
            nxt = (rv[0], rv[1] + 1)
            if nxt in writer and writer[nxt] != c: prec.add((c, writer[nxt]))
    for f, cm in enumerate(cmps):
        for c in cmovs_of[f]:
            prec.add((cm, c))
            if f + 1 < len(cmps): prec.add((c, cmps[f + 1]))
        if f + 1 < len(cmps): prec.add((cm, cmps[f + 1]))
    return info, ranges, sorted(prec)


class CoreEnc(Enc):
    def __init__(self, core, K, n=5, R=None, rules=RULES, xfixed=None, order=False):
        super().__init__(n, K, R=R, iset='I1', outmode='snap', rules=rules, nop=True)
        self.core = core
        info, ranges, prec = core_dataflow(core)
        self.info, self.ranges, self.prec = info, ranges, prec
        C, R = len(core), self.R
        nw = self.new
        # range -> register map
        self.mp = []
        for rg in ranges:
            if rg[0] == 'in':
                row = [nw() if r < n else False for r in range(R)]
            elif rg[0] == 'init':
                row = [nw() if r >= n else False for r in range(R)]
            else:
                row = [nw() for r in range(R)]
            self.exactly_one([l for l in row if l is not False])
            self.mp.append(row)
        ins = [i for i, rg in enumerate(ranges) if rg[0] == 'in']
        for r in range(n):  # injective input map
            lits = [self.mp[i][r] for i in ins]
            for a in range(len(lits)):
                for b in range(a):
                    self.cl(-lits[a], -lits[b])
        # mirror var per core cmp
        ncmp = sum(1 for x in info if x[0] == 'cmp')
        self.mu = [nw() for f in range(ncmp)]
        # placement
        self.x = [[nw() for i in range(K)] for c in range(C)]
        for c in range(C):
            self.exactly_one(self.x[c])
        for i in range(K):
            lits = [self.x[c][i] for c in range(C)]
            for a in range(C):
                for b in range(a):
                    self.cl(-lits[a], -lits[b])
        # pre[c][i]: c placed at a step < i
        pre = []
        for c in range(C):
            row = [False]
            for i in range(1, K + 1):
                v = nw()
                self.cl(-self.x[c][i - 1], v)
                if row[-1] is not False: self.cl(-row[-1], v)
                self.cl(-v, self.x[c][i - 1], *([row[-1]] if row[-1] is not False else []))
                row.append(v)
            pre.append(row)
        if order:  # core instructions in their given order (use without rule comm)
            prec = sorted(set(prec) | {(c, c + 1) for c in range(C - 1)})
        for a, b in prec:
            for i in range(K):
                self.cl(-self.x[b][i], self.neg(pre[a][i]) if False else pre[a][i]) if pre[a][i] is not False else self.cl(-self.x[b][i])
        # instruction binding
        for c, (o, dr, sr, fv, reads) in enumerate(info):
            for i in range(K):
                xc = self.x[c][i]
                ops = self.op[i]
                if o == 'mov':
                    self.cl(-xc, ops['mov'])
                    pairs = [(dr, self.d[i]), (sr, self.s[i])]
                    for rg, row in pairs:
                        for r in range(R):
                            self.cl(-xc, self.neg(self.mp[rg][r]), row[r])
                elif o == 'cmp':
                    self.cl(-xc, ops['cmp'])
                    m = self.mu[fv]
                    for r in range(R):
                        self.cl(-xc, m, self.neg(self.mp[dr][r]), self.d[i][r])
                        self.cl(-xc, m, self.neg(self.mp[sr][r]), self.s[i][r])
                        self.cl(-xc, -m, self.neg(self.mp[dr][r]), self.s[i][r])
                        self.cl(-xc, -m, self.neg(self.mp[sr][r]), self.d[i][r])
                else:
                    m = self.mu[fv]
                    self.cl(-xc, m, ops[o]); self.cl(-xc, -m, ops[MIR[o]])
                    for r in range(R):
                        self.cl(-xc, self.neg(self.mp[dr][r]), self.d[i][r])
                        self.cl(-xc, self.neg(self.mp[sr][r]), self.s[i][r])
        if xfixed is not None:
            for c, i in enumerate(xfixed): self.cl(self.x[c][i])


def to_names(prog, n):
    return [(o, satsim.reg_name(d, n), satsim.reg_name(s, n)) for o, d, s in prog if o != 'nop']


def run(core, K, R=None, seed=0, log=print, init_types=None, xfixed=None, maxtime=None):
    from ext_sat import sim_full, fmt
    t0 = time.time()
    e = CoreEnc(core, K, R=R, xfixed=xfixed)
    rnd = random.Random(seed)
    n = 5
    allw = satsim.weak_orders(n)
    perms = satsim.total_orders(n)
    init = init_types or rnd.sample(perms, 6)
    for t in init: e.add_type(t)
    s = Solver(name='cadical195'); pushed = 0; it = 0
    while True:
        for c in e.clauses[pushed:]: s.add_clause(c)
        pushed = len(e.clauses); it += 1
        if maxtime:
            import threading
            tm = threading.Timer(max(1.0, maxtime - (time.time() - t0)), s.interrupt); tm.start()
            r = s.solve_limited(expect_interrupt=True); tm.cancel()
            if r is None:
                return 'TIMEOUT', e.types, None, time.time() - t0
        else:
            r = s.solve()
        log('  iter %d types %d vars %d clauses %d -> %s (%.1fs)' % (it, len(e.types), e.nvars, len(e.clauses), 'SAT' if r else 'UNSAT', time.time() - t0))
        if not r:
            return 'UNSAT', e.types, None, time.time() - t0
        prog, outmap = e.decode(s.get_model())
        bad = satsim.check_relaxed(prog, n, 'snap', allw, outmap)
        if not bad:
            p = to_names(prog, n)
            sbad, outs = sim_full(p)
            return ('SAT' if not sbad else 'SAT-relaxed-only'), e.types, fmt(p, outs), time.time() - t0
        badp = [b for b in bad if len(set(b)) == n]
        e.add_type(rnd.choice(badp or bad))
        if maxtime and time.time() - t0 > maxtime:
            return 'TIMEOUT', e.types, None, time.time() - t0


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--key', help='core in canon key form'); ap.add_argument('--from5', help='prog#:keep-list from s5k32')
    ap.add_argument('--K', type=int, default=31); ap.add_argument('--R', type=int, default=None)
    ap.add_argument('--fixpos', action='store_true'); ap.add_argument('--maxtime', type=float, default=None)
    a = ap.parse_args()
    xf = None
    if a.key:
        from d5lib import parse_key
        core = parse_key(a.key)
    else:
        from d5lib import read_progs
        pi, keep = a.from5.split(':'); pi = int(pi); keep = [int(x) for x in keep.split(',')]
        for i, p in enumerate(read_progs('/path/to/repo/agents/upper/runs/r4/s5k32_coll.txt.gz')):
            if i == pi: break
        core = [p[i] for i in keep]
        if a.fixpos: xf = keep
    res = run(core, a.K, R=a.R, xfixed=xf, maxtime=a.maxtime)
    print('RESULT', res[0], 'K=%d' % a.K, 'types=%d' % len(res[1]), 'time=%.1fs' % res[3])
    if res[2]: print(res[2])
