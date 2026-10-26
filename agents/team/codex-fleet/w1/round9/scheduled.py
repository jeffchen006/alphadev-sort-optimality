"""Median rewrites with two insertions at solver-selected core gaps.

There are n+2 encoded steps. At each step, a three-state counter records
how many insertion positions have occurred. Every original instruction
occurs once and in its original order. Selected original positions can
change or become NOP. The two inserted positions can also become NOP.
The global non-NOP budget counts all these instructions.
"""
from fast_synth import Synth
class Scheduled(Synth):
 def __init__(self,base,original_editable,extra=2,budget=31):
  self.original=base;self.original_editable=set(original_editable)
  self.schedule_normalized=True
  self.n=len(base['code']);self.cut=min(original_editable,default=self.n)
  padded=dict(base,code=list(base['code'])+[(6,0,0)]*2,outs={})
  super().__init__(padded,list(range(self.cut,self.n+2)),extra=extra,drop=self.n+2-budget)
  self.at=[self.vars(3) for _ in range(self.n+3)]
  for row in self.at:self.one(row)
  self.insert=self.vars(self.n+2)
  self.add(self.at[0][0]);self.add(self.at[-1][2])
  for t,row in enumerate(self.at):
   for c,lit in enumerate(row):
    if not 0<=t-c<=self.n:self.add(-lit)
  for t,ins in enumerate(self.insert):
   if t<self.cut:self.add(-ins)
   for c,at in enumerate(self.at[t]):
    j=t-c
    if c==2 or j<self.cut or j>self.n or j<0:self.add(-at,-ins)
    else:self.add(-at,-ins,self.at[t+1][c+1])
    # Move an omitted added position to the final gap. It has no machine effect.
    if t>=self.cut and 0<=j<self.n:self.add(-at,-ins,-self.choice[t][0][6])
    # In the final gap, real additions precede omitted added positions.
    if t>=self.cut and j==self.n and t+1<self.n+2:
     self.add(-at,-ins,-self.choice[t][0][6],self.choice[t+1][0][6])
    if j<0 or j>=self.n:self.add(-at,ins)
    else:
     self.add(-at,ins,self.at[t+1][c])
     if t>=self.cut and j not in self.original_editable:
      op,d,src=base['code'][j];o,ds,ss=self.choice[t]
      for choice in (o[op],ds[d],ss[src]):self.add(-at,ins,choice)
  self.out_shift={int(j):self.vars(3) for j in base['outs'] if int(j)!=2}
  for j,shifts in self.out_shift.items():
   self.one(shifts);ot,_=base['outs'][str(j)]
   for c,choice in enumerate(shifts):self.add(-choice,self.at[ot+c][c])
 def constrain_snapshots(self,ss,w):
  super().constrain_snapshots(ss,w)
  target=sorted(w)
  for j,shifts in self.out_shift.items():
   ot,r=self.original['outs'][str(j)]
   for c,choice in enumerate(shifts):self.add(-choice,ss[ot+c][r][target[j]])
 def decode(self):
  q,outs=super().decode();model=set(v for v in self.solver.get_model() if v>0)
  for j,shifts in self.out_shift.items():
   ot,r=self.original['outs'][str(j)]
   c=next(c for c,v in enumerate(shifts) if v in model);outs[j]=(ot+c,r)
  return q,outs
 def pin_original(self):
  for t,lit in enumerate(self.insert):self.add(lit if t>=self.n else -lit)
  for t,(o,d,s) in self.choice.items():
   op,a,b=self.original['code'][t] if t<self.n else (6,0,0)
   for lit in (o[op],d[a],s[b]):self.add(lit)
  for shifts in self.out_shift.values():self.add(shifts[0])
