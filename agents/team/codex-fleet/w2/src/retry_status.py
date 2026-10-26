#!/usr/bin/env python3
from pathlib import Path
import json
import runpy
runpy.run_path('src/recompute9_retry_report.py')
s=json.loads(Path('logs/recompute9_priority/audit_summary.json').read_text())
for r in s['records']:
 if r['status'] in ['ACTIVE','PAUSED']:
  lines=Path(r['log']).read_text().splitlines()
  progress=[x for x in lines if x.startswith(('PROGRESS','RESULT'))]
  print('CURRENT',r['file'],progress[-1] if progress else lines[-1],flush=True)

for r in reversed(s['records']):
 if r['status']=='NONE':
  print('LAST_NONE',r['file'],r['result'],flush=True)
  break
