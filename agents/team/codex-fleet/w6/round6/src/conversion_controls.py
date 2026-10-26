from pathlib import Path
import sys,subprocess,json
sys.path.insert(0,str(Path(__file__).parent))
from mem_to_out import convert
rows=[]
for clean in (False,True):
 name='conversion_'+('clean_' if clean else '')+'control32';out=Path('round6/candidates',name+'.s')
 row=convert('round5/verified_mem/near9_repair32.s',out,clean=clean);rows.append(row)
 assert row['k']==32 and row['failed_orders']==0
 subprocess.run(['nice','-n','19','python3','-B','round6/src/verify.py',str(out)],check=True)
Path('round6/artifacts/conversion_controls.json').write_text(json.dumps(rows,indent=2))
