"""Retry unresolved five-position windows with external Kissat, smallest first.

Every child has a 3 GiB address-space limit. Only one child runs at a time.
A checked UNSAT certificate excludes the recorded eight-register window.
Every limit is UNKNOWN. A program must pass the strict reference judge.
"""
import argparse
from collections import Counter
import json
import os
from pathlib import Path
import time

from round2 import ROOT, CHECKER, digest
from round3 import run_child
from search import OPS, emit

PROJECT = ROOT.parents[3]
KISSAT = str(PROJECT / 'bin/kissat')


def events(path):
    rows = []
    for line in Path(path).read_text().splitlines():
        try:
            rows.append(json.loads(line))
        except ValueError:
            pass
    return rows


def prepare():
    selection = json.loads(Path('round3/selection.json').read_text())
    prior = json.loads(Path('round3/final_summary.json').read_text())
    unknown = {tuple(w) for w in prior['penta']['unknown_windows']}
    jobs = []
    for index, window in enumerate(selection['windows']):
        if tuple(window) not in unknown:
            continue
        prefix = f'round4/penta_{index:04d}'
        meta = Path(prefix + '.s.mapping.json')
        command = ['nice', '-n', '19', 'python3', '-B', 'src/search.py',
                   'seeds/near31.s', prefix + '.s', '--changes', '0',
                   '--registers', '8', '--free', ','.join(map(str, window)),
                   '--initial', '120', '--binary', '--export-only']
        if not meta.exists():
            child = run_child(command, prefix + '.generate', 120)
            assert child['exit'] == 0, (index, child)
            metadata = json.loads(meta.read_text())
            metadata['generation_resources'] = child
            metadata['generation_command'] = command
            metadata['initial_cnf_sha256'] = digest(prefix + '.s.cnf')
            meta.write_text(json.dumps(metadata, indent=2) + '\n')
        metadata = json.loads(meta.read_text())
        assert metadata['free'] == window and metadata['registers'] == 8
        assert len(metadata['cases']) == 128
        jobs.append({'index': index, 'window': window,
                     'variables': metadata['variables'], 'clauses': metadata['clauses'],
                     'cnf_bytes': Path(prefix + '.s.cnf').stat().st_size,
                     'prefix': prefix})
        print(json.dumps({'step': 'prepared', **jobs[-1]}), flush=True)
    jobs.sort(key=lambda j: (j['clauses'], j['variables'], j['index']))
    assert len(jobs) == 161
    result = {'jobs': jobs, 'ordering': ['initial clause count', 'initial variable count', 'prior window index'],
              'prior_summary_sha256': digest('round3/final_summary.json'),
              'prior_selection_sha256': digest('round3/selection.json'),
              'registers': 8, 'new_registers': 1, 'initial_cases': 128,
              'assumptions': ['G1', 'G2', 'G3', 'G4', 'A2', 'A11']}
    Path('round4/selection.json').write_text(json.dumps(result, indent=2) + '\n')
    return result


def decode(metadata, log):
    model = {int(v) for line in Path(log).read_text().splitlines()
             if line.startswith('v ') for v in line.split()[1:] if int(v) > 0}
    program = []
    literals = []
    for op, d, s in zip(metadata['op'], metadata['d'], metadata['s']):
        selected_op = [o for o, lit in op.items() if lit in model]
        selected_d = [r for r, lit in enumerate(d) if type(lit) is int and lit in model]
        selected_s = [r for r, lit in enumerate(s) if type(lit) is int and lit in model]
        assert len(selected_op) == len(selected_d) == len(selected_s) == 1
        o, dr, sr = selected_op[0], selected_d[0], selected_s[0]
        program.append((OPS.index(o), dr, sr))
        literals.extend([op[o], d[dr], s[sr]])
    witnesses = []
    for row in metadata['osnap']:
        selected = [x for x, lit in enumerate(row) if lit in model]
        assert len(selected) == 1
        x = selected[0]
        witnesses.append((-1, x) if x < 5 else (x - 5, program[x - 5][1]))
        literals.append(row[x])
    return program, witnesses, literals, model


def check_model(cnf, model):
    # Kissat prints a total assignment unless explicitly told otherwise.
    with open(cnf) as stream:
        for line in stream:
            if line.startswith(('p', 'c')):
                continue
            clause = [int(x) for x in line.split()[:-1]]
            assert any((x in model if x > 0 else -x not in model) for x in clause)


def block_mapping(cnf, literals):
    path = Path(cnf)
    temporary = path.with_suffix('.rewrite')
    with path.open() as inp, temporary.open('w') as out:
        header = inp.readline().split()
        out.write(f'p cnf {header[2]} {int(header[3]) + 1}\n')
        for line in inp:
            out.write(line)
        out.write(' '.join(str(-x) for x in literals) + ' 0\n')
    temporary.replace(path)


def solve(job, seconds):
    prefix = job['prefix']
    cnf = prefix + '.s.cnf'
    proof = prefix + '.drat'
    metadata = json.loads(Path(prefix + '.s.mapping.json').read_text())
    result = {**job, 'registers': 8, 'limit_seconds': seconds, 'status': 'UNKNOWN',
              'attempts': [], 'blocked_mappings': 0, 'strict_judge_calls': 0,
              'initial_cnf_sha256': metadata['initial_cnf_sha256']}
    # On resume, recover only judged-invalid output mappings. Never block all
    # snapshots merely because one selected output mapping failed the judge.
    remaining = seconds
    iteration = 0
    while remaining > 0:
        step = prefix + f'.solve{iteration:03d}'
        command = ['nice', '-n', '19', KISSAT, '-f', cnf, proof]
        print(json.dumps({'step': 'start', **job, 'remaining_seconds': remaining}), flush=True)
        child = run_child(command, step, remaining)
        result['attempts'].append({'command': command, **child, 'log': step + '.log'})
        remaining -= child['seconds']
        if child['limited']:
            result['reason'] = 'wall limit'
            break
        if child['exit'] == 20:
            result['solver_status'] = 'UNSAT'
            checked = run_child(['nice', '-n', '19', CHECKER, cnf, proof],
                                prefix + '.verify', max(900, seconds))
            result['verification'] = checked
            result['proof_verified'] = checked['exit'] == 0 and 's VERIFIED' in Path(prefix + '.verify.log').read_text()
            result['status'] = 'UNSAT' if result['proof_verified'] else 'UNKNOWN'
            result['cnf_sha256'] = digest(cnf)
            result['drat_sha256'] = digest(proof)
            break
        if child['exit'] != 10:
            result['reason'] = f"Kissat exit {child['exit']}"
            break
        program, witnesses, literals, model = decode(metadata, step + '.log')
        check_model(cnf, model)
        candidate = prefix + f'.candidate{iteration:03d}.s'
        emit(program, witnesses, candidate)
        judged = run_child(['nice', '-n', '19', 'python3', '-B', str(PROJECT / 'shared/judge.py'),
                            candidate, '--strict', '--model', 'out'], candidate + '.judge', 120)
        result['strict_judge_calls'] += 1
        if judged['exit'] == 0 and 'PASS ' in Path(candidate + '.judge.log').read_text():
            result.update(status='PASS', file=candidate, judge=judged)
            break
        if judged['limited'] or judged['exit'] == 0:
            result['reason'] = 'Unresolved reference judge result'
            break
        assert 'FAIL' in Path(candidate + '.judge.log').read_text()
        block_mapping(cnf, literals)
        result['blocked_mappings'] += 1
        iteration += 1
    result['search_seconds'] = sum(r['seconds'] for r in result['attempts'])
    result['peak_KiB'] = max([r['peak_KiB'] for r in result['attempts']] +
                             [result.get('verification', {}).get('peak_KiB', 0)])
    Path(prefix + '.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({'step': 'finished', **result}), flush=True)
    return result


def report():
    selection = json.loads(Path('round4/selection.json').read_text())
    rows = [json.loads(p.read_text()) for p in sorted(Path('round4').glob('penta_[0-9][0-9][0-9][0-9].json'))]
    prior = json.loads(Path('round3/final_summary.json').read_text())
    statuses = Counter(r['status'] for r in rows)
    closed = sum(r['status'] == 'UNSAT' and r.get('proof_verified') for r in rows)
    result = {'selected_retries': len(selection['jobs']), 'completed_retries': len(rows),
              'pending_retries': len(selection['jobs']) - len(rows), 'retry_statuses': dict(statuses),
              'new_checked_UNSAT': closed, 'combined_checked_UNSAT': prior['penta']['checked_UNSAT'] + closed,
              'combined_unresolved': 161 - closed - statuses['PASS'],
              'search_seconds': sum(r['search_seconds'] for r in rows),
              'verify_seconds': sum(r.get('verification', {}).get('seconds', 0) for r in rows),
              'peak_KiB': max((r['peak_KiB'] for r in rows), default=0),
              'strict_judge_calls': sum(r['strict_judge_calls'] for r in rows),
              'blocked_mappings': sum(r['blocked_mappings'] for r in rows),
              'strict_PASS_files': [r['file'] for r in rows if r['status'] == 'PASS'],
              'assumptions': selection['assumptions']}
    Path('round4/summary.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({'step': 'summary', **result}), flush=True)
    return result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--prepare-only', action='store_true')
    parser.add_argument('--report', action='store_true')
    parser.add_argument('--seconds', type=float, default=900)
    parser.add_argument('--count', type=int, default=100000)
    args = parser.parse_args()
    os.chdir(ROOT)
    Path('round4').mkdir(exist_ok=True)
    if args.report:
        report()
        return
    selection = json.loads(Path('round4/selection.json').read_text()) if Path('round4/selection.json').exists() else prepare()
    if args.prepare_only:
        return
    count = 0
    for job in selection['jobs']:
        if Path(job['prefix'] + '.json').exists():
            continue
        result = solve(job, args.seconds)
        report()
        count += 1
        if result['status'] == 'PASS' or count >= args.count:
            break


if __name__ == '__main__':
    main()
