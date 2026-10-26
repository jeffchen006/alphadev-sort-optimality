#!/usr/bin/env python3
"""Choose strict or inclusive conditions to repair a fixed instruction plan.

All 541 weak orders enter the SMT query. The emitted program still needs
the independent strict judge. Source and destination registers stay fixed.
"""
import itertools
from pathlib import Path
import sys
import z3

source=Path(sys.argv[1])
dest=Path(sys.argv[2])
code=[]
for line in source.read_text().splitlines():
    line=line.split('#',1)[0].strip()
    if line:
        op,args=line.split(None,1)
        code.append((op,*map(str.strip,args.split(','))))
choices={i:z3.Bool('inclusive_%d'%i) for i,(op,_,_) in enumerate(code)
         if op.startswith('cmov')}
solver=z3.Solver()
solver.set(timeout=20000)
orders=[x for x in itertools.product(range(5),repeat=5)
        if set(x)==set(range(max(x)+1))]
for values in orders:
    r={'P%d'%i:z3.BitVecVal(x,3) for i,x in enumerate(values)}
    outs={}
    lt=gt=eq=None
    for i,(op,d,s) in enumerate(code):
        if op=='out':
            outs[int(d)]=r[s]
        elif op=='mov':
            r[d]=r[s]
        elif op=='cmp':
            lt=z3.ULT(r[d],r[s])
            gt=z3.UGT(r[d],r[s])
            eq=r[d]==r[s]
        else:
            strict=lt if op in ('cmovl','cmovle') else gt
            take=z3.Or(strict,z3.And(choices[i],eq))
            r[d]=z3.If(take,r[s],r[d])
    for j,x in enumerate(sorted(values)):
        solver.add(outs.get(j,r['P%d'%j])==z3.BitVecVal(x,3))
result=solver.check()
print('TIE_REPAIR',result,flush=True)
if result==z3.sat:
    model=solver.model()
    lines=['# n=5 iset=I1 model=out source=w2_tie_repair origin='+str(source)]
    for i,(op,d,s) in enumerate(code):
        if i in choices:
            base='cmovl' if op in ('cmovl','cmovle') else 'cmovg'
            op=base+('e' if z3.is_true(model.eval(choices[i],model_completion=True)) else '')
        lines.append('%s %s, %s'%(op,d,s))
    dest.write_text('\n'.join(lines)+'\n')
    print('CANDIDATE',dest,flush=True)
