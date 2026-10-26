"""Independent integer-bitset implementation of masked event routing.

This version omits the C++ future-full-column lower bound. It identifies
opposite flag orientations, instead of selecting an operand orientation.
"""
from functools import cache, lru_cache
from pathlib import Path
import itertools
import json
import resource
import sys
import time

resource.setrlimit(resource.RLIMIT_AS, (2800 * 1024**2, 2800 * 1024**2))
ALL = (1 << 541) - 1


def problems():
    toks = iter(Path('round3/problems.txt').read_text().split())
    for _ in range(int(next(toks))):
        name, nv, ne = next(toks), int(next(toks)), int(next(toks))
        values = []
        for _ in range(nv):
            s = next(toks)
            values.append(tuple(sum(1 << t for t, v in enumerate(s)
                                    if (int(v) >> b) & 1) for b in range(3)))
        events = []
        for _ in range(ne):
            op, target = int(next(toks)), int(next(toks))
            if op == 1:
                checks = tuple((int(next(toks), 16), int(next(toks), 16))
                               for _ in range(4))
                events.append((op, target, checks))
            else:
                events.append((op, target, int(next(toks), 16)))
        live = []
        for _ in range(ne + 1):
            live.append(tuple((int(next(toks)), int(next(toks), 16))
                              for _ in range(int(next(toks)))))
        outs = [tuple(int(next(toks)) for _ in range(3))
                for _ in range(int(next(toks)))]
        yield name, values, events, live, outs


def search(problem, cap=31):
    name, values, events, live, outs = problem
    columns = []
    ids = {}

    def intern(col):
        if col not in ids:
            ids[col] = len(columns)
            columns.append(col)
        return ids[col]

    base = [intern(col) for col in values]
    blank = intern((ALL, ALL, ALL))

    @cache
    def agrees(a, b, mask):
        x, y = columns[a], columns[b]
        return not (((x[0] ^ y[0]) | (x[1] ^ y[1]) | (x[2] ^ y[2])) & mask)

    @cache
    def covers(pos, col):
        return sum(1 << j for j, (v, mask) in enumerate(live[pos])
                   if agrees(col, base[v], mask))

    @cache
    def compare(a, b):
        x, y = columns[a], columns[b]
        same, lt, gt = ALL, 0, 0
        for u, v in zip(reversed(x), reversed(y)):
            lt |= same & ~u & v
            gt |= same & u & ~v
            same &= ~(u ^ v)
        unknown = (x[0] & x[1] & x[2]) | (y[0] & y[1] & y[2])
        return lt & ~unknown, gt & ~unknown, unknown

    def conditions(flags):
        lt, gt, unknown = flags
        return lt, ALL & ~(gt | unknown), gt, ALL & ~(lt | unknown)

    def good_compare(flags, checks):
        return all(not (((condition ^ want) | flags[2]) & mask)
                   for condition, (want, mask) in zip(conditions(flags), checks))

    @lru_cache(maxsize=200000)
    def select(d, s, flags, op):
        if op == 0:
            return columns[s]
        x, y = columns[d], columns[s]
        take = conditions(flags)[op - 2]
        unknown = flags[2] & ((x[0] ^ y[0]) | (x[1] ^ y[1]) | (x[2] ^ y[2]))
        return tuple(((a & ~take) | (b & take) | unknown) & ALL
                     for a, b in zip(x, y))

    frontier = {(tuple(sorted(base[:5])), (0, 0, ALL)): 0}
    suffix_cmp = [sum(op == 1 for op, _, _ in events[pos:])
                  for pos in range(len(events) + 1)]
    states = 0
    peak = 0
    for pos, (op, target, detail) in enumerate(events):
        following = {}
        want = (1 << len(live[pos + 1])) - 1

        def add(regs, flags, cost):
            if cost + suffix_cmp[pos + 1] > cap:
                return
            key = tuple(sorted(regs)), flags
            if cost < following.get(key, cap + 1):
                following[key] = cost

        for (regs, flags), cost in frontier.items():
            cs = [covers(pos + 1, r) for r in regs]
            union = 0
            for c in cs:
                union |= c
            if op != 1 and union == want and any(agrees(r, base[target], detail) for r in regs):
                add(regs, flags, cost)
            if cost + 1 + suffix_cmp[pos + 1] > cap:
                continue
            if op == 1:
                if union != want:
                    continue
                seen = set()
                for d in range(len(regs)):
                    for s in range(d + 1):
                        f = (0, 0, 0) if d == s else compare(regs[d], regs[s])
                        reverse = f[1], f[0], f[2]
                        if not (good_compare(f, detail) or good_compare(reverse, detail)):
                            continue
                        f = min(f, reverse)
                        if f not in seen:
                            seen.add(f)
                            add(regs, f, cost + 1)
                continue
            distinct_sources = sorted(set(regs))
            for d in range(len(regs) + 1):
                if d < len(regs) and d and regs[d] == regs[d - 1]:
                    continue
                old = blank if d == len(regs) else regs[d]
                without = 0
                for i, c in enumerate(cs):
                    if i != d:
                        without |= c
                for src in distinct_sources:
                    for cm in (0, 2, 3, 4, 5):
                        value = select(old, src, flags, cm)
                        if d < len(regs) and value == columns[old]:
                            continue
                        goal = columns[base[target]]
                        if ((value[0] ^ goal[0]) | (value[1] ^ goal[1]) | (value[2] ^ goal[2])) & detail:
                            continue
                        col = intern(value)
                        if (without | covers(pos + 1, col)) != want:
                            continue
                        new = list(regs)
                        if d == len(regs):
                            new.append(col)
                        else:
                            new[d] = col
                        add(new, flags, cost + 1)
        frontier = following
        states += len(frontier)
        peak = max(peak, len(frontier))
        if not frontier:
            break
    result = min(frontier.values()) if frontier else None
    print(json.dumps({'name': name, 'minimum_within_bound': result,
                      'states': states, 'peak': peak, 'columns': len(columns)}), flush=True)
    return result, states, peak


def main():
    first = int(sys.argv[1]) if len(sys.argv) > 1 else 0
    last = int(sys.argv[2]) if len(sys.argv) > 2 else 143
    start = time.process_time()
    found, total, states, peak = 0, 0, 0, 0
    for index, problem in enumerate(problems()):
        if not first <= index < last:
            continue
        result, ns, pk = search(problem)
        total += 1
        states += ns
        peak = max(peak, pk)
        found += result is not None
    print(json.dumps({'complete': [first, last], 'programs': total,
                      'candidates': found, 'states': states, 'peak': peak,
                      'cpu': time.process_time() - start}), flush=True)


if __name__ == '__main__':
    main()
