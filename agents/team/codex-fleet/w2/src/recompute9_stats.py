#!/usr/bin/env python3
"""Read completed routing logs; keep limited jobs separate from negatives."""
import collections
import csv
import json
from pathlib import Path
import re

result={}
for name in ['recompute9_wide_k31','recompute9_gatecap19_k31','recompute9_deep_k31']:
    folder=Path('logs')/name
    if not folder.exists():continue
    counts=collections.Counter();limits=collections.Counter();calls=0;seconds=0
    records=[]
    for file in sorted(folder.glob('r*.log')):
        text=file.read_text()
        lines=re.findall(r'^RESULT .*$',text,re.M)
        if not lines:
            counts['RUNNING_OR_INCOMPLETE']+=1
            continue
        line=lines[-1];status=line.split()[1];counts[status]+=1
        verdict=re.findall(r'^VERIFIED_RESULT (\w+)',text,re.M)
        if verdict:
            counts[status]-=1
            status=verdict[-1];counts[status]+=1
        m=re.search(r'calls=(\d+)',line)
        if m:calls+=int(m.group(1))
        t=re.search(r'time=([\d.]+)s',line)
        if t:seconds+=float(t.group(1))
        # Early first-pass jobs requested 3M; wrappers state changed limits.
        m=re.search(r'actual_nodes=(\d+)',text)
        budget=int(m.group(1)) if m else (30000000 if name=='recompute9_deep_k31' else 3000000)
        limits[budget]+=1
        scope=re.search(r'ROUTING_SCOPE gate_cap=(\d+)',text)
        records.append(dict(file=str(file),status=status,node_limit=budget,
                            gate_cap=int(scope.group(1)) if scope else None,result=line))
    result[name]=dict(counts=dict(counts),node_limits=dict(limits),calls=calls,
                      routing_wall_seconds=round(seconds,1),records=records)
    summary_file=folder/'summary.json'
    if summary_file.exists():
        summary=json.loads(summary_file.read_text())
        if 'nodes' in summary:summary['requested_nodes']=summary.pop('nodes')
        summary['actual_node_limits']=dict(limits)
        summary['counts']=dict(counts)
        summary_file.write_text(json.dumps(summary,indent=2)+'\n')
for name in ['recompute9_classified','recompute9_wide_classified']:
    file=Path('sk')/name/'all_viable_recipes.tsv'
    if not file.exists():continue
    rows=list(csv.DictReader(file.open(),delimiter='\t'))
    counts=collections.Counter(r['recompute_kind'] for r in rows)
    new_recompute_ids=sorted({int(r['skeleton_id']) for r in rows
                            if r['recompute_kind']=='recomputed_lost' and r['previously_tested']=='0'})
    result[name]=dict(viable_recipes=len(rows),kinds=dict(counts),
                      new_recompute_ids=new_recompute_ids)
Path('logs/recompute9_round_summary.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:{x:y for x,y in v.items() if x!='records'} for k,v in result.items()},indent=2))
