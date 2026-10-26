"""Check round 5 counts, coverage ledgers, and current PASS-file hashes."""
import hashlib
import json
from pathlib import Path

HERE=Path(__file__).resolve().parent
WORK=HERE.parent


def load(stem):
    return json.loads((HERE/(stem+'.json')).read_text())


def main():
    expected={'raw_sorted':(76,720,120,12),
              'raw_sorted_distinct':(10,720,120,12),
              'raw_unsorted':(132,5040,0,None),
              'raw_unsorted_distinct':(20,5040,0,None)}
    for stem,(cases,orders,functional,best) in expected.items():
        r=load(stem)
        assert r['complete']
        assert (r['cases'],r['orders'],r['functional_orders'],r['best'])==(cases,orders,functional,best)
        rows=[list(map(int,line.split())) for line in (HERE/(stem+'.tsv')).read_text().splitlines()]
        assert len(rows)==orders
        assert [r[0] for r in rows]==list(range(orders))
        assert sum(all(c<99 for c in r[1:]) for r in rows)==functional
    assert (HERE/'raw_sorted_distinct.tsv').read_bytes()==(HERE/'forward_distinct.tsv').read_bytes()
    forward=[list(map(int,line.split())) for line in (HERE/'forward_distinct.tsv').read_text().splitlines()]
    # The C++ search checks every cost through four. An absent column costs
    # at least five. These lower bounds suffice for the global optimum.
    forward_lower=min(sum(5 if c==99 else c for c in r[1:]) for r in forward)
    assert forward_lower==12
    weak_equal=(HERE/'raw_sorted.tsv').read_bytes()==(HERE/'raw_sorted_distinct.tsv').read_bytes()
    units=load('rank_dag10_units')
    orders=[tuple(r['order']) for r in units['order_records']]
    assert len(orders)==len(set(orders))
    for status in ['UNSAT','SAT_DAG','SAT_STRICT_DAG']:
        assert sum(r['status']==status for r in units['order_records'])==units['counts'][status]
    assert sum(units['counts'].values())==720
    assert sum(units['best_counts'].values())==120
    shapes=load('binary16_shapes')
    closed={tuple(r['positions']) for r in shapes['records'] if r['status']=='UNSAT'}
    assert len(closed)==shapes['completed_unsat']==97
    assert shapes['unknown']==455-len(closed)
    assert len({tuple(r['positions']) for r in shapes['records']})==455
    for r in shapes['records']:
        p=r['positions']
        assert p[0]==0 and p==sorted(set(p)) and len(p)==4 and p[-1]<16
    passes=load('passes')
    for r in passes:
        for key in ['out','mem']:
            path=WORK/r[key]
            assert hashlib.sha256(path.read_bytes()).hexdigest()==r[key+'_sha256']
            suffix='_judge_out.log' if key=='out' else '_judge_mem.log'
            log=(HERE/(Path(r['out']).stem+suffix)).read_text()
            assert log.startswith('PASS '+str(path)+' '),log
        core=[line.split('#')[0].strip() for line in (WORK/r['out']).read_text().splitlines()]
        assert sum(bool(line) and not line.startswith('out ') for line in core)==r['k']
        mem=[line.split('#')[0].strip() for line in (WORK/r['mem']).read_text().splitlines()]
        assert sum(bool(line) for line in mem)==r['length_mem']==r['k']+10
    result={'status':'PASS_AUDIT','raw_tables_checked':4,'forward_cost_cells':3600,
            'weak_and_strict_cost_tables_equal':weak_equal,
            'forward_total_conditional_move_lower_bound':forward_lower,
            'distinct_closed_rank_orders':units['counts']['UNSAT'],
            'closed_comparison_placements':len(closed),
            'strict_program_pairs':len(passes)}
    (HERE/'audit.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__=='__main__':
    main()
