#!/usr/bin/env python3
import pathlib,subprocess,os,json,sys
metas=json.loads(pathlib.Path('sk/insertion_alpha/meta.json').read_text());total=int(sys.argv[1])
for m in metas:
 tag=m['name'];base=pathlib.Path('sk/insertion_alpha');env=dict(os.environ,INITIAL=str(base/(tag+'.initial')),HISTORY=str(base/(tag+'.history')))
 for sk in sorted(pathlib.Path('sk/insertion').glob('t*.txt')):
  r=subprocess.run(['./merge_dag',str(sk),str(total-m['length']),'1','100000000'],env=env,capture_output=True,text=True)
  key=tag+'_'+sk.stem+f'_k{total}';pathlib.Path(f'logs/alpha_{key}.log').write_text(r.stdout+r.stderr)
  print(json.dumps({'tag':key,'result':r.stdout.splitlines()[-1]}),flush=True)
  if 'SOLUTION' in r.stdout:
   ls=r.stdout.splitlines();code=ls[next(i for i,s in enumerate(ls) if s.startswith('SOLUTION'))+1:ls.index('END')];fn=pathlib.Path('candidates/alpha_'+key+'.s');fn.write_text((base/(tag+'.s')).read_text()+'\n'+'\n'.join(code)+'\n')
   j=subprocess.run(['python3','/path/to/repo/shared/judge.py',str(fn),'--strict','--model','out'],capture_output=True,text=True);pathlib.Path(f'logs/alpha_{key}.judge').write_text(j.stdout+j.stderr);print(j.stdout,flush=True)
