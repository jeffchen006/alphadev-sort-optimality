"""Export case-specific value demands and comparison predicate demands.

All data uses all 541 weak orders. A value column is the value of a register
for each weak order. Value 7 denotes unknown initial scratch data.
"""
import collections
import itertools
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
SOURCE = HERE.parents[1] / 'w6' / 'round2' / 'verified'
CASES = [w for w in itertools.product(range(5), repeat=5)
         if set(w) == set(range(max(w) + 1))]
ALL = (1 << len(CASES)) - 1
OPS = ['mov', 'cmp', 'cmovl', 'cmovle', 'cmovg', 'cmovge']


def mask(xs):
    return sum(1 << i for i, x in enumerate(xs) if x)


def take(q, op):
    return q < 0 if op == 2 else q <= 0 if op == 3 else q > 0 if op == 4 else q >= 0


CASE_INDEX = {w: i for i, w in enumerate(CASES)}


def lattice(col):
    """Return a Boolean lattice table if it represents the full value column."""
    if 7 in col:
        return None
    table = [col[CASE_INDEX[tuple((bits >> i) & 1 for i in range(5))]]
             for bits in range(31)] + [1]
    if table[0] != 0 or any(table[b] > table[b | (1 << i)]
                            for b in range(32) for i in range(5)):
        return None
    for w, v in zip(CASES, col):
        for level in range(max(w)):
            bits = sum((x > level) << i for i, x in enumerate(w))
            if table[bits] != (v > level):
                return None
    return sum(v << i for i, v in enumerate(table))


def analyze(path):
    regs = {f'P{i}': i for i in range(5)}
    cols = [tuple(w[i] for w in CASES) for i in range(5)]
    births = [-1] * 5
    events = []
    original = []
    flag = None
    fc = None
    outs = []
    snapshots = []
    for raw in path.read_text().splitlines():
        z = raw.split('#')[0].replace(',', ' ').split()
        if not z:
            continue
        if z[0] == 'out':
            outs.append((len(events), int(z[1]), regs[z[2]]))
            continue
        op, d, s = z
        for r in (d, s):
            if r not in regs:
                regs[r] = len(cols)
                cols.append((7,) * len(CASES))
                births.append(-1)
        a, b = regs[d], regs[s]
        op = OPS.index(op)
        original.append([op, d, s])
        e = {'op': op, 'old': a, 'src': b, 'new': -1, 'fc': fc}
        if op == 1:
            assert all(x < 5 and y < 5 for x, y in zip(cols[a], cols[b]))
            flag = tuple((x > y) - (x < y) for x, y in zip(cols[a], cols[b]))
            fc = len(events)
            e['conditions'] = [mask(take(q, c) for q in flag) for c in range(2, 6)]
        else:
            if op == 0:
                c = cols[b]
            else:
                assert flag is not None
                e['take'] = mask(take(q, op) for q in flag)
                e['different'] = mask(x != y for x, y in zip(cols[a], cols[b]))
                c = tuple(y if take(q, op) else x for x, y, q in zip(cols[a], cols[b], flag))
            e['new'] = len(cols)
            cols.append(c)
            births.append(len(events))
            regs[d] = e['new']
        events.append(e)
        snapshots.append(tuple(regs.values()))
    goals = [tuple(sorted(w)[j] for w in CASES) for j in range(5)]
    assert len(outs) == 5 and all(cols[v] == goals[j] for t, j, v in outs)
    live = {}
    boundaries = [None] * (len(events) + 1)
    cm = {i: [0] * 4 for i, e in enumerate(events) if e['op'] == 1}
    for pos in range(len(events), -1, -1):
        for t, j, v in outs:
            if t == pos:
                live[v] = live.get(v, 0) | ALL
        boundaries[pos] = [(v, m) for v, m in sorted(live.items()) if m]
        if pos == 0:
            break
        e = events[pos - 1]
        if e['op'] == 1:
            # Compare operands may change. Retain predicate requirements only.
            continue
        need = live.pop(e['new'], 0)
        e['need'] = need
        if e['op'] == 0:
            live[e['src']] = live.get(e['src'], 0) | need
        else:
            yes = need & e['take']
            no = need & (ALL ^ e['take'])
            live[e['src']] = live.get(e['src'], 0) | yes
            live[e['old']] = live.get(e['old'], 0) | no
            cm[e['fc']][e['op'] - 2] |= need & e['different']
    for i, e in enumerate(events):
        if e['op'] == 1:
            e['condition_demands'] = cm[i]
    for boundary in boundaries:
        for v, m in boundary:
            assert not any(x == 7 and (m >> t & 1) for t, x in enumerate(cols[v]))
    stats = {
        'file': str(path), 'name': path.stem,
        'counts': dict(collections.Counter(OPS[e['op']] for e in events)),
        'partial_writes': sum(e['op'] != 1 and e['need'] != ALL for e in events),
        'dead_writes': sum(e['op'] != 1 and not e['need'] for e in events),
        'partial_comparisons': sum(e['op'] == 1 and
                                   (cm[i][0] | cm[i][1] | cm[i][2] | cm[i][3]) != ALL
                                   for i, e in enumerate(events)),
        'comparison_case_counts': [(cm[i][0] | cm[i][1] | cm[i][2] | cm[i][3]).bit_count()
                                   for i in cm],
        'write_case_counts': [e.get('need', 0).bit_count() for e in events if e['op'] != 1],
        'max_live_values': max(len(b) for b in boundaries),
    }
    lc = [lattice(col) for col in cols]
    comparison_events = [i for i, e in enumerate(events) if e['op'] == 1]
    stats['nonlattice_comparison_stages'] = [j + 1 for j, i in enumerate(comparison_events)
                                            if lc[events[i]['old']] is None
                                            or lc[events[i]['src']] is None]
    stats['conditional_copy_positions'] = [i for i, e in enumerate(events)
                                            if e['op'] >= 2 and not (e['need'] & (ALL ^ e['take']))]
    stats['prefix_before_fifth_cost'] = comparison_events[4]
    strict_ids = [i for i, w in enumerate(CASES) if len(set(w)) == 5]
    flags = []
    for i in comparison_events:
        e = events[i]
        flags.append(''.join('0' if e['conditions'][0] >> t & 1 else
                             '2' if e['conditions'][2] >> t & 1 else '1'
                             for t in range(len(CASES))))
    stats['comparison_signs'] = flags
    stats['strict_comparison_equal_counts'] = [sum(s[t] == '1' for t in strict_ids)
                                                for s in flags]
    stats['strict_comparison_history_counts'] = [len({tuple(s[t] for s in flags[:j])
                                                     for t in strict_ids})
                                                  for j in range(1, 9)]
    before_fifth = comparison_events[4] - 1
    available = {cols[v] for v in snapshots[before_fifth]}
    partitions = []
    for triple in itertools.combinations(range(5), 3):
        pair = tuple(i for i in range(5) if i not in triple)
        wanted = [tuple(sorted(w[i] for i in group)[j] for w in CASES)
                  for group in (triple, pair) for j in range(len(group))]
        if all(c in available for c in wanted):
            partitions.append([triple, pair])
    stats['pair_triple_partition_before_fifth'] = partitions
    available_four = {cols[v] for v in snapshots[comparison_events[5] - 1]}
    four_partitions = []
    for single in range(5):
        group = tuple(i for i in range(5) if i != single)
        wanted = [tuple(sorted(w[i] for i in group)[j] for w in CASES) for j in range(4)]
        wanted.append(cols[single])
        if all(c in available_four for c in wanted):
            four_partitions.append([group, single])
    stats['quartet_single_partition_before_sixth'] = four_partitions
    stats['prefix_before_sixth_cost'] = comparison_events[5]
    stats['move_positions'] = [i for i, e in enumerate(events) if e['op'] == 0]
    problem = {'name': path.stem, 'cols': cols, 'events': events,
               'boundaries': boundaries, 'outs': outs, 'original': original}
    return stats, problem


def export(problems, destination=None):
    with (destination or HERE / 'problems.txt').open('w') as f:
        print(len(problems), file=f)
        for p in problems:
            print(p['name'], len(p['cols']), len(p['events']), file=f)
            for col in p['cols']:
                print(''.join(map(str, col)), file=f)
            for e in p['events']:
                print(e['op'], e['new'], file=f)
                if e['op'] == 1:
                    for c, m in zip(e['conditions'], e['condition_demands']):
                        print(format(c, 'x'), format(m, 'x'), file=f)
                else:
                    print(format(e['need'], 'x'), file=f)
            for b in p['boundaries']:
                print(len(b), file=f)
                for v, m in b:
                    print(v, format(m, 'x'), file=f)
            print(len(p['outs']), file=f)
            for t, j, v in p['outs']:
                print(t, j, v, file=f)


def main():
    rows, problems = [], []
    for path in sorted(SOURCE.glob('*.s')):
        row, p = analyze(path)
        rows.append(row)
        problems.append(p)
    assert len(rows) == 143
    export(problems)
    (HERE / 'analysis.json').write_text(json.dumps(rows, indent=2) + '\n')
    hist = collections.Counter(r['counts'].get('mov', 0) for r in rows)
    print('programs', len(rows), 'mov_histogram', dict(sorted(hist.items())))
    print('partial writes', sum(r['partial_writes'] for r in rows),
          'dead writes', sum(r['dead_writes'] for r in rows))
    print('comparison case-count histogram', dict(sorted(collections.Counter(
        n for r in rows for n in r['comparison_case_counts']).items())))
    print('max live values histogram', dict(sorted(collections.Counter(
        r['max_live_values'] for r in rows).items())))
    print('nonlattice comparison stages', dict(collections.Counter(
        tuple(r['nonlattice_comparison_stages']) for r in rows)))
    print('complete pair/triple before fifth comparison', sum(bool(
        r['pair_triple_partition_before_fifth']) for r in rows))
    print('complete quartet/single before sixth comparison', sum(bool(
        r['quartet_single_partition_before_sixth']) for r in rows))
    print('conditional copy writes', sum(len(r['conditional_copy_positions']) for r in rows))
    print('prefix costs before fifth comparison', dict(sorted(collections.Counter(
        r['prefix_before_fifth_cost'] for r in rows).items())))
    print('strict equality count patterns', dict(collections.Counter(
        tuple(r['strict_comparison_equal_counts']) for r in rows)))
    print('strict history count patterns', dict(collections.Counter(
        tuple(r['strict_comparison_history_counts']) for r in rows)))


if __name__ == '__main__':
    main()
