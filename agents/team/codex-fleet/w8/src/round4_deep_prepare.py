"""Freeze 200 new rotation cases for tenfold deeper routing."""
import collections,json,re
from pathlib import Path
p=Path('sk/round4_deep.json')
if p.exists():
    rows=json.loads(p.read_text())
else:
    rows=[]
    for line in Path('logs/round4_rotation/results.jsonl').read_text().splitlines():
        r=json.loads(line)
        if r['status']!='LIMIT':continue
        text=Path(r['log']).read_text();m=re.search(r'COPY_CACHE hits=(\d+) misses=(\d+)',text)
        r['copy_bound_visit_ratio']=(int(m[1])+int(m[2]))/r['calls'] if m else 1.
        r['previous_node_limit']=r['node_limit'];r['node_limit']*=10
        rows.append({k:v for k,v in r.items() if k in ('file','required_gates','node_limit','previous_node_limit','copy_bound_visit_ratio')})
    rows.sort(key=lambda r:(r['required_gates'],r['copy_bound_visit_ratio'],r['file']))
    rows=rows[:200];p.write_text(json.dumps(rows,indent=2)+'\n')
print(json.dumps(dict(cases=len(rows),required_columns=dict(collections.Counter(r['required_gates'] for r in rows)),limits=dict(collections.Counter(r['node_limit'] for r in rows)),ratio_range=[min(r['copy_bound_visit_ratio'] for r in rows),max(r['copy_bound_visit_ratio'] for r in rows)])))
