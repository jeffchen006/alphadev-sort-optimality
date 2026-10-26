"""Decompose two free slots into all 465 position pairs. Limits stay UNKNOWN."""
from pathlib import Path
import argparse,itertools,json,subprocess,sys,time
HERE=Path(__file__).resolve().parent
def main(args):
    results=[];pairs=list(itertools.combinations(range(31),2))
    for index in range(args.start,min(args.end,len(pairs))):
        a,b=pairs[index];tag=f'{args.seed}_slots_{a}_{b}'
        log=HERE/'logs'/f'{tag}.log';out=HERE/'candidates'/f'{tag}.s'
        cmd=['nice','-n','19',sys.executable,'-B',str(HERE/'sat_repair.py'),str(HERE/'seeds'/f'{args.seed}.s'),str(out),'--meta',str(HERE/'seeds'/f'{args.seed}.json'),'--predicates','--slots',f'{a},{b}']
        began=time.monotonic();code=None
        with log.open('w') as f:
            try:
                p=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,timeout=args.limit);code=p.returncode;status='ERROR'
            except subprocess.TimeoutExpired:status='UNKNOWN_WALL_LIMIT'
        events=[]
        for line in log.read_text().splitlines():
            try:events.append(json.loads(line))
            except ValueError:pass
        if code==0:status=next((x['status'] for x in reversed(events) if 'status'in x),'ERROR')
        row=dict(seed=args.seed,index=index,slots=[a,b],status=status,seconds=time.monotonic()-began,wall_limit=args.limit,code=code,log=str(log),command=cmd,last=events[-1] if events else None)
        if status=='CANDIDATE':
            proc=subprocess.run(['nice','-n','19',sys.executable,'-B',str(HERE/'verify.py'),str(out)],capture_output=True,text=True)
            (HERE/'logs'/f'{tag}_judge.log').write_text(proc.stdout+proc.stderr);row['strict_pass']=proc.returncode==0
        results.append(row)
        path=HERE/f'{args.seed}_slots_{args.start}_{args.end}.json';path.write_text(json.dumps(results,indent=2)+'\n')
        print(json.dumps(row),flush=True)
        if row.get('strict_pass'):break
    print(json.dumps(dict(done=True,seed=args.seed,start=args.start,end=args.end,queries=len(results))))
if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('seed',choices=['near9','near14']);ap.add_argument('--start',type=int,default=0);ap.add_argument('--end',type=int,default=465);ap.add_argument('--limit',type=float,default=3)
    main(ap.parse_args())
