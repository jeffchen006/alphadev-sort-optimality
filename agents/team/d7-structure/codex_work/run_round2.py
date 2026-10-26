import json,subprocess,concurrent.futures,time,os,re
manifest=json.load(open('codex_work/round2_manifest.json'))
done=json.load(open('codex_work/round2_results.json')) if os.path.exists('codex_work/round2_results.json') else {}
def run(e):
    rows=[]
    for r in [9,10]:
        fn='codex_work/log_'+e['tag']+'_r%d.txt'%r;t=time.monotonic()
        with open(fn,'w') as f:
            try:
                p=subprocess.run(['./pool_bfs',e['file'],'31',str(r)],stdout=f,stderr=subprocess.STDOUT,timeout=100)
                rc=p.returncode
            except subprocess.TimeoutExpired:rc=-9
        elapsed=time.monotonic()-t;log=open(fn).read()
        result=re.findall(r'MIN k = \d+|NONE <= \d+|ABORT[^\n]*',log)
        status=result[-1] if result else ('TIMEOUT' if rc==-9 else 'ERROR '+str(rc))
        row={'R':r,'result':status,'seconds':round(elapsed,3),'log':fn};rows.append(row)
        if 'MIN k' in status or rc!=0 or elapsed>8:break
    return e['tag'],rows
start=time.monotonic()
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as ex:
    fs=[ex.submit(run,e) for e in manifest if e['tag'] not in done]
    for f in concurrent.futures.as_completed(fs):
        tag,rows=f.result();done[tag]=rows
        json.dump(done,open('codex_work/round2_results.json','w'),indent=2)
        print(tag,rows,'wall',round(time.monotonic()-start,1),flush=True)
