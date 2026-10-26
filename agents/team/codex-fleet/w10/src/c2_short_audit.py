#!/usr/bin/env python3
"""Audit completed short passes, without resubmitting a position case."""
import collections
import hashlib
import json
from pathlib import Path
import re

import c2_short as work


def main():
    manifest = json.loads((work.DEST / 'manifest.json').read_text())
    cases = manifest['cases']
    bodies = {}
    counts = collections.Counter()
    per_c = {}
    peak_bytes = 0
    cpu_seconds = 0.0
    artifacts = {}
    for c in sorted({x['c'] for x in cases}):
        base = work.DEST / f'base/base_k31_c{c}.cnf'
        meta = json.loads(base.with_suffix('.json').read_text())
        assert work.sha(base) == meta['cnf_sha256']
        with base.open('rb') as f:
            assert f.readline() == f"p cnf {meta['variables']} {meta['clauses']}\n".encode()
            bodies[c] = f.read()
        cc = [r for r in cases if r['c'] == c]
        assert [(r['i'], r['j']) for r in cc] == list(work.positions(31-c))
        assert len(cc) == 1+(31-c)+(31-c)*(30-c)//2
        per_c[c] = collections.Counter()
        artifacts[str(base)] = meta['cnf_sha256']
    for case in cases:
        folder = work.DEST / case['case']
        r = json.loads((folder / 'result.json').read_text())
        assert r['pass_complete']
        assert r['solver']['nice'] == 19
        assert r['solver_limit_seconds'] == 5
        for key in ('c', 'i', 'j', 'units', 'base_sha256', 'variables', 'clauses'):
            assert r[key] == case[key]
        h = hashlib.sha256()
        h.update(f"p cnf {r['variables']} {r['clauses']}\n".encode())
        h.update(bodies[r['c']])
        h.update(''.join(f'{u} 0\n' for u in r['units']).encode())
        assert h.hexdigest() == r['cnf_sha256'], r['case']
        text = (folder / 'solver.log').read_text()
        rss = re.search(r'maximum-resident-set-size:\s*(\d+) bytes', text)
        cpu = re.search(r'process-time:.*?([\d.]+) seconds', text)
        if rss:
            peak_bytes = max(peak_bytes, int(rss[1]))
        if cpu:
            cpu_seconds += float(cpu[1])
        if r['status'] == 'UNSATISFIABLE':
            assert r['solver']['returncode'] == 20
            assert work.sha(folder / 'formula.cnf') == r['cnf_sha256']
            assert work.sha(folder / 'proof.drat') == r['proof_sha256']
            assert r['decided'] and r['checker']['returncode'] == 0
            assert 's VERIFIED' in (folder / 'check.log').read_text()
        elif r['status'] == 'SATISFIABLE':
            assert r['assignment_checked'] and r['decided']
            assert all(j['returncode'] == 0 and 'PASS ' in j['output']
                       for j in r['validation']['judges'])
        else:
            assert r['status'] == 'UNKNOWN' and not r['decided']
        counts[r['status']] += 1
        per_c[r['c']][r['status']] += 1
    for p in [Path(__file__), work.HERE / 'src/c2_short.py',
              work.HERE / 'round5/C2_COVERAGE.md']:
        artifacts[str(p)] = work.sha(p)
    report = dict(created=work.stamp(), cases=len(cases),
                  complete_short_pass=True, status_counts=dict(counts),
                  per_c={c: dict(v) for c, v in per_c.items()},
                  max_solver_rss_bytes=peak_bytes,
                  summed_reported_solver_cpu_seconds=round(cpu_seconds, 3),
                  reconstructed_formula_hashes_checked=len(cases),
                  artifacts=artifacts)
    work.save(work.DEST / 'audit.json', report)
    with (work.HERE / 'RESULTS.md').open('a') as out:
        out.write('\n### C2 five-second pass completed [A12, A15]\n\n')
        out.write(f"Cases submitted: {len(cases)}. Solver results: " +
                  ', '.join(f'{n} {s}' for s, n in sorted(counts.items())) + '.\n\n')
        out.write('| comparisons | SAT | checked UNSAT | UNKNOWN |\n'
                  '|---:|---:|---:|---:|\n')
        for c, cc in per_c.items():
            out.write(f"| {c} | {cc.get('SATISFIABLE', 0)} | "
                      f"{cc.get('UNSATISFIABLE', 0)} | {cc.get('UNKNOWN', 0)} |\n")
        out.write(f"\nReconstructed formula hashes checked: {len(cases)}. "
                  f"Maximum solver memory in the logs: {peak_bytes} bytes. "
                  f"Summed reported solver CPU time: {cpu_seconds:.3f} seconds.\n\n")
        out.write('The audit is `c2_short/audit.json`. Each UNKNOWN remains open. '
                  'The formulas are the original lattice-comparison-operand variant. '
                  'These results do not decide the broader V2 formulas. '
                  'd2-lattice owns the long position cases.\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
