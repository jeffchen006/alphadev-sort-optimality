import concurrent.futures,subprocess,json,pathlib,time
root=pathlib.Path('/path/to/repo')
names=['exception_0_original','exception_0_normalized','c8_guard_0_0','c8_guard_0_0_movified','nonlat_full_original','nonlat_full_normalized']
seeds=[root/'agents/team/codex-fleet/w10/programs'/f'{n}.s' for n in names]
def run(item):
 i,p=item;t=time.time()
 with open(f'logs/branch_{i}.log','w')as f:
  r=subprocess.run(['nice','-n','10','src/local_branch',str(p),'branch'+str(i)],stdout=f,stderr=subprocess.STDOUT)
 return dict(index=i,path=str(p),returncode=r.returncode,seconds=time.time()-t)
with concurrent.futures.ThreadPoolExecutor(max_workers=5)as ex: rows=list(ex.map(run,enumerate(seeds)))
pathlib.Path('analysis/branch_runs.json').write_text(json.dumps(rows,indent=2))
