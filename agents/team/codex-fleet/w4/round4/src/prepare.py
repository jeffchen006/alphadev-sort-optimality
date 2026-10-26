"""Resume exactly the final formulas of the 78 unknown round-3 queries."""
import hashlib
import itertools
import json
from pathlib import Path
import random

ROOT = Path(__file__).resolve().parents[2]
CASES = [x for x in itertools.product(range(5), repeat=5)
         if set(x) == set(range(max(x)+1))]


def main():
    tasks = []
    for batch in ('retry', 'frontier', 'variants_freeout', 'variants_broad'):
        rows = json.loads((ROOT/f'round3/logs/{batch}_summary.json').read_text())
        for row in rows:
            assert row['status'] in ('None', 'UNKNOWN'), row['tag']
            task = row['task'].copy()
            if task.get('all_cases'):
                cases = list(range(541))
            elif task.get('case_set') in ('binary', 'ternary'):
                maximum = 1 if task['case_set'] == 'binary' else 2
                cases = [i for i, x in enumerate(CASES) if max(x) <= maximum]
            elif task.get('case_set') == 'strict':
                cases = [i for i, x in enumerate(CASES) if len(set(x)) == 5]
            else:
                strict = [i for i, x in enumerate(CASES) if len(set(x)) == 5]
                cases = random.Random(task.get('random_seed', 0)).sample(strict, task.get('cases', 12))
            if task.get('case_file'):
                cases += json.loads((ROOT/task['case_file']).read_text())
            for record in row['records']:
                if record.get('phase') == 'refine':
                    cases += record['added']
            cases = list(dict.fromkeys(cases))
            final_build = next(r for r in reversed(row['records']) if r.get('phase') == 'built')
            assert len(cases) == final_build['cases']
            last = next(r for r in reversed(row['records']) if r.get('phase') == 'kissat_result')
            formula = ROOT/'round3/cnf'/f'{row["tag"]}.cnf'
            assert hashlib.sha256(formula.read_bytes()).hexdigest() == last['cnf_sha256']
            case_file = ROOT/'round4/logs'/f'{row["tag"]}_cases.json'
            case_file.write_text(json.dumps(cases)+'\n')
            task['case_file'] = str(case_file)
            task['seconds'] = 900
            tasks.append(dict(tag=row['tag'], task=task,
                              previous_formula_sha256=last['cnf_sha256'],
                              previous_cases=final_build['cases'],
                              previous_variables=final_build['variables'],
                              previous_clauses=final_build['clauses'],
                              phase_renaming=last.get('phase_renaming', False),
                              assumptions=['G1','G2','G3','G4','A2','A11']))
    assert len(tasks) == 78 and len({t['tag'] for t in tasks}) == 78
    # Start with the query that produced the smallest recorded failure count.
    tasks.sort(key=lambda t: (t['tag'] != 'variants_broad_v17',
                              not t['tag'].startswith('variants_broad'), t['tag']))
    (ROOT/'round4/logs/retry900_tasks.json').write_text(json.dumps(tasks, indent=2)+'\n')
    sources = ['search.py','rank_encode.py','encode.py','reference_window.py','analyze.py']
    hashes = {}
    provenance = ROOT/'round4/logs/w7_source_provenance.json'
    original_hashes = json.loads(provenance.read_text()) if provenance.exists() else {}
    for name in sources:
        source = ROOT.parent/'w7/src'/name
        copied = ROOT/'round4/src'/name
        original = copied.read_text()
        if name == 'search.py':
            original = original.replace('source=w4-copy-of-w7-exact', 'source=w7-exact')
            original = original.replace("['nice','-n','19','python3'", "['nice','-n','10','python3'")
        original_digest = hashlib.sha256(original.encode()).hexdigest()
        captured = original_hashes.get(name, original_digest)
        if isinstance(captured,dict):
            captured = captured['source_sha256']
        assert original_digest == captured, name
        hashes[name] = dict(source_sha256=original_digest,
                            current_upstream_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
                            copy_sha256=hashlib.sha256(copied.read_bytes()).hexdigest(),
                            adaptations=['output provenance comment','judge nice level 19']
                            if name == 'search.py' else [])
    (ROOT/'round4/logs/w7_source_provenance.json').write_text(json.dumps(hashes, indent=2)+'\n')
    print(json.dumps({'queries':len(tasks),'first':tasks[0]['tag'], 'limit_seconds':900,
                      'maximum_retry_wall_seconds':78*940}))


if __name__ == '__main__':
    main()
