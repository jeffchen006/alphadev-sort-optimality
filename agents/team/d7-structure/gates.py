#!/usr/bin/env python3
# d7: gate-DAG view of k=32 optima. Each new lattice term = gate min/max(a,b) of the operands' intended terms
# (a T-partial / N cmov = conditional copy: intended term = its source). Flags: own (cmp pair == gate pair) or borrowed.
# usage: gates.py ana.txt N [show]
import sys, gzip, collections as C
from show import progs, COLL
X = [sum(1 << S for S in range(32) if S >> i & 1) for i in range(5)]
FULL = (1 << 32) - 1
def col2int(col):
    return None if col is None or any(v is None for v in col) else sum(1 << S for S in range(32) if col[S])
def tname(t):
    fam = [S for S in range(1, 32) if t >> S & 1]
    mins = [S for S in fam if not any(U != S and (U & S) == U for U in fam)]
    return '|'.join(''.join(str(i) for i in range(5) if S >> i & 1) for S in sorted(mins, key=lambda S: (bin(S).count('1'), S)))
def analyse(prog, tags):
    regs = {('P%d' % i): X[i] for i in range(5)}  # intended terms (None = garbage)
    col = {('P%d' % i): [(S >> i) & 1 for S in range(32)] for i in range(5)}
    flags = [None] * 32; cmpp = None; ti = 0
    gates = []; copies = []; uses = C.Counter(); dest_uses = C.Counter(); terms = {X[i]: 'in' for i in range(5)}
    events = []
    for pos, ins in enumerate(prog):
        o, a = ins.split(None, 1); a = [x.strip() for x in a.split(',')]
        if o == 'out': events.append(('out', int(a[0]), regs.get(a[1]))); continue
        d, s = a
        D = col.get(d, [None] * 32); Sv = col.get(s, [None] * 32)
        if o == 'mov':
            col[d] = list(Sv); copies.append(('mov', regs.get(s), pos)); regs[d] = regs.get(s)
            events.append(('mov', regs.get(s))); continue
        if o == 'cmp':
            flags = [None if D[k] is None or Sv[k] is None else (D[k] > Sv[k]) - (D[k] < Sv[k]) for k in range(32)]
            cmpp = (regs.get(d), regs.get(s)); uses[regs.get(d)] += 1; uses[regs.get(s)] += 1
            events.append(('cmp', cmpp)); continue
        cond = {'cmovl': (-1,), 'cmovle': (-1, 0), 'cmovg': (1,), 'cmovge': (1, 0)}[o]
        nv = [(D[k] if D[k] == Sv[k] else None) if flags[k] is None else (Sv[k] if flags[k] in cond else D[k]) for k in range(32)]
        col[d] = nv
        tg = tags[ti]; ti += 1
        if tg in 'TN':
            copies.append(('c' + tg, regs.get(s), pos)); regs[d] = regs.get(s); events.append(('ccopy', regs.get(s))); continue
        r = col2int(nv)
        ta, tb = regs.get(d), regs.get(s)
        op = None
        if ta is not None and tb is not None:
            if r == ta & tb: op = 'min'
            elif r == ta | tb: op = 'max'
        if tg in 'aAp': copies.append(('re', r, pos))
        else:
            own = cmpp is not None and set(cmpp) == {ta, tb}
            gates.append((op, ta, tb, r, cmpp, own, pos))
            uses[ta] += 1; uses[tb] += 1; dest_uses[ta] += 1; terms[r] = 'g'
        regs[d] = r; events.append(('gate', r))
    return gates, copies, uses, dest_uses, events
if __name__ == '__main__':
    fa = sys.argv[1]; N = int(sys.argv[2]); show = len(sys.argv) > 3
    st = C.Counter(); fh = C.Counter(); bor = C.Counter(); cop = C.Counter(); fan = C.Counter(); bpat = C.Counter()
    tagsl = []
    import os; DUMP = os.environ.get('DUMP') == '1'
    M = int(sys.argv[4]) if len(sys.argv) > 4 else 1; R = int(sys.argv[5]) if len(sys.argv) > 5 else 0
    for i, line in enumerate(open(fa)):
        if i >= N: break
        tagsl.append(line.split()[15])
    for i, p in enumerate(progs(COLL)):
        if i >= N: break
        if i % M != R: continue
        gates, copies, uses, du, ev = analyse(p, tagsl[i])
        st['gates=%d' % len(gates)] += 1
        st['nonlocal gates=%d' % sum(1 for g in gates if g[0] is None)] += 1
        pairs = C.Counter(frozenset((g[1], g[2])) for g in gates if g[0])
        F = sum(1 for v in pairs.values() if v >= 2); H = sum(1 for v in pairs.values() if v == 1)
        fh[(F, H)] += 1
        nb = sum(1 for g in gates if g[0] and not g[5]); bor[nb] += 1
        for g in gates:
            if g[0] and not g[5]: st['borrowed gate in %s comparator' % ('full' if pairs[frozenset((g[1], g[2]))] >= 2 else 'half')] += 1
        # canonical-ish signature of virtual network: sizes of halves by op
        st['half ops min/max=%d/%d' % (sum(1 for g in gates if pairs[frozenset((g[1],g[2]))]==1 and g[0]=='min'), sum(1 for g in gates if pairs[frozenset((g[1],g[2]))]==1 and g[0]=='max'))] += 1
        cop[''.join(sorted(c[0][0] + (c[0][1] if len(c[0]) > 1 else '') for c in copies))] += 1
        # copied terms: input or gate?
        for c in copies: st['copy of ' + ('input' if c[1] in X else 'gate' if c[1] is not None else 'None')] += 1
        # borrowed pattern: gate pair (a,b) vs cmp pair (p,q): relation
        for g in gates:
            if g[0] and not g[5] and g[4]:
                pq = g[4]; a, b = g[1], g[2]
                sh = len({a, b} & set(pq))
                bpat['share %d operand(s)' % sh] += 1
        if DUMP:
            print('G', i, ' '.join('%s:%x:%x:%x:%x:%d' % (g[0], g[1], g[2], g[4][0], g[4][1], g[5]) for g in gates), '|', ' '.join('%s:%x' % (c[0], c[1] or 0) for c in copies))
            continue
        if show and i < 3:
            print('--- prog', i)
            for g in gates: print('  %s(%s, %s) = %s  flag cmp(%s, %s) %s' % (g[0], tname(g[1]) if g[1] else '?', tname(g[2]) if g[2] else '?', tname(g[3]), tname(g[4][0]), tname(g[4][1]), 'own' if g[5] else 'BORROWED'))
            for c in copies: print('  copy', c[0], tname(c[1]) if c[1] else '?', '@', c[2])
    print(st.most_common()); print('(full,half) virtual comparators', fh.most_common(10)); print('borrowed-flag gates per prog', sorted(bor.items()))
    print('borrowed patterns', bpat.most_common()); print('copy kinds', cop.most_common(12))
