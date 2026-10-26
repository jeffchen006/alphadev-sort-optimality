#!/usr/bin/env python3
import concurrent.futures as cf,subprocess,pathlib,json
jobs=[(0,1,101),(0,4,102),(0,12,103),(15,1,104),(15,4,105),(15,12,106)]
def job(j):
 freeze,temp,seed=j;tag=f'f{freeze}_t{temp}_s{seed}';cmd=['./mcmc8','-n','5','-L','31','-S','7','-m','out','-i','I1','-start','candidates/seed33.s','-time','300','-restart','0.0002','-mincmp','8','-maxcmp','8','-freeze',str(freeze),'-T',str(temp),'-seed',str(seed),'-out','candidates/mcmc_'+tag]
 with open('logs/mcmc_'+tag+'.log','w') as f:r=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT)
 return tag,r.returncode
with cf.ThreadPoolExecutor(max_workers=6) as pool:
 for result in pool.map(job,jobs):print(json.dumps(result),flush=True)
