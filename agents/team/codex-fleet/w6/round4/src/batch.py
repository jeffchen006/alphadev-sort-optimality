"""Use one CPU slot for a sequential batch of bounded local searches."""
import json
from pathlib import Path
import subprocess
import sys

part=sys.argv[1]
jobs=[]
specs=[('flagswrites','all'),('cmp2','all'),('flagsany','nomov')]
for mode,inventory in specs:
    name=mode+'_'+part
    command=['./round4/search_v2','round4/artifacts/'+inventory+'.txt',part,'2',mode,
             'round4/candidates/'+name]
    subprocess.run(['nice','-n','19','python3','-B','round4/src/run.py','1200',name,*command],check=True)
    row=json.loads(Path('round4/artifacts',name+'.json').read_text())
    jobs.append(row)
    Path('round4/artifacts','batch_'+part+'.json').write_text(json.dumps(jobs,indent=2))
    candidates=list(Path('round4/candidates').glob(name+'*_candidate*.s'))
    for candidate in candidates:
        jname=candidate.stem+'_judge'
        subprocess.run(['nice','-n','19','python3','-B','round4/src/run.py','45',jname,
                        'python3','-B',
                        '/path/to/repo/shared/judge.py',
                        str(candidate),'--strict','--model','out'],check=True)
        result=json.loads(Path('round4/artifacts',jname+'.json').read_text())
        if result['exit']==0 and Path(result['log']).read_text().startswith('PASS '):
            Path('round4/artifacts/FOUND_PENDING').write_text(str(candidate)+'\n')
            with Path('RESULTS.md').open('a') as f:
                f.write('\nFOUND k=31 '+str(candidate)+'; strict out judge: '+result['log']+'\n')
            print('FOUND k=31 '+str(candidate),flush=True)
            raise SystemExit(0)
