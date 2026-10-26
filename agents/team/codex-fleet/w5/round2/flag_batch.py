import concurrent.futures as cf
import json
from pathlib import Path
import subprocess
import sys
import time

HERE=Path(__file__).resolve().parent
manifest=json.loads((HERE/'manifest.json').read_text())
modes=sys.argv[1:] or ['cmp','cmov','other']
def run(item):
    row,mode=item
    name=f'{row["index"]:02d}_flag_{mode}'
    log=HERE/'logs'/f'{name}.log'
    cmd=['nice','-n','19',str(HERE/'flags'),mode,row['seed'],str(HERE/'candidates'/name),'1']
    start=time.monotonic()
    with log.open('w') as f:r=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT)
    result={'name':name,'code':r.returncode,'seconds':time.monotonic()-start,'tail':log.read_text().splitlines()[-1:]}
    print(json.dumps(result),flush=True)
    return result
jobs=[(row,mode) for row in manifest for mode in modes]
with cf.ThreadPoolExecutor(max_workers=2) as pool:results=list(pool.map(run,jobs))
(HERE/('flag_results_'+'_'.join(modes)+'.json')).write_text(json.dumps(results,indent=2)+'\n')
