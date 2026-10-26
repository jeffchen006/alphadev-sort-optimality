"""Independent scalar checks for each instruction transition in the SAT encoder."""
import itertools,json,random
from synth import Synth
rng=random.Random(20261026);counts={}
for typ in ['fixed','free']:
 for op in range(7 if typ=='free' else 6):
  for it in range(18):
   values=[rng.randrange(6) for _ in range(9)];a,b=rng.randrange(9),rng.randrange(9);fl0=rng.choice([(False,False),(False,True),(True,False)])
   if typ=='free' and op==6:a=b=0
   if typ=='free' and op in (0,2,3,4,5) and a==b:b=(b+1)%9
   base=dict(code=[(op,a,b)],names=['P0','P1','P2','P3','P4','S0','S1'],outs={})
   s=Synth(base,[0] if typ=='free' else [],extra=2,drop=0,median_free=False)
   regs=[s.vector() for _ in range(9)];fl=s.vars(2)
   for row,v in zip(regs,values):s.add(row[v])
   for bit,v in zip(fl,fl0):s.add(bit if v else -bit)
   if typ=='free':
    o,d,src=s.choice[0];s.add(o[op]);s.add(d[a]);s.add(src[b]);nr,nf=s.free(regs,fl,0)
   else:nr,nf=s.fixed(regs,fl,(op,a,b))
   expected=values.copy();expected_flag=fl0
   if op==1:expected_flag=(values[a]<values[b],values[a]==values[b])
   elif op!=6:
    lt,eq=fl0
    take=[True,False,lt,lt or eq,not(lt or eq),not lt][op]
    if take:expected[a]=values[b]
   assumptions=[nr[r][expected[r]] for r in range(9)]+[bit if v else -bit for bit,v in zip(nf,expected_flag)]
   assert s.solver.solve(assumptions=assumptions),(typ,op,it,'expected')
   for r in range(9):assert not s.solver.solve(assumptions=[-nr[r][expected[r]]]),(typ,op,it,r,'value')
   for bit,v in zip(nf,expected_flag):assert not s.solver.solve(assumptions=[-bit if v else bit]),(typ,op,it,'flags')
   s.solver.delete();counts[typ]=counts.get(typ,0)+1
print(json.dumps(dict(status='PASS_TRANSITION_AUDIT',cases=counts,seed=20261026)))
