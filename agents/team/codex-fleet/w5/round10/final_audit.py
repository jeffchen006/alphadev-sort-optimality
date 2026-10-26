"""Audit saved results. Do not turn a limit into a completed exclusion."""
from pathlib import Path
import collections,hashlib,json,re
HERE=Path(__file__).resolve().parent
def sha(b):return hashlib.sha256(b).hexdigest()
generated=json.loads((HERE/'generated_manifest.json').read_text());unique={}
for r in generated:
 p=HERE/r['file'];assert sha(p.read_bytes())==r['sha256']
 assert r['weak_order_failures']==0
 unique.setdefault(r['canonical_sha256'],r)
records=[];integrity=[]
for file in sorted(HERE.glob('*_results.jsonl')):
 for line in file.read_text().splitlines():
  r=json.loads(line);records.append(r)
  if 'log' not in r:continue
  p=Path(r['log']);assert sha(p.read_bytes())==r['log_sha256'],p
  txt=p.read_text();m=re.search(r'RESULT (\w+) K=(\d+) calls=(\d+) leaves=(\d+) sols=(\d+) best=(-?\d+)',txt)
  if r['status']=='NONE':
   assert r['exitcode']==0 and m and m[1]=='NONE' and int(m[2])==r['k']
   assert int(m[3])==r['calls']<=r['node_limit'] and int(m[5])==0
   assert r['canonical_sha256'] in unique
   assert sha((HERE/r['file']).read_bytes())==r['sha256']
   integrity.append({k:r[k] for k in ('canonical_sha256','file','k','calls','node_limit','log','log_sha256')})
latest={}
for r in records:
 if r.get('k')!=31:continue
 key=r['canonical_sha256']
 if r['status']=='NONE' or key not in latest:latest[key]=r
expected={h for h,r in unique.items() if r['min_block_distance']>=4 and not r['known_match'] and not r['w13_reserved']}
assert set(latest)==expected,(len(latest),len(expected),'unexpected routed target set')
closed=set((HERE/'closed.txt').read_text().splitlines())
assert closed=={h for h,r in latest.items() if r['status']=='NONE'}
judges=[]
for line in (HERE/'judge_ledger.jsonl').read_text().splitlines():
 r=json.loads(line);p=Path(r['file']);log=Path(r['log'])
 assert sha(p.read_bytes())==r['sha256'] and log.read_text()==r['output']
 if r['status']=='PASS':
  assert r['output'].startswith('PASS ') and '[relaxed+strict]' in r['output']
  code=[s.split('#',1)[0].strip() for s in p.read_text().splitlines()]
  length=sum(bool(s) and not s.startswith('out') for s in code)
  assert f'L={length} ' in r['output'];r['length']=length
 judges.append(r)
summary=dict(generated_records=len(generated),unique_skeletons=len(unique),
 far_target_skeletons=len(latest),final_status=dict(collections.Counter(r['status'] for r in latest.values())),
 near_skeletons_not_routed=sum(r['min_block_distance']<4 for r in unique.values()),
 direct_none_records=len(integrity),recorded_calls=sum(r.get('calls') or 0 for r in records if r.get('k')==31),
 query_wall_seconds=sum(r.get('wall_seconds',0) for r in records if r.get('k')==31),
 pass_files=[r for r in judges if r['status']=='PASS'],limited_queries=[r for r in latest.values() if r['status']!='NONE'],
 assumption_tags=['G1','G2','G3','A4','A6'],assumptions_challenged=[],
 target_pass=any(r['status']=='PASS' and r['model']=='out' and r['length']<=31 for r in judges))
(HERE/'routing_integrity.json').write_text(json.dumps(integrity,indent=2)+'\n')
(HERE/'final_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k not in ('pass_files','limited_queries')},indent=2))
