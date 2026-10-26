#!/usr/bin/env python3
"""Read current progress; do not start a search or modify result files."""
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
rows=[]
for name in ['sat.jsonl','extra.jsonl','followup.jsonl']:
 p=ROOT/'round3/logs'/name
 if p.exists():rows += [json.loads(s) for s in p.read_text().splitlines() if s.strip()]
active=[];errors=[]
for p in (ROOT/'round3/logs').glob('*.log'):
 driver=p.name.endswith('_driver.log')
 lines=p.read_text().splitlines()
 enc=[] if driver else [s for s in lines if s.startswith('{') and '"event": "ENC"' in s]
 result=[] if driver else [s for s in lines if s.startswith('{') and '"event": "RESULT"' in s]
 if enc and len(result)<len(enc):active.append((p.stat().st_mtime,p.stem))
 if any(s.startswith('Traceback') or 'control failed' in s.lower() or 'report failed' in s.lower() or '"status": "JUDGE_FAIL"' in s for s in lines):errors.append(p.stem)
status=[]
for r in rows:
 for s in r.get('result',[]):
  if s.startswith('{'):
   try:status.append(json.loads(s).get('status','UNKNOWN'))
   except ValueError:pass
found=(ROOT/'RESULTS.md').read_text().startswith('FOUND ')
complete=(ROOT/'round3/logs/sat_driver.log').exists() and 'QUEUE_COMPLETE' in (ROOT/'round3/logs/sat_driver.log').read_text()
extra_complete=(ROOT/'round3/logs/extra_driver.log').exists() and 'EXTRA_QUEUE_COMPLETE' in (ROOT/'round3/logs/extra_driver.log').read_text()
followup_scheduled=(ROOT/'round3/logs/followup_scheduled').exists()
followup_complete=not followup_scheduled or ((ROOT/'round3/logs/followup_driver.log').exists() and 'FOLLOWUP_COMPLETE' in (ROOT/'round3/logs/followup_driver.log').read_text())
print(json.dumps(dict(found=found,queue_complete=complete,extra_queue_complete=extra_complete,
 followup_complete=followup_complete,all_complete=complete and extra_complete and followup_complete,finished=len(rows),
 active=[n for _,n in sorted(active)],timeouts=status.count('TIMEOUT'),
 unsat=status.count('UNSATISFIABLE'),sat=status.count('SATISFIABLE'),errors=errors,
 last=rows[-1] if rows else None)))
