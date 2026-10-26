"""Force a nontrivial polarity assignment in a pinned positive control."""
import json
from control import transformed
from order_sat import HERE,CASES,OrderEnc,family_data,evaluate,emit
from pysat.solvers import Solver

def main():
    row=json.loads((HERE/'artifacts/orders.json').read_text())['families'][0]
    p,R,order=transformed(row)
    positions=[t for t,x in enumerate(p) if x[0]=='cmp'];pivot=positions[6]
    q=list(p);op,d,s=q[pivot];q[pivot]=(op,s,d)
    reverse={'cmovl':'cmovg','cmovg':'cmovl','cmovle':'cmovge','cmovge':'cmovle'}
    for t in range(pivot+1,positions[7]):
        op,d,s=q[t]
        if op in reverse:q[t]=(reverse[op],d,s)
    flags=family_data(row,order)
    e=OrderEnc(len(q),R,flags,prefix=q[:pivot],polarity=True)
    for t,(op,d,s) in enumerate(q):e.cl(e.op[t][op]);e.cl(e.d[t][d]);e.cl(e.s[t][s])
    chosen=CASES[::17]
    for w in chosen:e.add_type(w)
    with Solver(name='cadical195',bootstrap_with=e.clauses) as sat:
        assert sat.solve()
        q,out=e.decode(sat.get_model());cols,actual=evaluate(q,R)
        assert all(actual[j]==bytes(2-f for f in flags[j]) if j==6 else actual[j]==flags[j] for j in range(8))
        assert all(cols[when-1][t]==sorted(w)[j] for t,w in enumerate(CASES) for j,(when,r) in enumerate(out))
        m=set(sat.get_model())
        assert all(e.flip[6,e.history[6][CASES.index(w)]] in m for w in chosen if flags[6][CASES.index(w)]!=1)
    dest=HERE/'candidates/polarity_control32.s';emit(q,out,dest)
    result={'status':'SAT','cases':len(chosen),'path':str(dest),'reversed_comparison':6,'prefix_length':pivot,'full_case_check':541}
    (HERE/'artifacts/polarity_control.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result),flush=True)

if __name__=='__main__':main()
