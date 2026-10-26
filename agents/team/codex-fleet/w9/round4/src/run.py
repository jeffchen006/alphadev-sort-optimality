"""Round 4: ranked 600-second reruns and broader median-path repairs."""
import argparse
from collections import Counter
from datetime import datetime,timezone
import importlib.util
import json
import os
from pathlib import Path
import resource
import sys

sys.dont_write_bytecode=True
HERE=Path(__file__).resolve().parents[1]
OLD=HERE.parent/'round3'
sys.path.append(str(HERE.parent/'round2/src'))
from control import transformed
from order_kissat import solve

def rows(path):
    return [json.loads(line) for line in path.read_text().splitlines() if line.strip()] if path.exists() else []

def live(current=None):
    top=rows(HERE/'artifacts/top100.jsonl');extra=rows(HERE/'artifacts/median_extra3.jsonl')
    text=(f"Updated {datetime.now(timezone.utc).isoformat()}.\n\n"
          f"Ranked reruns: {len(top)}/100; {dict(Counter(r['status'] for r in top))}.\n\n"
          f"Absent-order repairs with three extra changed data slots: {len(extra)}/653; {dict(Counter(r['status'] for r in extra))}.\n\n"
          f"Current query: {current or 'none'}.\n\n"
          "Each ranked query has a 600-second wall limit shared across refinements. "
          "Repairs retain k=31 and allow up to three additional source data slots to change. "
          "Limits remain UNKNOWN. See each result for restrictions and resource use.\n")
    p=HERE/'LIVE.md';tmp=p.with_suffix('.tmp');tmp.write_text(text);tmp.replace(p)
    from report import report
    report()

def memory(path):
    lines=path.read_text().splitlines();mapping={f'P{i}':f'S{i}' for i in range(5)}
    result=['# n=5 model=mem iset=I1 source=w9-round4']+[f'mov S{i}, P{i}' for i in range(5)]
    for line in lines:
        code=line.split('#')[0].strip()
        if not code:continue
        op,args=code.split(None,1);d,s=[x.strip() for x in args.split(',')]
        for name in ([s] if op=='out' else [d,s]):
            if name not in mapping:mapping[name]=f'S{len(mapping)}'
        if op=='out':result.append(f'mov P{d}, {mapping[s]}')
        else:result.append(f'{op} {mapping[d]}, {mapping[s]}')
    target=path.with_name(path.stem+'_mem.s');target.write_text('\n'.join(result)+'\n')
    return target

def finish_candidate(row):
    if not row.get('strict_pass'):return False
    import subprocess
    path=Path(row['path']);mem=memory(path);log=HERE/'logs'/f'{mem.stem}_strict.log'
    with log.open('w') as stream:
        check=subprocess.run(['nice','-n','19','python3','-B',
              '/path/to/repo/shared/judge.py',
              str(mem),'--strict','--model','mem'],stdout=stream,stderr=subprocess.STDOUT)
    assert check.returncode==0 and 'PASS' in log.read_text(),str(log)
    row.update(memory_path=str(mem),memory_strict_log=str(log),memory_strict_pass=True)
    for p in (path,mem):(HERE/'verified'/p.name).write_bytes(p.read_bytes())
    if row['k']<=31:
        p=HERE.parent/'RESULTS.md'
        line=f"FOUND k={row['k']} strict out PASS: {path}; strict mem PASS: {mem}; memory judge: {log}\n"
        p.write_text(line+p.read_text())
        (HERE/'FOUND.json').write_text(json.dumps(row,indent=2)+'\n')
    return True

def controls():
    families=json.loads((HERE.parent/'round2/artifacts/orders.json').read_text())['families']
    result=[]
    for fi in (0,2,5):
        family=families[fi];p,R,order=transformed(family)
        insertion=next(t for t,x in enumerate(p) if x[0]!='cmp')
        baseline=p[:insertion]+[('mov',0,0)]+p[insertion:]
        # Three deliberately different fixed data slots need the new allowance.
        changed=[t for t,x in enumerate(baseline) if x[0]!='cmp' and t!=insertion][:3]
        for t in changed:
            assert tuple(baseline[t])!=('mov',0,0)
            baseline[t]=('mov',0,0)
        for budget in (3,2):
            a=argparse.Namespace(k=32,regs=max(9,R),seconds=30,types=12,add=5,
                polarity=False,save_models=True,tag=f'extra_control_{fi}_{budget}',
                repair=(baseline,[insertion],[insertion]),repair_extra=budget,
                pin_program=p,origin_cuts=True)
            r=solve(family,order,a)
            if budget==3:assert r.get('strict_pass'),r;finish_candidate(r)
            else:assert r['status']=='UNSAT',r
            r.update(extra_changed_budget=budget,control_changed_slots=changed)
            result.append(r)
    (HERE/'artifacts/controls.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'controls':len(result),'status':dict(Counter(r['status'] for r in result))}),flush=True)

def top100(a):
    ranks=json.loads((HERE/'artifacts/ranked_unknown.json').read_text())[:100]
    queue=json.loads((OLD/'artifacts/unknown_queue.json').read_text())
    filters=json.loads((OLD/'artifacts/unknown_weak_filter.json').read_text())
    assert len(json.loads((OLD/'artifacts/origin_controls.json').read_text()))==6
    path=HERE/'artifacts/top100.jsonl';done={r['queue_index'] for r in rows(path)}
    with path.open('a') as stream:
        for rank in ranks:
            if (HERE/'STOP_AFTER_QUERY').exists():live('stopped between queries');return
            i=rank['queue_index']
            if i in done:continue
            item=queue[i];previous=item['previous'];tag=f'top100_{rank["rank"]:03d}_{i:04d}'
            failures=rank['baseline_score']['failing_cases']
            sampled=failures if len(failures)<=64 else [failures[j*(len(failures)-1)//63] for j in range(64)]
            if not filters[i]['valid']:sampled=[]
            seeds=sorted(set(filters[i].get('witness_cases',[]))|set(sampled))
            local=argparse.Namespace(k=previous['k'],regs=previous['regs'],seconds=a.seconds,
                types=12 if previous.get('polarity',False) else 8,add=5,
                polarity=previous.get('polarity',False),save_models=True,tag=tag,
                seed_cases=seeds,origin_cuts=True)
            print(json.dumps({'event':'ranked_start','tag':tag,'rank':rank['rank'],
                'ranking_failures':rank['ranking_failures'],'limit':a.seconds}),flush=True)
            live(tag)
            r=solve(item['row'],previous['order'],local,item['prefix'],item['row']['source'],previous.get('positions'))
            r.update(queue_index=i,rank=rank['rank'],ranking_failures=rank['ranking_failures'],
                limit_seconds=a.seconds,origin_cuts=True,weak_filter=filters[i],old_status='UNKNOWN',seed_cases=seeds)
            finish_candidate(r)
            stream.write(json.dumps(r)+'\n');stream.flush();print(json.dumps(r),flush=True);live()
            if r.get('strict_pass') and r['k']<=31:return

def extra3(a):
    controls=json.loads((HERE/'artifacts/controls.json').read_text())
    assert len(controls)==6 and sum(r.get('strict_pass',False) for r in controls)==3
    queue=json.loads((OLD/'artifacts/median_queue.json').read_text())
    filters=json.loads((OLD/'artifacts/median_weak_filter.json').read_text())
    path=HERE/'artifacts/median_extra3.jsonl';done={r['index'] for r in rows(path)}
    with path.open('a') as stream:
        for task in queue:
            if (HERE/'STOP_AFTER_QUERY').exists():live('stopped between queries');return
            i=task['index']
            if i in done:continue
            # Origin constraints encode the same necessary information filter.
            # Rejected orders get a Kissat UNSAT call instead of being skipped.
            tag=f'median_extra3_{i:04d}'
            local=argparse.Namespace(k=31,regs=task['regs'],seconds=a.seconds,types=8,
                add=5,polarity=False,save_models=True,tag=tag,
                repair=(task['baseline'],task['free'],task['deletions']),repair_extra=3,
                seed_cases=filters[i].get('witness_cases',[]),origin_cuts=True)
            print(json.dumps({'event':'extra3_start','tag':tag,'limit':a.seconds}),flush=True);live(tag)
            r=solve(task['row'],task['order'],local)
            r.update(index=i,limit_seconds=a.seconds,origin_cuts=True,weak_filter=filters[i],
                extra_changed_data_slots=3,free_data_slots=task['free'],deletion_choices=task['deletions'])
            finish_candidate(r)
            stream.write(json.dumps(r)+'\n');stream.flush();print(json.dumps(r),flush=True);live()
            if r.get('strict_pass') and r['k']<=31:return

def main():
    ap=argparse.ArgumentParser();ap.add_argument('mode',choices=['controls','top100','extra3','report'])
    ap.add_argument('--seconds',type=float,default=600);a=ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    if a.mode=='report':
        from report import report
        report()
    else:{'controls':controls,'top100':lambda:top100(a),'extra3':lambda:extra3(a)}[a.mode]()

if __name__=='__main__':main()
