"""List-scheduling compiler: relaxed DAG (trees with sharing) -> real I0 program (latency agent).

Groups the cmovs that read one flag node after one cmp, copies a destroyed operand only when it has
later uses, takes each output snapshot (`out j`) as soon as it is computed, and keeps depth <= the
node deadlines (model U: mov 1, or E: mov 0; cmp latency cl).  Fails (returns None) when a copy
would break a deadline; the caller then tries another DAG.  Every result is checked strict.
"""
import itertools


def nodes_of(trees):
    """unique nodes by structure; returns (sels, flags) dicts with child references"""
    seen = {}
    order = []
    def visit(t):
        if t in seen or t[0] == 'in':
            return
        if t[0] == 'cmp':
            visit(t[1]); visit(t[2])
        else:
            visit(t[1]); visit(t[2]); visit(t[3])
        seen[t] = len(order); order.append(t)
    for t in trees:
        visit(t)
    return order


def compile_dag(trees, Ds, movlat=1, cl=1, i1=False):
    order = nodes_of(trees)
    sels = [t for t in order if t[0] == 'sel']
    flags = [t for t in order if t[0] == 'cmp']
    # canonical flag identity up to orientation: cmp(a,b) with pol and cmp(b,a) with !pol are the same cmp
    def fkey(f):
        return f
    dep = {}
    def depth(t):
        if t[0] == 'in':
            return 0
        if t not in dep:
            if t[0] == 'cmp':
                dep[t] = cl + max(depth(t[1]), depth(t[2]))
            else:
                dep[t] = 1 + max(depth(t[1]), depth(t[2]), depth(t[3]))
        return dep[t]
    # deadlines (ALAP)
    dl = {}
    def setdl(t, d):
        if t[0] == 'in':
            return
        if t in dl and dl[t] <= d:
            return
        dl[t] = d
        if t[0] == 'cmp':
            setdl(t[1], d - cl); setdl(t[2], d - cl)
        else:
            setdl(t[1], d - 1); setdl(t[2], d - 1); setdl(t[3], d - 1)
    for t, D in zip(trees, Ds):
        setdl(t, D)
    for t in order:
        if depth(t) > dl[t]:
            return None
    # uses: destroy-uses (as a), read-uses (as b, as cmp operand per flag node, as output)
    uses = {}
    def addu(t, k=1):
        uses[t] = uses.get(t, 0) + k
    flag_sels = {f: [] for f in flags}
    for v in sels:
        f, a, b = v[1], v[2], v[3]
        addu(a); addu(b); flag_sels[f].append(v)
    for f in flags:
        addu(f[1]); addu(f[2])
    outs_of = {}
    for j, t in enumerate(trees):
        addu(t); outs_of.setdefault(t, []).append(j)
    for t in list(uses):
        if t[0] == 'in':
            uses[t] += 10 ** 6       # inputs are never destroyed (cheap copies; needed for recomputation)
    n = 1 + max(c for t in order for c in [x[1] for x in (t[1:] if t[0] == 'cmp' else t[2:4]) if x[0] == 'in'] + [0])
    prog = []
    holders = {}          # node -> list of [reg, depth]
    ns = [0]
    def fresh():
        ns[0] += 1; return 'S%d' % (ns[0] - 1)
    def holder(t):
        if t[0] == 'in':
            return ('P%d' % t[1], 0) if ('in', t[1]) not in destroyed else best(t)
        return best(t)
    def best(t):
        hs = holders.get(t, [])
        return min(hs, key=lambda h: h[1]) if hs else None
    destroyed = set()
    for i in range(n):
        holders[('in', i)] = [['P%d' % i, 0]]
    done = set()
    curf = None
    fdepth = 0
    def use_done(t):
        uses[t] -= 1
        if uses[t] == 0 and t in holders:
            pass
    remaining_f = {f: len(flag_sels[f]) for f in flags}
    while len(done) < len(sels):
        ready = [v for v in sels if v not in done and v[2] in holders and v[3] in holders
                 and v[1][1] in holders and v[1][2] in holders]
        if not ready:
            return None
        groups = {}
        for v in ready:
            groups.setdefault(v[1], []).append(v)
        if curf in groups:
            f = curf
        else:
            f = min(groups, key=lambda g: min(dl[v] for v in groups[g]))
            ha, hb = best(f[1]), best(f[2])
            prog.append(('cmp', ha[0], hb[0]))
            fdepth = max(ha[1], hb[1]) + cl
            curf = f
        grp = sorted(groups[f], key=lambda v: dl[v])
        def later_ok(a, v, depth_):
            for w in sels:
                if w not in done and w is not v and a in (w[2], w[3]) and depth_ > dl[w] - 1:
                    return False
            for g in flags:
                if remaining_f[g] > 0 and a in (g[1], g[2]) and depth_ > dl[g] - cl:
                    if not (g is f and remaining_f[g] == 1):
                        return False
            return True
        while grp:
            pick = None
            for allow_conflict in (False, True):
                for v in grp:
                    if not allow_conflict and any(w is not v and w[3] == v[2] for w in grp):
                        continue
                    pick = v; break
                if pick:
                    break
            v = pick
            a, b = v[2], v[3]
            pol = len(v) > 4 and v[4]
            op = 'cmovg' if pol else 'cmovl'
            if i1:
                # I1: destroy either operand (cmovle/cmovge with a, b swapped); prefer one without a copy
                opts = []
                for w in grp:
                    for sw in (False, True):
                        x = w[3] if sw else w[2]
                        opts.append((uses[x] > 1, dl[w], sw, w))
                opts.sort(key=lambda o: (o[0], o[1], o[2]))
                _, _, sw, v = opts[0]
                pol = len(v) > 4 and v[4]
                a, b = (v[3], v[2]) if sw else (v[2], v[3])
                op = ('cmovle' if pol else 'cmovge') if sw else ('cmovg' if pol else 'cmovl')
            hb = best(b)
            hs = holders[a]
            if uses[a] > 1:
                if len(hs) == 1:
                    h = hs[0]
                    c = fresh(); prog.append(('mov', c, h[0]))
                    hs.append([c, h[1] + movlat])
                # choose the holder to destroy: keep a holder that later uses can live with
                cands = sorted(hs, key=lambda h: -h[1])
                hd = None
                for h in cands:
                    rest = [x for x in hs if x is not h]
                    if max(h[1], hb[1], fdepth) + 1 <= dl[v] and later_ok(a, v, min(x[1] for x in rest)):
                        hd = h; break
                if hd is None:
                    # recompute a fresh instance of a (tree unrolling), then re-issue the cmp of f
                    def anyh(t, need):
                        hs2 = [h for h in holders.get(t, []) if h[1] <= need]
                        return min(hs2, key=lambda h: h[1]) if hs2 else None
                    def own_tree(t):
                        if t[0] == 'in':
                            c = fresh(); prog.append(('mov', c, 'P%d' % t[1])); return [c, movlat]
                        tf, ta, tb = t[1], t[2], t[3]
                        ra = own_tree(ta)
                        rb = anyh(tb, depth(tb)) or own_tree(tb)
                        fa = anyh(tf[1], depth(tf[1])) or own_tree(tf[1])
                        fb = anyh(tf[2], depth(tf[2])) or own_tree(tf[2])
                        prog.append(('cmp', fa[0], fb[0]))
                        prog.append(('cmovg' if len(t) > 4 and t[4] else 'cmovl', ra[0], rb[0]))
                        return [ra[0], max(ra[1], rb[1], max(fa[1], fb[1]) + cl) + 1]
                    hd = own_tree(a)
                    hs.append(hd)
                    ha_, hb_ = best(f[1]), best(f[2])
                    prog.append(('cmp', ha_[0], hb_[0]))
                    fdepth = max(ha_[1], hb_[1]) + cl
                    if max(hd[1], hb[1], fdepth) + 1 > dl[v]:
                        return None
            else:
                hd = min(hs, key=lambda h: h[1])
            nd = max(hd[1], hb[1], fdepth) + 1
            if nd > dl[v]:
                return None
            hs.remove(hd)
            if not hs:
                del holders[a]
            prog.append((op, hd[0], hb[0]))
            holders.setdefault(v, []).append([hd[0], nd])
            uses[a] -= 1; uses[b] -= 1
            done.add(v); grp.remove(v)
            remaining_f[f] -= 1
            if remaining_f[f] == 0:
                uses[f[1]] -= 1; uses[f[2]] -= 1
            for j in outs_of.get(v, []):
                prog.append(('store', j, hd[0])); uses[v] -= 1
    return prog, n, ns[0]
