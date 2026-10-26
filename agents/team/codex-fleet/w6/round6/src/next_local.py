from pathlib import Path
import subprocess
for name,mode in [('new32_delete2','delete2'),('new32_cmp2','cmp2'),('new32_flags','flagswrites')]:
 subprocess.run(['nice','-n','19','python3','-B','round6/src/run.py','240',name,'round4/search_v2','round6/artifacts/new32.txt','0','1',mode,'round6/candidates/'+name],check=True)
 for p in Path('round6/candidates').glob(name+'*_candidate*.s'):
  subprocess.run(['nice','-n','19','python3','-B','round6/src/verify.py',str(p)],check=True)
 if Path('round6/artifacts/FOUND').exists():break
