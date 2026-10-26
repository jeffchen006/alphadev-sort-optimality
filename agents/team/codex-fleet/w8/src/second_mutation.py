#!/usr/bin/env python3
"""Apply the complete single-operation mutation pass to twelve new graphs."""
import json,subprocess,time,resource
from pathlib import Path
out=Path('sk/mutation2');out.mkdir(exist_ok=True);logs=Path('logs/mutation2');logs.mkdir(exist_ok=True)
rows=[]
def limits():resource.setrlimit(resource.RLIMIT_AS,(3*1024**3,3*1024**3))
for file in sorted(Path('sk/mutation').glob('*.dag')):
    folder=out/file.stem;start=time.monotonic()
    r=subprocess.run(['nice','-n','10','./mutation',str(file),str(folder)],capture_output=True,text=True,preexec_fn=limits)
    (logs/(file.stem+'.generation.log')).write_text(r.stdout+r.stderr)
    print(file,r.stdout.strip(),flush=True)
    if r.returncode:continue
    rows.extend(json.loads((folder/'manifest.json').read_text()))
    v=subprocess.run(['nice','-n','10','python3','src/fixed_route.py',str(folder/'valid_graphs.jsonl'),'--tag','mut2_'+file.stem],capture_output=True,text=True,preexec_fn=limits)
    (logs/(file.stem+'.fixed.log')).write_text(v.stdout+v.stderr)
    print(v.stdout.strip(),flush=True)
Path('sk/mutation2_manifest.json').write_text(json.dumps(rows,indent=2)+'\n')
print('TOTAL_GENERATED',len(rows),flush=True)
