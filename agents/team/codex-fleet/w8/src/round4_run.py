"""Search frozen new-class queues. Preserve limits as unknown results."""
import argparse,collections,json,os,re,resource,subprocess,time
from pathlib import Path
from round2_run import limits,verify

def main():
    p=argparse.ArgumentParser()
    p.add_argument('--manifest',required=True);p.add_argument('--tag',required=True)
    p.add_argument('--mode',type=int,required=True);p.add_argument('--cost',type=int,default=31);a=p.parse_args()
    if os.nice(0)<19:os.nice(19-os.nice(0))
    limits()
    if a.tag=='round4_repeat10' and not Path('logs/round4_semantic_audit.json').exists():
        subprocess.run(['python3','src/round4_audit.py'],check=True)
    folder=Path('logs')/a.tag;folder.mkdir(exist_ok=True)
    queue=json.loads(Path(a.manifest).read_text());dst=folder/'results.jsonl';completed={}
    if dst.exists():
        for l in dst.read_text().splitlines():
            r=json.loads(l);completed[r['file']]=r
    totals=collections.Counter(r['required_gates'] for r in queue)
    status=collections.Counter();groups={g:dict(total=n,completed=0,status=collections.Counter(),states=0) for g,n in sorted(totals.items())}
    states=0;seconds=0.;cpu=0.;peak=0
    def add(r):
        nonlocal states,seconds,cpu,peak
        status[r['status']]+=1;states+=r.get('calls',0);seconds+=r.get('seconds',0);cpu+=r.get('cpu',0);peak=max(peak,r.get('peak_rss_kib',0))
        g=groups[r['required_gates']];g['completed']+=1;g['status'][r['status']]+=1;g['states']+=r.get('calls',0)
    for r in completed.values():add(r)
    def snapshot():
        x=dict(total=len(queue),completed=len(completed),mode=a.mode,cost=a.cost,status=dict(status),states=states,seconds=seconds,cpu=cpu,peak_rss_kib=peak,gates=groups)
        (folder/'summary.json').write_text(json.dumps(x,indent=2)+'\n');return x
    print(json.dumps(dict(start=a.tag,**snapshot())),flush=True)
    with dst.open('a') as stream:
      for source in queue:
        if source['file'] in completed:continue
        identity=source['file'].replace('/','_').replace('.txt','')
        log=folder/(identity+'.log');(folder/'active.json').write_text(json.dumps(source,indent=2)+'\n')
        env=dict(os.environ,ROUTE_ORDER=str(a.mode));start=time.monotonic();before=resource.getrusage(resource.RUSAGE_CHILDREN)
        proc=subprocess.run(['./dagx_order',source['file'],str(a.cost),'1',str(source['node_limit'])],capture_output=True,text=True,preexec_fn=limits,env=env)
        after=resource.getrusage(resource.RUSAGE_CHILDREN);text=proc.stdout+proc.stderr;log.write_text(text)
        match=re.search(r'RESULT (\w+).*?calls=(\d+)',text)
        r=dict(source,log=str(log),mode=a.mode,status=match[1] if match else 'ERROR',cost=a.cost,calls=int(match[2]) if match else 0,seconds=round(time.monotonic()-start,3),cpu=after.ru_utime+after.ru_stime-before.ru_utime-before.ru_stime,peak_rss_kib=after.ru_maxrss,returncode=proc.returncode)
        if r['status']=='FOUND':
            actual=int(re.search(r'SOLUTION cost=(\d+)',text)[1]);r.update(verify(text,'round4_'+identity));r['actual_cost']=actual
            if not r['verified']:r['status']='REJECTED'
            elif actual<=31:
                result=Path('RESULTS.md');result.write_text('FOUND k='+str(actual)+' '+r['program']+'; strict out and mem PASS\n'+r['judge']+'\n'+result.read_text())
        stream.write(json.dumps(r)+'\n');stream.flush();completed[r['file']]=r;add(r)
        if len(completed)%25==0 or r['status'] in ('FOUND','REJECTED','ERROR'):
            snapshot();print(json.dumps(dict(done=len(completed),file=r['file'],status=r['status'],counts=status,states=states)),flush=True)
    (folder/'active.json').unlink(missing_ok=True);print(json.dumps(dict(finished=a.tag,**snapshot())),flush=True)
if __name__=='__main__':main()
