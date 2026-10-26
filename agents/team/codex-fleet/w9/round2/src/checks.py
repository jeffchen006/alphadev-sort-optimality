"""Independent checks for the comparison-order filter and SAT extensions."""
import collections
import itertools
import json
import time
from pathlib import Path
from orders import CASES as STRICT,HERE
from order_sat import CASES,OrderEnc,family_data,evaluate
from control import transformed
from pysat.solvers import Solver

def brute_flags(flags,order):
    groups=[list(range(120))]
    for j in order:
        for group in groups:
            if not any(all((STRICT[t][a]>STRICT[t][b])-(STRICT[t][a]<STRICT[t][b])+1==flags[j][t]
                           for t in group) for a in range(5) for b in range(5)):
                return False
        parts=[]
        for group in groups:
            split=collections.defaultdict(list)
            for t in group:split[flags[j][t]].append(t)
            parts.extend(split.values())
        groups=parts
    return True

def main():
    began=time.process_time();families=json.loads((HERE/'artifacts/orders.json').read_text())['families']
    # Every retained order is checked with lists of cases, without bitsets or
    # subset readiness tables. Rejected permutations receive a fixed sample.
    valid_count=0;invalid_count=0
    for row in families:
        flags=row['flags'];valid={tuple(x) for x in row['valid_flag_orders']}
        for order in valid:
            assert brute_flags(flags,order);valid_count+=1
        for i,order in enumerate(itertools.permutations(range(8))):
            if i%197==0 and order not in valid:
                assert not brute_flags(flags,order);invalid_count+=1
    controls=[]
    for ri in (0,2,5):
        row=families[ri];p,R,order=transformed(row)
        for polarity in (False,True):
            for n in (0,15,25):
                flags=family_data(row,order);e=OrderEnc(len(p),R,flags,prefix=p[:n],polarity=polarity)
                for t,(op,d,s) in enumerate(p):
                    e.cl(e.op[t][op]);e.cl(e.d[t][d]);e.cl(e.s[t][s])
                encoded=CASES[::37]+[w for w in CASES if len(set(w))==5][::13]
                for w in encoded:e.add_type(w)
                with Solver(name='cadical195',bootstrap_with=e.clauses) as sat:
                    assert sat.solve(),(ri,polarity,n)
                    q,out=e.decode(sat.get_model());cols,_=evaluate(q,R)
                    assert all(cols[when-1][t]==sorted(w)[j] for t,w in enumerate(CASES) for j,(when,r) in enumerate(out))
                controls.append({'family':row['id'],'prefix':n,'polarity':polarity,'status':'SAT','cases':len(encoded)})
    result={'retained_orders_checked':valid_count,'rejected_sample_checked':invalid_count,
            'controls':controls,'cpu':time.process_time()-began}
    (HERE/'artifacts/checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result),flush=True)

if __name__=='__main__':main()
