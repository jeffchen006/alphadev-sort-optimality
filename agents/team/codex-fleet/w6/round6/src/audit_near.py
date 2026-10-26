from pathlib import Path
import json,subprocess
rows=json.loads(Path('round6/artifacts/near_inventory.json').read_text())['representatives'];root=Path.cwd().parents[3];out=[]
for i,row in enumerate(rows):
 for model,key in [('out','file'),('mem','source')]:
  path=row[key];name=f'nearclass_{i}_{model}';log=Path('round6/logs',name+'_judge.log')
  with log.open('w') as f:rc=subprocess.run(['nice','-n','19','python3','-B',str(root/'shared/judge.py'),path,'--strict','--model',model],stdout=f,stderr=subprocess.STDOUT).returncode
  data=dict(file=path,model=model,exit=rc,log=str(log),result=log.read_text().splitlines()[0] if log.read_text() else '')
  out.append(data)
Path('round6/artifacts/near_judges.json').write_text(json.dumps(out,indent=2));print(json.dumps(out,indent=2))
