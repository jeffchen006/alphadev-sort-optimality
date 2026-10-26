"""Serial fixed-skeleton routing, with durable status and strict verification."""
import argparse, collections, hashlib, json, os, re, resource, subprocess, time
from pathlib import Path

ROOT=Path('/path/to/repo')
JUDGE=ROOT/'shared/judge.py'

def digest(file):
    keyfile=Path(file+'.key')
    if keyfile.exists():
        key=keyfile.read_text().strip()
    else:
        key=subprocess.check_output(['./generate','--key',file],text=True).strip()
        keyfile.write_text(key+'\n')
    return hashlib.sha256(key.encode()).hexdigest()

def verify(lines,stem):
    out=Path('programs')/(stem+'.s')
    out.write_text('# n=5 iset=I1 model=out\n'+'\n'.join(lines)+'\n')
    regs=sorted(set(re.findall(r'\b(?:P|S)\d+\b','\n'.join(lines))))
    rename={r:'S'+str(i) for i,r in enumerate(regs)}
    memlines=[f'mov {rename[f"P{i}"]}, P{i}' for i in range(5)]
    for line in lines:
        if line.startswith('out'):
            k,r=line[4:].split(',');memlines.append(f'mov P{k.strip()}, {rename[r.strip()]}')
        else:
            memlines.append(re.sub(r'\b(?:P|S)\d+\b',lambda m:rename[m[0]],line))
    mem=out.with_name(out.stem+'_mem.s')
    mem.write_text('# n=5 iset=I1 model=mem\n'+'\n'.join(memlines)+'\n')
    records=[]
    for file,model in ((out,'out'),(mem,'mem')):
        result=subprocess.run(['python3',str(JUDGE),str(file),'--strict','--model',model],capture_output=True,text=True)
        log=Path('logs')/(file.stem+'.judge.log');log.write_text(result.stdout+result.stderr)
        records.append(dict(file=str(file),model=model,passed=result.returncode==0 and 'PASS ' in result.stdout,log=str(log),output=result.stdout+result.stderr))
    Path('logs/judges.jsonl').open('a').write(json.dumps(records)+'\n')
    if all(x['passed'] for x in records) and sum(not l.startswith('out') for l in lines)<=31:
        p=Path('RESULTS.md');p.write_text('FOUND '+str(out)+'; strict out and mem PASS\n'+p.read_text())
    return records

def main():
    ap=argparse.ArgumentParser();ap.add_argument('tag');ap.add_argument('manifests',nargs='+');ap.add_argument('--limit',type=int,default=100000);ap.add_argument('--k',type=int,default=31);ap.add_argument('--required-max',type=int,default=100);ap.add_argument('--required-min',type=int,default=0);ap.add_argument('--mode',type=int,default=13);ap.add_argument('--timeout',type=int,default=90)
    a=ap.parse_args()
    current_nice=os.nice(0)
    if current_nice<10:os.nice(10-current_nice)
    resource.setrlimit(resource.RLIMIT_AS,(4*1024**3,4*1024**3))
    folder=Path('logs')/a.tag;folder.mkdir(exist_ok=True)
    rows=[]
    for mf in a.manifests:
        rows.extend(json.loads(line) for line in Path(mf).read_text().splitlines() if line.strip())
    rows=[r for r in rows if a.required_min<=r['required']<=a.required_max]
    rows.sort(key=lambda r:(r['required'],-r['nonlattice'],r['file']))
    done=set()
    results=folder/'results.jsonl'
    if results.exists():done={json.loads(l)['file'] for l in results.read_text().splitlines()}
    counts=collections.Counter();calls=0;start=time.monotonic()
    summary=dict(tag=a.tag,total=len(rows),processed=len(done),status={},calls=0,wall_seconds=0)
    for i,row in enumerate(rows):
        if row['file'] in done:continue
        log=folder/(Path(row['file']).parent.name+'_'+Path(row['file']).stem+'.log')
        command=['./dagx',row['file'],str(a.k),'1',str(a.limit)]
        env=os.environ|{'ROUTE_ORDER':str(a.mode)}
        t0=time.monotonic();before=resource.getrusage(resource.RUSAGE_CHILDREN)
        try:
            r=subprocess.run(command,capture_output=True,text=True,env=env,timeout=a.timeout)
            txt=r.stdout+r.stderr
        except subprocess.TimeoutExpired as e:
            txt=(e.stdout or b'').decode()+(e.stderr or b'').decode()+'\nWALL_TIMEOUT\n'
        after=resource.getrusage(resource.RUSAGE_CHILDREN);log.write_text(txt)
        m=re.search(r'RESULT (\w+) K=(\d+) calls=(\d+) leaves=(\d+) sols=(\d+) best=(-?\d+)',txt)
        status=m[1] if m else 'TIMEOUT' if 'WALL_TIMEOUT' in txt else 'ERROR'
        sha=digest(row['file'])
        rec=dict(row,status=status,k=a.k,node_limit=a.limit,mode=a.mode,calls=int(m[3]) if m else None,best=int(m[6]) if m else None,log=str(log),sha256=sha,wall_seconds=time.monotonic()-t0,cpu_seconds=after.ru_utime+after.ru_stime-before.ru_utime-before.ru_stime)
        if status=='NONE' and a.k==31:
            Path('closed.txt').open('a').write(sha+'\n')
            Path('logs/closed.jsonl').open('a').write(json.dumps(rec)+'\n')
        if status=='FOUND':
            lines=txt.split('SOLUTION ',1)[1].split('\n',1)[1].split('\nEND',1)[0].splitlines()
            rec['verification']=verify(lines,a.tag+'_'+Path(row['file']).parent.name+'_'+Path(row['file']).stem)
        results.open('a').write(json.dumps(rec)+'\n')
        counts[status]+=1;calls+=rec['calls'] or 0
        summary=dict(tag=a.tag,total=len(rows),processed=sum(counts.values())+len(done),status=dict(counts),calls=calls,wall_seconds=time.monotonic()-start)
        (folder/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
        if i%100==0 or status=='FOUND':print(json.dumps(summary),flush=True)
    print(json.dumps(summary if rows else dict(total=0)),flush=True)

if __name__=='__main__':main()
