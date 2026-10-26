"""Check reordered routing and measure search calls, one process at a time."""
import argparse,collections,json,os,random,re,resource,subprocess,time
from pathlib import Path
from round2_run import verify

def limits():resource.setrlimit(resource.RLIMIT_AS,(3*1024**3,3*1024**3))
if os.nice(0)<19:os.nice(19-os.nice(0))
limits()
parser=argparse.ArgumentParser()
parser.add_argument('--modes',default='0,1,2,3')
parser.add_argument('--tag',default='round3_bench')
parser.add_argument('--small',action='store_true')
args=parser.parse_args();modes=list(map(int,args.modes.split(',')))
folder=Path('logs')/args.tag;folder.mkdir(exist_ok=True)
rows=[json.loads(l) for l in Path('logs/round2_rerun/results.jsonl').read_text().splitlines()]
cases=[]
for gates in (16,17,18,19,20):
    choices=sorted((r for r in rows if r['status']=='NONE' and r['required_gates']==gates),key=lambda r:r['calls'])
    for q in (0,.25,.5,.75,1):
        r=choices[int(q*(len(choices)-1))]
        cases.append(dict(file=r['file'],K=31,node_limit=max(1000000,2*r['calls']),expected='NONE',gates=gates,old_calls=r['calls']))
opens=sorted((r for r in rows if r['status']=='LIMIT'),key=lambda r:(r['required_gates'],r['node_limit'],r['file']))
# Include inexpensive limits across gate counts and both added-source families.
for gates in (15,16,18,19):
    choices=[r for r in opens if r['required_gates']==gates]
    for r in choices[:2]:cases.append(dict(file=r['file'],K=31,node_limit=1000000,expected='UNKNOWN',gates=gates))
net=json.loads(Path('sk/round2_net9_41.json').read_text())
for r in (net[0],net[-1]):cases.append(dict(file=r['file'],K=31,node_limit=1000000,expected='UNKNOWN',gates=r['required_gates']))
cases.append(dict(file='sk/known32.txt',K=32,node_limit=3000000,expected='FOUND',gates=15))
if args.small:
    cases=[c for i,c in enumerate(cases) if c['expected']!='NONE' or (c.get('old_calls',0)<=1500000 and i%2==0)]
Path('sk/'+args.tag+'.json').write_text(json.dumps(cases,indent=2)+'\n')
dst=folder/'results.jsonl';done={}
if dst.exists():
    for l in dst.read_text().splitlines():
        r=json.loads(l);done[r['id']]=r
with dst.open('a') as out:
    for index,c in enumerate(cases):
      for mode in modes:
        identity=f'{index:03}_order{mode}'
        if identity in done:continue
        env=dict(os.environ,ROUTE_ORDER=str(mode));start=time.monotonic()
        before=resource.getrusage(resource.RUSAGE_CHILDREN)
        p=subprocess.run(['./dagx_order',c['file'],str(c['K']),'1',str(c['node_limit'])],capture_output=True,text=True,env=env,preexec_fn=limits)
        after=resource.getrusage(resource.RUSAGE_CHILDREN);text=p.stdout+p.stderr
        log=folder/(identity+'.log');log.write_text(text)
        m=re.search(r'RESULT (\w+).*?calls=(\d+)',text)
        r=dict(c,id=identity,mode=mode,status=m[1] if m else 'ERROR',calls=int(m[2]) if m else 0,log=str(log),seconds=time.monotonic()-start,cpu=after.ru_utime+after.ru_stime-before.ru_utime-before.ru_stime,returncode=p.returncode)
        if c['expected']=='NONE' and r['status'] not in ('NONE','LIMIT'):raise RuntimeError(r)
        if r['status']=='FOUND':
            r.update(verify(text,'round3_bench_'+identity))
            if not r['verified']:raise RuntimeError(r)
        out.write(json.dumps(r)+'\n');out.flush();done[identity]=r
        print(json.dumps({k:r[k] for k in ('id','file','status','calls','cpu')}),flush=True)
summary={}
for mode in modes:
    rr=[r for r in done.values() if r['mode']==mode]
    negatives=[r for r in rr if r['expected']=='NONE']
    summary[mode]=dict(cases=len(rr),status=dict(collections.Counter(r['status'] for r in rr)),calls=sum(r['calls'] for r in rr),cpu=sum(r['cpu'] for r in rr),completed_negatives=sum(r['status']=='NONE' for r in negatives),ratios=[round(r['calls']/r['old_calls'],6) for r in negatives])
(folder/'summary.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(summary),flush=True)
