from pathlib import Path
import subprocess,json
for name,temp,seed in [('c7_fixed_t4',4,626074),('c7_fixed_t10',10,626070)]:
 cmd=['round6/bin/core_search','round6/seeds/c8_c7_0_out.s','round6/candidates/'+name,'31',str(temp),'0.15','65',str(seed),'7','0','7']
 subprocess.run(['nice','-n','19','python3','-B','round6/src/run.py','150',name,*cmd],check=True)
 for p in Path('round6/candidates').glob(name+'*_k*.s'):
  subprocess.run(['nice','-n','19','python3','-B','round6/src/verify.py',str(p)],check=True)
 if Path('round6/artifacts/FOUND').exists():break
