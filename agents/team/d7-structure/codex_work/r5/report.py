import collections,csv,hashlib,json,pathlib,re,subprocess,sys
from analyse import *
groups=['s3','bound','trim_bound','trim_tail','trim_early','hpair','htriple']
exact=[];summary=[];unique=set()
for g in groups:
    a=json.loads((DIR/f'results_{g}.json').read_text())
    for r in a:
        r=dict(r,engine='pool_bfs + necessary rank-preservation pruning',group=g);exact.append(r)
        unique.add(frozenset(tuple(map(int,l.split())) for l in (ROOT/r['file']).read_text().splitlines()))
    summary.append(dict(group=g,runs=len(a),sizes=sorted(set(r['size'] for r in a)),R=sorted(set(r['R'] for r in a)),results=dict(collections.Counter(r['result'] for r in a))))
pre=[]
for fn in ['results_all.json','results_trim_bound_original.json']:
    for r in json.loads((DIR/fn).read_text()):pre.append(dict(r,engine='unmodified ./pool_bfs',group='preliminary'))
meta={r['id']:r for fn in ['manifest_full.json','manifest.json'] for r in json.loads((DIR/fn).read_text())}
for tag in ['bound_CEmin_ADmin','trim_bound_CEmin_AEmax','trim_bound_CEmin_ADmin']:
    pre.append(dict(meta[tag],R=10,result='INTERRUPTED',seconds=None,engine='unmodified ./pool_bfs',group='preliminary'))
for k in [31,32]:
    txt=(DIR/f'live_control{k}.txt').read_text();r=re.search(r'R = (\d+)',txt)
    exact.append(dict(id=f'baseline_K{k}',idea='Original term pool control',file='codex_work/r5/pool_control.txt',size=25,R=int(r[1]),result='NONE <= 31' if k==31 else 'MIN k = 32',seconds=None,engine='pool_bfs + necessary rank-preservation pruning',group='baseline',K=k))
allruns=pre+exact
with (DIR/'runs.csv').open('w') as f:
    wr=csv.DictWriter(f,fieldnames=['group','id','idea','file','size','R','K','result','seconds','engine'],extrasaction='ignore');wr.writeheader();wr.writerows(dict(r,K=r.get('K',31)) for r in allruns)
judge=[]
for f in ['control32_found.s','window_tail_w5.s']:
    r=subprocess.run([sys.executable,'/path/to/repo/shared/judge.py',str(DIR/f),'--strict','--model','out'],capture_output=True,text=True)
    p=readprog(DIR/f);ct=collections.Counter(s.split()[0] for s in p)
    judge.append(dict(file=f,result=r.stdout+r.stderr,rc=r.returncode,c=ct['cmp'],g=sum(v for k,v in ct.items() if k.startswith('cmov')),v=ct['mov']))
(DIR/'controls_judge.json').write_text(json.dumps(judge,indent=2))
status=dict(result='No k<=31 candidate found',groups=summary,completed_design_pool_searches=len(exact)-2,distinct_design_pools=len(unique),baseline_controls=exact[-2:],preliminary=pre,controls=judge,local_synthesis=[json.loads((DIR/f).read_text()) for f in ['window_tail.json','window_tailg_w4.json','window_max.json','window_maxcore_w9.json','window_max_w9_423.json']],limits='Pool exclusions apply only to their columns. Local SMT result applies only to the fixed post-H register state. No global lower bound follows.')
(DIR/'summary.json').write_text(json.dumps(status,indent=2))
print(json.dumps({k:v for k,v in status.items() if k in ['groups','completed_pool_searches','distinct_completed_pools','controls']},indent=2))
