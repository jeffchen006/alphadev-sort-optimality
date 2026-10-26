#!/usr/bin/env python3
"""Exact breadth-first search for the shortest kernel in the memory models (MODEL.md §4.2 MM, §4.5 MM+).

  python3 agents/spec/tools/mm_bfs.py N LMAX {mem|memplus} [I0|I1]

T-relaxed semantics (MODEL §2): every register starts as T (> all inputs, cmp(T,T) = eq), flags start eq, all weak
orders of N inputs. Lower bounds from this search are sound for the strict model (Lemma L2).
State = (cells, multiset of non-T register vectors, flags vector). Exact abstraction:
- register names do not matter (renaming), so registers are a multiset; all-T registers are an unbounded implicit supply;
- an unconditional write (load, mov) goes to a fresh register: overwriting a register only removes a value, and a
  state with a super-multiset of register values can run every program of the smaller state (ignore the extra
  register), so fresh writes dominate overwrites;
- cmovX D, S: D any existing register (in place) or a fresh T register; S any register or (memplus) a cell.
- cmp A, B: registers (incl. T) and, in memplus, at most one cell. Cells change only by stores.
Goal: cells = sorted inputs on every weak order. Prints the first length with a solution and one program.
"""
import sys
from itertools import combinations

sys.path.insert(0, __file__.rsplit('/agents/', 1)[0] + '/shared')
import judge  # noqa: E402


def main(n, lmax, model, iset):
    orders = judge.weak_orders(n)
    T = n
    m = len(orders)
    cells0 = tuple(tuple(v[i] for v in orders) for i in range(n))
    goal = tuple(tuple(sorted(v)[j] for v in orders) for j in range(n))
    tvec = tuple([T] * m)
    eq = tuple([(1, 0)] * m)
    ops = ['cmovl', 'cmovg'] + (['cmovle', 'cmovge'] if iset == 'I1' else [])
    start = (cells0, (), eq)
    seen = {start: None}
    frontier = [start]
    for L in range(1, lmax + 1):
        nxt = []
        for st in frontier:
            cells, regs, fl = st
            rl = list(regs)
            srcs = rl + [tvec]                                     # register sources (T = fresh register)
            succ = []
            for i in range(n):                                     # load
                succ.append(((cells, tuple(sorted(rl + [cells[i]])), fl), 'load r<-m%d' % i))
            for a in range(len(rl)):                               # store
                for j in range(n):
                    c = list(cells); c[j] = rl[a]
                    succ.append(((tuple(c), regs, fl), 'store m%d<-r%d' % (j, a)))
                succ.append(((cells, tuple(sorted(rl + [rl[a]])), fl), 'mov r,r%d' % a))
            operands = [('r', x) for x in srcs]
            if model == 'memplus':
                operands += [('m', c) for c in cells]
            for (ka, a), (kb, b) in combinations(operands, 2):     # cmp (order free: all cmovs swap with it)
                if ka == 'm' and kb == 'm':
                    continue
                f = tuple((int(x == y), int(x < y)) for x, y in zip(a, b))
                succ.append(((cells, regs, f), 'cmp'))
            msrc = srcs + (list(cells) if model == 'memplus' else [])
            for op in ops:
                c = [judge.cond(op, f) for f in fl]
                for s in msrc:
                    for d in range(len(rl) + 1):                    # in place on rl[d], or fresh T register
                        dv = rl[d] if d < len(rl) else tvec
                        nv = tuple(y if cc else x for x, y, cc in zip(dv, s, c))
                        if nv == dv:
                            continue
                        r2 = rl[:d] + rl[d + 1:] if d < len(rl) else list(rl)
                        succ.append(((cells, tuple(sorted(r2 + [nv])), fl), op))
            for s2, lab in succ:
                if s2 not in seen:
                    seen[s2] = (st, lab)
                    if s2[0] == goal:
                        path = []
                        x = s2
                        while seen[x]:
                            x, l2 = seen[x]
                            path.append(l2)
                        print('n=%d model=%s iset=%s: FOUND L=%d (states %d): %s' % (
                            n, model, iset, L, len(seen), '; '.join(reversed(path))))
                        return L
                    nxt.append(s2)
        print('n=%d model=%s iset=%s: none with L=%d (states %d)' % (n, model, iset, L, len(seen)), flush=True)
        frontier = nxt
    return None


if __name__ == '__main__':
    main(int(sys.argv[1]), int(sys.argv[2]), sys.argv[3], sys.argv[4] if len(sys.argv) > 4 else 'I1')
