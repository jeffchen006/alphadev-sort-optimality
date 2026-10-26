#!/usr/bin/env python3
"""d1-skeleton: exact gate-DAG routing search for a fixed VALUE skeleton (sort5, M_out, I1, perms).

Program = c cmps (fixed operand columns) + gates (cmov) + copies (mov). Cost = c + #gates + #copies.
Search: backward from needed columns (cmp operands, deadline = block before the cmp; outputs, any block).
A requirement = partial column P (values on a subset of types) + deadline block. Resolve by
 (a) link to a finished node X (block <= deadline, X matches P), or
 (b) a new gate in block j <= deadline with cond: S must match P on cond-true types, D on cond-false types.
DFS creation order => every real DAG is reached (links only to finished nodes; acyclic).
Leaf: exact max number of in-place gates (copies = gates - in-place) by branch and bound over a
precedence model (destroyer of X after all other uses of X; cmp operands alive at their cmp).
usage: dag.py SKELFILE K [maxsol]
"""
import sys, itertools, time
sys.path.insert(0, __import__('os').path.dirname(__file__))
from rsat import ev_formula, perms, flag

TY = perms()
NT = len(TY)
CONDS = {'cmovl': lambda f: f == 'l', 'cmovg': lambda f: f == 'g', 'cmovle': lambda f: f != 'g', 'cmovge': lambda f: f != 'l'}


def load(fn):
    sk = [l.strip().split(':') for l in open(fn) if l.strip() and l[0] != '#']
    return sk


class Search:
    def __init__(self, sk, K, maxsol=1, log=print):
        self.sk, self.K, self.c = sk, K, len(sk)
        self.log = log
        col = lambda f: tuple(ev_formula(f, t) for t in TY)
        self.opc = [(col(a), col(b)) for a, b in sk]
        self.F = [None] + [tuple(flag(x, y) for x, y in zip(a, b)) for a, b in self.opc]
        self.tg = [tuple(sorted(t)[k] for t in TY) for k in range(5)]
        # truth sets per (block, cond)
        self.tset = {}
        for j in range(1, self.c + 1):
            hasEq = 'e' in self.F[j]
            for cn, cf in CONDS.items():
                if not hasEq and cn in ('cmovle', 'cmovge'):
                    continue
                self.tset[(j, cn)] = tuple(cf(f) for f in self.F[j])
        # flag-history classes per block: a column created in block j holds x_idx with idx a function of the class
        self.cls = []
        for j in range(self.c + 1):
            ids = {}
            self.cls.append([ids.setdefault(tuple(self.F[i][t] for i in range(1, j + 1)), len(ids)) for t in range(NT)])
        self.ncls = [max(c) + 1 for c in self.cls]
        self.idxsets = [[frozenset(i for i in range(5) if TY[t][i] == v) for v in range(5)] for t in range(NT)]
        # nodes: [col, blk, kind, D, S, cond]; inputs first
        self.nodes = [[tuple(t[i] for t in TY), 0, 'in', None, None, None] for i in range(5)]
        self.fin = [True] * 5
        self.cmpuse = {}  # j -> (nodeA, nodeB)
        self.outuse = {}
        self.best = None
        self.nsol = 0
        self.maxsol = maxsol
        self.leaves = 0
        self.calls = 0
        self.budget = K - self.c  # gates + copies
        # needed requirements: full columns
        reqs = []
        for j in range(1, self.c + 1):
            reqs.append((self.opc[j - 1][0], j - 1, ('cmp', j, 0)))
            reqs.append((self.opc[j - 1][1], j - 1, ('cmp', j, 1)))
        for k in range(5):
            reqs.append((self.tg[k], self.c, ('out', k)))
        reqs.sort(key=lambda r: -r[1])  # stack: last = earliest deadline
        self.init = [('req',) + r for r in reqs]

    @staticmethod
    def match(col, P):
        return all(p is None or p == v for p, v in zip(P, col))

    def consistent(self, P, j):
        cl = self.cls[j]
        acc = {}
        for t, p in enumerate(P):
            if p is None:
                continue
            k = cl[t]
            s = self.idxsets[t][p]
            if k in acc:
                s = acc[k] & s
                if not s:
                    return False
            acc[k] = s
        return True

    def lb(self, stack):
        """#pairwise-incompatible open requirements with no matching finished node (each needs its own gate)."""
        fin = [n for i, n in enumerate(self.nodes) if self.fin[i]]
        open_ = []
        seen = set()
        for it in stack:
            if it[0] != 'req' or it[1] in seen:
                continue
            seen.add(it[1])
            P, dl = it[1], it[2]
            if any(n[1] <= dl and self.match(n[0], P) for n in fin):
                continue
            open_.append(P)
        open_.sort(key=lambda P: -sum(p is not None for p in P))
        picked = []
        for P in open_:
            if all(any(a is not None and b is not None and a != b for a, b in zip(P, Q)) for Q in picked):
                picked.append(P)
        return len(picked)

    def copies_lb(self):
        """each node X: D-users can be in place at most once, and only a D-user g with every other use of X
        no later than g (gates: block <= blk(g); cmps: j <= blk(g)). Monotone in the DAG."""
        users = {}
        for g in range(5, len(self.nodes)):
            nd = self.nodes[g]
            for w, x in (('D', nd[3]), ('S', nd[4])):
                if x is not None:
                    users.setdefault(x, []).append((w, g, nd[1]))
        for j, ab in self.cmpuse.items():
            for x in ab:
                if x is not None:
                    users.setdefault(x, []).append(('C', j, j))
        lb = 0
        for x, us in users.items():
            ds = [u for u in us if u[0] == 'D']
            if not ds:
                continue
            mx = max(u[2] for u in us if u[0] != 'C') if any(u[0] != 'C' for u in us) else 0
            mc = max((u[2] for u in us if u[0] == 'C'), default=0)
            ok = any(u[2] >= mx and u[2] >= mc for u in ds)
            lb += len(ds) - (1 if ok else 0)
        return lb

    def ngates(self):
        return len(self.nodes) - 5

    def run(self):
        t0 = time.time()
        self.t0 = t0
        self.rec(list(self.init))
        return self.best

    def setslot(self, slot, x):
        if slot[0] == 'cmp':
            u = list(self.cmpuse.get(slot[1], (None, None)))
            u[slot[2]] = x
            self.cmpuse[slot[1]] = tuple(u)
        elif slot[0] == 'out':
            self.outuse[slot[1]] = x
        else:
            g, w = slot
            self.nodes[g][3 if w == 'D' else 4] = x

    def rec(self, stack):
        self.calls += 1
        if self.nsol >= self.maxsol:
            return
        if not stack:
            self.leaf()
            return
        it = stack[-1]
        rest = stack[:-1]
        if it[0] == 'fin':
            g = it[1]
            nd = self.nodes[g]
            ts = self.tset[(nd[1], nd[5])]
            Dc, Sc = self.nodes[nd[3]][0], self.nodes[nd[4]][0]
            nd[0] = tuple(s if t else d for t, s, d in zip(ts, Sc, Dc))
            # a gate that changes nothing is useless
            if nd[0] == Dc or nd[0] == Sc:
                return
            self.fin[g] = True
            self.rec(rest)
            self.fin[g] = False
            return
        _, P, dl, slot = it
        if self.ngates() + self.lb(stack) + self.copies_lb() > self.budget:
            return
        G = [g for g in range(5, len(self.nodes)) if self.nodes[g][3] is not None and self.nodes[g][4] is not None]
        mi = self.max_inplace(G, 0)
        if mi is None or self.ngates() + self.lb(stack) + len(G) - len(mi[0]) > self.budget:
            return
        # (a) link
        for x in range(len(self.nodes)):
            if self.fin[x] and self.nodes[x][1] <= dl and self.match(self.nodes[x][0], P):
                self.setslot(slot, x)
                self.rec(rest)
                self.setslot(slot, None)
                if self.nsol >= self.maxsol:
                    return
        # (b) new gate
        if self.ngates() + 1 + self.lb(rest) + self.copies_lb() > self.budget:
            return
        g = len(self.nodes)
        for j in range(dl, 0, -1):
            for cn in CONDS:
                ts = self.tset.get((j, cn))
                if ts is None:
                    continue
                PS = tuple(p if t else None for p, t in zip(P, ts))
                PD = tuple(None if t else p for p, t in zip(P, ts))
                if all(p is None for p in PS) or all(p is None for p in PD):
                    continue
                if not self.consistent(P, j):
                    break
                self.nodes.append([None, j, 'gate', None, None, cn])
                self.fin.append(False)
                self.setslot(slot, g)
                self.rec(rest + [('fin', g), ('req', PD, j, (g, 'D')), ('req', PS, j, (g, 'S'))])
                self.setslot(slot, None)
                self.nodes.pop()
                self.fin.pop()
                if self.nsol >= self.maxsol:
                    return

    def leaf(self):
        self.leaves += 1
        G = list(range(5, len(self.nodes)))
        ng = len(G)
        need_inplace = ng - (self.budget - ng)  # copies = ng - inplace <= budget - ng
        if need_inplace > ng:
            return
        best = self.max_inplace(G, need_inplace)
        if best is None:
            return
        inpl, order = best
        cost = self.c + ng + (ng - len(inpl))
        if cost <= self.K:
            self.nsol += 1
            prog = self.emit(inpl, order)
            self.log('SOLUTION cost=%d gates=%d copies=%d (leaves=%d calls=%d %.0fs)' % (cost, ng, ng - len(inpl), self.leaves, self.calls, time.time() - self.t0))
            self.log('\n'.join(prog))
            if self.best is None or cost < self.best[0]:
                self.best = (cost, prog)

    def uses(self):
        """for each node: list of (kind, who): ('g', gate) for gate uses as D or S, ('c', j) for cmp uses."""
        U = {x: [] for x in range(len(self.nodes))}
        for g in range(5, len(self.nodes)):
            if self.nodes[g][3] is not None:
                U[self.nodes[g][3]].append(('g', g, 'D'))
            if self.nodes[g][4] is not None:
                U[self.nodes[g][4]].append(('g', g, 'S'))
        for j, ab in self.cmpuse.items():
            for x in ab:
                if x is not None:
                    U[x].append(('c', j))
        return U

    def max_inplace(self, G, need):
        U = self.uses()
        blk = lambda x: self.nodes[x][1]
        # candidate destroyer for node X: gate g with D(g)=X, valid if all other uses of X can precede g
        cand = {}
        for g in G:
            X = self.nodes[g][3]
            ok = True
            for u in U[X]:
                if u[0] == 'c':
                    if u[1] > blk(g):
                        ok = False
                elif u[1] != g and blk(u[1]) > blk(g):
                    ok = False
            if ok:
                cand[g] = X
        cands = sorted(cand)
        Gs = set(G)
        best = [None]

        def feasible(chosen):
            # precedence edges within blocks: creation edges + destroy edges; check acyclic, return order
            succ = {g: set() for g in G}
            indeg = {g: 0 for g in G}
            def add(a, b):
                if b not in succ[a]:
                    succ[a].add(b)
                    indeg[b] += 1
            for g in G:
                for x in (self.nodes[g][3], self.nodes[g][4]):
                    if x in Gs:
                        add(x, g)
            for g in chosen:
                X = cand[g]
                for u in U[X]:
                    if u[0] == 'g' and u[1] != g and u[1] in Gs:
                        add(u[1], g)
            # topological sort by (block, ...)
            order = []
            ready = sorted([g for g in G if indeg[g] == 0], key=lambda g: blk(g))
            import heapq
            h = [(blk(g), g) for g in G if indeg[g] == 0]
            heapq.heapify(h)
            while h:
                b, g = heapq.heappop(h)
                order.append(g)
                for s in succ[g]:
                    indeg[s] -= 1
                    if indeg[s] == 0:
                        heapq.heappush(h, (blk(s), s))
            if len(order) < len(G):
                return None
            # block monotone check (edges never go to a lower block by construction)
            for i in range(1, len(order)):
                if blk(order[i]) < blk(order[i - 1]):
                    return None
            return order

        # branch: each candidate in/out; at most one destroyer per X
        def br(i, chosen, usedX):
            if best[0] is not None and len(best[0][0]) >= len(chosen) + (len(cands) - i):
                return
            if len(chosen) + (len(cands) - i) < need:
                return
            if i == len(cands):
                o = feasible(chosen)
                if o is not None:
                    best[0] = (list(chosen), o)
                return
            g = cands[i]
            if cand[g] not in usedX:
                chosen.append(g)
                usedX.add(cand[g])
                if feasible(chosen) is not None:
                    br(i + 1, chosen, usedX)
                chosen.pop()
                usedX.discard(cand[g])
            br(i + 1, chosen, usedX)
        br(0, [], set())
        if best[0] is None or len(best[0][0]) < need:
            return None
        return best[0]

    def emit(self, inpl, order):
        """register program (M_out text) from the DAG and schedule."""
        inpl = set(inpl)
        reg = {i: 'P%d' % i for i in range(5)}
        nsc = [0]
        def fresh():
            nsc[0] += 1
            return 'S%d' % (nsc[0] - 1)
        out = []
        pos = 0
        done = set()
        for j in range(1, self.c + 1):
            a, b = self.cmpuse[j]
            out.append('cmp %s, %s' % (reg[a], reg[b]))
            while pos < len(order) and self.nodes[order[pos]][1] == j:
                g = order[pos]
                pos += 1
                _, _, _, D, S, cn = self.nodes[g]
                if g in inpl:
                    r = reg[D]
                else:
                    r = fresh()
                    out.append('mov %s, %s' % (r, reg[D]))
                out.append('%s %s, %s' % (cn, r, reg[S]))
                reg[g] = r
                for k in range(5):
                    if k not in done and self.nodes[g][0] == self.tg[k]:
                        done.add(k)
                        out.append('out %d, %s' % (k, r))
        return out


if __name__ == '__main__':
    sk = load(sys.argv[1])
    K = int(sys.argv[2])
    ms = int(sys.argv[3]) if len(sys.argv) > 3 else 1
    s = Search(sk, K, ms, log=lambda x: print(x, flush=True))
    t0 = time.time()
    s.run()
    print('RESULT %s K=%d calls=%d leaves=%d sols=%d %.1fs' % ('FOUND' if s.nsol else 'NONE', K, s.calls, s.leaves, s.nsol, time.time() - t0))
