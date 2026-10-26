"""One CPU: permit one changed write destination in each narrow SAT window."""
from pathlib import Path
import json,subprocess,sys,time
from verify import verify
HERE=Path(__file__).resolve().parent
seeds=json.loads((HERE/'manifest.json').read_text());rows=[]
for index in [0,40,143,148]:
    cs=[i for i,x in enumerate(seeds[index]['program']) if x[0]==1]
    for z in [4,6]:
        name=f'dest1_{index}_{z}';output=HERE/'candidates'/f'{name}.s';log=HERE/'logs'/f'{name}.log'
        cmd=['nice','-n','19',sys.executable,'-B',str(HERE/'src/flag_sat.py'),str(index),str(cs[z]),str(output),'--before','1','--after','1','--edits','0','--dest-edits','1']
        start=time.monotonic();status='UNKNOWN';code=None
        with log.open('w') as f:
            try:code=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,timeout=15).returncode
            except subprocess.TimeoutExpired:status='UNKNOWN_WALL_LIMIT'
        if code==0:
            for line in log.read_text().splitlines():
                try:r=json.loads(line)
                except json.JSONDecodeError:continue
                if 'status'in r:status=r['status']
        if code not in(None,0):status='ERROR'
        row=dict(name=name,index=index,delete=cs[z],command=cmd,cap=15,status=status,code=code,seconds=time.monotonic()-start,log=str(log))
        if status=='CANDIDATE':row['judge_pass']=verify(output)
        rows.append(row);print(json.dumps(row),flush=True)
        (HERE/'destination_results.json').write_text(json.dumps(rows,indent=2)+'\n')
        if row.get('judge_pass'):raise SystemExit(0)
