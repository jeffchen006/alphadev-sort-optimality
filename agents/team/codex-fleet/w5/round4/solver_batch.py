"""One bounded SAT process at a time, with complete argument records."""
from pathlib import Path
import json, subprocess, sys, time
from verify import verify
HERE=Path(__file__).resolve().parent
seeds=json.loads((HERE/'manifest.json').read_text())
rows=[]
jobs=[]
for index in [148,143,146,0,20,40,60,80,100,120]:
    cs=[i for i,x in enumerate(seeds[index]['program']) if x[0]==1]
    for z in [6,4]:
        jobs.append((f'local_{index}_{z}',index,cs[z],20,['--before','1','--after','1','--edits','1']))
for index in [148,143,146,0,40,80]:
    cs=[i for i,x in enumerate(seeds[index]['program']) if x[0]==1]
    jobs.append((f'merge_{index}',index,cs[6],35,['--before','3','--after','1','--edits','0']))
for name,index,delete,cap,options in jobs:
    output=HERE/'candidates'/f'{name}.s';log=HERE/'logs'/f'{name}.log'
    cmd=['nice','-n','19',sys.executable,'-B',str(HERE/'src/flag_sat.py'),str(index),str(delete),str(output)]+options
    start=time.monotonic();status='UNKNOWN';code=None
    with log.open('w') as f:
        try:code=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,timeout=cap).returncode
        except subprocess.TimeoutExpired:status='UNKNOWN_WALL_LIMIT'
    if code==0:
        for line in log.read_text().splitlines():
            try:r=json.loads(line)
            except json.JSONDecodeError:continue
            if 'status' in r:status=r['status']
    row=dict(name=name,index=index,delete=delete,command=cmd,cap=cap,code=code,status=status,seconds=time.monotonic()-start,log=str(log))
    if code not in (None,0):row['status']='ERROR'
    if status=='CANDIDATE':row['judge_pass']=verify(output)
    rows.append(row)
    (HERE/'solver_results.json').write_text(json.dumps(rows,indent=2)+'\n')
    print(json.dumps(row),flush=True)
    if row.get('judge_pass'):break
