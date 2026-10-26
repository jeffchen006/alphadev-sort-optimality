"""Independent scalar check of the insertion scheduler and SAT transitions."""
import itertools,json,os,random,resource
from pathlib import Path
from scheduled import Scheduled
from normal import normalize_new_registers
from fast_synth import Synth
HERE=Path(__file__).resolve().parent
def snapshots(code,w,r):
 regs=list(w)+[5]*(r-5);flag=0;out=[tuple(regs)]
 for op,a,b in code:
  if op==1:flag=(regs[a]>regs[b])-(regs[a]<regs[b])
  elif op==0 or (op==2 and flag<0) or (op==3 and flag<=0) or (op==4 and flag>0) or (op==5 and flag>=0):regs[a]=regs[b]
  out.append(tuple(regs))
 return out
class Inspect(Scheduled):
 def constrain_snapshots(self,ss,w):self.snapshots[w]=ss
def main():
 os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
 if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
 resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
 bases=json.loads((HERE/'bases.json').read_text());rng=random.Random(9026);records=[]
 for bi in [0,20,26,56,169]:
  b=bases[bi];editable=sorted(set(b['exclusive'])|set(b['writes'][-6:]));cut=min(editable)
  for gaps in [(cut,cut),(cut,32),(31,32)]:
   s=Inspect(b,editable,extra=2,budget=34);s.snapshots={};q=[];is_insert=[]
   for t in range(33):
    for gap in gaps:
     if gap==t:
      op=rng.randrange(6);a,breg=rng.sample(range(s.r),2)
      q.append((op,a,breg));is_insert.append(True)
    if t<32:
     z=tuple(b['code'][t])
     if t in editable and rng.randrange(2):
      op=rng.randrange(7);a,breg=rng.sample(range(s.r),2)
      z=(op,a,breg) if op!=6 else (6,0,0)
     q.append(z);is_insert.append(False)
   assert len(q)==34
   for t,lit in enumerate(s.insert):s.add(lit if is_insert[t] else -lit)
   for t,(op,a,breg) in enumerate(q):
    if t in s.choice:
     o,d,src=s.choice[t]
     for lit in (o[op],d[a],src[breg]):s.add(lit)
   seeds=[(0,1,2,3,4),(4,3,2,1,0),(1,0,1,2,0),(0,0,0,0,0)]
   for w in seeds:s.case(w)
   assert s.solver.solve(),(bi,gaps)
   model=set(v for v in s.solver.get_model() if v>0);checks=0
   for w in seeds:
    exact=snapshots(q,w,s.r)
    for t,state in enumerate(s.snapshots[w]):
     for r,vector in enumerate(state):
      actual=[v for v,lit in enumerate(vector) if (lit>0 and lit in model) or (lit<0 and -lit not in model)]
      assert actual==[exact[t][r]],(bi,gaps,w,t,r,actual,exact[t][r])
      checks+=1
   # Every chosen fixed-output event must lie at its original core boundary.
   for j,choices in s.out_shift.items():
    ot,_=s.original['outs'][str(j)]
    c=next(c for c,v in enumerate(choices) if v in model)
    assert sum(not z for z in is_insert[:ot+c])==ot
   records.append(dict(base=bi,gaps=gaps,cases=len(seeds),value_checks=checks));s.solver.delete()
   print('TRANSITIONS',records[-1],flush=True)
 # Exhaust every Boolean insertion trace for a three-instruction example.
 small=dict(code=[(1,0,1),(1,1,2),(1,2,3)],names=[f'P{i}' for i in range(5)],outs={})
 s=Inspect(small,[1,2],extra=0,budget=5);traces=0
 for bits in itertools.product((False,True),repeat=5):
  assumptions=[v if bit else -v for v,bit in zip(s.insert,bits)]
  expected=sum(bits)==2 and not bits[0]
  assert s.solver.solve(assumptions=assumptions)==expected,bits
  traces+=1
 s.solver.delete()
 # Check that the budget counts both original and inserted instructions.
 s=Inspect(small,[1,2],extra=0,budget=2);s.pin_original()
 assert not s.solver.solve();s.solver.delete()
 reduced=dict(small,code=[(1,0,1),(6,0,0),(1,2,3)])
 s=Inspect(reduced,[1,2],extra=0,budget=2);s.pin_original()
 assert s.solver.solve();s.solver.delete()
 # Repeat the fresh-name check with this round's copied encoder.
 b=dict(code=[(1,0,0)]*2,names=[f'P{i}' for i in range(5)],outs={})
 s=Synth(b,[0,1],extra=4,drop=0,median_free=False)
 normalize_new_registers(s,[0,1],5,4)
 for t in (0,1):s.add(s.choice[t][0][1])
 named=0
 for trace in itertools.product(range(9),repeat=4):
  mapping={r:r for r in range(5)};normal=[]
  for r in trace:
   if r not in mapping:mapping[r]=len(mapping)
   normal.append(mapping[r])
  given=[s.choice[i//2][1+i%2][r] for i,r in enumerate(trace)]
  renamed=[s.choice[i//2][1+i%2][r] for i,r in enumerate(normal)]
  assert s.solver.solve(assumptions=given)==(tuple(normal)==trace)
  assert s.solver.solve(assumptions=renamed)
  named+=1
 s.solver.delete()
 result=dict(status='PASS_INTERNAL_AUDIT',records=records,schedule_traces=traces,budget_checks=2,
  fresh_name_traces=named,value_checks=sum(r['value_checks'] for r in records))
 (HERE/'audit.json').write_text(json.dumps(result,indent=2)+'\n');print(result['status'],result['value_checks'],traces,named,flush=True)
if __name__=='__main__':main()
