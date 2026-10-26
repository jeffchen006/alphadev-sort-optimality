import concurrent.futures,subprocess,json,pathlib,time
root=pathlib.Path('/path/to/repo')
base=root/'agents/team/codex-fleet/w10/programs'
configs=[
 (32,7,'exception_0_original.s',100,8,1201),
 (32,10,'c8_guard_0_0.s',100,12,1202),
 (32,7,'nonlat_full_original.s',180,20,1203),
 (31,7,'exception_0_original.s',80,12,1204),
 (31,10,'c8_guard_0_0.s',80,20,1205),
 (31,16,'exception_0_original.s',120,35,1206),
]
rows=[]
for i,(k,ns,seed,gpen,temp,rng) in enumerate(configs):
 source=base/seed
 if k==31:
  lines=source.read_text().splitlines();ops=[j for j,s in enumerate(lines)if s and not s.startswith(('#','out'))]
  del lines[ops[[1,6,4][i-3]]]
  source=pathlib.Path(f'programs/start_{i}.s');source.write_text('\n'.join(lines)+'\n')
 cmd=['nice','-n','10','src/gmcmc','-n','5','-m','out','-i','I1','-S',str(ns),'-L',str(k),'-start',str(source),'-gpen',str(gpen),'-T',str(temp),'-time','180','-iters','3000000','-restart','0.00002','-seed',str(rng),'-out',f'programs/wave0_{i}']
 rows.append(dict(index=i,cmd=cmd))
pathlib.Path('logs/mcmc_config.json').write_text(json.dumps(rows,indent=2))
def run(row):
 t=time.monotonic()
 with open(f'logs/mcmc_{row["index"]}.log','w')as f:
  try:r=subprocess.run(row['cmd'],stdout=f,stderr=subprocess.STDOUT,timeout=600);row['returncode']=r.returncode
  except subprocess.TimeoutExpired:row['returncode']=124
 row['wall_seconds']=time.monotonic()-t
 return row
with concurrent.futures.ThreadPoolExecutor(max_workers=6)as ex: rows=list(ex.map(run,rows))
pathlib.Path('analysis/mcmc_runs.json').write_text(json.dumps(rows,indent=2))
