"""One CPU: repair controls, narrow SAT queries, then saved-state judges."""
from pathlib import Path
import json,subprocess,sys,time
from verify import verify
HERE=Path(__file__).resolve().parent
manifest=json.loads((HERE/'manifest.json').read_text())
# Duplicate a comparison. Removing its duplicate must restore a k=32 core.
lines=Path(manifest[0]['seed']).read_text().splitlines()
nr,k=map(int,lines[0].split());body=lines[1:]
ci=next(i for i,x in enumerate(body) if x.startswith('cmp '))
body.insert(ci,body[ci])
control=HERE/'seeds/block_control33.txt'
control.write_text(f'{nr} {k+1}\n'+'\n'.join(body)+'\n')
control_list=HERE/'block_control_list.txt';control_list.write_text(str(control)+'\n')
with (HERE/'logs/block_control.log').open('w') as f:
    subprocess.run(['nice','-n','19',str(HERE/'block_repair'),str(control_list),str(HERE/'candidates/block_control')],stdout=f,stderr=subprocess.STDOUT,check=True)
assert verify(HERE/'candidates/block_control_found_k32.s')
rows=[]
for index in [0,20,40,80,143,148]:
    cs=[i for i,x in enumerate(manifest[index]['program']) if x[0]==1]
    for z in [4,6]:
        name=f'narrow_{index}_{z}';output=HERE/'candidates'/f'{name}.s';log=HERE/'logs'/f'{name}.log'
        cmd=['nice','-n','19',sys.executable,'-B',str(HERE/'src/flag_sat.py'),str(index),str(cs[z]),str(output),'--before','1','--after','1','--edits','0','--sources']
        start=time.monotonic();status='UNKNOWN';code=None
        with log.open('w') as f:
            try:code=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,timeout=12).returncode
            except subprocess.TimeoutExpired:status='UNKNOWN_WALL_LIMIT'
        if code==0:
            for line in log.read_text().splitlines():
                try:item=json.loads(line)
                except json.JSONDecodeError:continue
                if 'status'in item:status=item['status']
        if code not in(None,0):status='ERROR'
        row=dict(name=name,index=index,delete=cs[z],command=cmd,cap=12,status=status,code=code,seconds=time.monotonic()-start,log=str(log))
        if status=='CANDIDATE':row['judge_pass']=verify(output)
        rows.append(row);print(json.dumps(row),flush=True)
        (HERE/'narrow_results.json').write_text(json.dumps(rows,indent=2)+'\n')
        if row.get('judge_pass'):raise SystemExit(0)
# The fixed-length walk has finished, so its saved files are immutable.
sources=sorted((HERE/'candidates').glob('restart_a*.s'))
for i,path in enumerate(sources):
    if not verify(path):raise RuntimeError(path)
    if i%20==0:print(json.dumps(dict(step='judge_restart',done=i+1,total=len(sources))),flush=True)
(HERE/'restart_judges_done.json').write_text(json.dumps(dict(files=len(sources),both_models=True))+'\n')
