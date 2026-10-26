"""Audit query coverage and statuses. Do not convert limits into negatives."""
from pathlib import Path
import collections,hashlib,json

def events(path):
    result=[]
    for line in Path(path).read_text().splitlines():
        try:result.append(json.loads(line))
        except ValueError:pass
    return result

ledger=json.loads(Path('round7/artifacts/query_ledger.json').read_text())
plan=json.loads(Path('round7/artifacts/query_plan.json').read_text())
refined_path=Path('round7/artifacts/refined_ledger.json')
refined=json.loads(refined_path.read_text()) if refined_path.exists() else []
bykind=collections.defaultdict(collections.Counter)
cegis=collections.Counter()
for row in ledger+refined:
    ev=events(row['log'])
    finish=[e for e in ev if e.get('step')=='finished']
    assert finish and finish[-1]['status']==row['status'],row
    assert row['status'] in ('UNSAT','UNKNOWN','CANDIDATE'),row
    assert row['peak_rss_kib']<3*1024*1024,row
    assert row['exit']==0,row
    bykind[('typed' if row['typed'] else 'full',row['width'])][row['status']]+=1
    for e in ev:
        if e.get('step')=='candidate':cegis['candidates']+=1
        if e.get('step')=='solve':cegis['solve_calls']+=1
    cegis['max_encoded_cases']=max(cegis['max_encoded_cases'],row['cases'])

initial=events('round7/logs/t00_w6_i12.log')[-1]
assert initial['status']=='UNSAT'
bykind[('typed',6)]['UNSAT']+=1

seeds=json.loads(Path('round6/artifacts/near_inventory.json').read_text())['representatives']
coverage=[]
for i,row in enumerate(seeds):
    starts={q['start'] for q in ledger if q['seed']==i and q['typed'] and q['width']==6}
    if i==0:starts.add(12)
    coverage.append(dict(seed=i,source=row['file'],starts=sorted(starts),all_26_starts=starts==set(range(26))))
known={r['name']:r for r in ledger}
known['t00_w6_i12']=dict(status='UNSAT',typed=True,seed=0,start=12,width=6)
for row in refined:
    outer=set(range(row['start'],row['start']+row['width']))
    for cut in row['cuts']:
        closed=known[cut['query']]
        assert closed['status']=='UNSAT' and closed['typed'] and closed['seed']==row['seed']
        inner=set(range(closed['start'],closed['start']+closed['width']))
        assert inner<outer and cut['must_change_one_of']==sorted(outer-inner)
for a in json.loads(Path('round7/artifacts/path_analysis.json').read_text()):
    assert hashlib.sha256(Path(a['source']).read_bytes()).hexdigest()==a['sha256']

passes=[]
for name in ('fixed_control32','binary_control32'):
    row=json.loads(Path('round7/artifacts',name+'_judge.json').read_text())
    for model in ('out','mem'):
        p=row[model]
        assert p['pass'] and 'PASS ' in Path(p['log']).read_text()
        passes.append(dict(file=p['file'],model=model,k=32,log=p['log']))
    retained=Path('round7/verified',name+'.s')
    assert retained.read_bytes()==Path(row['source']).read_bytes()
    passes.append(dict(file=str(retained),model='out',k=32,copy_of=row['source']))

near=[str(p) for p in Path('round7/candidates').glob('*_near.s')]
rows=[dict(kind=kind,width=width,**counts) for (kind,width),counts in sorted(bykind.items())]
report=dict(batch_finished=len(ledger)==len(plan),batch_queries=len(ledger),planned_batch_queries=len(plan),
            refined_finished=len(refined)==30,refined_queries=len(refined),
            groups=rows,coverage=coverage,cegis=dict(cegis),new_near_files=near,
            batch_cpu_seconds=sum(r['cpu_seconds'] for r in ledger+refined),batch_wall_seconds=sum(r['seconds'] for r in ledger+refined),
            peak_child_rss_kib=max(r['peak_rss_kib'] for r in ledger+refined),passes=passes,
            sources={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in Path('round7/src').glob('*.py')},
            assumptions=['A2: used registers plus one fresh register','A11: fixed instructions outside each window'],
            limits='Every timeout is UNKNOWN. UNSAT concerns only the stated local query and relaxed initial state. No global lower bound.',
            scheduling='All jobs nice 19. One early 0.74-second control judge overlapped a search. All subsequent CPU jobs ran sequentially.')
audit=json.loads(Path('round7/artifacts/encoding_audit.json').read_text())
report['encoding_audit']={k:v for k,v in audit.items() if k!='records'}
assert audit['status']=='MATCH' and audit['boolean_collision_hits']==0
report['model_mining']=json.loads(Path('round7/artifacts/mined_models.json').read_text())
report['mined_judges']=[json.loads(p.read_text()) for p in sorted(Path('round7/artifacts').glob('mined_*_judge.json'))]
Path('round7/artifacts/final_summary.json').write_text(json.dumps(report,indent=2))
print(json.dumps({k:report[k] for k in ('batch_finished','batch_queries','refined_finished','refined_queries','groups','cegis','new_near_files','batch_cpu_seconds','batch_wall_seconds','peak_child_rss_kib')},indent=2))
