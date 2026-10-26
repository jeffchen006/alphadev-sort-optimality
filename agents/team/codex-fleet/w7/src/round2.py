"""Select and run four-position repair searches on one CPU core.

The selection follows the nine failed orders. Every search uses eight registers.
The runner preserves formulas and checks UNSAT certificates before it reports
them as checked. A time limit is UNKNOWN.
"""
import argparse
from collections import Counter
import hashlib
import itertools
import json
import os
from pathlib import Path
import resource
import signal
import subprocess
import time

from analyze import parse

ROOT = Path(__file__).resolve().parents[1]
CHECKER = '/path/to/repo/agents/proofs/tools/bin/drat-trim'


def digest(path):
    h = hashlib.sha256()
    with open(path, 'rb') as f:
        for block in iter(lambda: f.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def select():
    code = [x for x in parse('seeds/near31.s') if x[0] != 'out']
    failures = json.loads(Path('artifacts/near_analysis.json').read_text())['failures']
    traces = []
    for failure in failures:
        x = failure['input']
        registers = {r: [9, set()] for _, d, s in code for r in (d, s)}
        registers.update({f'P{i}': [v, set()] for i, v in enumerate(x)})
        flag = 0
        flag_deps = set()
        median = sorted(x)[2]
        losses = []
        last = None
        for i, (op, d, s) in enumerate(code):
            a, da = registers[d]
            b, db = registers[s]
            if op == 'cmp':
                flag = (a > b) - (a < b)
                flag_deps = da | db | {i}
                continue
            takes = op == 'mov' or {'cmovl': flag < 0, 'cmovle': flag <= 0,
                                    'cmovg': flag > 0, 'cmovge': flag >= 0}.get(op, False)
            value = b if takes else a
            deps = (db if takes else da) | {i}
            if op != 'mov':
                deps |= flag_deps
            if a == median and value != median:
                losses.append(i)
            registers[d] = [value, deps]
            if i == 29:
                last = sorted(deps)
        traces.append({'input': x, 'median': median, 'median_loss_positions': losses,
                       'output2_dynamic_dependencies': last})
    cone = sorted(set().union(*(set(t['output2_dynamic_dependencies']) for t in traces)))
    losses = sorted(set().union(*(set(t['median_loss_positions']) for t in traces)))
    # The fixed prefix ends before the triple/pair merge. Keep its first 12
    # instructions. Choose the dynamic cone and every median-loss instruction
    # after that prefix. Each window must include a median-loss instruction.
    pool = sorted(p for p in set(cone) | set(losses) if p >= 12)
    windows = [list(w) for w in itertools.combinations(pool, 4)
               if set(w).intersection(losses) and w[-1] - w[0] > 3]
    # Search the final median branch first. This order does not change scope.
    windows.sort(key=lambda w: (-len(set(w) & {14, 17, 18, 21, 28, 29}),
                                -len(set(w) & set(losses)), w))
    tail_windows = len(windows)
    # Positions 15 and 23 erase the median from P3 and S1 in every failure.
    # Vary both loss points. Select two comparisons anywhere, or one median
    # route point (14, 18, 21) and one arbitrary core position.
    comparisons = {i for i, (op, _, _) in enumerate(code) if op == 'cmp'}
    loss_pair_windows = [tuple(sorted((15, 23, *pair)))
                         for pair in itertools.combinations([i for i in range(31) if i not in (15, 23)], 2)
                         if set(pair) <= comparisons or set(pair) & {14, 18, 21}]
    # The original median selector reads the copy at position 14 through 18.
    # Test these alternative routes even though the failing branch does not
    # read them. Let the fourth substitution occur anywhere in the core.
    route_windows = {tuple(sorted((*triple, i)))
                     for triple in ((14, 18, 21), (14, 21, 29))
                     for i in range(31) if i not in triple}
    seen = {tuple(w) for w in windows}
    windows.extend(list(w) for w in sorted(route_windows) if w not in seen)
    seen = {tuple(w) for w in windows}
    windows.extend(list(w) for w in loss_pair_windows if w not in seen)
    result = {'seed': 'seeds/near31.s', 'seed_sha256': digest('seeds/near31.s'),
              'registers': 8, 'new_registers': 1,
              'families': {'tail_dynamic_cone': tail_windows,
                           'both_loss_points_anywhere': len(loss_pair_windows),
                           'alternate_median_route_anywhere': len(route_windows),
                           'overlap': tail_windows + len(loss_pair_windows) + len(route_windows) - len(windows)},
              'tail_fixed_prefix_length': 12,
              'traces': traces, 'dependency_union': cone, 'loss_union': losses,
              'pool': pool, 'selected_windows': len(windows), 'windows': windows,
              'assumptions': ['G1', 'G2', 'G3', 'G4', 'A2', 'A11'],
              'scope': 'Four arbitrary substitutions at selected non-contiguous positions; eight registers; free output snapshots; top-scratch relaxation.'}
    Path('round2/selection.json').write_text(json.dumps(result, indent=2) + '\n')
    return result


def setup():
    os.setsid()
    resource.setrlimit(resource.RLIMIT_AS, (3 * 1024**3, 3 * 1024**3))


def execute(index, window, seconds, attempt, initial=16, all_cases=False, binary=False):
    name = f'quad_{index:04d}_{attempt}'
    prefix = f'round2/{name}'
    output = prefix + '.s'
    cmd = ['nice', '-n', '19', 'python3', '-B', 'src/search.py',
           'seeds/near31.s', output, '--changes', '0', '--registers', '8',
           '--free', ','.join(map(str, window)), '--proof', '--initial', str(initial)]
    if all_cases:
        cmd.append('--all-cases')
    if binary:
        cmd.append('--binary')
    began = time.monotonic()
    with open(prefix + '.log', 'w') as f:
        p = subprocess.Popen(cmd, stdout=f, stderr=subprocess.STDOUT, preexec_fn=setup)
        try:
            p.wait(timeout=seconds)
            status = 'ERROR'
        except subprocess.TimeoutExpired:
            os.killpg(p.pid, signal.SIGTERM)
            p.wait()
            status = 'UNKNOWN'
    records = []
    for line in Path(prefix + '.log').read_text().splitlines():
        try:
            records.append(json.loads(line))
        except json.JSONDecodeError:
            pass
    final = next((r for r in reversed(records) if 'status' in r), None)
    if final and final['status'] in ('UNSAT', 'PASS'):
        status = final['status']
    result = {'index': index, 'window': window, 'attempt': attempt,
              'status': status, 'registers': 8, 'limit_seconds': seconds,
              'search_seconds': time.monotonic() - began, 'exit': p.returncode,
              'command': cmd, 'solver_result': final,
              'blocked_rejected_candidates': sum(r.get('step') == 'candidate' and
                  not r.get('added', []) for r in records)}
    if status == 'UNSAT':
        cnf, proof = output + '.cnf', output + '.drat'
        began = time.monotonic()
        with open(prefix + '.verify.log', 'w') as f:
            checked = subprocess.run(['nice', '-n', '19', CHECKER, cnf, proof],
                                     stdout=f, stderr=subprocess.STDOUT,
                                     preexec_fn=setup, timeout=seconds + 60)
        result['proof_verified'] = checked.returncode == 0 and 's VERIFIED' in Path(prefix + '.verify.log').read_text()
        result['verify_seconds'] = time.monotonic() - began
        result['cnf_sha256'] = digest(cnf)
        result['drat_sha256'] = digest(proof)
    Path(prefix + '.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result), flush=True)
    return result


def summary(selection):
    by_index = {}
    rows = []
    for file in sorted(Path('round2').glob('quad_*.json')):
        row = json.loads(file.read_text())
        rows.append(row)
        old = by_index.get(row['index'])
        if not old or old['status'] not in ('UNSAT', 'PASS'):
            by_index[row['index']] = row
    result = {'selected': len(selection['windows']), 'attempts': len(rows),
              'attempt_statuses': dict(Counter(r['status'] for r in rows)),
              'processed_windows': len(by_index),
              'final_statuses': dict(Counter(r['status'] for r in by_index.values())),
              'checked_UNSAT_windows': sum(r.get('proof_verified', False) for r in by_index.values()),
              'pending': len(selection['windows']) - len(by_index),
              'unknown_windows': [r['window'] for r in by_index.values() if r['status'] == 'UNKNOWN'],
              'search_seconds': sum(r['search_seconds'] for r in rows),
              'verify_seconds': sum(r.get('verify_seconds', 0) for r in rows),
              'blocked_rejected_candidates': sum(r['blocked_rejected_candidates'] for r in rows),
              'source_hashes': {str(p): digest(p) for p in map(Path, ['src/round2.py', 'src/search.py', 'src/rank_encode.py', 'src/encode.py'])}}
    Path('round2/summary.json').write_text(json.dumps(result, indent=2) + '\n')
    return by_index, result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--seconds', type=float, default=15)
    parser.add_argument('--count', type=int, default=100000)
    parser.add_argument('--attempt', type=int, default=0)
    parser.add_argument('--initial', type=int, default=16)
    parser.add_argument('--all-cases', action='store_true')
    parser.add_argument('--binary', action='store_true')
    parser.add_argument('--retry', action='store_true')
    parser.add_argument('--select-only', action='store_true')
    args = parser.parse_args()
    os.chdir(ROOT)
    Path('round2').mkdir(exist_ok=True)
    selection = select()
    by_index, report = summary(selection)
    print(json.dumps({'selection': {k: selection[k] for k in ('pool', 'loss_union', 'selected_windows')},
                      'summary': report}), flush=True)
    if args.select_only:
        return
    count = 0
    for i, w in enumerate(selection['windows']):
        if Path(f'round2/quad_{i:04d}_{args.attempt}.json').exists():
            continue
        old = by_index.get(i)
        if old and (not args.retry or old['status'] != 'UNKNOWN'):
            continue
        if args.retry and not old:
            continue
        result = execute(i, w, args.seconds, args.attempt, args.initial, args.all_cases, args.binary)
        summary(selection)
        count += 1
        if result['status'] == 'PASS' or count >= args.count:
            break


if __name__ == '__main__':
    main()
