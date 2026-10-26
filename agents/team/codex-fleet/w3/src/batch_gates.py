from pathlib import Path
import concurrent.futures,subprocess,time
start=time.time()
jobs=[(i,g) for g in range(12,25) for i in [1,4]]
def run(job):
 i,g=job;tag=f'logs/gate{i}_g{g}_k31'
 with open(tag+'.log','w') as f:
  p=subprocess.run(['nice','-n','10','python3','src/ssa_sat.py',f'sk/t{i}_common_last.txt','--k','31','--gates',str(g),'--onehot','--exact','--init','48','--tag',tag,'--timeout','120','--seed',str(i+g)],stdout=f,stderr=subprocess.STDOUT)
 ls=Path(tag+'.log').read_text().splitlines()
 result='; '.join(l for l in ls if l.startswith(('RESULT','PERMUTATION')))
 return job,p.returncode,result
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as ex:
 for job,rc,res in ex.map(run,jobs):print(f'{time.time()-start:.1f}s {job} rc={rc} {res}',flush=True)
