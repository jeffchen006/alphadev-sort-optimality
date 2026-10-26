from pathlib import Path
import json,subprocess
inventory=json.loads(Path('round6/artifacts/near_inventory.json').read_text())
seeds=[r for r in inventory['representatives'] if r['failed_orders']<=10 and not r['old_signature'] and r['k']<=31]
Path('round6/artifacts/mined_repair_selection.json').write_text(json.dumps(seeds[:3],indent=2))
for i,row in enumerate(seeds[:3]):
 name=f'mined_{i}_typed4';out='round6/candidates/'+name+'.s'
 cmd=['python3','-B','round3/src/satrep.py',row['file'],out,'--rank','--typed','--changes','4','--maxcmp','9','--fresh','1','--change-cmp','--random-seed',str(626400+i)]
 subprocess.run(['nice','-n','19','python3','-B','round6/src/run.py','90',name,*cmd],check=True)
 if Path(out).exists():subprocess.run(['nice','-n','19','python3','-B','round6/src/verify.py',out],check=True)
 if Path('round6/artifacts/FOUND').exists():break
