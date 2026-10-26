from pathlib import Path
import json,subprocess
rows=json.loads(Path('round6/artifacts/near_inventory.json').read_text())['representatives'];chosen=[r for r in rows if not r['old_signature']];ledger=[]
for i,row in enumerate(chosen):
 name=f'class_{i}_two';prefix='round6/candidates/'+name
 subprocess.run(['nice','-n','19','python3','-B','round6/src/run.py','90',name,'round5/bin/near_repair',row['file'],prefix],check=True)
 ledger.append(dict(source=row['file'],name=name))
 Path('round6/artifacts/class_pair_repairs.json').write_text(json.dumps(ledger,indent=2))
 for p in Path('round6/candidates').glob(name+'*_candidate*.s'):
  subprocess.run(['nice','-n','19','python3','-B','round6/src/verify.py',str(p)],check=True)
 if Path('round6/artifacts/FOUND').exists():break
