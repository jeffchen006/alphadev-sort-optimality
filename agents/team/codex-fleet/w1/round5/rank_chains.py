"""Exact backward search of raw-source conditional assignment chains.

Merge two sorted lists. No base program is read. Sources are the five
unchanged sorted-list entries. Each output has one independent accumulator.
The main search uses weak orders, including all I1 conditions.
"""
import argparse
import functools
import itertools
import json
from pathlib import Path
import time

HERE = Path(__file__).resolve().parent


def data(groups=(2, 3), strict=False):
    cases = []
    for w in itertools.product(range(5), repeat=5):
        if set(w) != set(range(max(w) + 1)):
            continue
        if strict and len(set(w)) != 5:
            continue
        k = 0
        good = True
        for n in groups:
            good &= list(w[k:k+n]) == sorted(w[k:k+n])
            k += n
        if good:
            cases.append(w)
    cols = [tuple(w[i] for w in cases) for i in range(5)]
    goals = [tuple(sorted(w)[j] for w in cases) for j in range(5)]
    return cases, cols, goals


def solve(order, cases, cols, goals, save=False):
    allmask = (1 << len(cases)) - 1
    predicates = []
    for a, b in order:
        q = [(w[a] > w[b]) - (w[a] < w[b]) for w in cases]
        predicates.append([sum((v < 0 if c == 0 else v <= 0 if c == 1
                                else v > 0 if c == 2 else v >= 0) << i
                               for i, v in enumerate(q)) for c in range(4)])
    costs, traces, states = [], [], 0
    for goal in goals:
        matches = [sum((v == g) << i for i, (v, g) in enumerate(zip(col, goal)))
                   for col in cols]

        @functools.lru_cache(None)
        def visit(t, demand):
            nonlocal states
            states += 1
            if any(demand & ~m == 0 for m in matches):
                return 0, next(i for i, m in enumerate(matches) if demand & ~m == 0), ()
            if t < 0:
                return 99, -1, ()
            # A flag block has two disjoint selected regions. All repeated
            # assignments with the same condition retain only the last one.
            # Four I1 masks may overlap at equality. Search their closure.
            best = visit(t - 1, demand)
            pending = [(demand, ())]
            seen = {demand: 0}
            for d, tail in pending:
                for c, mask in enumerate(predicates[t]):
                    need = d & mask
                    if not need:
                        continue
                    for src, match in enumerate(matches):
                        if need & ~match:
                            continue
                        rem = d & ~mask
                        ntail = ((t, c, src),) + tail
                        if len(ntail) >= seen.get(rem, 99):
                            continue
                        seen[rem] = len(ntail)
                        pending.append((rem, ntail))
                        cost, init, prefix = visit(t - 1, rem)
                        choice = cost + len(ntail), init, prefix + ntail
                        if choice[0] < best[0]:
                            best = choice
            return best

        cost, init, trace = visit(len(order) - 1, allmask)
        costs.append(cost)
        traces.append((init, trace))
    return costs, traces if save else None, states


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--strict', action='store_true')
    ap.add_argument('--unsorted-pair', action='store_true')
    ap.add_argument('--limit', type=int, default=0)
    args = ap.parse_args()
    groups = (1, 1, 3) if args.unsorted_pair else (2, 3)
    cases, cols, goals = data(groups, args.strict)
    pairs = [(i, j) for i in range(2) for j in range(2, 5)]
    if args.unsorted_pair:
        pairs.append((0, 1))
    hist, best, states = {}, 999, 0
    functional = 0
    bestrows = []
    rows = []
    start = time.process_time()
    n = 0
    for index, order in enumerate(itertools.permutations(pairs)):
        if args.limit and index >= args.limit:
            break
        costs, _, ns = solve(order, cases, cols, goals)
        rows.append(str(index)+'\t'+'\t'.join(map(str,costs)))
        states += ns
        possible = all(cost < 99 for cost in costs)
        total = sum(costs) if possible else 'IMPOSSIBLE'
        hist[total] = hist.get(total, 0) + 1
        functional += possible
        if possible and total < best:
            best = total
            print('BEST', index, total, costs, order, flush=True)
            bestrows = []
        if possible and total == best:
            _, trace, _ = solve(order, cases, cols, goals, True)
            bestrows.append({'index': index, 'order': order, 'costs': costs,
                             'trace': trace})
        n += 1
        if n % 120 == 0:
            print('PROGRESS', n, 'states', states, 'cpu', time.process_time()-start, flush=True)
    record = {'cases': len(cases), 'groups': groups, 'strict': args.strict,
              'orders': n, 'functional_orders': functional,
              'histogram': hist, 'best': best if functional else None, 'states': states,
              'cpu': time.process_time()-start, 'bestrows': bestrows,
              'complete': n == (5040 if args.unsorted_pair else 720)}
    stem = 'raw_unsorted' if args.unsorted_pair else 'raw_sorted'
    if args.strict:
        stem += '_distinct'
    (HERE/(stem+'.json')).write_text(json.dumps(record, indent=2)+'\n')
    (HERE/(stem+'.tsv')).write_text('\n'.join(rows)+'\n')
    print('RESULT', {k:v for k,v in record.items() if k != 'bestrows'}, flush=True)


if __name__ == '__main__':
    main()
