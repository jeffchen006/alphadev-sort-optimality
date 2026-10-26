"""One 900-second Kissat query for each saved descriptive structure class."""
import argparse
from collections import Counter
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import resource
import subprocess
import sys

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parents[1]
BASE = HERE.parent
sys.path.append(str(BASE / 'round2/src'))
from control import transformed
from order_kissat import solve


def read_rows(path):
    return [json.loads(s) for s in path.read_text().splitlines() if s.strip()] if path.exists() else []


def atomic(path, text):
    tmp = path.with_suffix(path.suffix + '.tmp')
    tmp.write_text(text)
    tmp.replace(path)


def prepare():
    classes = json.loads((BASE / 'round4/artifacts/structure_classes.json').read_text())
    ranks = {r['queue_index']: r for r in json.loads((BASE / 'round4/artifacts/ranked_unknown.json').read_text())}
    old_queue = json.loads((BASE / 'round3/artifacts/unknown_queue.json').read_text())
    filters = json.loads((BASE / 'round3/artifacts/unknown_weak_filter.json').read_text())
    tasks = []
    for group in classes:
        i = min(group['members'], key=lambda i: (ranks[i]['ranking_failures'], ranks[i]['old_variables'], ranks[i]['old_clauses'], i))
        ranked = ranks[i]
        failures = ranked['baseline_score']['failing_cases'] if filters[i]['valid'] else []
        sampled = failures if len(failures) <= 64 else [failures[j * (len(failures)-1) // 63] for j in range(64)]
        seeds = sorted(set(sampled) | set(filters[i].get('witness_cases', [])))
        tasks.append(dict(class_id=group['class_id'], signature=group['signature'],
            members=group['members'], member_count=len(group['members']), queue_index=i,
            ranking_failures=ranked['ranking_failures'], old_variables=ranked['old_variables'],
            old_clauses=ranked['old_clauses'], prefix_length=ranked['prefix_length'],
            weak_filter=filters[i], seed_cases=seeds, item=old_queue[i]))
    # Rejected orders should resolve quickly. Among accepted orders, longer
    # exact prefixes reduce the remaining repair scope. Selection within each
    # class remains the failure/size ranking stated above.
    tasks.sort(key=lambda t: (t['weak_filter']['valid'], -t['prefix_length'],
                             t['old_variables'], t['old_clauses'], t['class_id']))
    assert len(tasks) == len({t['class_id'] for t in tasks}) == 306
    assert len({t['queue_index'] for t in tasks}) == 306
    assert sorted(i for t in tasks for i in t['members']) == sorted(ranks)
    for t in tasks:
        item = t['item']
        assert hashlib.sha256(Path(item['row']['source']).read_bytes()).hexdigest() == item['source_sha256']
    atomic(HERE / 'artifacts/queue.json', json.dumps(tasks, indent=2) + '\n')
    info = dict(classes=len(tasks), source_configurations=len(ranks),
        rejected_representatives=sum(not t['weak_filter']['valid'] for t in tasks),
        accepted_representatives=sum(t['weak_filter']['valid'] for t in tasks),
        representative_rule='minimum baseline/model failures, old variables, old clauses, queue index',
        execution_order='information-filter rejected first, then decreasing fixed-prefix length, then formula size',
        input_sha256={str(p.relative_to(BASE)): hashlib.sha256(p.read_bytes()).hexdigest() for p in
            [BASE/'round4/artifacts/structure_classes.json', BASE/'round4/artifacts/ranked_unknown.json',
             BASE/'round3/artifacts/unknown_queue.json', BASE/'round3/artifacts/unknown_weak_filter.json']})
    atomic(HERE / 'artifacts/preparation.json', json.dumps(info, indent=2) + '\n')
    print(json.dumps(info), flush=True)
    report()


def memory(path):
    mapping = {f'P{i}': f'S{i}' for i in range(5)}
    result = ['# n=5 model=mem iset=I1 source=w9-round5'] + [f'mov S{i}, P{i}' for i in range(5)]
    for line in path.read_text().splitlines():
        code = line.split('#')[0].strip()
        if not code:
            continue
        op, args = code.split(None, 1)
        d, s = [x.strip() for x in args.split(',')]
        for name in ([s] if op == 'out' else [d, s]):
            if name not in mapping:
                mapping[name] = f'S{len(mapping)}'
        result.append(f'mov P{d}, {mapping[s]}' if op == 'out' else f'{op} {mapping[d]}, {mapping[s]}')
    target = path.with_name(path.stem + '_mem.s')
    target.write_text('\n'.join(result) + '\n')
    return target


def finish(row):
    if not row.get('strict_pass'):
        return
    path = Path(row['path'])
    mem = memory(path)
    log = HERE / 'logs' / f'{mem.stem}_strict.log'
    with log.open('w') as stream:
        check = subprocess.run(['nice', '-n', '19', 'python3', '-B',
            '/path/to/repo/shared/judge.py',
            str(mem), '--strict', '--model', 'mem'], stdout=stream, stderr=subprocess.STDOUT)
    assert check.returncode == 0 and 'PASS' in log.read_text(), str(log)
    row.update(memory_path=str(mem), memory_strict_log=str(log), memory_strict_pass=True)
    for p in (path, mem):
        (HERE / 'verified' / p.name).write_bytes(p.read_bytes())
    if row['k'] <= 31:
        target = BASE / 'RESULTS.md'
        atomic(target, f"FOUND k={row['k']} strict out PASS: {path}; strict mem PASS: {mem}; memory judge: {log}\n" + target.read_text())
        atomic(HERE / 'FOUND.json', json.dumps(row, indent=2) + '\n')


def controls():
    families = json.loads((BASE / 'round2/artifacts/orders.json').read_text())['families']
    records = []
    for fi in (0, 2, 5):
        family = families[fi]
        p, R, order = transformed(family)
        a = argparse.Namespace(k=len(p), regs=R, seconds=30, types=12, add=5,
            polarity=False, save_models=True, tag=f'class_control_{fi}', origin_cuts=True)
        row = solve(family, order, a, p, family['source'])
        assert row.get('strict_pass'), row
        finish(row)
        records.append(row)
    atomic(HERE / 'artifacts/controls.json', json.dumps(records, indent=2) + '\n')
    print(json.dumps({'controls': len(records), 'statuses': dict(Counter(r['status'] for r in records))}), flush=True)
    report()


MARK = '\n## Round 5 — one representative per structure class\n'


def report(current=None):
    tasks = json.loads((HERE / 'artifacts/queue.json').read_text())
    rows = read_rows(HERE / 'artifacts/class_results.jsonl')
    assert len({r['class_id'] for r in rows}) == len(rows)
    by_class = {r['class_id']: r for r in rows}
    controls_path = HERE / 'artifacts/controls.json'
    controls = json.loads(controls_path.read_text()) if controls_path.exists() else []
    counts = Counter(r['status'] for r in rows)
    stamp = datetime.now(timezone.utc).isoformat()
    class_rows = []
    for task in sorted(tasks, key=lambda t: t['class_id']):
        result = by_class.get(task['class_id'])
        class_rows.append({k: task[k] for k in ('class_id', 'signature', 'members', 'member_count', 'queue_index', 'ranking_failures')})
        class_rows[-1].update(status=result['status'] if result else 'UNRUN',
            wall=result['wall'] if result else None,
            solver_calls=result['stats']['solver_calls'] if result else [],
            weak_filter_valid=task['weak_filter']['valid'])
    atomic(HERE / 'artifacts/class_status.json', json.dumps(class_rows, indent=2) + '\n')
    status_text = '| Class | Representative queue index | Members | Filter accepts | Status | Wall seconds |\n|---:|---:|---:|---|---|---:|\n'
    for r in class_rows:
        status_text += f"| {r['class_id']} | {r['queue_index']} | {r['member_count']} | {r['weak_filter_valid']} | {r['status']} | {format(r['wall'], '.3f') if r['wall'] is not None else ''} |\n"
    atomic(HERE / 'CLASS_STATUS.md', status_text)
    summary = dict(updated_utc=stamp, planned=306, recorded=len(rows), statuses=dict(counts),
        unrun=306-len(rows), current=current,
        parent_cpu_seconds=sum(r['cpu'] for r in rows),
        child_cpu_seconds=sum(r['stats']['child_cpu_seconds'] for r in rows),
        summed_wall_seconds=sum(r['wall'] for r in rows),
        peak_job_rss_kib=max((r['stats']['peak_job_rss_kib'] for r in rows), default=0),
        models=sum(len(r.get('models', [])) for r in rows),
        resources=dict(cpu_jobs=1, nice=19, address_space_mib=2800, combined_rss_limit_kib=2800000),
        code_sha256={p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted((HERE/'src').glob('*.py'))})
    atomic(HERE / 'artifacts/summary.json', json.dumps(summary, indent=2) + '\n')
    live = (f"Updated {stamp}.\n\nRecorded: {len(rows)}/306; {dict(counts)}. Unrun: {306-len(rows)}.\n\n"
        f"Current query: {current or 'none'}.\n\nOne CPU job; nice 19; 2,800 MiB address-space limit. "
        "Each representative gets a 900-second wall budget shared across refinements. Limits remain UNKNOWN. "
        "Classes describe structure; one representative does not exclude its other members.\n")
    atomic(HERE / 'LIVE.md', live)
    text = (MARK + '\nRead all prior results before this round. The new queue selects one of the 698 unresolved configurations '
        'from each of the 306 saved structure classes. It does not repeat the earlier broad scans. '
        'The representative has the smallest recorded failure ranking in its class. Ties use the earlier variable count, clause count, and queue index. '
        'The failure ranking uses concrete scratch value 7. It is not a strict correctness result.\n\n'
        'Assumptions tested: A2 (finite register bound), A4 (fixed comparison-flag histories), A6 (comparison order), and A11 (fixed-prefix repair scope). '
        'The classes are descriptive groups. They are not established program equivalences. A representative UNSAT result does not exclude every member of its class.\n\n'
        'The queue contains 200 representatives rejected by the earlier information filter and 106 accepted representatives. '
        'Rejected representatives run first. Accepted representatives run in decreasing fixed-prefix length, then increasing formula size. '
        'Each query retains the saved register bound, prefix, comparison positions, and direction freedom. '
        'All queries use the previously tested comparison-origin constraints. Witness cases and up to 64 baseline failure cases seed the formula. '
        'These cases retain the full-case query scope. Both the query encoder and the Kissat wrapper were copied unchanged from round 4.\n\n'
        'The encoder permits mov and all four allowed conditional moves. Scratch starts at a sentinel above the input values. '
        'Comparisons must use input-derived values. These are stated query restrictions. A strict judge result is still required for any candidate.\n\n'
        'Each representative has a 900-second wall budget shared across formula construction, solver calls, and refinements. '
        'A limit remains UNKNOWN. An unrun representative is UNRUN. No independently checked UNSAT certificate is produced. '
        'Kissat SAT assignments must satisfy every emitted clause. Every decoded program gets the strict out judge. '
        'A strict out PASS also gets the strict memory judge.\n\n'
        f"Recorded representatives: {len(rows)}/306. Status: {dict(counts)}. Unrun: {306-len(rows)}.\n\n"
        f"Recorded parent CPU seconds: {summary['parent_cpu_seconds']:.3f}. Child CPU seconds: {summary['child_cpu_seconds']:.3f}. "
        f"Summed query wall seconds: {summary['summed_wall_seconds']:.3f}. Peak recorded combined resident memory: {summary['peak_job_rss_kib']} KiB.\n\n"
        'All jobs run sequentially on one CPU at nice level 19. Each job has a 2,800 MiB address-space limit. '
        'The wrapper stops above 2,800,000 KiB combined parent and child resident memory. All project writes remain in w9. No agents were started.\n\n'
        'Per-class results: [CLASS_STATUS.md](round5/CLASS_STATUS.md) and [class_status.json](round5/artifacts/class_status.json). '
        'Full queries and raw solver log paths: [class_results.jsonl](round5/artifacts/class_results.jsonl). '
        'Selection and source hashes: [queue.json](round5/artifacts/queue.json). Resource totals and code hashes: [summary.json](round5/artifacts/summary.json).\n\n'
        f"New pinned controls completed: {len(controls)}/3. Their lengths are k=32 and memory length 42. "
        'Every new strict PASS file follows. Each retained copy has identical bytes.\n\n'
        '| PASS file | Model | Strict judge output |\n|---|---|---|\n')
    for r in controls + rows:
        if not r.get('strict_pass'):
            continue
        for p, model, log in [(Path(r['path']), 'out', Path(r['models'][-1]['judge_log'])),
                              (Path(r['memory_path']), 'mem', Path(r['memory_strict_log']))]:
            text += f'| [{p.name}]({p.relative_to(BASE)}) | {model} | [PASS]({log.relative_to(BASE)}) |\n'
            retained = HERE / 'verified' / p.name
            assert retained.read_bytes() == p.read_bytes()
            text += f'| [{retained.name} retained copy]({retained.relative_to(BASE)}) | {model} | identical to tested file |\n'
    text += ('\nNo new strict PASS with k<=31 is recorded.\n' if not any(r.get('strict_pass') and r['k']<=31 for r in rows) else '\nA strict PASS with k<=31 is recorded at the top of this file.\n')
    text += ('\nCurrent activity: [LIVE.md](round5/LIVE.md). Resume with `bash round5/run_remaining.sh`. '
             'The runner skips completed representatives, including recorded time limits. '
             'A stopped or interrupted query without a result record is not complete.\n')
    target = BASE / 'RESULTS.md'
    atomic(target, target.read_text().split(MARK)[0] + text)
    continuation = BASE / 'round6/src/report.py'
    if continuation.exists():
        import runpy
        runpy.run_path(str(continuation))['update']()


def run(a):
    controls = json.loads((HERE / 'artifacts/controls.json').read_text())
    assert len(controls) == 3 and all(r.get('strict_pass') and r.get('memory_strict_pass') for r in controls)
    tasks = json.loads((HERE / 'artifacts/queue.json').read_text())
    path = HERE / 'artifacts/class_results.jsonl'
    done = {r['class_id'] for r in read_rows(path)}
    with path.open('a') as stream:
        for task in tasks:
            if task['class_id'] in done:
                continue
            if (HERE / 'STOP_AFTER_QUERY').exists():
                report('stopped between queries')
                return
            item = task['item']
            old = item['previous']
            assert hashlib.sha256(Path(item['row']['source']).read_bytes()).hexdigest() == item['source_sha256']
            tag = f'class_{task["class_id"]:03d}_q{task["queue_index"]:04d}'
            report(tag)
            print(json.dumps(dict(event='class_start', tag=tag, class_id=task['class_id'], queue_index=task['queue_index'], seconds=a.seconds)), flush=True)
            local = argparse.Namespace(k=old['k'], regs=old['regs'], seconds=a.seconds,
                types=12 if old.get('polarity', False) else 8, add=5,
                polarity=old.get('polarity', False), save_models=True, tag=tag,
                origin_cuts=True, seed_cases=task['seed_cases'])
            r = solve(item['row'], old['order'], local, item['prefix'], item['row']['source'], old.get('positions'))
            r.update(class_id=task['class_id'], queue_index=task['queue_index'], class_members=task['members'],
                class_signature=task['signature'], limit_seconds=a.seconds, origin_cuts=True,
                seed_cases=task['seed_cases'], weak_filter=task['weak_filter'], source_sha256=item['source_sha256'])
            finish(r)
            stream.write(json.dumps(r) + '\n')
            stream.flush()
            os.fsync(stream.fileno())
            print(json.dumps(dict(event='class_result', class_id=r['class_id'], queue_index=r['queue_index'], status=r['status'], wall=r['wall'])), flush=True)
            report()
            if r.get('strict_pass') and r['k'] <= 31:
                return
    report('complete')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('mode', choices=['prepare', 'controls', 'run', 'report'])
    ap.add_argument('--seconds', type=float, default=900)
    a = ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    os.sched_setaffinity(0, {min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS, (2800*1024**2, 2800*1024**2))
    if a.mode == 'run':
        run(a)
    else:
        {'prepare': prepare, 'controls': controls, 'report': report}[a.mode]()


if __name__ == '__main__':
    main()
