import json,subprocess,concurrent.futures,time,os,re
ROOT='codex_work/r3'
try:os.sched_setaffinity(0,set(sorted(os.sched_getaffinity(0))[:2]))
except (AttributeError,OSError):pass
manifest=json.load(open(ROOT+'/manifest.json'))
done=json.load(open(ROOT+'/results.json')) if os.path.exists(ROOT+'/results.json') else {}
def run(e):
    fn=ROOT+'/log_'+e['tag']+'.txt';t=time.monotonic()
    with open(fn,'w') as f:
        try:
            p=subprocess.run(['./pool_bfs',e['file'],'31','0'],stdout=f,stderr=subprocess.STDOUT,timeout=150);rc=p.returncode
        except subprocess.TimeoutExpired:rc=-9
    elapsed=time.monotonic()-t;s=open(fn).read()
    result=re.findall(r'MIN k = \d+|NONE <= \d+|ABORT[^\n]*',s)
    status=result[-1] if result else ('TIMEOUT' if rc==-9 else 'ERROR '+str(rc))
    rr=re.search(r'^R = (\d+)',s,re.M);root=re.search(r'root: ([^\n]+)',s)
    return e['tag'],{'R':int(rr.group(1)) if rr else None,'result':status,'seconds':round(elapsed,3),'log':fn,'root':root.group(1) if root else None}
start=time.monotonic()
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as ex:
    fs=[ex.submit(run,e) for e in manifest if e['tag'] not in done]
    for f in concurrent.futures.as_completed(fs):
        tag,row=f.result();done[tag]=row;json.dump(done,open(ROOT+'/results.json','w'),indent=2)
        print(tag,row,'wall',round(time.monotonic()-start,1),flush=True)
