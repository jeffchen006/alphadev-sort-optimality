#!/usr/bin/env python3
"""Independently check recipes and audit the completed routing logs."""
import csv
import hashlib
import itertools
import json
import re
from collections import Counter
from pathlib import Path

base = Path('logs/round0800')
perms = list(itertools.permutations(range(5)))
engine_sha = hashlib.sha256(Path('dagx_lb').read_bytes()).hexdigest()
perm_index = {p: i for i, p in enumerate(perms)}
renamings = [tuple(perm_index[tuple(p[q[i]] for i in range(5))] for p in perms) for q in perms]
renamed_columns = {}


def canonical(sk):
    for col in {col for pair in sk for col in pair}:
        if col not in renamed_columns:
            renamed_columns[col] = tuple(bytes(col[t] for t in rename) for rename in renamings)
    return min(b''.join(b''.join(sorted((renamed_columns[a][pi], renamed_columns[b][pi])))
                        for a, b in sk) for pi in range(120))


def column(expr):
    if expr.startswith('='):
        values = tuple(map(int, expr[1:]))
    else:
        # Formula syntax: maximum of the minimums in each | separated term.
        terms = [tuple(map(int, term)) for term in expr.split('|')]
        values = tuple(max(min(p[i] for i in term) for term in terms) for p in perms)
    assert len(values) == 120 and set(values) <= set(range(5))
    return values


def read_skeleton(fn):
    result = []
    for line in Path(fn).read_text().splitlines():
        line = line.split('#')[0].strip()
        if not line:
            continue
        first = line.split()[0].split(';')[0]
        a, b = first.split(':')
        result.append((column(a), column(b)))
    return result


def is_lattice(values):
    # A min/max expression must give one monotone Boolean threshold function.
    truth = {0: False, 31: True}
    for p, value in zip(perms, values):
        for cut in range(1, 5):
            mask = sum(1 << i for i, x in enumerate(p) if x >= cut)
            bit = value >= cut
            if mask in truth and truth[mask] != bit:
                return False
            truth[mask] = bit
    assert len(truth) == 32
    return all(not truth[a] or truth[b] for a in range(32) for b in range(32) if a & b == a)


records = []
sources = {}
lattice_cache = {}
for c in (10, 11):
    folder = Path(f'sk/round0800_c{c}')
    rows = list(csv.DictReader((folder / 'manifest.tsv').open(), delimiter='\t'))
    assert len(rows) == 300
    canonical_keys = set()
    for row in rows:
        fn = folder / row['file']
        source_path = Path(row['source'])
        if row['source'] not in sources:
            sources[row['source']] = dict(
                sha256=hashlib.sha256(source_path.read_bytes()).hexdigest(),
                skeleton=read_skeleton(source_path))
        source = sources[row['source']]['skeleton']
        sk = read_skeleton(fn)
        repeats = [int(x) - 1 for x in row['repeated_cmp_1based'].split(',')]
        slots = [int(x) - 1 for x in row['insert_before_source_cmp_1based'].split(',')]
        assert len(source) == (8 if c == 10 else 10)
        assert len(repeats) == (2 if c == 10 else 1)
        assert len(repeats) == len(slots)
        expected = list(source)
        for repeat, slot in reversed(list(zip(repeats, slots))):
            assert 0 <= repeat < slot - 1 <= len(source) - 1
            expected.insert(slot, source[repeat])
        assert sk == expected and len(sk) == c
        key = canonical(sk)
        assert key not in canonical_keys, f'equivalent retained skeleton: {fn}'
        canonical_keys.add(key)
        histories = {tuple((a[t] > b[t]) - (a[t] < b[t]) for a, b in sk) for t in range(120)}
        assert len(histories) == 120
        sk_sha = hashlib.sha256(fn.read_bytes()).hexdigest()
        log = base / f'c{c}_{fn.stem}.log'
        txt = log.read_text() if log.exists() else ''
        statuses = re.findall(r'^RESULT (\w+)', txt, re.M)
        assert len(statuses) <= 1
        status = statuses[0] if statuses else 'PENDING'
        if statuses:
            assert f'skeleton_sha256={sk_sha}' in txt
            assert f'engine_sha256={engine_sha}' in txt
            assert 'K=31 node_limit=0 ' in txt
            assert f'skeleton c={c} K=31 budget(gates+copies)={31-c}' in txt
        result = re.search(r'^RESULT .*calls=(\d+).*leaves=(\d+).*time=([\d.]+)s', txt, re.M)
        end = re.search(r'^RUN_END elapsed=([\d.]+) cpu=([\d.]+) child_peak_rss_kib=(\d+)', txt, re.M)
        columns = {col for pair in sk for col in pair}
        for col in columns:
            if col not in lattice_cache:
                lattice_cache[col] = is_lattice(col)
        records.append(dict(file=str(fn), source=row['source'], comparisons=c,
                            repeats_1based=[r + 1 for r in repeats],
                            insert_before_source_cmp_1based=[s + 1 for s in slots],
                            status=status, log=str(log), skeleton_sha256=sk_sha,
                            source_sha256=sources[row['source']]['sha256'],
                            non_lattice_operand_columns=sum(not lattice_cache[col] for col in columns),
                            calls=int(result[1]) if result else None,
                            leaves=int(result[2]) if result else None,
                            seconds=float(result[3]) if result else None,
                            elapsed=float(end[1]) if end else None,
                            cpu=float(end[2]) if end else None,
                            child_peak_rss_kib=int(end[3]) if end else None))

counts = Counter(r['status'] for r in records)
summary = dict(total=len(records), counts=dict(counts), exhaustive_none=counts['NONE'],
               unknown=sum(counts[s] for s in ['LIMIT', 'TIMEOUT', 'ERROR', 'PENDING']),
               groups={str(c): dict(Counter(r['status'] for r in records if r['comparisons'] == c)) for c in (10, 11)},
               calls=sum(r['calls'] or 0 for r in records), leaves=sum(r['leaves'] or 0 for r in records),
               elapsed=sum(r['elapsed'] or 0 for r in records), cpu=sum(r['cpu'] or 0 for r in records),
               child_peak_rss_kib=max(r['child_peak_rss_kib'] or 0 for r in records),
               source_counts={str(c): len({r['source'] for r in records if r['comparisons'] == c}) for c in (10, 11)},
               non_lattice_skeletons={str(c): sum(r['non_lattice_operand_columns'] > 0 for r in records if r['comparisons'] == c) for c in (10, 11)},
               recipes={str(c): dict(Counter(str((r['repeats_1based'], r['insert_before_source_cmp_1based'])) for r in records if r['comparisons'] == c)) for c in (10, 11)},
               K=31, node_limit=0, wall_limit_seconds=3600, nice=19,
               address_space_limit_bytes=2800000000, engine_sha256=engine_sha,
               generator_source_sha256=hashlib.sha256(Path('src/round0800_generate.cpp').read_bytes()).hexdigest(),
               generator_sha256=hashlib.sha256(Path('round0800_generate').read_bytes()).hexdigest(),
               assumptions=['A4', 'A6'], strict_pass_files=[], records=records)
summary['independent_recipe_history_and_symmetry_checks'] = True
(base / 'final_audit.json').write_text(json.dumps(summary, indent=2) + '\n')
(base / 'unknown.tsv').write_text('file\tstatus\tlog\n' + ''.join(
    f'{r["file"]}\t{r["status"]}\t{r["log"]}\n' for r in records if r['status'] not in ['NONE', 'FOUND']))
print(json.dumps({k: v for k, v in summary.items() if k != 'records'}, indent=2))
