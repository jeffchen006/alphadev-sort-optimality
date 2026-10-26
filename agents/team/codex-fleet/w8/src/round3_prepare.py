"""Freeze a 200-case changed-order queue. The prior LIMIT cases remain unknown."""
import collections,json
from pathlib import Path
previous={}
for tag in ('round2_rerun','round2_net41'):
    for line in Path('logs',tag,'results.jsonl').read_text().splitlines():
        r=json.loads(line)
        if r['status']=='LIMIT':previous[r['file']]=r
assert len(previous)==3478
closed=set()
for path in Path('logs').glob('round3_bench*/results.jsonl'):
    for line in path.read_text().splitlines():
        r=json.loads(line)
        if r.get('K')==31 and r['status']=='NONE':closed.add(r['file'])
previous={f:r for f,r in previous.items() if f not in closed}
priority=[r for r in previous.values() if r['required_gates']<=16]
assert len(priority)==167
families=collections.defaultdict(list)
for r in previous.values():
    if r['required_gates']==18:families[r['file'].split('/')[1]].append(r)
for rs in families.values():rs.sort(key=lambda r:(r['node_limit'],r['file']))
# The remaining 33 slots sample the one-partner-swap source families equally.
remaining=33
for i in range(9):
    for name in sorted(families):
        if remaining==0:break
        rs=families[name];r=rs[int(i*(len(rs)-1)/8)]
        priority.append(r);remaining-=1
assert len(priority)==200 and len({r['file'] for r in priority})==200
queue=[]
for r in priority:
    queue.append(dict(file=r['file'],required_gates=r['required_gates'],previous_node_limit=r['node_limit'],previous_calls=r['calls'],previous_log=r['log'],node_limit=2000000,source_family=r['file'].split('/')[1],selection='all_15_16_columns' if r['required_gates']<=16 else 'balanced_18_column_sample'))
queue.sort(key=lambda r:(r['required_gates'],r['source_family'],r['file']))
Path('sk/round3_order200.json').write_text(json.dumps(queue,indent=2)+'\n')
print(json.dumps(dict(total=len(queue),gates=dict(collections.Counter(r['required_gates'] for r in queue)),families=dict(collections.Counter(r['source_family'] for r in queue)),node_limit=2000000),indent=2))
