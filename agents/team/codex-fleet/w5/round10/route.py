"""Run one exact routing process at a time. Save limits as UNKNOWN."""
import argparse,collections,hashlib,json,os,re,resource,subprocess,time
from pathlib import Path

HERE=Path(__file__).resolve().parent
JUDGE=Path('/path/to/repo/shared/judge.py')
def sha(b):return hashlib.sha256(b).hexdigest()
def verify(lines,stem):
 out=HERE/'verified'/f'{stem}.s'
 out.write_text('# n=5 iset=I1 model=out source=w5_round10\n'+'\n'.join(lines)+'\n')
 mem=out.with_name(out.stem+'_mem.s')
 def r(x):return 'S'+str(int(x[1:])+(5 if x[0]=='S' else 0))
 body=[f'mov S{i}, P{i}' for i in range(5)]
 for l in lines:
  op,a,b=l.replace(',','').split()
  body.append(f'mov P{a}, {r(b)}' if op=='out' else f'{op} {r(a)}, {r(b)}')
 mem.write_text('# n=5 iset=I1 model=mem source=w5_round10\n'+'\n'.join(body)+'\n')
 records=[]
 for p,model in ((out,'out'),(mem,'mem')):
  res=subprocess.run(['python3',str(JUDGE),str(p),'--strict','--model',model],capture_output=True,text=True)
  txt=res.stdout+res.stderr;log=HERE/'logs'/('judge_'+p.stem+'.log');log.write_text(txt)
  rec=dict(file=str(p),model=model,status='PASS' if res.returncode==0 and txt.startswith('PASS ') else 'FAIL',
           sha256=sha(p.read_bytes()),log=str(log),output=txt)
  (HERE/'judge_ledger.jsonl').open('a').write(json.dumps(rec)+'\n');records.append(rec)
 k=sum(not l.startswith('out') for l in lines)
 if k<=31 and all(r['status']=='PASS' for r in records):
  results=HERE.parent/'RESULTS.md';results.write_text(f'FOUND k={k} {out}; both strict judges PASS\n'+results.read_text())
 return records

def main():
 ap=argparse.ArgumentParser();ap.add_argument('tag');ap.add_argument('--limit',type=int,default=3000000)
 ap.add_argument('--wall',type=float,default=90);ap.add_argument('--k',type=int,default=31)
 ap.add_argument('--count',type=int,default=100000);ap.add_argument('--min-distance',type=int,default=4)
 ap.add_argument('--mode',type=int,default=13);ap.add_argument('--deepen',action='store_true')
 a=ap.parse_args();os.nice(max(0,19-os.nice(0)));os.sched_setaffinity(0,{77})
 resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
 folder=HERE/'logs'/a.tag;folder.mkdir(exist_ok=True);resultfile=HERE/(a.tag+'_results.jsonl')
 rows=json.loads((HERE/'queue.json').read_text());rows=[r for r in rows if r['min_block_distance']>=a.min_distance]
 if a.deepen:
  previous=[json.loads(l) for p in HERE.glob('*_results.jsonl') for l in p.read_text().splitlines()]
  direct={r['canonical_sha256']:r for r in previous if r.get('status')=='NONE' and r.get('k')==a.k}
  rows=[r for r in rows if r['canonical_sha256'] not in direct]
 else:
  previous=[json.loads(l) for p in HERE.glob('*_results.jsonl') if p!=resultfile for l in p.read_text().splitlines()]
  touched={r['canonical_sha256'] for r in previous if r.get('k')==a.k}
  rows=[r for r in rows if r['canonical_sha256'] not in touched]
 rows=rows[:a.count]
 old=[json.loads(l) for l in resultfile.read_text().splitlines()] if resultfile.exists() else []
 done={r['canonical_sha256'] for r in old};records=old;start=time.monotonic()
 for row in rows:
  if row['canonical_sha256'] in done:continue
  # Read the current w13 reservations before each route.
  closed=HERE.parent.parent/'w13/closed.txt'
  if closed.exists() and row['canonical_sha256'] in set(closed.read_text().split()):
   rec=dict(**row,k=a.k,status='SKIP_W13_CLOSED');records.append(rec);resultfile.open('a').write(json.dumps(rec)+'\n');continue
  path=HERE/row['file'];assert sha(path.read_bytes())==row['sha256']
  log=folder/f'{row["index"]:04d}.log';env=os.environ|{'ROUTE_ORDER':str(a.mode),'OMP_NUM_THREADS':'1'}
  cmd=[str(HERE/'bin/dagx_order'),str(path),str(a.k),'1',str(a.limit)]
  t=time.monotonic();exitcode=None
  try:
   p=subprocess.run(cmd,capture_output=True,text=True,timeout=a.wall,env=env);txt=p.stdout+p.stderr;exitcode=p.returncode
  except subprocess.TimeoutExpired as e:
   txt=(e.stdout or b'').decode()+(e.stderr or b'').decode()+'\nUNKNOWN_WALL_LIMIT\n'
  log.write_text(txt);m=re.search(r'RESULT (\w+) K=(\d+) calls=(\d+) leaves=(\d+) sols=(\d+) best=(-?\d+)',txt)
  status=m[1] if m else 'UNKNOWN_WALL_LIMIT' if 'UNKNOWN_WALL_LIMIT' in txt else 'ERROR'
  if status=='LIMIT':status='UNKNOWN_NODE_LIMIT'
  rec=dict(**row,k=a.k,status=status,node_limit=a.limit,wall_limit=a.wall,mode=a.mode,command=cmd,
           calls=int(m[3]) if m else None,best=int(m[6]) if m else None,exitcode=exitcode,
           wall_seconds=time.monotonic()-t,log=str(log),log_sha256=sha(log.read_bytes()))
  if status=='FOUND':
   lines=txt.split('SOLUTION ',1)[1].split('\n',1)[1].split('\nEND',1)[0].splitlines()
   rec['verification']=verify(lines,f'{a.tag}_{row["index"]:04d}_k{rec["best"]}')
  if status=='NONE' and a.k==31:(HERE/'closed.txt').open('a').write(row['canonical_sha256']+'\n')
  records.append(rec);resultfile.open('a').write(json.dumps(rec)+'\n')
  summary=dict(tag=a.tag,planned=len(rows),completed=len(records),status=dict(collections.Counter(r['status'] for r in records)),
               calls=sum(r.get('calls') or 0 for r in records),wall_seconds=sum(r.get('wall_seconds',0) for r in records),
               max_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss)
  (HERE/(a.tag+'_progress.json')).write_text(json.dumps(summary,indent=2)+'\n')
  print(json.dumps(summary),flush=True)
 print('BATCH_FINISHED',flush=True)

if __name__=='__main__':main()
