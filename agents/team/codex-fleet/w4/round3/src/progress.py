#!/usr/bin/env python3
"""Report saved query counts and the active query's elapsed time."""
import collections
import json
import time
from pathlib import Path

BASE=Path(__file__).resolve().parents[1]/'logs'
names=['retry','frontier','variants_fixed','variants_freeout','variants_broad']
for name in names:
    path=BASE/(name+'_summary.json')
    if not path.exists():continue
    try:queries=json.loads(path.read_text())
    except ValueError:continue
    counts=collections.Counter(q['status'] for q in queries)
    print(f"{name}: {len(queries)} finished; {counts.get('False',0)} UNSAT; "
          f"{counts.get('None',0)+counts.get('UNKNOWN',0)} unknown; "
          f"{counts.get('CANDIDATE',0)} candidates.")
logs=[BASE/(name+'_batch.log') for name in names if (BASE/(name+'_batch.log')).exists()]
if logs:
    parent=max(logs,key=lambda p:p.stat().st_mtime)
    rows=[]
    for line in parent.read_text().splitlines():
        try:rows.append(json.loads(line))
        except ValueError:pass
    if rows:
        record=rows[-1]
        tag=record.get('tag')
        if tag and record.get('phase')=='start':
            path=BASE/(tag+'.log')
            details=[]
            for line in path.read_text().splitlines() if path.exists() else []:
                try:details.append(json.loads(line))
                except ValueError:pass
            elapsed=next((r['seconds'] for r in reversed(details) if 'seconds' in r),0)
            if 'started_unix' in record:elapsed=time.time()-record['started_unix']
            limit=record['task']['seconds']
            print(f'Active query: {tag}; elapsed {elapsed:.0f} / {limit:.0f} seconds.')
        else:
            print('Latest batch record:',record.get('phase'),tag or '')
