"""Audit the guide failure sets with distinct symbolic scratch values."""
from pathlib import Path
import importlib.util,json
HERE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('judge','/path/to/repo/shared/judge.py')
j=importlib.util.module_from_spec(spec);spec.loader.exec_module(j)
rows=[]
for name in ['near9','near14']:
    path=HERE/'seeds'/f'{name}.s';_,program=j.parse(path.read_text());regs=j.regs(5,program)
    expected={tuple(x) for x in json.loads(path.with_suffix('.json').read_text())['failing_orders']}
    checked=0
    for initial_flags in j.FLAG_STATES:
        failed=set()
        for case in j.weak_orders(5):
            state={r:('x',case[int(r[1:])])if r[0]=='P'else('g',int(r[1:]))for r in regs};outputs={};flags=initial_flags
            for op,a,b,_ in program:
                if op=='out':outputs[int(a)]=state[b]
                elif op=='mov':state[a]=state[b]
                elif op=='cmp':
                    x,y=state[a],state[b]
                    assert x==y or x[0]==y[0]=='x',(name,case,a,b,x,y)
                    flags=(int(x==y),int(x[1]<y[1])if x!=y else 0)
                elif j.cond(op,flags):state[a]=state[b]
            actual=[outputs.get(i,state[f'P{i}'])for i in range(5)]
            assert all(x[0]=='x'for x in actual),(name,case,actual)
            if [x[1]for x in actual]!=sorted(case):failed.add(case)
            checked+=1
        assert failed==expected,(name,initial_flags,len(failed),len(expected))
    rows.append(dict(file=str(path),weak_orders=541,initial_flag_states=4,executions=checked,failed_orders=len(expected),unresolved_scratch_comparisons=0,garbage_outputs=0))
(HERE/'symbolic_input_check.json').write_text(json.dumps(rows,indent=2)+'\n')
print(json.dumps(rows,indent=2))
