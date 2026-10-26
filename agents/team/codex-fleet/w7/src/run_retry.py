"""Retry up to 64 unresolved three-position windows after the first scan."""
import json, subprocess, time
from pathlib import Path

while len(list(Path('artifacts').glob('triples_*.json')))<4495:time.sleep(2)
rows=[json.loads(p.read_text()) for p in Path('artifacts').glob('triples_*.json')]
pending=[r for r in rows if r['status']=='timeout']
pending.sort(key=lambda r:(-len(set(r['free'])&{14,21}),r['free']))
chosen=pending[:64]
Path('artifacts/groups.json').write_text(json.dumps([r['free'] for r in chosen],indent=2)+'\n')
if chosen:
    with open('logs/retry_scan.log','w') as f:
        subprocess.run(['nice','-n','10','python3','-B','src/scan.py','groups','--workers','8','--dynamic','--registers','11','--seconds','120','--proof'],stdout=f,stderr=subprocess.STDOUT)
Path('artifacts/retry_done.json').write_text(json.dumps({'unresolved_first_scan':len(pending),'retried':len(chosen)},indent=2)+'\n')
print(json.dumps({'unresolved_first_scan':len(pending),'retried':len(chosen)}),flush=True)
