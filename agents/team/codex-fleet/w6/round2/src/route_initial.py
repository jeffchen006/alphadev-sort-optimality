from pathlib import Path
import subprocess,json,time
results=[]
for p in sorted(Path('round2/verified').glob('*.s')):
 sk=Path('round2/artifacts/skeletons')/(p.stem+'.skel')
 begun=time.monotonic()
 log=Path('round2/logs')/(p.stem+'_route31.log')
 with log.open('w') as f:
  r=subprocess.run(['nice','-n','19','./dagx',str(sk),'31','1','60000000'],stdout=f,stderr=subprocess.STDOUT)
 text=log.read_text();status=[x for x in text.splitlines() if x.startswith('RESULT')]
 row={'program':str(p),'skeleton':str(sk),'exit':r.returncode,'result':status,'seconds':time.monotonic()-begun}
 results.append(row)
 Path('round2/artifacts/initial_routing.json').write_text(json.dumps(results,indent=2))
 print(json.dumps(row),flush=True)
 if 'RESULT FOUND' in text: break
