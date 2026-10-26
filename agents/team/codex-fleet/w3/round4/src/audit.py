import hashlib,json,re
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
logs=ROOT/'round4/logs'; programs=ROOT/'round4/programs'
registry=[]
for path in sorted(programs.glob('*.s')):
 text=path.read_text()
 if not text.startswith('# n=5'):continue
 candidates=[path.with_suffix(path.suffix+'.judge.txt'), logs/(path.stem+'.judge'), logs/(re.sub(r'_i[0-9]+$','',path.stem)+'.log')]
 lines=[]
 for log in candidates:
  if log.exists():
   lines += [(str(log.relative_to(ROOT)),s) for s in log.read_text().splitlines() if 'PASS ' in s or 'FAIL ' in s]
 assert any('PASS ' in s for _,s in lines),(path,lines)
 instructions=[s for s in text.splitlines() if s.strip() and not s.startswith('#')]
 registry.append(dict(file=str(path.relative_to(ROOT)),model='mem' if 'model=mem ' in text.splitlines()[0] else 'out',length=sum(not s.startswith('out ') for s in instructions),comparisons=sum(s.startswith('cmp ') for s in instructions),judge=lines))
(logs/'judge_registry.json').write_text(json.dumps(registry,indent=2))
queries=[]
for path in sorted(logs.glob('*.log')):
 for line in path.read_text().splitlines():
  if line.startswith('{'):
   row=json.loads(line)
   if row.get('event')=='RESULT':queries.append(dict(log=path.name,**row))
counts={status:sum(q['result']==status for q in queries) for status in sorted(set(q['result'] for q in queries))}
classes=[tuple(map(int,line.split())) for line in (logs/'raw_classes.tsv').read_text().splitlines()]
checks=[]
for path in sorted(logs.glob('*.drat_check')):
 text=path.read_text();assert 's VERIFIED' in text
 checks.append(str(path.relative_to(ROOT)))
hashes={}
for path in sorted(list((ROOT/'round4/src').glob('*'))+list(logs.glob('*cert*.cnf'))+list(logs.glob('*cert*.drat'))):
 if path.is_file():hashes[str(path.relative_to(ROOT))]=hashlib.sha256(path.read_bytes()).hexdigest()
summary=dict(programs=sum(n for _,n in classes),raw_state_classes=len(classes),queries=queries,query_counts=counts,strict_pass=registry,certificates=checks,sha256=hashes)
(logs/'summary.json').write_text(json.dumps(summary,indent=2))
print(json.dumps({k:summary[k] for k in ('programs','raw_state_classes','query_counts')}))
print('strict_pass_files',len(registry),'checked_certificates',len(checks))
