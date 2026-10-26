from pathlib import Path
import sys,itertools,time,concurrent.futures,subprocess
sys.path.insert(0,str(Path(__file__).resolve().parent))
from mixed import logs
from trees import trees,PS
from batch_dag import key
P=list(itertools.permutations(range(5)));Path('sk/phase').mkdir(exist_ok=True)
seen={key(Path('/path/to/repo/agents/team/d1-skeleton/sk/d3_fj5.txt'))}
for pp in itertools.chain(Path('sk').glob('t*.txt'),Path('sk/mixed').glob('*.txt')):seen.add(key(pp))
files=[]
for mask in [0,6,8,10,12]:
 for ti,tr in enumerate(trees(tuple(range(15)),4)):
  for orient in ['phase_actual','phase_reflected']:
   for pad in ['last','eq']+[str(5*a+b) for a,b in itertools.combinations(range(5),2)]:
    rows=[logs(x,tr,mask,pad,orient) for x in P]
    assert len(set(tuple((a>b)-(a<b) for a,b in row) for row in rows))==120
    fn=Path(f'sk/phase/m{mask}_t{ti}_{orient}_{pad}.txt')
    fn.write_text('# partner-first comparison orientation\n'+''.join('='+''.join(str(row[j][0]) for row in rows)+':='+''.join(str(row[j][1]) for row in rows)+'\n' for j in range(7)))
    sig=key(fn)
    # Keep duplicate files for six-choice SAT families, but skip their routing runs.
    if sig in seen:continue
    seen.add(sig);files.append(fn)
print('new phase skeletons',len(files),flush=True)
files.sort(key=lambda p:('last' not in p.name and 'eq' not in p.name,p.name))
start=time.time()
def run(fn):
 log=Path('logs')/(fn.stem+'_k31.phase')
 with log.open('w') as f:p=subprocess.run(['nice','-n','10','timeout','120','src/dagx',str(fn),'31','1','1500000'],stdout=f,stderr=subprocess.STDOUT)
 ls=log.read_text().splitlines();return fn.name,p.returncode,ls[-1] if ls else 'EMPTY'
with concurrent.futures.ThreadPoolExecutor(max_workers=3) as ex:
 for fn,rc,s in ex.map(run,files):print(f'{time.time()-start:.1f}s {fn} rc={rc} {s}',flush=True)
