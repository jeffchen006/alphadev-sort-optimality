"""Search a frozen queue with a chosen order. Never classify LIMIT as NONE."""
import argparse,collections,json,os,re,resource,subprocess,time
from pathlib import Path
from round2_run import limits,verify

def main():
    p=argparse.ArgumentParser()
    p.add_argument('--manifest',required=True);p.add_argument('--tag',required=True)
    p.add_argument('--mode',type=int,required=True);a=p.parse_args()
    if os.nice(0)<19:os.nice(19-os.nice(0))
    limits();folder=Path('logs')/a.tag;folder.mkdir(exist_ok=True)
    queue=json.loads(Path(a.manifest).read_text());dst=folder/'results.jsonl'
    completed={}
    if dst.exists():
        for l in dst.read_text().splitlines():
            r=json.loads(l);completed[r['file']]=r
    def snapshot():
        rr=list(completed.values());groups={}
        for g in sorted({r['required_gates'] for r in queue}):
            x=[r for r in rr if r['required_gates']==g]
            groups[str(g)]=dict(total=sum(r['required_gates']==g for r in queue),completed=len(x),status=dict(collections.Counter(r['status'] for r in x)),states=sum(r.get('calls',0) for r in x))
        x=dict(total=len(queue),completed=len(rr),mode=a.mode,status=dict(collections.Counter(r['status'] for r in rr)),states=sum(r.get('calls',0) for r in rr),seconds=sum(r.get('seconds',0) for r in rr),cpu=sum(r.get('cpu',0) for r in rr),peak_rss_kib=max((r.get('peak_rss_kib',0) for r in rr),default=0),gates=groups)
        (folder/'summary.json').write_text(json.dumps(x,indent=2)+'\n');return x
    print(json.dumps(dict(start=a.tag,**snapshot())),flush=True)
    with dst.open('a') as stream:
      for source in queue:
        if source['file'] in completed:continue
        identity=source['file'].replace('/','_').replace('.txt','')
        log=folder/(identity+'.log');(folder/'active.json').write_text(json.dumps(source,indent=2)+'\n')
        env=dict(os.environ,ROUTE_ORDER=str(a.mode));start=time.monotonic();before=resource.getrusage(resource.RUSAGE_CHILDREN)
        proc=subprocess.run(['./dagx_order',source['file'],'31','1',str(source['node_limit'])],capture_output=True,text=True,preexec_fn=limits,env=env)
        after=resource.getrusage(resource.RUSAGE_CHILDREN);text=proc.stdout+proc.stderr;log.write_text(text)
        match=re.search(r'RESULT (\w+).*?calls=(\d+)',text)
        r=dict(source,log=str(log),mode=a.mode,status=match[1] if match else 'ERROR',cost=31,calls=int(match[2]) if match else 0,seconds=round(time.monotonic()-start,3),cpu=after.ru_utime+after.ru_stime-before.ru_utime-before.ru_stime,peak_rss_kib=after.ru_maxrss,returncode=proc.returncode)
        if r['status']=='FOUND':
            actual=int(re.search(r'SOLUTION cost=(\d+)',text)[1]);r.update(verify(text,'round3_'+identity));r['actual_cost']=actual
            if not r['verified']:r['status']='REJECTED'
            else:
                result=Path('RESULTS.md');result.write_text('FOUND k='+str(actual)+' '+r['program']+'; strict out and mem PASS\n'+r['judge']+'\n'+result.read_text())
        stream.write(json.dumps(r)+'\n');stream.flush();completed[r['file']]=r;info=snapshot()
        print(json.dumps(dict(done=len(completed),file=r['file'],gates=r['required_gates'],status=r['status'],calls=r['calls'],cpu=r['cpu'],counts=info['status'],states=info['states'])),flush=True)
    (folder/'active.json').unlink(missing_ok=True);print(json.dumps(dict(finished=a.tag,**snapshot())),flush=True)
if __name__=='__main__':main()
