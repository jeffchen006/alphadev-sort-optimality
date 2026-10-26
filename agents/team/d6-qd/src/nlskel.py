#!/usr/bin/env python3
"""d6-qd: non-lattice c=9 value skeletons for d1's dagx ('=' format, 120 perms in lex order).
Sources: (1) programs (QD elites, fam32): their own cmp operand columns; (2) fam32 neighbours: one cmp operand replaced
by a NON-lattice column held by some register just before that cmp (other cmps unchanged).
Keep skeletons with 1..2 non-lattice operand columns; dedupe mod S5 x reversal (cmp pair unordered).
Usage: nlskel.py OUTDIR [--elites F --maxscore S] [--fam F] [--known DIR ...]"""
import sys, os, itertools, argparse
import numpy as np

N = 5
PERMS = list(itertools.permutations(range(N)))
PIDX = {p: i for i, p in enumerate(PERMS)}
PA = np.array(PERMS, dtype=np.int8)                 # 120 x 5
# group actions on columns: col'[p] = col[p o s] (input relabel), rev: col'[p] = 4 - col[4 - p]
SIGMA = []
for s in PERMS:
    SIGMA.append(np.array([PIDX[tuple(p[s[i]] for i in range(N))] for p in PERMS]))
REVI = np.array([PIDX[tuple(4 - x for x in p)] for p in PERMS])


def lattice(col):
    """col: 120 values. True iff col = max_S min_{i in S} x_i for a monotone family (lattice polynomial)."""
    phi = {}
    for k, p in enumerate(PERMS):
        if col[k] not in p:
            return False
        for t in range(1, N + 1):          # threshold t: S = {i: x_i >= t}... use values 0..4 -> t in 1..4 plus 0
            pass
        for t in range(N):
            S = frozenset(i for i in range(N) if p[i] >= t)
            b = col[k] >= t
            if phi.setdefault(S, b) != b:
                return False
    for S, b in phi.items():
        if b:
            for i in range(N):
                T = S | {i}
                if T in phi and not phi[T]:
                    return False
    return True


def run_cols(lines):
    """simulate program on 120 perms; returns list of (cmp operand cols a, b, state-before-cmp dict) or None if garbage"""
    regs = {'P%d' % i: PA[:, i].astype(np.int16) for i in range(N)}
    fl = None
    out = []
    for op, d, s in lines:
        if op == 'cmp':
            if d not in regs or s not in regs or (regs[d] < 0).any() or (regs[s] < 0).any():
                return None
            out.append((regs[d].copy(), regs[s].copy(), {r: v.copy() for r, v in regs.items() if (v >= 0).all()}))
            a, b = regs[d], regs[s]
            fl = np.where(a < b, 1, np.where(a > b, 2, 0))
        elif op == 'mov':
            regs[d] = regs[s].copy() if s in regs else np.full(120, -1, np.int16)
        else:
            src = regs.get(s, np.full(120, -1, np.int16))
            dst = regs.get(d, np.full(120, -1, np.int16))
            c = op[4:]
            mv = np.zeros(120, bool)
            if fl is None:
                return None
            if 'l' in c: mv |= fl == 1
            if 'g' in c: mv |= fl == 2
            if c.endswith('e'): mv |= fl == 0
            regs[d] = np.where(mv, src, dst)
    return out


def canon(pairs):
    best = None
    for rev in (False, True):
        for sg in SIGMA:
            key = []
            for a, b in pairs:
                aa, bb = a[sg], b[sg]
                if rev:
                    aa, bb = 4 - aa[REVI], 4 - bb[REVI]
                x, y = aa.tobytes(), bb.tobytes()
                key.append(min(x, y) + max(x, y))
            key = b''.join(key)
            if best is None or key < best:
                best = key
    return best


def read_progs(fn):
    progs, cur, hdr = [], None, ''
    for line in open(fn):
        if line.startswith('# prog'):
            if cur: progs.append((hdr, cur))
            cur, hdr = [], line.strip(); continue
        line = line.split('#')[0].strip()
        if not line or line.startswith('out'): continue
        op, rest = line.split(None, 1)
        d, s = [x.strip() for x in rest.split(',')]
        cur.append((op, d, s))
    if cur: progs.append((hdr, cur))
    return progs


def fmt(col):
    return '=' + ''.join(str(int(v)) for v in col)


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('outdir')
    ap.add_argument('--elites', nargs='*', default=[])
    ap.add_argument('--maxscore', type=int, default=99)
    ap.add_argument('--fam', default=None)
    ap.add_argument('--known', nargs='*', default=[])
    ap.add_argument('--only', default=None)
    a = ap.parse_args()
    os.makedirs(a.outdir, exist_ok=True)
    seen, nout, stats = set(), 0, {}
    for d in a.known:            # dedupe against existing '=' skeleton files
        for f in os.listdir(d):
            if not f.endswith('.txt'): continue
            pr = []
            ok = True
            for line in open(os.path.join(d, f)):
                if line.startswith('#') or not line.strip(): continue
                x, y = line.split(';')[0].strip().split(':')
                if x[0] != '=' or y[0] != '=': ok = False; break
                pr.append((np.array([int(c) for c in x[1:]], np.int16), np.array([int(c) for c in y[1:]], np.int16)))
            if ok and pr: seen.add(canon(pr))
    print('known', len(seen), file=sys.stderr)
    latc = {}
    def islat(col):
        k = col.tobytes()
        if k not in latc: latc[k] = lattice(list(col))
        return latc[k]
    def emit(pairs, tag, src):
        global nout
        nl = sum((not islat(x)) + (not islat(y)) for x, y in pairs)
        if not 1 <= nl <= 2:
            stats['nl%d' % nl] = stats.get('nl%d' % nl, 0) + 1; return
        k = canon(pairs)
        if k in seen:
            stats['dup'] = stats.get('dup', 0) + 1; return
        seen.add(k)
        with open(os.path.join(a.outdir, '%s.txt' % tag), 'w') as fo:
            fo.write('# d6-qd non-lattice c=%d nl=%d src=%s\n' % (len(pairs), nl, src))
            for x, y in pairs: fo.write('%s:%s\n' % (fmt(x), fmt(y)))
        nout += 1
    for fn in a.elites:
        base = os.path.basename(fn).replace('_archive.txt', '')
        for k, (hdr, lines) in enumerate(read_progs(fn)):
            sc = int(hdr.split('score=')[1].split()[0]) if 'score=' in hdr else 0
            if sc > a.maxscore: continue
            cols = run_cols(lines)
            if cols is None or len(cols) != 9: continue
            emit([(x, y) for x, y, _ in cols], 'el_%s_%d' % (base, k), '%s#%d score=%d' % (fn, k, sc))
    if a.fam:
        for k, (hdr, lines) in enumerate(read_progs(a.fam)):
            tag0 = hdr.split('idx=')[1].strip() if 'idx=' in hdr else str(k)
            if a.only and tag0 != a.only: continue
            cols = run_cols(lines)
            if cols is None: continue
            pairs = [(x, y) for x, y, _ in cols]
            emit(pairs, 'fam_%s' % tag0, a.fam)
            flags = [x < y for x, y, _ in cols]
            for j, (x, y, st) in enumerate(cols):
                cands = {}   # partner selects: operands (u, v) of cmp j2, chosen by the flag of a later cmp j1 < j
                for j1 in range(j):
                    for j2 in range(j1 + 1):
                        u, v = cols[j2][0], cols[j2][1]
                        for c in (np.where(flags[j1], u, v), np.where(flags[j1], v, u)):
                            if not islat(c): cands[c.tobytes()] = c
                for side in (0, 1):
                    for v in cands.values():
                        other = y if side == 0 else x
                        if (v == other).all() or (v == (x if side == 0 else y)).all(): continue
                        np2 = list(pairs)
                        np2[j] = (v, y) if side == 0 else (x, v)
                        emit(np2, 'fn_%s_%d_%d_%d' % (tag0, j, side, nout), '%s cmp%d side%d' % (tag0, j, side))
    print('written', nout, stats, file=sys.stderr)
