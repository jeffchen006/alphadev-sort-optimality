import subprocess
from pathlib import Path
jobs=[('conversion_controls',60,['python3','-B','round6/src/conversion_controls.py']),('mine_near_clean',120,['python3','-B','round6/src/mine_near.py','--clean']),('audit_near',120,['python3','-B','round6/src/audit_near.py']),('class_pair_batch',900,['python3','-B','round6/src/repair_classes.py']),('mined_sat_batch',300,['python3','-B','round6/src/repair_mined.py'])]
for name,limit,cmd in jobs:
 subprocess.run(['nice','-n','19','python3','-B','round6/src/run.py',str(limit),name,*cmd],check=True)
 if Path('round6/artifacts/FOUND').exists():break
