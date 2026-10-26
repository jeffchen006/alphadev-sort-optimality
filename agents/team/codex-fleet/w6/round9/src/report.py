"""Audit final counters, scores, controls, parameters, and strict judge logs."""
from pathlib import Path
import collections,hashlib,json,re
from check import inspect,parse

plan=json.loads(Path('round9/artifacts/plan.json').read_text())
ledger=json.loads(Path('round9/artifacts/ledger.json').read_text())
assert len(ledger)==len(plan) or Path('round9/artifacts/FOUND').exists()
rows=[]
for row in ledger:
    p=next(p for p in plan if p['name']==row['name'])
    assert row['command']==p['command']
    assert hashlib.sha256(Path(row['source']).read_bytes()).hexdigest()==row['source_sha256']
    # The host can replace the initial one-CPU affinity with its worker mask.
    # One single-threaded search runs at a time regardless of that mask.
    assert 1<=len(row['affinity'])<=2
    assert row['peak_child_rss_kib']<3*1024*1024
    log=Path(row['log']).read_text()
    focusline=next(s for s in log.splitlines() if s.startswith('FOCUS inputs='))
    focus={tuple(map(int,s)) for s in focusline.split('=')[1].split(',') if s}
    assert len(focus)==9
    if row['status']=='COMPLETE':assert row['summary']['cpu']>=row['cpu_limit'] or row['summary']['zero_candidates']>0
    files=sorted(f for f in Path('round9/candidates').glob(row['name']+'*.s') if not f.stem.endswith('_snapshots'))
    judged={j['file']:j for j in row['judges']}
    assert set(judged)=={str(f) for f in files}
    for f in files:
        measured=inspect(f,focus,tuple(row['weights']))
        j=judged[str(f)];jlog=Path(j['log']).read_text()
        assert ('PASS ' in jlog)==j['passed']
        assert ('FAIL ' in jlog or 'PASS ' in jlog),j
        length=int(re.search(r'\blength=(\d+)',f.read_text().splitlines()[0]).group(1))
        assert length<= (41 if row['mode']=='mem' else 31)
        instructions=[i for i in parse(f) if i[0]!='out']
        budget=dict(cmp=sum(i[0]=='cmp' for i in instructions),mov=sum(i[0]=='mov' for i in instructions),cmov=sum(i[0].startswith('cmov') for i in instructions))
        if row['mode']=='mem':
            budget.update(loads=sum(i[0]=='mov' and i[2].startswith('P') for i in instructions),stores=sum(i[0]=='mov' and i[1].startswith('P') for i in instructions))
        rows.append(dict(**measured,mode=row['mode'],length=length,budget=budget,judge=j))
controls=json.loads(Path('round9/artifacts/positive_controls.json').read_text())
scorer_controls=json.loads(Path('round9/artifacts/scorer_controls.json').read_text())
assert scorer_controls['status']=='MATCH' and scorer_controls['files']==120
assert scorer_controls['cases_per_file']==541 and len(scorer_controls['records'])==120
assert all(Path(r['file']).exists() for r in scorer_controls['records'])
for c in controls:
    assert 'PASS ' in Path(c['judge']).read_text()
    measured=inspect(c['file'],set(),(4,2,4));assert measured['weak_fail']==0
summary={}
for mode in ('out','mem'):
    selected=[r for r in ledger if r['mode']==mode]
    summary[mode]=dict(runs=len(selected),iterations=sum(r.get('summary',{}).get('iterations',0) for r in selected),accepted=sum(r.get('summary',{}).get('accepted',0) for r in selected),cpu_seconds=sum(r['cpu_seconds'] for r in selected),binary_cpu_seconds=sum(r.get('summary',{}).get('cpu',0) for r in selected),wall_seconds=sum(r['wall_seconds'] for r in selected),best_failed_orders=min((r.get('summary',{}).get('best_fail',541) for r in selected),default=None),states_with_at_most_six_failures=sum(r.get('summary',{}).get('lowfiles',0) for r in selected))
result=dict(result='FOUND' if Path('round9/artifacts/FOUND').exists() else 'No strict PASS with core k <= 31 was found.',scope=['A1','A2','A11'],statuses=dict(collections.Counter(r['status'] for r in ledger)),summary=summary,peak_child_rss_kib=max(r['peak_child_rss_kib'] for r in ledger),score_check=dict(status='MATCH',files=len(rows),cases_per_file=541),search_scores=rows,positive_controls=controls,source_hashes={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(Path('round9/src').glob('*')) if p.is_file()},binary_sha256=hashlib.sha256(Path('round9/bin/weighted').read_bytes()).hexdigest())
result['scorer_control_inventory']=dict(status=scorer_controls['status'],files=scorer_controls['files'],cases_per_file=scorer_controls['cases_per_file'])
mining=Path('round9/artifacts/snapshot_mining.json')
if mining.exists():
    result['snapshot_mining']=json.loads(mining.read_text())
    for item in result['snapshot_mining']['conversions']:
        assert item['exit']==0 and item['k']==31
        f=Path(item['converted'])
        meta=json.loads(Path('round9/artifacts',f.stem+'_judge.json').read_text())
        assert meta['sha256']==hashlib.sha256(f.read_bytes()).hexdigest()
        assert meta['out']['file']==str(f)
        log=Path(meta['out']['log']).read_text()
        assert ('PASS ' in log)==meta['out']['pass']
    for item in result['snapshot_mining']['programs']:
        assert item['status']=='COMPLETE'
        if 'retained' in item:
            f=Path(item['retained'])
            assert hashlib.sha256(f.read_bytes()).hexdigest()==item['sha256']
            meta=json.loads(Path('round9/artifacts',f.stem+'_judge.json').read_text())
            assert meta['sha256']==item['sha256']
            log=Path(meta['out']['log']).read_text()
            assert ('PASS ' in log)==meta['out']['pass']
judge_logs=list(Path('round9/logs').glob('*judge.log'))
result['judge_audit']=dict(logs=len(judge_logs),passes=sum('PASS ' in p.read_text() for p in judge_logs),failures=sum('FAIL ' in p.read_text() for p in judge_logs))
assert result['judge_audit']['passes']+result['judge_audit']['failures']==len(judge_logs)
Path('round9/artifacts/final_summary.json').write_text(json.dumps(result,indent=2))
print(json.dumps({k:v for k,v in result.items() if k not in ('search_scores','positive_controls','source_hashes')},indent=2))
