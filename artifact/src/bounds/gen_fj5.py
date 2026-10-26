#!/usr/bin/env python3
"""Build a sort5 program in I0 with only 7 cmp (merge insertion / Ford-Johnson),
to show that #cmp >= 9 (comparator-network size) is NOT a valid bound for cmp/cmov programs.
Values live in SSA registers; sel(flag,a,b) = 'mov z,b ; cmovl z,a' (or alias when a==b).
"""
import sys

prog = []
nfresh = [0]


def fresh():
    nfresh[0] += 1
    return f'S{nfresh[0] - 1}'


def cmp(a, b):
    prog.append(('cmp', a, b))


def sel(a, b):
    """value = a if lt else b (lt of the latest cmp)."""
    if a == b:
        return a
    z = fresh()
    prog.append(('mov', z, b))
    prog.append(('cmovl', z, a))
    return z


a, b, c, d, e = 'P0', 'P1', 'P2', 'P3', 'P4'
cmp(a, b); A0, A1 = sel(a, b), sel(b, a)
cmp(c, d); B0, B1 = sel(c, d), sel(d, c)
cmp(A1, B1)
C0, C1, C2, C3 = sel(A0, B0), sel(A1, B1), sel(B0, A0), sel(B1, A1)
cmp(e, C1)
V = sel(C0, C3)
Ach = [sel(x, y) for x, y in zip((e, C0, C1, C3), (C0, C1, e, C3))]
Bch = [sel(x, y) for x, y in zip((C0, e, C1, C3), (C0, C1, C3, e))]
cmp(e, V)
Z = [sel(x, y) for x, y in zip(Ach, Bch)]
cmp(C2, Z[1])
W = sel(Z[0], Z[2])
F = [sel(x, y) for x, y in zip((C2, Z[0], Z[1], Z[2], Z[3]), (Z[0], Z[1], C2, Z[2], Z[3]))]
G = [sel(x, y) for x, y in zip((Z[0], C2, Z[1], Z[2], Z[3]), (Z[0], Z[1], Z[2], C2, Z[3]))]
cmp(C2, W)
OUT = [sel(x, y) for x, y in zip(F, G)]
# final placement: P_k := OUT[k]; inputs P0..P4 may still be read by OUT -> copy via temps
tmp = {}
for k, v in enumerate(OUT):
    if v.startswith('P') and v != f'P{k}':
        t = fresh(); prog.append(('mov', t, v)); tmp[v] = t
for k, v in enumerate(OUT):
    if v != f'P{k}':
        prog.append(('mov', f'P{k}', tmp.get(v, v)))
print('# n=5 iset=I0 source=bounds/gen_fj5.py (merge insertion, 7 cmp; not length-optimized)')
for op, x, y in prog:
    print(f'{op} {x}, {y}')
