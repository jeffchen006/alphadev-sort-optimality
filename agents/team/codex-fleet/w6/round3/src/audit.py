"""Strict-judge the mined cores and retain counted memory versions."""
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[6]
memory_dir = Path('round3/verified_mem')
memory_dir.mkdir(exist_ok=True)
rows = []
def judge(source,model):
    log = Path('round3/logs')/(source.stem+'_'+model+'_judge.log')
    with log.open('w') as f:
        result = subprocess.run(['nice','-n','19','python3','-B',str(ROOT/'shared/judge.py'),
                                 str(source),'--strict','--model',model],
                                stdout=f,stderr=subprocess.STDOUT)
    return result.returncode == 0 and 'PASS ' in log.read_text(), str(log)

inventory = json.loads(Path('round3/artifacts/zero_mov_inventory.json').read_text())
for entry in inventory['programs']:
    source = Path(entry['target'])
    ok, outlog = judge(source,'out')
    row = {'source':str(source),'out_pass':ok,'out_log':outlog}
    if ok:
        target = Path('round3/verified')/source.name
        shutil.copyfile(source,target)
        scratch = {}
        instructions = []
        for line in source.read_text().splitlines():
            line = line.split('#')[0].strip()
            if not line:
                continue
            def rename(m):
                old = m[0]
                if old not in scratch:
                    scratch[old] = f'S{5+len(scratch)}'
                return scratch[old]
            line = re.sub(r'S\d+',rename,line)
            line = re.sub(r'P(\d+)',lambda m:f'S{m[1]}',line)
            if line.startswith('out '):
                j,r = line[4:].replace(',','').split()
                line = f'mov P{j}, {r}'
            instructions.append(line)
        mem = memory_dir/source.name
        mem.write_text('# n=5 model=mem iset=I1 core=32 L=42\n'+
                       '\n'.join([f'mov S{i}, P{i}' for i in range(5)]+instructions)+'\n')
        mok, mlog = judge(mem,'mem')
        row.update({'retained':str(target),'out_sha256':hashlib.sha256(target.read_bytes()).hexdigest(),
                    'memory':str(mem),'mem_pass':mok,'mem_log':mlog,
                    'mem_sha256':hashlib.sha256(mem.read_bytes()).hexdigest()})
    rows.append(row)
    Path('round3/artifacts/mined_judge_ledger.json').write_text(json.dumps(rows,indent=2))
    print(json.dumps(row),flush=True)
for path in [Path('round3/candidates/nomov_4c02da04dce39b74_del27.s'),
             *sorted(Path('round3/candidates').glob('n14_neighbour*.s'))]:
    ok,log = judge(path,'out')
    print(json.dumps({'near':str(path),'strict_pass':ok,'log':log}),flush=True)
