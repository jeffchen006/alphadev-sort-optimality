from pathlib import Path
import subprocess,json
jobs=[
 ('near9_suffix12_free',180,['python3','-B','round3/src/satrep.py','round5/candidates/fresh31_near.s','round6/candidates/near9_suffix12_free.s','--rank','--changes','0','--prefix','19','--maxcmp','9','--random-seed','626121']),
 ('near9_suffix12_typed',180,['python3','-B','round3/src/satrep.py','round5/candidates/fresh31_near.s','round6/candidates/near9_suffix12_typed.s','--rank','--typed','--changes','0','--prefix','19','--maxcmp','9','--random-seed','626122'])]
for name,limit,cmd in jobs:
 subprocess.run(['nice','-n','19','python3','-B','round6/src/run.py',str(limit),name,*cmd],check=True)
 p=Path('round6/candidates',name+'.s')
 if p.exists():subprocess.run(['nice','-n','19','python3','-B','round6/src/verify.py',str(p)],check=True)
 if Path('round6/artifacts/FOUND').exists():break
