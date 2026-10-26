#!/usr/bin/env python3
"""Exhaustive search, no pruning: is there an M_out (snapshot) or M_end (outputs = any registers at the end) program
of k instructions that sorts n inputs in the T-relaxed model (all weak orders, scratch = T, flags = eq), iset I1?

  python3 agents/spec/tools/tiny_search.py N KMAX
Registers: P0..P{n-1}, S0..S{k-1} (R = n + k suffices, MODEL §2). Every (register, step) value vector is a snapshot
candidate (M_out); M_end uses only the final register values. Prints, per k, SAT/UNSAT for both output rules.
"""
import itertools
import sys

sys.path.insert(0, __file__.rsplit('/agents/', 1)[0] + '/shared')
import judge  # noqa: E402


def main(n, kmax):
    orders = judge.weak_orders(n)
    T = n
    for k in range(kmax + 1):
        regs = ['P%d' % i for i in range(n)] + ['S%d' % i for i in range(k)]
        R = len(regs)
        ins = []
        for d in range(R):
            for s in range(R):
                if d != s:
                    ins.append(('mov', d, s))
                    for op in ('cmovl', 'cmovle', 'cmovg', 'cmovge'):
                        ins.append((op, d, s))
                if d < s:
                    ins.append(('cmp', d, s))  # cmp s,d = cmp d,s with lt/gt swapped; covered by cmov variants
        want = [tuple(sorted(v)[j] for v in orders) for j in range(n)]
        init = [tuple(v[i] for v in orders) for i in range(n)] + [tuple(T for _ in orders)] * k
        found_out = found_end = None
        for prog in itertools.product(ins, repeat=k):
            st = list(init)
            fl = [(1, 0)] * len(orders)
            seen = set(st)
            for op, d, s in prog:
                if op == 'mov':
                    st[d] = st[s]
                elif op == 'cmp':
                    fl = [(int(a == b), int(a < b)) for a, b in zip(st[d], st[s])]
                else:
                    st[d] = tuple(y if judge.cond(op, f) else x for x, y, f in zip(st[d], st[s], fl))
                seen.update((st[d],))
            if found_out is None and all(w in seen for w in want):
                found_out = prog
            if found_end is None and all(w in st for w in want):
                found_end = prog
            if found_out and found_end:
                break
        show = lambda p: 'SAT ' + '; '.join('%s %s, %s' % (o, regs[d], regs[s]) for o, d, s in p) if p else 'UNSAT'
        print('n=%d k=%d |ins|=%d  M_out: %s  |  M_end: %s' % (n, k, len(ins), show(found_out), show(found_end)),
              flush=True)


if __name__ == '__main__':
    main(int(sys.argv[1]), int(sys.argv[2]))
