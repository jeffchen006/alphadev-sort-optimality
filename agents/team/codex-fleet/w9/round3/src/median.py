"""Reorder comparisons and resynthesise the median data path.

The median data path includes every data instruction reached by tracing the
median backward on any of the 541 weak orders. Comparison operands are free.
Other data instructions retain their source operands. A selector permits any
single deletion from the median data path. No canonical scratch rule is used:
fixed source register names can otherwise cause spurious contradictions.
"""
import argparse
from collections import Counter
import hashlib
import json
import os
from pathlib import Path
import resource
import sys

sys.dont_write_bytecode=True
HERE=Path(__file__).resolve().parents[1]
OLD=HERE.parent/'round2'
sys.path.insert(0,str(OLD/'src'))
from control import transformed
from order_kissat import CASES,evaluate,solve
from run import record_found


def median_slice(p,R):
    cols,flags=evaluate(p,R)
    targets=[tuple(sorted(w)[j] for w in CASES) for j in range(5)]
    outputs=[next((t for t,col in enumerate(cols) if p[t][0]!='cmp' and col==goal),None)
             for goal in targets]
    end=outputs[2]
    if end is None:
        end=min((t for t,x in enumerate(p) if x[0]!='cmp'),
                key=lambda t:sum(a!=b for a,b in zip(cols[t],targets[2])))
    free=set();case_paths=[]
    for ci,w in enumerate(CASES):
        needed={p[end][1]};condition=[1]*len(p)
        # The trace records each conditional move's actual comparison outcome.
        flag=1;comparison=0
        for t,(op,d,s) in enumerate(p):
            if op=='cmp':flag=flags[comparison][ci];comparison+=1
            condition[t]=flag
        path=set()
        for t in range(end,-1,-1):
            op,d,s=p[t]
            if op=='cmp' or d not in needed:continue
            path.add(t)
            take={'mov':True,'cmovl':condition[t]==0,'cmovle':condition[t]<=1,
                  'cmovg':condition[t]==2,'cmovge':condition[t]>=1}[op]
            if take:
                needed.remove(d);needed.add(s)
        assert all(r<5 for r in needed),'Median depends on concrete scratch data'
        free.update(path);case_paths.append(sorted(path))
    return {'slots':sorted(free),'median_snapshot':end,'output_snapshots':outputs,
            'missing_output_columns':[j for j,t in enumerate(outputs) if t is None],
            'median_reference_failures':sum(a!=b for a,b in zip(cols[end],targets[2])),
            'case_path_sizes':dict(Counter(map(len,case_paths)))}


def check_slice(p,R,path):
    # Replay only the selected data path. Comparison flags come from the
    # unchanged reference trace, as they do in the repair relation.
    cols,flags=evaluate(p,R);selected=set(path['slots']);end=path['median_snapshot']
    for ci,w in enumerate(CASES):
        regs=list(w)+[7]*(R-5);comparison=0;flag=1
        for t,(op,d,s) in enumerate(p[:end+1]):
            if op=='cmp':
                flag=flags[comparison][ci];comparison+=1
            elif t in selected:
                take=(op=='mov' or op=='cmovl' and flag==0 or op=='cmovle' and flag<=1
                      or op=='cmovg' and flag==2 or op=='cmovge' and flag>=1)
                if take:regs[d]=regs[s]
        assert regs[p[end][1]]==cols[end][ci],(ci,w,path)


def prepare():
    families=json.loads((OLD/'artifacts/orders.json').read_text())['families']
    tasks=[];cache={};source_records={}
    for fi,family in enumerate(families):
        choices=[]
        for source in family['sources']:
            if source not in cache:
                row=dict(family,source=source);p,R,order=transformed(row)
                original_length=len(p)
                if original_length==31:p=p+[('mov',0,0)]
                path=median_slice(p,R) if len(p)==32 else None
                if path and original_length==31:
                    path['slots'].append(31)
                    path['padded_near_miss']=True
                cache[source]=(p,R,order,path)
                if path:
                    check_slice(p,R,path)
                    source_records[source]={'sha256':hashlib.sha256(Path(source).read_bytes()).hexdigest(),
                                            'length':len(p),'original_length':original_length,
                                            'registers':R,'isolated_path_check_cases':541,**path}
            p,R,order,path=cache[source]
            if path:choices.append((source,p,R,order,path))
        assert choices,family['id']
        for order in family['new_flag_orders']:
            def quality(choice):
                source,p,R,old,path=choice
                common=next((j for j,(a,b) in enumerate(zip(order,old)) if a!=b),8)
                return common,-len(path['slots']),-R,source
            source,p,R,old,path=max(choices,key=quality)
            starts=[t for t,x in enumerate(p) if x[0]=='cmp']+[len(p)]
            blocks={j:list(range(starts[i],starts[i+1])) for i,j in enumerate(old)}
            index=[t for j in order for t in blocks[j]]
            baseline=[p[t] for t in index]
            free=[t for t,old_t in enumerate(index) if old_t in path['slots']]
            assert len(baseline)==32 and baseline[0][0]=='cmp' and free
            # All deletion slots are covered by one selector query. The
            # comparison locations and every fixed data slot shift together.
            tasks.append({'index':len(tasks),'family':family['id'],
                          'row':dict(family,source=source),'order':order,
                          'baseline':baseline,'free':free,'deletions':free,
                          'regs':max(9,R),'source_order':old,
                          'source_median_path':path,'common_comparisons':quality((source,p,R,old,path))[0]})
        print(json.dumps({'event':'median_family_prepared','family':family['id'],
                          'families_done':fi+1,'tasks':len(tasks)}),flush=True)
    assert len(tasks)==653
    (HERE/'artifacts/median_queue.json').write_text(json.dumps(tasks,indent=2)+'\n')
    (HERE/'artifacts/median_sources.json').write_text(json.dumps(source_records,indent=2)+'\n')
    summary={'orders':len(tasks),'source_programs':len(source_records),
             'free_data_slots':dict(Counter(len(t['free']) for t in tasks)),
             'single_deletion_choices':sum(len(t['deletions']) for t in tasks)}
    (HERE/'artifacts/median_scope.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps(summary),flush=True)


def batch(a):
    queue=json.loads((HERE/'artifacts/median_queue.json').read_text())
    filter_path=HERE/'artifacts/median_weak_filter.json'
    filters=json.loads(filter_path.read_text()) if filter_path.exists() else []
    path=HERE/'artifacts'/f'{a.tag}.jsonl'
    done={json.loads(line)['index'] for line in path.read_text().splitlines()} if path.exists() else set()
    with path.open('a') as stream:
        for task in queue[a.first:a.first+a.count]:
            if task['index'] in done:continue
            tag=f"{a.tag}_{task['index']:04d}"
            if filters and not filters[task['index']]['valid']:
                row={'index':task['index'],'family':task['family'],'order':task['order'],
                     'status':'FILTER_REJECTED','weak_filter':filters[task['index']],
                     'k':31,'regs':task['regs'],'cpu':0,'wall':0,'iterations':0,
                     'stats':{'child_cpu_seconds':0,'peak_job_rss_kib':0,'solver_calls':[]},
                     'free_data_slots':task['free'],'deletion_choices':task['deletions']}
                text=json.dumps(row);stream.write(text+'\n');stream.flush();print(text,flush=True)
                continue
            local=argparse.Namespace(k=31,regs=task['regs'],seconds=a.seconds,types=8,add=5,
                                     polarity=False,save_models=True,tag=tag,
                                     repair=(task['baseline'],task['free'],task['deletions']),
                                     seed_cases=filters[task['index']].get('witness_cases',[]) if filters else [])
            print(json.dumps({'event':'median_query_start','tag':tag,
                              'free_data_slots':len(task['free']),'seconds':a.seconds}),flush=True)
            row=solve(task['row'],task['order'],local)
            row.update(index=task['index'],free_data_slots=task['free'],
                       deletion_choices=task['deletions'],limit_seconds=a.seconds,
                       source_median_snapshot=task['source_median_path']['median_snapshot'],
                       weak_filter=filters[task['index']] if filters else None,
                       seed_cases=local.seed_cases)
            text=json.dumps(row);stream.write(text+'\n');stream.flush();print(text,flush=True)
            if row.get('strict_pass'):
                record_found(row);return


def controls():
    families=json.loads((OLD/'artifacts/orders.json').read_text())['families']
    records=[]
    for fi in (0,2,5):
        family=families[fi];p,R,order=transformed(family)
        path=median_slice(p,R);assert path
        check_slice(p,R,path)
        # Insert an erasable dummy data instruction. This tests the deletion
        # selector at the first and final median-path locations, with the
        # remaining source data pinned exactly after the shift.
        for insertion in (min(path['slots']),max(path['slots'])+1):
            baseline=p[:insertion]+[('mov',0,0)]+p[insertion:]
            local=argparse.Namespace(k=32,regs=max(9,R),seconds=30,types=12,add=5,
                                     polarity=False,save_models=True,tag=f'median_control_{fi}_{insertion}',
                                     repair=(baseline,[insertion],[insertion]),pin_program=p)
            row=solve(family,order,local)
            assert row.get('strict_pass'),row
            row.update(control_insertion=insertion,source_median_path=path)
            records.append(row)
    (HERE/'artifacts/median_controls.json').write_text(json.dumps(records,indent=2)+'\n')


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('mode',choices=['prepare','batch','controls'])
    ap.add_argument('--seconds',type=float,default=3)
    ap.add_argument('--first',type=int,default=0)
    ap.add_argument('--count',type=int,default=653)
    ap.add_argument('--tag',default='median_all')
    a=ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    {'prepare':prepare,'batch':lambda:batch(a),'controls':controls}[a.mode]()


if __name__=='__main__':main()
