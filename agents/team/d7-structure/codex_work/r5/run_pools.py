import concurrent.futures,json,os,pathlib,re,subprocess,time,sys
D=pathlib.Path(__file__).resolve().parent;ROOT=D.parents[1]
os.sched_setaffinity(0,{0,1})
M=json.loads((D/os.environ.get('D7_MANIFEST','manifest.json')).read_text()); results=[]; start=time.monotonic()
if len(sys.argv)>1:M=[m for m in M if m['id'].startswith(sys.argv[1])]
def run(m):
    path=D/('log_'+m['id']+'.txt');t=time.monotonic()
    if (D/'STOP').exists() or time.monotonic()-start>850:return dict(m,result='NOT RUN',R=None,seconds=0,rc=-1)
    with path.open('w') as f:
        try:
            r=subprocess.run([binary,m['file'],'31','0'],cwd=ROOT,stdout=f,stderr=subprocess.STDOUT,timeout=45)
            rc=r.returncode
        except subprocess.TimeoutExpired:rc=-9
    s=path.read_text();ans=re.search(r'(MIN k = \d+|NONE <= \d+|ABORT[^\n]*)',s)
    r=re.search(r'R = (\d+)',s)
    out=dict(m,result=ans[0] if ans else 'TIMEOUT' if rc==-9 else 'ERROR',R=int(r[1]) if r else None,seconds=round(time.monotonic()-t,3),rc=rc)
    if ans and ans[0].startswith('MIN'):print('HIT',out,flush=True)
    return out
suffix=sys.argv[1] if len(sys.argv)>1 else 'all'
binary=os.environ.get('D7_BFS','./pool_bfs')
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
    for i,r in enumerate(pool.map(run,M)):
        results.append(r);(D/f'results_{suffix}.json').write_text(json.dumps(results,indent=2))
        if i%10==0:print(i+1,len(M),r['id'],r['result'],round(time.monotonic()-start,1),flush=True)
print('DONE',len(results),round(time.monotonic()-start,1),flush=True)
