from pathlib import Path
import itertools,concurrent.futures,subprocess,time,json,sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
from batch_dag import key
seen={key(Path('/path/to/repo/agents/team/d1-skeleton/sk/d3_fj5.txt'))}
for pp in itertools.chain(Path('sk').glob('t*.txt'),Path('sk/mixed').glob('*.txt')):seen.add(key(pp))
files=[];done=0
for mask in [0,6,8,10,12]:
 for ti in range(6):
  for orient in ['phase_actual','phase_reflected']:
   for pad in ['last','eq']+[str(5*a+b) for a,b in itertools.combinations(range(5),2)]:
    fn=Path(f'sk/phase/m{mask}_t{ti}_{orient}_{pad}.txt');sig=key(fn)
    if sig in seen:continue
    seen.add(sig)
    log=Path('logs')/(fn.stem+'_k31.phase')
    if log.exists() and 'RESULT ' in log.read_text():done+=1;continue
    files.append(fn)
Path('sk/phase_remaining.json').write_text(json.dumps([str(f) for f in files],indent=2)+'\n')
print('phase completed before resume',done,'remaining',len(files),'new call cap 300000',flush=True)
files.sort(key=lambda p:('last' not in p.name and 'eq' not in p.name,p.name));start=time.time()
def run(fn):
 log=Path('logs')/(fn.stem+'_k31.phase')
 with log.open('w') as f:p=subprocess.run(['nice','-n','10','timeout','120','src/dagx',str(fn),'31','1','300000'],stdout=f,stderr=subprocess.STDOUT)
 ls=log.read_text().splitlines();return fn.name,p.returncode,ls[-1] if ls else 'EMPTY'
with concurrent.futures.ThreadPoolExecutor(max_workers=3) as ex:
 for fn,rc,s in ex.map(run,files):print(f'{time.time()-start:.1f}s {fn} rc={rc} {s}',flush=True)
