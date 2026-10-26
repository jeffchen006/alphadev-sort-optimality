#!/usr/bin/env python3
"""Summarize completed routing logs without treating limits as rejections."""
from collections import Counter
import json
from pathlib import Path
import re

summary={}
batch_logs={'net10':'net10_batch_all.log','net10_safe':'net10_safe_batch.log',
            'repeat':'repeat_batch.log','refresh':'refresh_batch.log',
            'nonlattice10':'nonlattice10_batch.log','refresh_tail':'refresh_tail_batch.log',
            'sat_selected':'sat_selected_batch.log'}
for name in ['net10','net10_safe','repeat','refresh','nonlattice10','refresh_tail','sat_selected']:
    batch=Path('logs')/batch_logs[name]
    if batch.exists():
        lines=batch.read_text().splitlines()
        records=[json.loads(line) for line in lines if line.startswith('{')]
        if records:
            last=records[-1]
            summary[name]=dict(counts=last['counts'],calls=last.get('calls'),
                               done=last['done'],total=last['total'],
                               seconds=last['seconds'],
                               complete=bool(lines and lines[-1]=='BATCH COMPLETE'))
            continue
    directory=Path('logs')/name
    counts=Counter()
    engines=Counter()
    calls=0
    for fn in directory.glob('*.log'):
        text=fn.read_text()
        results=re.findall(r'^(?:RESULT|FINAL) (\w+).*$',text,re.M)
        if not results:
            counts['RUNNING']+=1
            continue
        status=results[-1]
        counts[status]+=1
        if 'ROUTER conservative_open_bound' in text:
            engine='conservative'
        elif 'ENCODED pool=' in text:
            engine='finite_pool_sat'
        else:
            engine='original'
        engines[engine+'_'+status]+=1
        c=re.findall(r'calls=(\d+)',text)
        if c:
            calls+=int(c[-1])
    summary[name]=dict(counts=dict(counts),engines=dict(engines),calls=calls)
Path('logs/search_stats.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(summary,indent=2))
