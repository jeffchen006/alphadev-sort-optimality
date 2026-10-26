#!/usr/bin/env python3
"""Cross-check completed d2 cases only. Preserve unfinished independent cubes."""
import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import subprocess
import sys
import time

from independent_c2 import sha
from peer_cases import discover, build, certify_cube_cover
from prefix_campaign import HERE

PEER = HERE.parent.parent/'d2-lattice/c2'


def stamp():
    return datetime.now(timezone.utc).isoformat()


def snapshot(records, unresolved):
    cases = []
    whole_cases = set()
    cube_groups = {}
    for record in records:
        path = HERE/'independent/crosscheck'/record['case']/'cubes/state.json'
        summary = json.loads(path.read_text())['summary'] if path.exists() else None
        cases.append(dict(case=record['case'], variant=record['variant'],
                          peer_record_sha256=record['peer_sha256'], summary=summary,
                          agreement=bool(summary and summary['complete'])))
        key = (record['variant'], record['c'], record['i'], record['j'])
        if cases[-1]['agreement']:
            if record['cube'] is None:
                whole_cases.add(key)
            else:
                parent = record['case'].rsplit('_q', 1)[0]
                cube_groups.setdefault((key, parent), set()).add(record['cube'])
    for (key, parent), indices in cube_groups.items():
        cube_path = PEER/'cubes'/(parent+'.json')
        cubes = json.loads(cube_path.read_text())
        if indices == set(range(len(cubes['cubes']))):
            cover = HERE/'independent/crosscheck/covers'/parent/'cover_answer.json'
            if cover.exists():
                proof = json.loads(cover.read_text())
                assert proof['status'] == 'UNSAT_VERIFIED' and proof['verified']
                assert proof['config']['peer_cube_sha256'] == sha(cube_path)
                whole_cases.add(key)
    expected = {(variant,c,i,j) for variant, start in [('v1',9),('v2',7)]
                for c in range(start,16) for i in range(32-c) for j in range(i,32-c)
                if i < j or i == j == 31-c}
    assert len(expected) == 3280 and whole_cases <= expected
    closed = len(whole_cases)
    result = dict(time=stamp(), expected_position_cases=len(expected),
                  peer_records_available=len(records),
                  independently_checked_records=sum(case['agreement'] for case in cases),
                  decided=closed, remaining=len(expected)-closed, unknown=len(expected)-closed,
                  uncompleted_peer_records=len(unresolved), cases=cases,
                  external_limit='Peer cases absent from results are not cross-checked.')
    target = HERE/'independent/crosscheck_status.json'
    tmp = target.with_suffix('.new')
    tmp.write_text(json.dumps(result, indent=2)+'\n')
    tmp.replace(target)
    return result


def append_progress(status):
    with (HERE/'RESULTS.md').open('a') as out:
        out.write(f"\n{status['time']}: completed-peer cross-check cases decided "
                  f"{status['decided']} / remaining {status['remaining']} / "
                  f"unknown {status['unknown']}; available peer records {status['peer_records_available']}. "
                  'Absent peer decisions remain an external limit.\n')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--workers', type=int, default=4)
    ap.add_argument('--seconds', type=int, default=0,
                    help='Stop after this observation interval; zero keeps watching.')
    ap.add_argument('--batch-jobs', type=int, default=16)
    ap.add_argument('--conflicts', type=int, default=10000)
    args = ap.parse_args()
    assert 1 <= args.workers <= 4
    if os.getpriority(os.PRIO_PROCESS, 0) < 10:
        os.nice(10-os.getpriority(os.PRIO_PROCESS, 0))
    started = last_progress = time.monotonic()
    last_signature = None
    # This lock also prevents two watchers from writing the same case tree.
    import fcntl
    lock = (HERE/'independent/peer_watch.lock').open('w')
    fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    while True:
        records, unresolved = discover(PEER)
        status = snapshot(records, unresolved)
        signature = (status['peer_records_available'], status['decided'], status['unknown'])
        if signature != last_signature:
            print(json.dumps({key:value for key,value in status.items() if key != 'cases'}), flush=True)
            last_signature = signature
        if time.monotonic()-last_progress >= 7200:
            append_progress(status)
            last_progress = time.monotonic()
        if args.seconds and time.monotonic()-started >= args.seconds:
            append_progress(status)
            return
        todo = [record for record, case in zip(records, status['cases']) if not case['agreement']]
        # A parent case closes only when every translated cube closes and an
        # independent DRAT certificate verifies that those cubes cover it.
        complete_cubes = {}
        for record, case in zip(records, status['cases']):
            if case['agreement'] and record['cube'] is not None:
                parent = record['case'].rsplit('_q',1)[0]
                complete_cubes.setdefault(parent, set()).add(record['cube'])
        for parent, indices in complete_cubes.items():
            table = json.loads((PEER/'cubes'/(parent+'.json')).read_text())
            if indices == set(range(len(table['cubes']))):
                certify_cube_cover(parent, HERE/'independent/crosscheck/covers'/parent, PEER)
        if not todo:
            time.sleep(30)
            continue
        for record in todo:
            directory = HERE/'independent/crosscheck'/record['case']
            base = build(record, directory, PEER)
            log = directory/'campaign.log'
            command = [sys.executable, '-u', str(HERE/'src/prefix_campaign.py'),
                       '--c', str(record['c']), '--workers', str(args.workers),
                       '--persistent', '--base', str(base), '--directory', str(directory/'cubes'),
                       '--conflicts', str(args.conflicts), '--max-jobs', str(args.batch_jobs),
                       '--order', 'breadth']
            print(json.dumps(dict(time=stamp(), running_case=record['case'],
                                  variant=record['variant'])), flush=True)
            with log.open('a') as output:
                proc = subprocess.run(command, stdout=output, stderr=subprocess.STDOUT)
            assert proc.returncode == 0, f'Review {log}'
            state = json.loads((directory/'cubes/state.json').read_text())
            statuses = {node['status'] for node in state['nodes'].values()}
            if 'SAT_JUDGE_PASS' in statuses:
                message = dict(time=stamp(), status='DISAGREEMENT', peer=record,
                               independent_state=str(directory/'cubes/state.json'),
                               message='Independent SAT candidate passed both strict judges. '
                               'SendMessage is unavailable; supervisor relay is required.')
                (HERE/'DISAGREEMENT.json').write_text(json.dumps(message, indent=2)+'\n')
                print(json.dumps(message), flush=True)
                return
            assert 'ERROR' not in statuses, f'Review {log}'
            if state['summary']['complete']:
                agreement = dict(time=stamp(), status='AGREE_UNSAT', peer=record,
                                 state=str(directory/'cubes/state.json'),
                                 state_sha256=sha(directory/'cubes/state.json'))
                (directory/'agreement.json').write_text(json.dumps(agreement, indent=2)+'\n')
                print(json.dumps(agreement), flush=True)


if __name__ == '__main__':
    main()
