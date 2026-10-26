"""Audit completed retries and repairs without repeating synthesis."""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT/'round4'


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path, default=None):
    return json.loads(Path(path).read_text()) if Path(path).exists() else default


def audit(require_complete=True):
    tasks = read(BASE/'logs/retry900_tasks.json')
    rows = read(BASE/'logs/retry900_summary.json',[])
    old = [r for group in ('retry','frontier','variants_freeout','variants_broad')
           for r in read(ROOT/f'round3/logs/{group}_summary.json')]
    assert len(tasks)==78
    assert {t['tag'] for t in tasks} == {r['tag'] for r in old}
    assert all(r['status'] in ('None','UNKNOWN') for r in old)
    assert len({r['tag'] for r in rows})==len(rows)
    assert {r['tag'] for r in rows} <= {t['tag'] for t in tasks}
    verified_formulas = 0
    statuses = Counter()
    pass_files = {}
    for row in rows:
        statuses[row['status']] += 1
        records = row['records']
        solver = [r for r in records if r.get('phase')=='kissat_result']
        if solver:
            assert solver[0]['cnf_sha256']==row['query']['previous_formula_sha256']
            assert row['initial_formula_matches']
            formula = BASE/'cnf'/f'{row["tag"]}.cnf'
            assert digest(formula)==solver[-1]['cnf_sha256']
            verified_formulas += 1
        if row['status']=='UNSAT':
            assert not row['returncode'] and not row['external_limit']
            assert solver[-1]['returncode']==20 and solver[-1]['status']=='False'
            assert 's UNSATISFIABLE' in Path(solver[-1]['raw_log']).read_text()
        assert row['status'] not in ('ERROR','REJECTED'),row['tag']
        for j in row.get('judges',[]):
            assert digest(j['path'])==j['sha256']
            assert Path(j['judge_log']).read_text()==j['output']
            if not j['returncode'] and j['output'].startswith('PASS '):
                pass_files[j['path']]=j
    analyses = read(BASE/'handoff/analysis.json',[])
    prior_models = read(ROOT/'round3/logs/recovered_models.json')
    if analyses:
        assert len(analyses)==7
        assert [r['failing_weak_orders'] for r in analyses] == [153,144,90,98,461,27,153]
        for row,prior in zip(analyses,prior_models):
            assert digest(row['path'])==prior['sha256']==row['sha256']
            assert row['scalar_failing_weak_orders']==len(row['failures'])
            assert row['prior_strict_judge']==prior['judge']
    repair_tasks = read(BASE/'repair/tasks.json',[])
    repairs = read(BASE/'repair/summary.json',[])
    for row in repairs:
        assert len(set(row['task']['window']))==4
        assert row['status'] not in ('ERROR','REJECTED'),row['tag']
        if row['status']=='UNSAT':
            assert row['certificate']['verified']
            output = BASE/'repair'/f'{row["tag"]}.s'
            assert digest(str(output)+'.cnf')==row['certificate']['cnf_sha256']
            assert digest(str(output)+'.drat')==row['certificate']['drat_sha256']
        for j in row.get('judges',[]):
            assert Path(j['judge_log']).read_text()==j['output']
            if not j['returncode'] and j['output'].startswith('PASS '):
                pass_files[j['path']]=j
    for j in read(BASE/'repair/controls.json',{}).get('judges',[]):
        assert digest(j['path'])==j['sha256']
        assert Path(j['judge_log']).read_text()==j['output']
        assert not j['returncode'] and j['output'].startswith('PASS ')
        pass_files[j['path']]=j
    found = (ROOT/'RESULTS.md').read_text().startswith('FOUND k=')
    if require_complete and not found:
        assert len(rows)==78
        assert len(analyses)==7
        assert len(repairs)==len(repair_tasks)>0
    result = dict(complete=len(rows)==78 and len(repairs)==len(repair_tasks)>0,
                  target_found=found,retry_planned=78,retry_completed=len(rows),
                  retry_statuses=dict(statuses),verified_retained_formula_hashes=verified_formulas,
                  repair_planned=len(repair_tasks),repair_completed=len(repairs),
                  repair_statuses=dict(Counter(r['status'] for r in repairs)),
                  checked_repair_certificates=sum(r.get('certificate',{}).get('verified',False) for r in repairs),
                  independent_failure_counts=[r['failing_weak_orders'] for r in analyses],
                  scalar_failure_counts=[r['scalar_failing_weak_orders'] for r in analyses],
                  strict_pass_files=list(pass_files.values()),assumptions=['A2','A11'])
    path = BASE/'logs/independent_audit.json'
    path.write_text(json.dumps(result,indent=2)+'\n')
    if require_complete and not (BASE/'logs/independent_audit_appended').exists():
        with (ROOT/'RESULTS.md').open('a') as stream:
            stream.write('\n### Round-4 independent audit\n\n'
                         f"Retained-formula hashes checked: {verified_formulas}. "
                         f"Retry status counts: {dict(statuses)}. "
                         f"Repair status counts: {result['repair_statuses']}. "
                         f"Checked repair certificates: {result['checked_repair_certificates']}. "
                         'All limits remain UNKNOWN. These results concern only the encoded scopes [A2,A11]. '
                         'The complete audit is `round4/logs/independent_audit.json`.\n')
        (BASE/'logs/independent_audit_appended').write_text('complete\n')
    print(json.dumps(result),flush=True)
    return result


if __name__=='__main__':
    parser=argparse.ArgumentParser()
    parser.add_argument('--allow-pending',action='store_true')
    audit(not parser.parse_args().allow_pending)
