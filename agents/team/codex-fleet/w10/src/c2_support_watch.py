#!/usr/bin/env python3
"""Track both d2 C2 variants and sample their saved LRAT certificates.

This program starts no position solver. Peer-checked case counts are distinct
from the independent random certificate sample. Split coverage alone never
closes a case. All output files stay in w10.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import time

from c2_short import D2, DEST, HERE, positions, sample_d2, save, stamp


def load(path):
    try:
        return json.loads(path.read_text())
    except (FileNotFoundError, json.JSONDecodeError):
        return None


def retained(r, name, units, meta):
    """Check peer metadata and retention, without claiming an LRAT recheck."""
    if not r or r.get('case') != name or r.get('units') != units:
        return False
    if (r.get('base_cnf_sha256') != meta['cnf_sha256']
            or r.get('encoder_sha256') != meta['encoder_sha256']):
        return False
    if r.get('status') != 'UNSAT' or not r.get('verified'):
        return False
    if not any(line.strip() == 'c VERIFIED' for line in r.get('checker_tail', [])):
        return False
    for field in ('proof_file', 'cnf_file'):
        if not r.get(field) or not Path(r[field]).is_file():
            return False
    return bool(r.get('proof_sha256') and r.get('cnf_sha256'))


def split_coverage(name, manifest):
    info = load(D2 / 'cubes' / (name+'.cover.json'))
    if not info or not info.get('verified'):
        return False
    cubes = [row['units'] for row in manifest['cubes']]
    if not cubes or info.get('cubes') != len(cubes):
        return False
    # Bind the coverage decision to the current exact cube manifest. A
    # certificate for an older split must not close a newer split.
    nv = max((abs(x) for cube in cubes for x in cube), default=0)
    formula = f'p cnf {nv} {len(cubes)}\n' + ''.join(
        ' '.join(str(-x) for x in cube)+' 0\n' for cube in cubes)
    if hashlib.sha256(formula.encode()).hexdigest() != info.get('cover_cnf_sha256'):
        return False
    return all(info.get(key) and Path(info[key]).is_file()
               for key in ('cover_cnf', 'cover_proof'))


def census():
    report = dict(created=stamp(), variants={}, cases=[],
                  count_basis='Peer-checked UNSAT with retained CNF and LRAT; '
                  'not independent checks of all case certificates')
    for variant, cs in [('v1', range(9, 16)), ('v2', range(7, 16))]:
        counts = dict(total=0, decided=0, remaining=0, unknown=0,
                      no_result=0, incomplete=0, split=0, sat_pending_review=0)
        for c in cs:
            suffix = '_v2' if variant == 'v2' else ''
            meta = load(D2 / 'base' / f'base_k31_c{c}{suffix}.json')
            for i, j in positions(31-c):
                name = ('v2_' if suffix else '')+f'c{c}_{i:02}_{j:02}'
                root = load(D2 / 'results' / (name+'.json'))
                split = load(D2 / 'cubes' / (name+'.json'))
                counts['total'] += 1
                units = [meta['position_choices'][0][i], meta['position_choices'][1][j]] if meta else None
                closed = bool(units and retained(root, name, units, meta))
                row = dict(case=name, variant=variant, c=c, i=i, j=j,
                           peer_checked_unsat=closed, split=False)
                records = [root] if root else []
                if split and units and split.get('case') == name:
                    counts['split'] += 1
                    row['split'] = True
                    children = []
                    good = 0
                    for q, cube in enumerate(split['cubes']):
                        qname = name+f'_q{q:03}'
                        child = load(D2 / 'results' / (qname+'.json'))
                        if child:
                            records.append(child)
                        checked = retained(child, qname, units+cube['units'], meta)
                        good += checked
                        children.append(dict(case=qname, peer_checked_unsat=checked,
                                             status=child.get('status') if child else 'NO_RESULT'))
                    cover = split_coverage(name, split)
                    row.update(cubes=children, peer_checked_cube_coverage=cover)
                    if children and good == len(children) and cover:
                        closed = True
                unknown = any(r.get('status') == 'UNKNOWN' for r in records)
                sat = any(r.get('status') == 'SAT' for r in records)
                if closed:
                    state = 'PEER_CHECKED_UNSAT'
                    counts['decided'] += 1
                elif sat:
                    state = 'SAT_PENDING_STRICT_REVIEW'
                    counts['sat_pending_review'] += 1
                elif unknown:
                    state = 'UNKNOWN'
                    counts['unknown'] += 1
                elif records:
                    state = 'INCOMPLETE'
                    counts['incomplete'] += 1
                else:
                    state = 'NO_RESULT'
                    counts['no_result'] += 1
                row.update(status=state, peer_checked_unsat=closed)
                report['cases'].append(row)
        counts['remaining'] = counts['total']-counts['decided']
        report['variants'][variant] = counts
    assert report['variants']['v1']['total'] == 1351
    assert report['variants']['v2']['total'] == 1929
    report['totals'] = {key: sum(v[key] for v in report['variants'].values())
                        for key in report['variants']['v1']}
    save(DEST / 'support_status.json', report)
    return report


def append_status(status, sample):
    t = status['totals']
    with (HERE / 'RESULTS.md').open('a') as f:
        f.write(f"\nC2 SUPPORT STATUS {stamp()} [A15]: "
                f"{t['decided']} cases decided / {t['remaining']} remaining / "
                f"{t['unknown']} unknown in d2 V1+V2; "
                f"{t['no_result']} without a completed result, {t['incomplete']} incomplete, "
                f"{t['sat_pending_review']} SAT pending review. "
                'Decisions use peer-checked UNSAT with retained artifacts. '
                f"Independent sample: {sample['verified']}/"
                f"{sample['requested_sample_size']} verified from "
                f"{sample['population_size']} available checked UNSAT result files. "
                'The earlier w10 short pass still has 1351 UNKNOWN V1 cases.\n')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--watch', action='store_true')
    args = ap.parse_args()
    assert os.nice(0) >= 19
    last_status = 0
    while True:
        status = census()
        sample = sample_d2()
        if time.monotonic()-last_status >= 7200 or not args.watch:
            append_status(status, sample)
            last_status = time.monotonic()
        print(json.dumps(dict(time=stamp(), cases=status['totals'],
                              independent_sample_verified=sample['verified'],
                              independent_sample_requested=sample['requested_sample_size'],
                              sample_complete=sample['complete'])), flush=True)
        if not args.watch:
            return
        # Continue after the first nonempty sample. Later results change the
        # finite population and can select additional certificates.
        time.sleep(60)


if __name__ == '__main__':
    main()
