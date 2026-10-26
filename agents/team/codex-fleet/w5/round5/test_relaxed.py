"""Compare the SAT candidate evaluator with the reference scalar interpreter."""
from pathlib import Path
import importlib.util,json,random
from fusion_sat import concrete,CASES,OPS
path=Path('/path/to/repo/shared/judge.py')
spec=importlib.util.spec_from_file_location('reference_judge',path)
judge=importlib.util.module_from_spec(spec);spec.loader.exec_module(judge)
rng=random.Random(532627);checked=0
for number in range(32):
    nr=9;k=18
    p=[(rng.randrange(6),rng.randrange(nr),rng.randrange(nr)) for _ in range(k)]
    _,states=concrete(p,nr)
    regs=[f'P{i}' if i<5 else f'S{i-5}' for i in range(nr)]
    for case_index in rng.sample(range(541),8):
        case=CASES[case_index]
        initial={r:case[i] if i<5 else 7 for i,r in enumerate(regs)}
        instructions=[]
        for t,(o,d,s) in enumerate(p):
            instructions.append((OPS[o],regs[d],regs[s],t+1))
            expected=judge.run_concrete(instructions,initial,(1,0))
            for r,name in enumerate(regs):
                assert expected[name]==states[t+1][0][r][case_index],(number,t,r,case)
                checked+=1
print(json.dumps(dict(programs=32,cases=256,register_values=checked,failures=0)))
