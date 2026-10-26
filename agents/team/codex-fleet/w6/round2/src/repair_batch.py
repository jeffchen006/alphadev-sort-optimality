from pathlib import Path
import subprocess,json,time
paths=sorted(Path('round2/verified').glob('*.s'))+sorted(Path('verified').glob('*.s'))
results=[]
for mode in (0,1):
 for i,p in enumerate(paths):
  # The first full mode-0 search was already completed.
  if mode==0 and p.stem=='c8_156fdd193572fb27': continue
  stem=f'repair_m{mode}_{p.stem}'
  log=Path('round2/logs')/(stem+'.log');err=Path('round2/logs')/(stem+'.err')
  began=time.monotonic()
  with log.open('w') as out,err.open('w') as errors:
   r=subprocess.run(['nice','-n','19','./round2/doublecmp',str(p),f'round2/candidates/{stem}','90','0',str(6900+100*mode+i),str(mode)],stdout=out,stderr=errors)
  text=log.read_text();summary=[l for l in text.splitlines() if l.startswith('SUMMARY')]
  row={'path':str(p),'mode':mode,'returncode':r.returncode,'summary':summary,'seconds':time.monotonic()-began,'log':str(log)}
  results.append(row);Path('round2/artifacts/repair_batch.json').write_text(json.dumps(results,indent=2))
  print(json.dumps(row),flush=True)
  if 'CANDIDATE file=' in text: raise SystemExit
