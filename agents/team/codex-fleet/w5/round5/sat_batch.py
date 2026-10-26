"""Audited-pair SAT queries, with separate batches for the remaining pairs."""
from pathlib import Path
import json,sys,subprocess,time
HERE=Path(__file__).resolve().parent
rows=json.loads((HERE/'pair_audit.json').read_text())['rows']
keys=sorted({(x['seed'],*x['pair']) for x in rows},key=lambda x:(x[2]-x[1],x))
seen=set();queries=[]
for key in keys:
    if key[0] in seen:continue
    seen.add(key[0]);queries.append(key)
remaining='--remaining' in sys.argv
if remaining:queries=[key for key in keys if key not in queries]
start=int(sys.argv[1]) if len(sys.argv)>1 else 0
end=int(sys.argv[2]) if len(sys.argv)>2 else len(queries)
results=[]
for number in range(start,min(end,len(queries))):
    seed,a,b=queries[number];stem=f'fusion_sat_{seed}_{a}_{b}'
    out=HERE/'candidates'/f'{stem}.s';log=HERE/'logs'/f'{stem}.log'
    cmd=['nice','-n','19',sys.executable,'-B',str(HERE/'fusion_sat.py'),str(seed),str(a),str(b),str(out)]
    began=time.monotonic();status='UNKNOWN';code=None
    with log.open('w') as f:
        try:
            proc=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,timeout=15);code=proc.returncode
            if code:status='ERROR'
            else:
                for line in log.read_text().splitlines():
                    try:item=json.loads(line)
                    except ValueError:continue
                    if 'status' in item:status=item['status']
        except subprocess.TimeoutExpired:status='UNKNOWN_WALL_LIMIT'
    result=dict(number=number,seed=seed,pair=[a,b],command=cmd,code=code,status=status,seconds=time.monotonic()-began,log=str(log),output=str(out))
    if out.exists():
        from verify import verify
        result['strict_pass']=verify(out)
    results.append(result)
    label='remaining_' if remaining else ''
    (HERE/f'sat_results_{label}{start}_{end}.json').write_text(json.dumps(results,indent=2)+'\n')
    print(json.dumps(result),flush=True)
