"""Enumerate first-comparison-at-zero schedules for the binary merge.

Every source, destination, and write opcode remains free. Reuse one solver
across all 455 placements of the other three comparisons.
"""
import argparse
import itertools
import json
import os
from pathlib import Path
import resource
import time
from types import SimpleNamespace

from merge_sat import CASES, Merge, emit, simulate

HERE=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--cpu',type=float,default=180)
    ap.add_argument('--stem',default='binary16_shapes')
    args=ap.parse_args()
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    config=SimpleNamespace(k=16,regs=8,cmps=4,solver='cadical195',fixed='binary',
                           prefix='pair',predicate_order='0,2,1,3',creation_outputs=True)
    search=Merge(config)
    for w in CASES:
        if len(set(w))==5 and w[0]<w[1] and w[2]<w[3]<w[4]:
            search.case(w)
    placements=[(0,)+c for c in itertools.combinations(range(1,16),3)]
    def priority(p):
        gaps=[p[1]-1,p[2]-p[1]-1,p[3]-p[2]-1,15-p[3]]
        return sum(abs(a-b) for a,b in zip(gaps,[2,4,2,4])),p
    placements.sort(key=priority)
    assert len(placements)==455
    completed=set()
    records=[]
    start=time.process_time()

    def save(status=None,path=None):
        result={'status':status or ('COMPLETE_UNSAT' if len(completed)==455 else 'UNKNOWN'),
                'cpu':time.process_time()-start,'cases':len(search.used),
                'args':vars(args),'placements':455,'completed_unsat':len(completed),
                'unknown':455-len(completed),'records':records,
                'vars':search.pool.top,'clauses':search.clauses,
                'stats':search.solver.accum_stats()}
        if path:
            result['path']=str(path)
        (HERE/(args.stem+'.json')).write_text(json.dumps(result,indent=2)+'\n')
        return {k:v for k,v in result.items() if k!='records'}

    for budget in [2000,20000,100000,500000]:
        for i,places in enumerate(placements):
            if places in completed:
                continue
            if time.process_time()-start>=args.cpu:
                print('RESULT',save(),flush=True)
                return
            assumptions=[search.ops[t][1] for t in places]
            search.solver.conf_budget(budget)
            sat=search.solver.solve_limited(assumptions=assumptions)
            row={'positions':places,'status':'UNSAT' if sat is False else 'SAT' if sat else 'UNKNOWN',
                 'budget':budget,'cpu_cumulative':time.process_time()-start}
            if sat is False:
                completed.add(places)
                search.add(*[-x for x in assumptions])
            elif sat:
                prog,outs=search.decode(search.solver.get_model())
                bad=[]
                for w in CASES:
                    p,f,_=simulate(search.prefix,w)
                    _,_,snap=simulate(prog,w,(p[:8],f))
                    if any(snap[t][r]!=sorted(w)[j] for j,(t,r) in enumerate(outs)):
                        bad.append(w)
                assert not set(bad)&set(search.used)
                if bad:
                    for w in bad[:8]:
                        search.case(w)
                    row['status']='REFINE'
                    row['added_cases']=bad[:8]
                else:
                    path=HERE/(args.stem+'.s')
                    emit(path,prog,outs)
                    row['status']='CANDIDATE'
                    records.append(row)
                    print('RESULT',save('CANDIDATE',path),flush=True)
                    return
            records.append(row)
            if row['status']!='UNKNOWN' or i%30==0:
                print('PLACEMENT',i,places,row['status'],'complete',len(completed),
                      'cpu',time.process_time()-start,flush=True)
            if i%30==0:
                save()
        print('PASS',budget,'complete',len(completed),'cpu',time.process_time()-start,flush=True)
        if len(completed)==455:
            break
    print('RESULT',save(),flush=True)


if __name__=='__main__':
    main()
