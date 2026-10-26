#!/usr/bin/env python3
"""Audit the retained skeletons and routing records without rerunning search."""
import csv
import hashlib
import itertools
import json
import re
from collections import Counter, defaultdict
from pathlib import Path

base = Path('logs/round0620')
manifest = list(csv.DictReader(Path('sk/round0620/manifest.tsv').open(), delimiter='\t'))
perms = list(itertools.permutations(range(5)))
engine_sha = hashlib.sha256(Path('dagx_lb').read_bytes()).hexdigest()

def read_skeleton(fn):
    return [tuple(part[1:] for part in line.split(':'))
            for line in Path(fn).read_text().splitlines()
            if line and not line.startswith('#')]

def is_lattice_column(column):
    # A min/max term has one monotone Boolean threshold function at every cut.
    truth = {0: False, 31: True}
    for p, digit in zip(perms, column):
        value = int(digit)
        for cut in range(1, 5):
            mask = sum(1 << i for i, x in enumerate(p) if x >= cut)
            bit = value >= cut
            if mask in truth and truth[mask] != bit:
                return False
            truth[mask] = bit
    assert len(truth) == 32
    return all(not truth[a] or truth[b] for a in range(32) for b in range(32) if a & b == a)

records = []
families = defaultdict(Counter)
audit_dir = Path('sk/round0620_exclusion_audit')
assert (audit_dir / 'manifest.tsv').read_bytes() == Path('sk/round0620/manifest.tsv').read_bytes()
for row in manifest:
    fn = Path('sk/round0620') / row['file']
    assert fn.read_bytes() == (audit_dir / row['file']).read_bytes(), f'exclusion audit changed {fn}'
    sk = read_skeleton(fn)
    source = read_skeleton(row['source'])
    repeated = int(row['repeated_cmp_1based']) - 1
    inserted = int(row['insert_before_cmp_1based']) - 1
    assert len(sk) == 10 and len(source) == 9
    assert sk[inserted] == source[repeated]
    assert sk[:inserted] + sk[inserted + 1:] == source
    assert all(len(c) == 120 and set(c) <= set('01234') for pair in sk for c in pair)
    histories = {tuple((a[t] > b[t]) - (a[t] < b[t]) for a, b in sk) for t in range(120)}
    assert len(histories) == 120
    seed = re.search(r'fam32="([^"]+)"', Path(row['source']).read_text())[1]
    log = base / (fn.stem + '.log')
    txt = log.read_text() if log.exists() else ''
    matches = re.findall(r'^RESULT (\w+)', txt, re.M)
    status = matches[-1] if matches else 'PENDING'
    if matches:
        assert len(matches) == 1
        assert 'K=31 node_limit=0 ' in txt
        assert 'engine_sha256=' + engine_sha in txt
    result = re.search(r'^RESULT .*calls=(\d+).*leaves=(\d+).*time=([\d.]+)s', txt, re.M)
    elapsed = re.search(r'^RUN_END elapsed=([\d.]+)', txt, re.M)
    operand_columns = {c for pair in sk for c in pair}
    non_lattice = sum(not is_lattice_column(c) for c in operand_columns)
    rec = dict(file=str(fn), source=row['source'], seed=seed, repeated_cmp=repeated + 1,
               inserted_before_cmp=inserted + 1, status=status, log=str(log),
               distinct_operand_columns=len(operand_columns), non_lattice_operand_columns=non_lattice,
               skeleton_sha256=hashlib.sha256(fn.read_bytes()).hexdigest(),
               calls=int(result[1]) if result else None,
               leaves=int(result[2]) if result else None,
               seconds=float(result[3]) if result else None,
               elapsed=float(elapsed[1]) if elapsed else None)
    records.append(rec)
    families[seed][status] += 1

counts = Counter(r['status'] for r in records)
summary = dict(total=len(records), counts=dict(counts),
               exhaustive_none=counts['NONE'],
               unknown=counts['LIMIT'] + counts['TIMEOUT'] + counts['ERROR'] + counts['PENDING'],
               calls=sum(r['calls'] or 0 for r in records),
               leaves=sum(r['leaves'] or 0 for r in records),
               elapsed=sum(r['elapsed'] or 0 for r in records),
               K=31, comparisons=10, node_limit=0, wall_limit_seconds=3600,
               nice=19, address_space_limit_bytes=2800000000,
               child_peak_rss_kib=json.loads((base / 'summary.json').read_text())['child_peak_rss_kib'],
               strict_pass_files=[],
               engine_sha256=engine_sha, assumptions=['A4', 'A6'],
               generator_source_sha256=hashlib.sha256(Path('src/round0620_generate.cpp').read_bytes()).hexdigest(),
               generator_sha256=hashlib.sha256(Path('round0620_generate').read_bytes()).hexdigest(),
               strengthened_exclusion_reproduction_identical=True,
               skeletons_with_non_lattice_cmp_operands=sum(r['non_lattice_operand_columns'] > 0 for r in records),
               source_families={seed: dict(c) for seed, c in sorted(families.items())},
               records=records)
(base / 'final_audit.json').write_text(json.dumps(summary, indent=2) + '\n')
(base / 'unknown.tsv').write_text('file\tstatus\tlog\n' + ''.join(
    f'{r["file"]}\t{r["status"]}\t{r["log"]}\n' for r in records
    if r['status'] not in ['NONE', 'FOUND']))
print(json.dumps({k: v for k, v in summary.items() if k != 'records'}, indent=2))
