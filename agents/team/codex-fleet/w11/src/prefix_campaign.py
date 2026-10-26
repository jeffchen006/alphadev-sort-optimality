#!/usr/bin/env python3
"""Persistent independent C2 prefix queue, with at most four CPU workers.

The first-data prefix partition has 5 + 4*5*5 = 105 leaves per c.
After a conflict budget, a binary selector split replaces an unresolved leaf.
State saves make every incomplete case explicit and permit a safe restart.
"""
import argparse
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor, wait, FIRST_COMPLETED
import contextlib
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parents[1]
sys.setrecursionlimit(10000)


def stamp():
    return datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')


def roots(meta):
    n = meta['config']['n']
    result = []
    for op in range(5):
        for source in range(n):
            for dest in ([None] if op == 0 else range(n)):
                name = f'o{op}s{source}'+('' if dest is None else f'd{dest}')
                units = [meta['op'][0][op], meta['src'][0][source]]
                if dest is not None:
                    units.append(meta['dst'][0][dest])
                result.append(dict(name=name, root=name, units=units, depth=0))
    return result


def selectors(meta):
    # Program decisions only. Values, shapes, and exception tags are absent.
    result = []
    for i in range(len(meta['op'])):
        for key in ('op', 'src', 'dst', 'block'):
            result.extend(meta[key][i])
    for pair in meta['comparands'][1:]:
        for row in pair:
            result.extend(row)
    for row in meta['outputs']:
        result.extend(row)
    return result


def selector_closure(meta, units, extra=()):
    """Use only explicit one-hot and mov/fresh constraints for split choice."""
    known = set(units) | set(extra)
    groups = [row for key in ('op', 'src', 'dst', 'block', 'outputs')
              for row in meta[key]]
    groups.extend(row for pair in meta['comparands'] for row in pair)
    known.add(meta['comparands'][0][0][0])
    known.add(meta['comparands'][0][1][1])
    if meta['config']['useful']:
        known.add(meta['block'][0][0])
    previous = -1
    while len(known) != previous:
        previous = len(known)
        for row in groups:
            positives = [x for x in row if x in known]
            if positives:
                known.update(-x for x in row if x != positives[0])
            elif sum(-x in known for x in row) == len(row)-1:
                known.update(x for x in row if -x not in known)
        for op, dst in zip(meta['op'], meta['dst']):
            mov, fresh = op[0], dst[-1]
            if mov in known or fresh in known:
                known.update((mov, fresh))
            if -mov in known or -fresh in known:
                known.update((-mov, -fresh))
    return known


def report(state, path, append=False):
    counts = {}
    for r in state['nodes'].values():
        counts[r['status']] = counts.get(r['status'], 0)+1
    summary = dict(time=stamp(), c=state['c'], nodes=counts,
                   decided=counts.get('UNSAT_VERIFIED', 0)+counts.get('SAT_JUDGE_PASS', 0),
                   remaining=counts.get('PENDING', 0)+counts.get('RUNNING', 0),
                   unresolved_budget_cases=counts.get('SPLIT_REQUIRED', 0),
                   roots=len(state['roots']), complete=False)
    summary['unknown'] = summary['remaining']+summary['unresolved_budget_cases']
    def closed(name):
        node = state['nodes'][name]
        if node['status'] == 'UNSAT_VERIFIED':
            return True
        if node['status'] == 'BRANCHED':
            return all(closed(ch) for ch in node['children'])
        return False
    summary['closed_roots'] = sum(closed(r) for r in state['roots'])
    summary['complete'] = summary['closed_roots'] == len(state['roots'])
    state['summary'] = summary
    tmp = path.with_suffix('.new')
    tmp.write_text(json.dumps(state)+'\n')
    tmp.replace(path)
    if append:
        with (HERE/'RESULTS.md').open('a') as out:
            out.write(f"\n{stamp()}: c={state['c']} cases decided {summary['decided']} / "
                      f"remaining {summary['remaining']} / "
                      f"unknown {summary['unknown']}; "
                      f"closed prefix roots {summary['closed_roots']}/{summary['roots']}.\n")
    return summary


def work(base, directory, node, budget):
    if node.get('unlimited'):
        budget = 0
    tag = directory/node['name']
    command = [sys.executable, '-u', str(HERE/'src/certify_c2.py'),
               '--base', str(base), '--tag', str(tag),
               '--units='+','.join(map(str, node['units'])),
               '--conflicts', str(budget), '--clean']
    with Path(str(tag)+'.log').open('w') as out:
        p = subprocess.run(command, stdout=out, stderr=subprocess.STDOUT)
    if p.returncode:
        return dict(status='ERROR', returncode=p.returncode,
                    log=str(tag)+'.log')
    return json.loads(Path(str(tag)+'.json').read_text())


def persistent_work(base, directory, node, budget):
    """Cache only parsed immutable base clauses. Start a fresh proof per cube."""
    from certify_c2 import solve
    import resource
    import traceback
    resource.setrlimit(resource.RLIMIT_AS, (6 << 30, 6 << 30))
    override = directory/'budget.json'
    if node.get('unlimited'):
        budget = 0
    if budget and override.exists():
        budget = int(json.loads(override.read_text())['conflicts'])
    tag = directory/node['name']
    with Path(str(tag)+'.log').open('w') as out:
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(out):
            try:
                return solve(base, tag, node['units'], budget, clean=True, cache=True)
            except Exception:
                traceback.print_exc()
                return dict(status='ERROR', log=str(tag)+'.log')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--c', type=int, required=True)
    ap.add_argument('--workers', type=int, default=4)
    ap.add_argument('--conflicts', type=int, default=2000)
    ap.add_argument('--max-jobs', type=int, default=0)
    ap.add_argument('--base')
    ap.add_argument('--directory')
    ap.add_argument('--order', choices=['breadth', 'depth'], default='breadth')
    ap.add_argument('--persistent', action='store_true')
    args = ap.parse_args()
    assert 1 <= args.workers <= 4
    if os.getpriority(os.PRIO_PROCESS, 0) < 10:
        os.nice(10-os.getpriority(os.PRIO_PROCESS, 0))
    base = Path(args.base) if args.base else HERE/f'independent/base/c{args.c}'
    if not Path(str(base)+'.json').exists():
        subprocess.run([sys.executable, str(HERE/'src/independent_c2.py'),
                        '--c', str(args.c), '--tag', str(base)], check=True)
    meta = json.loads(Path(str(base)+'.json').read_text())
    directory = (Path(args.directory) if args.directory else
                 HERE/f'independent/cases/c{args.c}')
    directory.mkdir(parents=True, exist_ok=True)
    path = directory/'state.json'
    if path.exists():
        state = json.loads(path.read_text())
        assert state['base_sha256'] == meta['cnf_sha256'], 'Base changed; use a new directory.'
        for node in state['nodes'].values():
            if node['status'] == 'RUNNING':
                node['status'] = 'PENDING'
    else:
        rs = roots(meta)
        state = dict(c=args.c, base=str(base), base_sha256=meta['cnf_sha256'],
                     roots=[n['name'] for n in rs], nodes={
                         n['name']: dict(n, status='PENDING') for n in rs})
    split_order = selectors(meta)
    futures = {}
    jobs = 0
    last_report = time.monotonic()
    pool_type = ProcessPoolExecutor if args.persistent else ThreadPoolExecutor
    worker = persistent_work if args.persistent else work
    with pool_type(args.workers) as pool:
        while True:
            pending = sorted((n for n in state['nodes'].values()
                              if n['status'] == 'PENDING'),
                             key=lambda n: (n['depth'] if args.order == 'breadth'
                                            else -n['depth'], n['name']))
            while pending and len(futures) < args.workers:
                if args.max_jobs and jobs >= args.max_jobs:
                    break
                node = pending.pop(0)
                node['status'] = 'RUNNING'
                futures[pool.submit(worker, base, directory, node,
                                    args.conflicts)] = node['name']
                jobs += 1
            report(state, path)
            if not futures:
                break
            ready, _ = wait(futures, timeout=30, return_when=FIRST_COMPLETED)
            for future in ready:
                name = futures.pop(future)
                node = state['nodes'][name]
                rec = future.result()
                node['result'] = str(directory/(name+'.json'))
                node['status'] = rec['status']
                if rec['status'] == 'SPLIT':
                    implied = selector_closure(meta, node['units'],
                                               rec.get('implied_selectors', []))
                    lit = next((x for x in split_order
                                if x not in implied and -x not in implied), None)
                    if lit is None:
                        node['status'] = 'PENDING'
                        node['unlimited'] = True
                        node['reason'] = 'All syntax selectors fixed; retry without budget.'
                    else:
                        node['status'] = 'BRANCHED'
                        node['split_literal'] = lit
                        node['children'] = []
                        for suffix, sign in [('a', 1), ('b', -1)]:
                            units = node['units']+[sign*lit]
                            digest = hashlib.sha256(','.join(map(str, units)).encode()).hexdigest()[:24]
                            child = node['root']+'_'+digest
                            assert child not in state['nodes']
                            node['children'].append(child)
                            state['nodes'][child] = dict(
                                name=child, root=node['root'], units=units,
                                depth=node['depth']+1, status='PENDING')
                print(json.dumps(dict(time=stamp(), case=name,
                                      status=node['status'],
                                      solver_seconds=rec.get('solver_seconds'),
                                      verified=rec.get('verified'))), flush=True)
                if rec['status'] in ('ERROR', 'SAT_JUDGE_PASS'):
                    # Finish in-flight work and preserve the queue for review.
                    args.max_jobs = jobs
            if time.monotonic()-last_report >= 7200:
                report(state, path, append=True)
                last_report = time.monotonic()
    print(json.dumps(report(state, path, append=True)), flush=True)


if __name__ == '__main__':
    main()
