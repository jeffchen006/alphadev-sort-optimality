import json,subprocess,time
from pathlib import Path
start=time.monotonic();result={'name':'inside_reorders'}
try:
    subprocess.run(['g++','-O3','-std=c++17','src/reorder.cpp','-o','src/reorder'],check=True)
    with open('logs/inside_reorders.log','w') as f:
        p=subprocess.run(['nice','-n','10','src/reorder','inside'],stdout=f,stderr=subprocess.STDOUT,timeout=600)
    result['exit']=p.returncode;result['summary']=Path('logs/inside_reorders.log').read_text().splitlines()[-1];result['judges']=[]
    for path in sorted(Path('candidates').glob('inside_reorder_*.s')):
        with open(str(path)+'.judge.log','w') as f:
            j=subprocess.run(['nice','-n','10','python3','-B','/path/to/repo/shared/judge.py',str(path),'--strict','--model','out'],stdout=f,stderr=subprocess.STDOUT)
        result['judges'].append({'file':str(path),'exit':j.returncode,'pass':'PASS ' in Path(str(path)+'.judge.log').read_text()})
except Exception as error:result['error']=repr(error)
finally:
    result['seconds']=time.monotonic()-start
    Path('artifacts/inside_reorders.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)
