"""Audit the finished round without treating limits as exclusions."""
from pathlib import Path
import collections,hashlib,json

sat=json.loads(Path('round8/artifacts/sat_ledger.json').read_text())
mcmc=json.loads(Path('round8/artifacts/mcmc_ledger.json').read_text())
plan=json.loads(Path('round8/artifacts/smallest40_plan.json').read_text())
mplan=json.loads(Path('round8/artifacts/mcmc_plan.json').read_text())
assert len(sat)==40 and len(mcmc)==len(mplan)==60,(len(sat),len(mcmc))
assert {r['prior_name'] for r in sat}=={r['name'] for r in plan}
assert len({(r['seed'],r['temperature']) for r in mcmc})==60
assert all(r['peak_child_rss_kib']<3*1024*1024 for r in sat+mcmc)
assert all(r['status'] in ('UNSAT','UNKNOWN','CANDIDATE') for r in sat)
assert all(r['exit']==0 for r in sat)
assert all(r['status'] in ('FINISHED','FINISHED_AT_WALL_LIMIT') and r['exit'] in (0,124) for r in mcmc)
assert all(r['summary']['cpu']>=40 for r in mcmc if r['status']=='FINISHED')
seed_hashes={}
for row in json.loads(Path('round7/artifacts/path_analysis.json').read_text()):
    digest=hashlib.sha256(Path(row['source']).read_bytes()).hexdigest()
    assert digest==row['sha256'],row['source']
    seed_hashes[row['source']]=digest
score=json.loads(Path('round8/artifacts/score_check.json').read_text());assert score['status']=='MATCH'
groups={}
for temp in sorted({r['temperature'] for r in mcmc}):
    a=[r for r in mcmc if r['temperature']==temp]
    groups[str(temp)]=dict(runs=len(a),proposals=sum(r['summary']['iterations'] for r in a),
                         accepted=sum(r['summary']['accepted'] for r in a),
                         best_failures=min(r['summary']['best_fail'] for r in a),
                         cpu_seconds=sum(r['summary']['cpu'] for r in a),saved_le6=sum(len(r['saved_le6']) for r in a))
report=dict(sat_queries=len(sat),sat_statuses=dict(collections.Counter(r['status'] for r in sat)),
            mcmc_runs=len(mcmc),mcmc_statuses=dict(collections.Counter(r['status'] for r in mcmc)),mcmc_groups=groups,
            proposals=sum(r['summary']['iterations'] for r in mcmc),accepted=sum(r['summary']['accepted'] for r in mcmc),
            best_failures=min(r['summary']['best_fail'] for r in mcmc),saved_le6=[f for r in mcmc for f in r['saved_le6']],
            sat_cpu_seconds=sum(r['cpu_seconds'] for r in sat),mcmc_cpu_seconds=sum(r['cpu_seconds'] for r in mcmc),
            wall_seconds=sum(r['wall_seconds'] for r in sat+mcmc),peak_child_rss_kib=max(r['peak_child_rss_kib'] for r in sat+mcmc),
            solve_calls=sum(e.get('step')=='solve' for r in sat for e in r['events']),
            sat_models=sum(e.get('step')=='candidate' for r in sat for e in r['events']),score_check=score,
            scope=['A1: stochastic search, not exhaustive','A2: SAT uses one fresh register; MCMC uses two',
                   'A11: window fixes every outside instruction'],
            source_hashes={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(Path('round8/src').glob('*')) if p.is_file()},
            judges=[json.loads(p.read_text()) for p in sorted(Path('round8/artifacts').glob('*_judge.json'))])
report['sat_groups']={}
for width in sorted({r['width'] for r in sat}):
    report['sat_groups'][str(width)]=dict(collections.Counter(r['status'] for r in sat if r['width']==width))
new_unsat=sum(r['status']=='UNSAT' for r in sat)
known={r['name']:r for r in json.loads(Path('round7/artifacts/query_ledger.json').read_text())+sat}
known['t00_w6_i12']=dict(status='UNSAT',typed=True,source=json.loads(Path('round6/artifacts/near_inventory.json').read_text())['representatives'][0]['file'],start=12,width=6)
cut_count=0
for row in sat:
    outer=set(range(row['start'],row['start']+row['width']))
    cuts=next((e.get('covered',[]) for e in row['events'] if e.get('step')=='initial_cases'),[])
    for cut in cuts:
        prev=known[cut['query']]
        assert prev['status']=='UNSAT' and prev['typed'] and prev['source']==row['source']
        inner=set(range(prev['start'],prev['start']+prev['width']))
        assert inner<outer and sorted(outer-inner)==cut['must_change_one_of']
        cut_count+=1
report['audited_cut_dependencies']=cut_count
report['round7_overlay']=dict(distinct_window_queries=465,scoped_unsat=262+new_unsat,remaining_unknown=203-new_unsat,
                              note='Updates only the selected formerly UNKNOWN scopes; does not add distinct windows.')
report['model_mining']=json.loads(Path('round8/artifacts/mined_models.json').read_text())
report['seed_hashes']=seed_hashes
for name in ('src/local.cpp','src/window_sat.py','round7/src/binary_encode.py','round3/src/rank_encode.py','round3/src/satrep.py'):
    report['source_hashes'][name]=hashlib.sha256(Path(name).read_bytes()).hexdigest()
Path('round8/artifacts/final_summary.json').write_text(json.dumps(report,indent=2))
print(json.dumps({k:v for k,v in report.items() if k not in ('source_hashes','score_check','judges')},indent=2))
