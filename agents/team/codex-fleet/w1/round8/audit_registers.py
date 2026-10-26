"""Exhaustively check the first-occurrence clauses for two editable slots."""
import itertools,json,os
from pathlib import Path
from synth import Synth
from search import normalize_new_registers
HERE=Path(__file__).resolve().parent
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
b=dict(code=[(1,0,0)]*2,names=[f'P{i}' for i in range(5)],outs={})
s=Synth(b,[0,1],extra=4,drop=0,median_free=False)
normalize_new_registers(s,[0,1],5,4)
for t in (0,1):s.add(s.choice[t][0][1])
canonical=0;total=0
for trace in itertools.product(range(9),repeat=4):
 mapping={r:r for r in range(5)};normal=[]
 for r in trace:
  if r not in mapping:mapping[r]=len(mapping)
  normal.append(mapping[r])
 assumptions=[s.choice[i//2][1+i%2][r] for i,r in enumerate(trace)]
 expected=tuple(normal)==trace
 assert s.solver.solve(assumptions=assumptions)==expected,trace
 normal_assumptions=[s.choice[i//2][1+i%2][r] for i,r in enumerate(normal)]
 assert s.solver.solve(assumptions=normal_assumptions),(trace,normal)
 total+=1;canonical+=expected
out=dict(status='PASS_FIRST_OCCURRENCE_AUDIT',slots=2,base_registers=5,new_registers=4,
 raw_operand_traces=total,canonical_operand_traces=canonical)
(HERE/'audit_registers.json').write_text(json.dumps(out,indent=2)+'\n');print(out)
