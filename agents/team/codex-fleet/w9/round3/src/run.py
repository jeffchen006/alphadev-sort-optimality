"""Build a reproducible queue, then run one CPU job at a time."""
import argparse
from collections import Counter
from datetime import datetime,timezone
import hashlib
import json
import os
from pathlib import Path
import resource
import sys
import time

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parents[1]
OLD = HERE.parent/'round2'
sys.path.insert(0, str(OLD/'src'))
from control import transformed
from order_kissat import solve, CASES, evaluate


def query_key(row):
    return (row['family'],tuple(row['order']),row['k'],row['regs'],row.get('prefix_length',0),
            tuple(row.get('positions') or ()),row.get('polarity',False),row.get('source',''))


def prepare():
    families=json.loads((OLD/'artifacts/orders.json').read_text())['families']
    latest={}
    for file in sorted((OLD/'artifacts').glob('*.jsonl')):
        for line in file.read_text().splitlines():
            row=json.loads(line)
            latest[query_key(row)]=row
    assert len(latest)==795
    assert Counter(row['status'] for row in latest.values())=={'UNSAT':94,'UNKNOWN':701}
    unknown=[row for row in latest.values() if row['status']=='UNKNOWN']
    unknown.sort(key=lambda row:(row['variables'],row['clauses'],row['family'],row['order']))
    manifest=[]
    for i,previous in enumerate(unknown):
        family=next(row for row in families if row['id']==previous['family'])
        family=dict(family,source=previous.get('source') or family['source'])
        p,R,old=transformed(family)
        n=previous.get('prefix_length',0)
        manifest.append({'queue_index':i,'previous':previous,'row':family,
                         'prefix':p[:n],'source_sha256':hashlib.sha256(Path(family['source']).read_bytes()).hexdigest(),
                         'size_order':['variables','clauses','family','order']})
    path=HERE/'artifacts/unknown_queue.json'
    path.write_text(json.dumps(manifest,indent=2)+'\n')
    print(json.dumps({'queue':str(path),'queries':len(manifest),
                      'smallest':{k:manifest[0]['previous'].get(k) for k in ('variables','clauses','prefix_length','family','index')},
                      'largest_variables':manifest[-1]['previous']['variables']}),flush=True)


def run_unknown(a):
    if a.origin_cuts:
        control_path=HERE/'artifacts/origin_controls.json'
        assert control_path.exists(),'Run origin_controls.py before enabling comparison-origin constraints'
        controls=json.loads(control_path.read_text())
        assert len(controls)==6 and all(row.get('strict_pass') for row in controls)
    queue=json.loads((HERE/'artifacts/unknown_queue.json').read_text())
    filter_path=HERE/'artifacts/unknown_weak_filter.json'
    filters=json.loads(filter_path.read_text()) if filter_path.exists() else []
    result_path=HERE/'artifacts/kissat_unknown.jsonl'
    done={json.loads(line)['queue_index'] for line in result_path.read_text().splitlines()} if result_path.exists() else set()
    with result_path.open('a') as stream:
        for item in queue[a.first:a.first+a.count]:
            i=item['queue_index']
            if i in done:continue
            old=item['previous'];tag=f'unknown_{i:04d}'
            local=argparse.Namespace(k=old['k'],regs=old['regs'],seconds=a.seconds,
                                    types=12 if old.get('polarity',False) else 8,add=5,
                                    polarity=old.get('polarity',False),save_models=True,tag=tag,
                                    seed_cases=filters[i].get('witness_cases',[]) if filters else [],
                                    origin_cuts=a.origin_cuts)
            print(json.dumps({'event':'query_start','tag':tag,'family':old['family'],
                              'old_variables':old['variables'],'prefix_length':len(item['prefix']),
                              'limit_seconds':a.seconds}),flush=True)
            update_live(result_path,current=i)
            row=solve(item['row'],old['order'],local,item['prefix'],
                      item['row']['source'],old.get('positions'))
            row.update(queue_index=i,old_status='UNKNOWN',old_key=list(query_key(old)),
                       limit_seconds=a.seconds,old_variables=old['variables'],old_clauses=old['clauses'],
                       weak_filter=filters[i] if filters else None,seed_cases=local.seed_cases)
            row['origin_cuts']=a.origin_cuts
            text=json.dumps(row);stream.write(text+'\n');stream.flush();print(text,flush=True)
            update_live(result_path)
            if row.get('strict_pass'):
                record_found(row)
                return


def update_live(result_path,current=None):
    rows=[json.loads(line) for line in result_path.read_text().splitlines()]
    status=Counter(row['status'] for row in rows)
    resolved=status.get('UNSAT',0)
    stamp=datetime.now(timezone.utc).isoformat()
    current_text=f'Queue index {current} is running. Its result remains UNKNOWN until the query finishes.\n\n' if current is not None else ''
    text=(f'Updated {stamp}.\n\n'
          f'Kissat reruns recorded: {len(rows)}/701.\n\n'
          f'Rerun status: {dict(status)}.\n\n'
          f'Original solver ledger: {94+resolved} UNSAT; {701-resolved} UNKNOWN.\n\n'
          +current_text+
          'Each query has a 900-second wall budget. Time limits remain UNKNOWN. '
          'The result JSONL file records query limits, source restrictions, solver logs, '
          'SAT models, strict-judge outputs, and resource use.\n')
    path=HERE/'LIVE.md';temporary=path.with_suffix('.tmp')
    temporary.write_text(text);temporary.replace(path)


def record_found(row):
    path=HERE.parent/'RESULTS.md'
    old=path.read_text()
    path.write_text(f"FOUND k={row['k']} strict out PASS: {row['path']}\n"+old)


def controls():
    families=json.loads((OLD/'artifacts/orders.json').read_text())['families']
    rows=[]
    for i in (0,2,5):
        family=families[i];p,R,order=transformed(family)
        a=argparse.Namespace(k=len(p),regs=R,seconds=30,types=12,add=5,
                             polarity=False,save_models=True,tag=f'control_{i}')
        row=solve(family,order,a,p,family['source'])
        assert row.get('strict_pass'),row
        rows.append(row)
    (HERE/'artifacts/controls.json').write_text(json.dumps(rows,indent=2)+'\n')


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('mode',choices=['prepare','controls','unknown'])
    ap.add_argument('--seconds',type=float,default=900)
    ap.add_argument('--first',type=int,default=0)
    ap.add_argument('--count',type=int,default=701)
    ap.add_argument('--origin-cuts',action='store_true')
    a=ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS,0)==19,'Run with nice -n 19'
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    {'prepare':prepare,'controls':controls,'unknown':lambda:run_unknown(a)}[a.mode]()


if __name__=='__main__':main()
