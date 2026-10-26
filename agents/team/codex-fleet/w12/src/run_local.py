import concurrent.futures,subprocess,json,pathlib,time
root=pathlib.Path('/path/to/repo')
seeds=list((root/'agents/team/codex-fleet/w10/programs').glob('*.s'))
seeds=[p for p in seeds if not p.stem.endswith('_mem')]
def run(item):
 i,p=item;t=time.time()
 with open(f'logs/local_{i}.log','w')as f:
  r=subprocess.run(['nice','-n','10','src/local',str(p),str(i)],stdout=f,stderr=subprocess.STDOUT)
 return dict(index=i,path=str(p),returncode=r.returncode,seconds=time.time()-t)
with concurrent.futures.ThreadPoolExecutor(max_workers=5)as ex:
 rows=list(ex.map(run,enumerate(seeds)))
pathlib.Path('analysis/local_runs.json').write_text(json.dumps(rows,indent=2))
