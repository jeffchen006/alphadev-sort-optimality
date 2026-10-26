"""Enumerate raw-flag orders with one incremental shared-selection solver.

Check all 720 orders directly. Completed UNSAT assumptions can be blocked.
Unknown orders are revisited with larger
conflict budgets. The CPU cap never changes an unknown order to a negative.
"""
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
    ap.add_argument('--cpu',type=float,default=600)
    ap.add_argument('--stem',default='rank_dag10_batch')
    args=ap.parse_args()
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    search=Dag(SimpleNamespace(gates=10,solver='cadical195'))
    cases,_,_=data()
    # Every raw cross comparison has distinct operands on these ten cases.
    # Thus l/le and g/ge coincide here. This does NOT assume that arbitrary
    # comparisons of copied values have unequal operands.
    for cnd in search.cnd:
        search.add(-cnd[1])
        search.add(-cnd[3])
    for w in cases:
        if len(set(w))==5:
            assert all(w[a]!=w[b] for a,b in search.pairs)
            search.case(w)
    orders=[]
    for p in itertools.permutations(range(6)):
        if p[0]<3:
            orders.extend([p,tuple(5-x for x in p)])
    assert len(orders)==len(set(orders))==720
    completed={}
    records=[]
    seed=HERE/'rank_dag10_fixed.json'
    if seed.exists():
        prior=json.loads(seed.read_text())
        if prior['status']=='UNSAT' and prior['args']['gates']==10:
            order=tuple(map(int,prior['args']['order'].split(',')))
            completed[order]='UNSAT'
            search.add(*[-search.order[b][p] for b,p in enumerate(order)])
            records.append({'order':order,'status':'UNSAT','seed':str(seed)})
    start=time.process_time()

    def save():
        counts={status:sum(s==status for s in completed.values())
                for status in ['UNSAT','SAT_DAG','SAT_STRICT_DAG']}
        counts['UNKNOWN']=720-len(completed)
        status=('COMPLETE_UNSAT' if counts['UNSAT']==720 else
                'COMPLETE_MIXED' if not counts['UNKNOWN'] else 'UNKNOWN')
        result={'status':status,'cpu':time.process_time()-start,
                'args':vars(args),'cases':len(search.used),'counts':counts,
                'strict_raw_condition_normalization':True,
                'orders_represented':720,'order_records':records,
                'stats':search.solver.accum_stats(),
                'vars':search.pool.top,'clauses':search.clauses}
        (HERE/(args.stem+'.json')).write_text(json.dumps(result,indent=2)+'\n')
        return result

    for budget in [2000,20000,100000,500000,2000000]:
        for index,order in enumerate(orders):
            if order in completed:
                continue
            if time.process_time()-start>=args.cpu:
                print('RESULT', {k:v for k,v in save().items() if k!='order_records'},flush=True)
                return
            assumptions=[search.order[b][p] for b,p in enumerate(order)]
            search.solver.conf_budget(budget)
            sat=search.solver.solve_limited(assumptions=assumptions)
            row={'order':order,'status':'UNSAT' if sat is False else 'SAT' if sat else 'UNKNOWN',
                 'budget':budget,'cpu_cumulative':time.process_time()-start}
            if sat is False:
                completed[order]='UNSAT'
                search.add(*[-x for x in assumptions])
            elif sat:
                plan=search.decode(search.solver.get_model())
                assert all(search.evaluate(plan,w)==sorted(w) for w in search.used)
                # Resolve cross-list ties with the triple entries first.
                # l remains l; its strict complement g becomes ge.
                lifted={**plan,'gates':[(a,b,bl,3 if c==2 else c)
                                      for a,b,bl,c in plan['gates']]}
                bad=[w for w in cases if search.evaluate(lifted,w)!=sorted(w)]
                status='SAT_STRICT_DAG' if bad else 'SAT_DAG'
                completed[order]=status
                row['status']=status
                row['plan']=plan if bad else lifted
                row['weak_bad_cases']=bad
            records.append(row)
            if row['status']!='UNKNOWN' or index%30==0:
                print('ORDER',index,order,row['status'],'budget',budget,
                      'complete',len(completed),'cpu',row['cpu_cumulative'],flush=True)
            if index%30==0:
                save()
        print('PASS',budget,'completed',len(completed),'cpu',time.process_time()-start,flush=True)
        if len(completed)==720:
            break
    print('RESULT',{k:v for k,v in save().items() if k!='order_records'},flush=True)


if __name__=='__main__':
    main()
