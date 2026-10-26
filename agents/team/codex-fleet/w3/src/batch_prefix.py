from pathlib import Path
import concurrent.futures,subprocess,time
jobs=[(i,k) for i in [0,2,3,4] for k in [31]]
start=time.time()
def run(job):
 i,k=job;tag=f'logs/prefix{i}_k{k}'
 with open(tag+'.log','w') as f:
  p=subprocess.run(['nice','-n','10','python3','src/ssa_sat.py',f'sk/t{i}_common_last.txt','--k',str(k),'--tag',tag,'--timeout','240','--init','32','--free-last','--fix','programs/prefix_fj.s','--seed',str(10+i)],stdout=f,stderr=subprocess.STDOUT)
 return job,p.returncode,Path(tag+'.log').read_text().strip().splitlines()[-1]
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as ex:
 for job,rc,s in ex.map(run,jobs):print(time.time()-start,job,rc,s,flush=True)
