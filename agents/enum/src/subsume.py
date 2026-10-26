#!/usr/bin/env python3
"""Measure Lemma-M dominance in a format-v1 certificate (enum agent).
A state B is dominated if some other kept state A has: same flags, A.cols ⊇ B.cols, done_A ⊇ done_B,
gamma_A >= gamma_B, g_A <= g_B. (Only the stored image is compared, no S_n images: a lower estimate.)
usage: python3 subsume.py FILE.cert
"""
import sys, collections

def main():
    mode = None; st = []
    for line in open(sys.argv[1]):
        t = line.split()
        if t[0] in ('cert', 'W', 'END'):
            continue
        if t[0] in ('C', 'S'):
            mode = t[0]; continue
        if mode == 'S':
            st.append((int(t[0]), t[1], int(t[2]), int(t[3]), frozenset(int(x) for x in t[4:])))
    idx = collections.defaultdict(list)            # (flags, column) -> states that hold the column
    for i, (g, fl, dn, ga, cs) in enumerate(st):
        for c in cs:
            idx[(fl, c)].append(i)
    dom = 0; byg = collections.Counter(); tot = collections.Counter()
    for i, (g, fl, dn, ga, cs) in enumerate(st):
        tot[g] += 1
        best = min((idx[(fl, c)] for c in cs), key=len)
        for j in best:
            if j == i:
                continue
            g2, fl2, dn2, ga2, cs2 = st[j]
            if g2 <= g and (dn2 & dn) == dn and ga2 >= ga and cs <= cs2:
                dom += 1; byg[g] += 1; break
    print('states', len(st), 'dominated', dom, '%.2f%%' % (100.0 * dom / len(st)))
    print('by g (dominated, total):', {g: (byg[g], tot[g]) for g in sorted(tot)})

if __name__ == '__main__':
    main()
