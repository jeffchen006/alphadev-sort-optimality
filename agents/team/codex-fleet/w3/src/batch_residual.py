from pathlib import Path
import subprocess,time
start=time.time()
for k in range(10,20):
 for sk in sorted(Path('sk').glob('r*common*')):
  tag=f'logs/res_{sk.stem}_k{k}.log'
  with open(tag,'w') as f:
   p=subprocess.run(['nice','-n','10','timeout','45','src/dag_relaxed',str(sk),str(k),'1','3000000'],stdout=f,stderr=subprocess.STDOUT)
  lines=Path(tag).read_text().splitlines()
  print(f'{time.time()-start:.1f}s {sk.name} k={k} rc={p.returncode} {lines[-1] if lines else "EMPTY"}',flush=True)
