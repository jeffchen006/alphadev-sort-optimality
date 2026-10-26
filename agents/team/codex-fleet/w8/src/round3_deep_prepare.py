"""Select 200 fresh bounded cases by the prior copy-bound visit ratio."""
import collections,json,re
from pathlib import Path
closed=set()
for path in Path('logs').glob('round3*/results.jsonl'):
    for line in path.read_text().splitlines():
        r=json.loads(line)
        if r.get('K',r.get('cost'))==31 and r['status']=='NONE':closed.add(r['file'])
primary={r['file'] for r in json.loads(Path('sk/round3_order200.json').read_text())}
queue=[]
for line in Path('logs/round2_rerun/results.jsonl').read_text().splitlines():
    r=json.loads(line)
    if r['status']!='LIMIT' or r['file'] in closed|primary:continue
    if r['node_limit']!=200000 or r['previous_node_limit']!=20000:continue
    text=Path(r['log']).read_text();m=re.search(r'COPY_CACHE hits=(\d+) misses=(\d+)',text)
    assert m
    bound_visits=int(m[1])+int(m[2]);ratio=bound_visits/r['calls']
    queue.append(dict(file=r['file'],required_gates=r['required_gates'],source_family=r['file'].split('/')[1],node_limit=2000000,original_node_limit=20000,previous_node_limit=200000,previous_calls=r['calls'],previous_log=r['log'],prior_copy_bound_visits=bound_visits,prior_copy_bound_visit_ratio=ratio,node_multiplier_original=100,node_multiplier_round2=10))
queue.sort(key=lambda r:(r['prior_copy_bound_visit_ratio'],r['file']));eligible=len(queue);queue=queue[:200]
assert len(queue)==200 and len({r['file'] for r in queue})==200
Path('sk/round3_deep200.json').write_text(json.dumps(queue,indent=2)+'\n')
print(json.dumps(dict(eligible=eligible,selected=len(queue),ratio_min=queue[0]['prior_copy_bound_visit_ratio'],ratio_max=queue[-1]['prior_copy_bound_visit_ratio'],gates=dict(collections.Counter(r['required_gates'] for r in queue)),families=dict(collections.Counter(r['source_family'] for r in queue))),indent=2))
