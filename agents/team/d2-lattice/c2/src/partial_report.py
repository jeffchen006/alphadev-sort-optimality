#!/usr/bin/env python3
"""Collect exact solver, certificate, and reference-judge records."""
from collections import Counter
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
OUT = HERE/'round2'


def main():
    runs, proofs, passes = [], [], []
    for p in sorted(OUT.glob('*.json')):
        r = json.loads(p.read_text())
        if not isinstance(r, dict):
            continue
        if r.get('status') in ('SATISFIABLE', 'UNSATISFIABLE', 'UNKNOWN'):
            runs.append(dict(name=p.stem, **r))
        if p.name.endswith('.proofcheck.json'):
            proofs.append(r)
        if p.name.endswith('.validation.json'):
            assert r['wrong_outputs'] == r['undefined_comparisons'] == 0
            if p.name == 'n4_k20_partial_normalized.validation.json':
                assert r['k'] == 20 and r['comparisons'] == 5
                assert not r['partial_data_nodes'] and not r['nonlattice_full_data_nodes']
                assert len(r['lattice_full_data_nodes']) == 15
            for j in r['judges']:
                assert j['returncode'] == 0 and 'PASS ' in j['output']
            passes.append(dict(file=p.name.replace('.validation.json', '.s'), **r))
    counts = Counter(r['status'] for r in runs)
    summary = dict(counts=dict(counts), runs=runs, proofs=proofs, passes=passes,
                   sources={str(p.relative_to(HERE)): hashlib.sha256(p.read_bytes()).hexdigest()
                            for p in sorted((HERE/'src').glob('partial_*.py'))})
    (OUT/'summary.json').write_text(json.dumps(summary, indent=2)+'\n')
    accepted = sum(r['verified'] for r in proofs)
    status = (f'The separate checker accepted {accepted} of {len(proofs)} UNSAT '
              'certificates. ')
    failed = [Path(r['file']).stem for r in proofs if not r['verified']]
    if failed:
        status += ('Certificate verification remains incomplete for: ' + ', '.join(failed) +
                   '. These entries retain their solver UNSAT status.\n')
    else:
        assert accepted == counts['UNSATISFIABLE']
        status += ('Every saved UNSAT formula therefore has an accepted certificate. '
                   'This checks the formula result. It does not certify the encoder '
                   'or establish the general A15 claim.\n')
    status += ('The checker records are `round2/proof_checks.json` and '
               '`round2/*.proofcheck.json`. The first checker pass used a 90-second '
               'limit. Incomplete checks were retried with a 300-second limit.\n\n')
    status += ('The new strict PASS files are listed below. Each row passed both '
               '`--strict --model out` and `--strict --model mem`. The associated '
               '`.validation.json` file contains the complete judge output. '
               f'There are {2*len(passes)} new PASS records.\n\n')
    status += '| n | out file | memory file | k | memory length |\n|---|---|---|---:|---:|\n'
    for r in passes:
        out, mem = r['judges']
        status += (f'| {r["n"]} | `{Path(out["file"]).resolve().relative_to(HERE)}` | '
                   f'`{Path(mem["file"]).resolve().relative_to(HERE)}` | {r["k"]} | '
                   f'{r["k"]+2*r["n"]} |\n')
    status += ('\nFor `round2/n4_k20_partial_normalized.s`, replace three writes in '
               'the synthesized partial program with `mov`: `cmovle P1, P2`, '
               '`cmovg S1, P3`, and `cmovge S2, P0`. The result has 15 full lattice '
               'written columns on all 75 weak orders. It keeps k = 20 and five '
               'comparisons. Both strict judge checks passed. This is one more '
               'finite rewrite example, not a rewrite theorem.\n\n'
               '`round2/summary.json` lists all 25 solver records, all certificate '
               'records, all new PASS paths, and source hashes.\n')
    target = HERE/'RESULTS.md'
    text = target.read_text()
    placeholder = 'Certificate verification status and the complete new PASS list follow below.'
    assert placeholder in text
    target.write_text(text.replace(placeholder, status.rstrip()))
    readme = ['# Round 2: A15 SAT records', '',
              'All runs used one CPU job at nice level 19. Run every command serially.', '',
              'The strongest sort4 query can be reproduced with:', '', '```sh',
              'nice -n 19 python3 src/partial_sat.py --n 4 --k 19 --c 5 --mode full --origin --cases strict --network 01,23,02,13,12 --tag /tmp/w10_n4 --timeout 240 --proof',
              'nice -n 19 /path/to/repo/bin/drat-trim /tmp/w10_n4.cnf /tmp/w10_n4.drat -t 600',
              '```', '',
              '`full` permits undefined and non-lattice columns. It does not require a partial witness.',
              'Comparisons and outputs must be defined. The five flag columns are fixed.',
              'A flag column specifies comparison outcomes, not comparison operands.', '',
              'Each query has a JSON parameter record, CNF, solver log, and DRAT file.',
              'Only UNSAT queries have UNSAT certificates. SAT and UNKNOWN DRAT files are incomplete traces.',
              'Each SAT program has a validation JSON file with both strict judge outputs.',
              'Each UNSAT certificate check has a proofcheck JSON file and log.', '',
              '| query | status | elapsed seconds |', '|---|---|---:|']
    for r in runs:
        readme.append(f'| {r["name"]} | {r["status"]} | {r["elapsed_seconds"]:.3f} |')
    (OUT/'README.md').write_text('\n'.join(readme)+'\n')
    print(json.dumps(dict(counts=dict(counts), certificates_accepted=accepted,
                          certificates=len(proofs), strict_pass_records=2*len(passes))))


if __name__ == '__main__':
    main()
