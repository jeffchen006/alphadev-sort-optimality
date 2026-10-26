from pathlib import Path
import subprocess
jobs=[('suffix19_t1',240,['round6/bin/suffix','round5/candidates/fresh31_near.s','round6/candidates/suffix19_t1','31','1','0.05','180','626191','9','0','8','19']),('suffix16_t3',240,['round6/bin/suffix','round5/candidates/fresh31_near.s','round6/candidates/suffix16_t3','31','3','0.05','180','626163','9','0','8','16']),('c7_packed',240,['round5/bin/new_search','round6/seeds/c8_c7_0_out.s','round6/candidates/c7_packed','31','4','0.2','180','626071','7','0','7'])]
for name,limit,cmd in jobs:
 subprocess.run(['nice','-n','19','python3','-B','round6/src/run.py',str(limit),name,*cmd],check=True)
 for p in Path('round6/candidates').glob(name+'*_k*.s'):
  subprocess.run(['nice','-n','19','python3','-B','round6/src/verify.py',str(p)],check=True)
 if Path('round6/artifacts/FOUND').exists():break
