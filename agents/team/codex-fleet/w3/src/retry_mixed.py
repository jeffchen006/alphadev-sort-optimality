from pathlib import Path
import subprocess,concurrent.futures,time
files=[]
for p in Path('logs').glob('*.mixed'):
 if 'RESULT LIMIT' in p.read_text():files.append(Path('sk/mixed')/(p.name.replace('_k31.mixed','.txt')))
start=time.time();print('retry skeletons',len(files),flush=True)
def run(fn):
 log=Path('logs')/(fn.stem+'_retry_k31.mixed')
 with log.open('w') as f:p=subprocess.run(['nice','-n','10','timeout','300','src/dagx',str(fn),'31','1','100000000'],stdout=f,stderr=subprocess.STDOUT)
 ls=log.read_text().splitlines();return fn.name,p.returncode,ls[-1] if ls else 'EMPTY'
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as ex:
 for fn,rc,s in ex.map(run,files):print(f'{time.time()-start:.1f}s {fn} rc={rc} {s}',flush=True)
