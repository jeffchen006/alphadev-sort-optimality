"""Sample checks for folded and symbolic rank transition selectors."""
from flag_sat import FoldEnc, OPS
from pysat.solvers import Solver
import json,random
rnd=random.Random(522040)
checked=wrongbits=0
for index in range(100):
    nr=9;k=18
    p=[(rnd.randrange(6),rnd.randrange(nr),rnd.randrange(nr)) for _ in range(k)]
    e=FoldEnc(5,k,R=nr,iset='I1',outmode='snap',rules=());e.check_outputs=False
    assumptions=[]
    for i,(o,d,s) in enumerate(p):
        assumptions.extend((e.op[i][OPS[o]],e.d[i][d],e.s[i][s]))
        if i%3==0:
            for x,v in e.op[i].items():e.cl(v if x==OPS[o] else -v)
            e.op[i]={x:x==OPS[o] for x in e.op[i]}
        if i%3==1:
            for r,v in enumerate(e.d[i]):e.cl(v if r==d else -v)
            e.d[i]=[r==d for r in range(nr)]
            for r,v in enumerate(e.s[i]):e.cl(v if r==s else -v)
            e.s[i]=[r==s for r in range(nr)]
    expected=[]
    for ci in range(5):
        case=tuple(rnd.randrange(5) for _ in range(5));e.add_type(case)
        rs=list(case)+[7]*(nr-5);f=0;trace=[]
        for o,d,s in p:
            if o==0:rs[d]=rs[s]
            elif o==1:f=(rs[d]>rs[s])-(rs[d]<rs[s])
            elif ((o==2 and f<0)or(o==3 and f<=0)or(o==4 and f>0)or(o==5 and f>=0)):rs[d]=rs[s]
            trace.append(rs[d])
        expected.append(trace)
    with Solver(name='cadical195',bootstrap_with=e.clauses) as solver:
        assert solver.solve(assumptions=assumptions)
        model={x for x in solver.get_model() if x>0}
        for ci,trace in enumerate(expected):
            for t,value in enumerate(trace):
                for b,lit in enumerate(e.traces[ci][t]):
                    actual=lit if type(lit)is bool else lit in model if lit>0 else -lit not in model
                    assert actual==bool(value>>b&1),(index,ci,t,b,value,actual)
                checked+=1
        candidates=[(lit,expected[ci][t]>>b&1) for ci in range(5) for t in range(k) for b,lit in enumerate(e.traces[ci][t]) if type(lit)is not bool]
        lit,value=rnd.choice(candidates)
        assert not solver.solve(assumptions=assumptions+[-lit if value else lit])
        wrongbits+=1
print(json.dumps(dict(programs=100,cases=500,transition_values=checked,rejected_wrong_bits=wrongbits,disagreements=0)))
