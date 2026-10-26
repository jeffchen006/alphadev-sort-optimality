"""Audit retained scopes, hashes, solver exits, certificates, and judge logs."""
from collections import Counter
import hashlib
import json
from pathlib import Path
import os
import sys

BASE = Path(__file__).resolve().parents[1]


def digest(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        while block := f.read(1024**2):
            h.update(block)
    return h.hexdigest()


def main():
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    tasks = json.loads((BASE/'logs/tasks.json').read_text())
    rows = json.loads((BASE/'logs/summary.json').read_text())
    controls = json.loads((BASE/'logs/controls.json').read_text())
    task_by_tag = {t['tag']: t for t in tasks}
    assert len(task_by_tag) == len(tasks)
    assert len({r['task']['tag'] for r in rows}) == len(rows)
    checked = 0
    passes = []
    statuses = Counter()
    for row in rows+controls:
        task = row['task']
        tag = task['tag']
        if task['group'] == 'target':
            assert task == task_by_tag[tag]
            assert task.get('delete') is not None
            assert task['mode'] in ['fixed_dest','free_dest']
            assert 0 < task['registers'] <= (16 if task.get('large_register_test') else 11)
            statuses[row['status']] += 1
        assert digest(task['seed']) == task['seed_sha256']
        stem = BASE/'cnf'/tag
        for r in row['records']:
            if r.get('step') == 'candidate':
                file = Path(r['path'])
                log = Path(str(file)+'.judge')
                assert log.exists()
                assert log.read_text() == r['judge']
        final_solver = next((r for r in reversed(row['records']) if r.get('step') == 'kissat'), None)
        assert final_solver is not None
        assert digest(stem.with_suffix('.cnf')) == final_solver['cnf_sha256']
        if row['status'] == 'UNSAT':
            assert final_solver['status'] == 'UNSAT' and final_solver['returncode'] == 20
            certificate = row['certificate']
            assert certificate['verified'] and certificate['returncode'] == 0
            assert digest(stem.with_suffix('.cnf')) == certificate['cnf_sha256']
            assert digest(stem.with_suffix('.drat')) == certificate['proof_sha256']
            assert 's VERIFIED' in Path(certificate['log']).read_text()
            checked += task['group'] == 'target'
        if row['status'] == 'PASS':
            for judge in row['judges']:
                assert judge['returncode'] == 0 and judge['output'].startswith('PASS ')
                assert Path(judge['log']).read_text() == judge['output']
                assert digest(judge['path']) == judge['sha256']
                passes.append(judge)
        assert row['status'] in ['PASS','UNSAT','UNSAT_UNCHECKED','UNKNOWN']
    progress = json.loads((BASE/'logs/progress.json').read_text())
    assert progress['completed'] == len(rows)
    assert progress['statuses'] == dict(statuses)
    assert progress['checked_unsat'] == checked
    for name, sha in progress['source_sha256'].items():
        assert digest(BASE/'src'/name) == sha
    report = dict(audit_pass=True, planned=len(tasks), completed=len(rows),
                  statuses=dict(statuses), checked_target_certificates=checked,
                  strict_passes=passes, assumptions=progress['assumptions'],
                  tasks_sha256=digest(BASE/'logs/tasks.json'),
                  summary_sha256=digest(BASE/'logs/summary.json'),
                  scope='finite registers, fixed comparison values and positions; full-core free data routing')
    symbolic = BASE/'logs/symbolic_controls.json'
    if symbolic.exists():
        report['symbolic_controls'] = json.loads(symbolic.read_text())
        for row in report['symbolic_controls']:
            assert row['judge'].startswith('PASS ')
            assert (BASE/'logs'/f"{row['tag']}.judge").read_text() == row['judge']
    (BASE/'logs/independent_audit.json').write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps(dict(audit_pass=True, completed=len(rows), statuses=dict(statuses), checked_unsat=checked)))


if __name__ == '__main__':
    main()
