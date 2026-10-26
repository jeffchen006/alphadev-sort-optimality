"""Check raw-flag orders with separate, permanently fixed SAT formulas."""
import argparse
import itertools
import json
import os
from pathlib import Path
import resource
import time
from types import SimpleNamespace

from rank_chains import data
from rank_dag import Dag

HERE=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--cpu',type=float,default=300)
    ap.add_argument('--per-order',type=float,default=20)
    ap.add_argument('--stem',default='rank_dag10_units')
    args=ap.parse_args()
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    cases,_,_=data()
    pairs=[(i,j) for i in range(2) for j in range(2,5)]
    best=json.loads((HERE/'raw_sorted.json').read_text())['bestrows']
    bestorders=[tuple(pairs.index(tuple(p)) for p in row['order']) for row in best]
    assert len(bestorders)==len(set(bestorders))==120
    orders=bestorders+[p for p in itertools.permutations(range(6)) if p not in set(bestorders)]
    complete={}
    rows=[]
    prior=json.loads((HERE/'rank_dag10_fixed.json').read_text())
    if prior['status']=='UNSAT':
        p=tuple(map(int,prior['args']['order'].split(',')))
        complete[p]='UNSAT'
        rows.append({'order':p,'status':'UNSAT','seed':'rank_dag10_fixed.json'})
    start=time.process_time()

    def counts(subset):
        return {status:sum(complete.get(p,'UNKNOWN')==status for p in subset)
                for status in ['UNSAT','SAT_DAG','SAT_STRICT_DAG','UNKNOWN']}

    def save():
        c=counts(orders)
        result={'status':'COMPLETE_UNSAT' if c['UNSAT']==720 else 'UNKNOWN',
                'cpu':time.process_time()-start,'cases':10,'args':vars(args),
                'counts':c,'best_counts':counts(bestorders),'order_records':rows,
                'strict_raw_condition_normalization':True,
                'stats':{'conflicts':sum(r.get('stats',{}).get('conflicts',0) for r in rows)}}
        (HERE/(args.stem+'.json')).write_text(json.dumps(result,indent=2)+'\n')
        return {k:v for k,v in result.items() if k!='order_records'}

    for index,order in enumerate(orders):
        if order in complete:
            continue
        if time.process_time()-start>=args.cpu:
            break
        began=time.process_time()
        search=Dag(SimpleNamespace(gates=10,solver='cadical195',order=','.join(map(str,order))))
        for cnd in search.cnd:
            search.add(-cnd[1]);search.add(-cnd[3])
        for w in cases:
            if len(set(w))==5:
                search.case(w)
        sat=None
        while time.process_time()-began<args.per_order and time.process_time()-start<args.cpu:
            search.solver.conf_budget(10000)
            sat=search.solver.solve_limited()
            if sat is not None:
                break
        row={'order':order,'status':'UNSAT' if sat is False else 'SAT' if sat else 'UNKNOWN',
             'cpu':time.process_time()-began,'stats':search.solver.accum_stats(),
             'vars':search.pool.top,'clauses':search.clauses}
        if sat is False:
            complete[order]='UNSAT'
        elif sat:
            plan=search.decode(search.solver.get_model())
            assert all(search.evaluate(plan,w)==sorted(w) for w in search.used)
            lifted={**plan,'gates':[(a,b,bl,3 if c==2 else c) for a,b,bl,c in plan['gates']]}
            bad=[w for w in cases if search.evaluate(lifted,w)!=sorted(w)]
            status='SAT_STRICT_DAG' if bad else 'SAT_DAG'
            row.update({'status':status,'plan':plan if bad else lifted,'weak_bad_cases':bad})
            complete[order]=status
        rows.append(row)
        search.solver.delete()
        print('ORDER',index,order,row['status'],'cpu',row['cpu'],
              'total_cpu',time.process_time()-start,'best',counts(bestorders),flush=True)
        save()
    print('RESULT',save(),flush=True)


if __name__=='__main__':
    main()
