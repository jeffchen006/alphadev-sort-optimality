from pathlib import Path
import json,re,hashlib,collections
folder=Path('round6');jobs=[]
for p in sorted((folder/'artifacts').glob('*.json')):
 try:r=json.loads(p.read_text())
 except Exception:continue
 if isinstance(r,dict) and {'name','command','exit','log'}<=r.keys():
  r=dict(r);r['status']='UNKNOWN_LIMIT' if r['exit']==124 else 'FINISHED' if r['exit']==0 else 'FAILED'
  if r['name']=='c7_packed':r['status']='INVALID_NO_SEARCH'
  r['last_status']=[x for x in Path(r['log']).read_text().splitlines() if x.startswith(('SUMMARY','STATUS','done ','bestwrong=','{"status"'))][-2:]
  jobs.append(r)
mem=[];totit=totacc=0
for r in jobs:
 if not r['name'].startswith('mem_'):continue
 text=Path(r['log']).read_text();m=re.search(r'done it=(\d+) acc=(\d+).*time=([0-9.]+)s',text)
 best=Path('round6/candidates',r['name']+'_best.s');header=best.read_text().splitlines()[0] if best.exists() else ''
 counts=collections.Counter(l.split()[0] for l in best.read_text().splitlines() if l.strip() and not l.startswith('#')) if best.exists() else {}
 row=dict(name=r['name'],exit=r['exit'],status=r['status'],file=str(best),header=header,instructions=dict(counts),final_counters=bool(m))
 if m:row.update(iterations=int(m[1]),accepted=int(m[2]),cpu_seconds=float(m[3]));totit+=int(m[1]);totacc+=int(m[2])
 mem.append(row)
paired=[];counts=collections.Counter()
for p in sorted((folder/'logs').glob('class_*_two.log')):
 lines=[l for l in p.read_text().splitlines() if l.startswith('SUMMARY ')]
 if not lines:continue
 r={k:(float(v) if '.' in v else int(v)) for k,v in re.findall(r'(\w+)=([0-9.]+)',lines[-1])};r['log']=str(p);paired.append(r)
 for k in ('singles','pairs','tried','filtered','full','hits'):counts[k]+=r[k]
passes=[];copies=[]
for p in sorted((folder/'artifacts').glob('*_judge.json')):
 r=json.loads(p.read_text())
 for model in ('out','mem'):
  x=r.get(model,{})
  if not x.get('pass'):continue
  source=Path(x['file']);passes.append(dict(file=str(source),model=model,k=r['k'],log=x['log'],sha256=hashlib.sha256(source.read_bytes()).hexdigest()))
 if r.get('out',{}).get('pass'):
  c=folder/'verified'/Path(r['source']).name
  if c.exists():copies.append(dict(file=str(c),source=r['source'],sha256=hashlib.sha256(c.read_bytes()).hexdigest()))
near=json.loads((folder/'artifacts/near_judges.json').read_text())
for r in near:assert r['result'].startswith('FAIL '),(r['file'],r['result'])
for r in passes:assert r['k']==32 or (folder/'artifacts/FOUND').exists(),r
c7_near=json.loads((folder/'artifacts/c7_near_judges.json').read_text())
assert all(r['result']=='FAIL' for r in c7_near)
sources={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted((folder/'src').glob('*')) if p.is_file()}
result=dict(result='No strict PASS with core k <= 31 was found.' if not (folder/'artifacts/FOUND').exists() else (folder/'artifacts/FOUND').read_text(),jobs=jobs,memory_runs=mem,memory_complete_counter_totals=dict(iterations=totit,accepted=totacc,runs=sum(x['final_counters'] for x in mem)),class_pair_repairs=paired,class_pair_totals=dict(counts),strict_passes=passes,retained_pass_copies=copies,near_strict_failures=near,c7_near_strict_failures=c7_near,source_hashes=sources)
(folder/'artifacts/final_summary.json').write_text(json.dumps(result,indent=2));print(json.dumps({k:result[k] for k in ('result','memory_complete_counter_totals','class_pair_totals')},indent=2));print('jobs',len(jobs),'passes',len(passes),'copies',len(copies))
