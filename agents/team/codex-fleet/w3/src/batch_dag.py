from pathlib import Path
import concurrent.futures,subprocess,time,json,os
files=list(Path('sk').glob('t*.txt'))
old=Path('/path/to/repo/agents/team/d1-skeleton/sk/d3_fj5.txt')
def key(fn,flagonly=False):
 rows=[]
 for line in fn.read_text().splitlines():
  if not line or line.startswith('#'):continue
  a,b=line.split(':')
  if flagonly:
   s=tuple((x>y)-(x<y) for x,y in zip(a[1:],b[1:]));r=tuple(-v for v in s);rows.append(min(s,r))
  else:rows.append(min((a,b),(b,a)))
 return tuple(rows)
if __name__ == '__main__':
 seen={key(old)};todo=[]
 for f in sorted(files,key=lambda p:('common' not in p.name,'last' not in p.name and 'eq' not in p.name,p.name)):
  k=key(f)
  if k in seen:continue
  seen.add(k);todo.append(f)
 print('unique exact skeletons',len(todo),'total',len(files),flush=True)
 start=time.time()
 def run(f):
  log=Path('logs')/(f.stem+'_k31.dag')
  with log.open('w') as out:
   r=subprocess.run(['nice','-n','10','timeout','240','src/dagx',str(f),'31','1','3000000'],stdout=out,stderr=subprocess.STDOUT)
  lines=log.read_text().splitlines();result=lines[-1] if lines else 'EMPTY'
  return f.name,r.returncode,result
 with concurrent.futures.ThreadPoolExecutor(max_workers=5) as ex:
  for f,rc,result in ex.map(run,todo):
   print(f'{time.time()-start:.1f}s {f} rc={rc} {result}',flush=True)
