"""Data-flow five-position windows and 30-minute four-position retries.

One child runs at a time. Every child has a 3 GiB address-space limit.
Every timeout is UNKNOWN. An UNSAT claim requires a checked certificate.
"""
import argparse
from collections import Counter
import itertools
import json
import os
from pathlib import Path
import signal
import subprocess
import time

from round2 import ROOT, CHECKER, digest, setup


def select():
    prior = json.loads(Path('round2/final_summary.json').read_text())
    unresolved = prior['unknown_windows']
    families = {}
    families['unresolved_quad_plus_anywhere'] = sorted({
        tuple(sorted((*w, i))) for w in unresolved for i in range(31) if i not in w})
    families['alternate_median_route_plus_anywhere'] = sorted({
        tuple(sorted((14, 18, 21, 29, i))) for i in range(31) if i not in (14, 18, 21, 29)})
    # All failing inputs lose copies of the median at positions 6, 15, 23.
    # Alter these three writes and two instructions in the median route.
    route = [12, 14, 18, 19, 21, 25, 27, 28, 29]
    families['all_three_median_losses_plus_two_route_positions'] = sorted({
        tuple(sorted((6, 15, 23, *pair))) for pair in itertools.combinations(route, 2)})
    families['median_copy_and_selector_rewrite_plus_anywhere'] = sorted({
        tuple(sorted((14, 15, 18, 21, i))) for i in range(31) if i not in (14, 15, 18, 21)})
    families['final_median_dataflow_five_of_seven'] = list(itertools.combinations([19, 21, 23, 25, 27, 28, 29], 5))
    seen = set()
    windows = []
    counts = []
    for name, family in families.items():
        added = [list(w) for w in family if w not in seen]
        windows.extend(added)
        seen.update(family)
        counts.append({'family': name, 'raw_windows': len(family), 'distinct_added': len(added)})
    result = {'seed': 'seeds/near31.s', 'seed_sha256': digest('seeds/near31.s'),
              'registers': 8, 'new_registers': 1, 'zero_based_positions': True,
              'quad_retry_windows': unresolved, 'windows': windows, 'families': counts,
              'selected_windows': len(windows), 'assumptions': ['G1', 'G2', 'G3', 'G4', 'A2', 'A11'],
              'scope': 'Five arbitrary substitutions in selected non-contiguous windows; eight registers; free output snapshots; top-scratch relaxation.'}
    assert len(seen) == len(windows)
    assert all(len(set(w)) == 5 and w[-1] - w[0] > 4 for w in windows)
    Path('round3/selection.json').write_text(json.dumps(result, indent=2) + '\n')
    return result


def run_child(command, prefix, seconds):
    began = time.monotonic()
    wrapped = ['/usr/bin/time', '-v', '-o', prefix + '.resources.log', *command]
    with open(prefix + '.log', 'w') as stream:
        child = subprocess.Popen(wrapped, stdout=stream, stderr=subprocess.STDOUT, preexec_fn=setup)
        limited = False
        peak_kib = 0
        heartbeat = began
        while True:
            # Read the kernel's high-water marks before a timed-out process
            # exits. GNU time can itself receive the process-group signal.
            pending = [child.pid]
            descendants = []
            while pending:
                pid = pending.pop()
                if pid != child.pid:
                    descendants.append(pid)
                try:
                    pending.extend(map(int, Path(f'/proc/{pid}/task/{pid}/children').read_text().split()))
                    fields = dict(line.split(':', 1) for line in Path(f'/proc/{pid}/status').read_text().splitlines() if ':' in line)
                    peak_kib = max(peak_kib, int(fields.get('VmHWM', '0 kB').split()[0]))
                except (FileNotFoundError, ProcessLookupError):
                    pass
            remaining = seconds - (time.monotonic() - began)
            if remaining <= 0:
                # Keep GNU time alive so it writes the timeout's CPU and
                # memory counters. Terminate every process below it.
                for pid in reversed(descendants):
                    try:
                        os.kill(pid, signal.SIGTERM)
                    except ProcessLookupError:
                        pass
                try:
                    child.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    os.killpg(child.pid, signal.SIGTERM)
                    child.wait()
                limited = True
                break
            try:
                child.wait(timeout=min(5, remaining))
                break
            except subprocess.TimeoutExpired:
                if time.monotonic() - heartbeat >= 50:
                    print(json.dumps({'step': 'heartbeat', 'job': prefix, 'elapsed_seconds': round(time.monotonic() - began, 1), 'sampled_peak_KiB': peak_kib}), flush=True)
                    heartbeat = time.monotonic()
    resource_log = Path(prefix + '.resources.log')
    counters = {}
    if resource_log.exists():
        for line in resource_log.read_text().splitlines():
            if 'Maximum resident set size' in line:
                peak_kib = max(peak_kib, int(line.split(':')[-1].strip()))
            for label, key in [('User time (seconds)', 'user_seconds'), ('System time (seconds)', 'system_seconds')]:
                if label in line:
                    counters[key] = float(line.split(':')[-1].strip())
    return {'exit': child.returncode, 'limited': limited, 'seconds': time.monotonic() - began, 'peak_KiB': peak_kib, **counters}


def execute(kind, index, window, args):
    prefix = f'round3/{kind}_{index:04d}_{args.attempt}'
    output = prefix + '.s'
    command = ['nice', '-n', '19', 'python3', '-B', 'src/search.py', 'seeds/near31.s', output,
               '--changes', '0', '--registers', '8', '--free', ','.join(map(str, window)),
               '--proof', '--initial', str(args.initial)]
    if args.all_cases:
        command.append('--all-cases')
    if args.binary:
        command.append('--binary')
    print(json.dumps({'step': 'start', 'kind': kind, 'index': index, 'window': window, 'limit_seconds': args.seconds}), flush=True)
    child = run_child(command, prefix, args.seconds)
    records = []
    for line in Path(prefix + '.log').read_text().splitlines():
        try:
            records.append(json.loads(line))
        except json.JSONDecodeError:
            pass
    final = next((r for r in reversed(records) if 'status' in r), None)
    status = final['status'] if final and final['status'] in ('UNSAT', 'PASS') else 'UNKNOWN' if child['limited'] else 'ERROR'
    result = {'kind': kind, 'index': index, 'window': window, 'attempt': args.attempt,
              'status': status, 'registers': 8, 'limit_seconds': args.seconds,
              'search_seconds': child['seconds'], 'peak_KiB': child['peak_KiB'], 'exit': child['exit'], 'command': command,
              'solver_result': final, 'blocked_rejected_candidates': sum(r.get('step') == 'candidate' and not r.get('added', []) for r in records)}
    result['search_resource_counters'] = child
    if status == 'UNSAT':
        check = run_child(['nice', '-n', '19', CHECKER, output + '.cnf', output + '.drat'], prefix + '.verify', max(120, args.seconds))
        result['proof_verified'] = check['exit'] == 0 and 's VERIFIED' in Path(prefix + '.verify.log').read_text()
        result['verify_seconds'] = check['seconds']
        result['verify_peak_KiB'] = check['peak_KiB']
        result['cnf_sha256'] = digest(output + '.cnf')
        result['drat_sha256'] = digest(output + '.drat')
    Path(prefix + '.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result), flush=True)
    return result


def summary(selection):
    rows = [json.loads(p.read_text()) for p in sorted(Path('round3').glob('*_[0-9][0-9][0-9][0-9]_*.json'))]
    best = {}
    for row in rows:
        key = (row['kind'], row['index'])
        if key not in best or best[key]['status'] not in ('UNSAT', 'PASS'):
            best[key] = row
    result = {'attempts': len(rows), 'attempt_statuses': dict(Counter(r['status'] for r in rows)),
              'search_seconds': sum(r['search_seconds'] for r in rows),
              'verify_seconds': sum(r.get('verify_seconds', 0) for r in rows),
              'peak_KiB': max((max(r.get('peak_KiB', 0), r.get('verify_peak_KiB', 0)) for r in rows), default=0),
              'blocked_rejected_candidates': sum(r['blocked_rejected_candidates'] for r in rows),
              'assumptions': ['A2', 'A11'], 'strict_PASS_files_new': []}
    for kind, selected in [('quad', selection['quad_retry_windows']), ('penta', selection['windows'])]:
        these = [r for (k, i), r in best.items() if k == kind]
        result[kind] = {'selected': len(selected), 'processed': len(these),
                        'pending': len(selected) - len(these),
                        'statuses': dict(Counter(r['status'] for r in these)),
                        'checked_UNSAT': sum(r.get('proof_verified', False) for r in these),
                        'unknown_windows': [r['window'] for r in these if r['status'] == 'UNKNOWN']}
    result['source_hashes'] = {p: digest(p) for p in ['src/round3.py', 'src/search.py', 'src/rank_encode.py', 'src/binary_encode.py', 'src/encode.py']}
    Path('round3/summary.json').write_text(json.dumps(result, indent=2) + '\n')
    return best, result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--kind', choices=['quad', 'penta'], default='penta')
    parser.add_argument('--seconds', type=float, default=15)
    parser.add_argument('--attempt', type=int, default=0)
    parser.add_argument('--initial', type=int, default=16)
    parser.add_argument('--all-cases', action='store_true')
    parser.add_argument('--binary', action='store_true')
    parser.add_argument('--retry', action='store_true')
    parser.add_argument('--count', type=int, default=100000)
    parser.add_argument('--select-only', action='store_true')
    parser.add_argument('--indices', help='Optional comma-separated indices; selection and scope do not change.')
    args = parser.parse_args()
    os.chdir(ROOT)
    Path('round3').mkdir(exist_ok=True)
    selection = select()
    best, result = summary(selection)
    print(json.dumps({'step': 'summary', **result}), flush=True)
    if args.select_only:
        return
    windows = selection['quad_retry_windows'] if args.kind == 'quad' else selection['windows']
    count = 0
    selected_indices = set(map(int, args.indices.split(','))) if args.indices else set(range(len(windows)))
    for index, window in enumerate(windows):
        if index not in selected_indices:
            continue
        if Path(f'round3/{args.kind}_{index:04d}_{args.attempt}.json').exists():
            continue
        old = best.get((args.kind, index))
        if old and (not args.retry or old['status'] != 'UNKNOWN'):
            continue
        if args.retry and not old:
            continue
        result = execute(args.kind, index, window, args)
        summary(selection)
        count += 1
        if result['status'] == 'PASS' or count >= args.count:
            break


if __name__ == '__main__':
    main()
