import concurrent.futures as cf
import json, subprocess, sys
from pathlib import Path

HERE=Path(__file__).resolve().parents[1]
manifest=json.loads((HERE/'seeds/manifest.json').read_text())
mode=sys.argv[1] if len(sys.argv)>1 else 'repair'
binary=sys.argv[2] if len(sys.argv)>2 else 'search'
workers=int(sys.argv[3]) if len(sys.argv)>3 else 6
def run(row):
    i=row['index']
    output=HERE/f'logs/{mode}_{i:02d}.log'
    cmd=['nice','-n','10',str(HERE/binary),mode,row['seed'],str(HERE/f'candidates/{mode}{i:02d}'),str(1000+i)]
    if mode in ('repair','repair3'):cmd+=['1']
    with output.open('w') as f:
        result=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT)
    return i,result.returncode,output.read_text().strip()
with cf.ThreadPoolExecutor(max_workers=workers) as pool:
    for i,rc,msg in pool.map(run,manifest):
        print(i,rc,msg,flush=True)
