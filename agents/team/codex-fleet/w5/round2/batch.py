"""Two single-thread CPU workers. Never writes outside w5."""
import concurrent.futures as cf
import json
from pathlib import Path
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sources = sorted((ROOT.parent / 'w6/verified').glob('*.s'))
sources += [ROOT / 'verified/palette_c8_k32.s']
manifest = []
for i, source in enumerate(sources):
    seed = HERE / 'seeds' / (source.stem + '.txt')
    subprocess.run([sys.executable, str(ROOT/'src/import_seed.py'), str(source), str(seed)], check=True)
    manifest.append({'index': i, 'source': str(source), 'seed': str(seed)})
(HERE/'manifest.json').write_text(json.dumps(manifest, indent=2)+'\n')

def run(item):
    row, mode = item
    name = f'{row["index"]:02d}_{mode}'
    log = HERE/'logs'/f'{name}.log'
    cmd = ['nice','-n','19',str(HERE/'search'),mode,row['seed'],str(HERE/'candidates'/name),str(20261025+row['index']),'1']
    start = time.monotonic()
    with log.open('w') as f:
        r = subprocess.run(cmd, stdout=f, stderr=subprocess.STDOUT)
    result = {'name':name,'code':r.returncode,'seconds':time.monotonic()-start,'tail':log.read_text().splitlines()[-1:]}
    print(json.dumps(result), flush=True)
    return result

jobs = [(row,mode) for row in manifest for mode in ('repair','repair3','cmov3')]
with cf.ThreadPoolExecutor(max_workers=2) as pool:
    results = list(pool.map(run, jobs))
(HERE/'batch_results.json').write_text(json.dumps(results,indent=2)+'\n')
