"""The same SAT family with a concrete fixed prefix and cached suffix states."""
from synth import Synth as PlainSynth
class Synth(PlainSynth):
 def __init__(self,*args,**kwargs):
  super().__init__(*args,**kwargs)
  self.truth=self.pool.id();PlainSynth.add(self,self.truth)
  self.constants=[[self.truth if v==w else -self.truth for v in range(6)] for w in range(6)]
  self.suffix_cache={};self.suffix_builds=0
 def add(self,*clause):
  truth=getattr(self,'truth',None)
  if truth is not None:
   if truth in clause:return
   clause=tuple(v for v in clause if v!=-truth)
  PlainSynth.add(self,*clause)
 def case(self,w):
  assert w not in self.used;self.used.append(w)
  cut=min(self.editable,default=len(self.code))
  values=list(w)+[5]*(self.r-5);flag=(False,True)
  ss=[[self.constants[v] for v in values]]
  for op,a,b in self.code[:cut]:
   if op==1:flag=(values[a]<values[b],values[a]==values[b])
   else:
    lt,eq=flag
    take=op==0 or (op==2 and lt) or (op==3 and (lt or eq)) or (op==4 and not(lt or eq)) or (op==5 and not lt)
    if take:values[a]=values[b]
   ss.append([self.constants[v] for v in values])
  key=(tuple(values),flag)
  suffix=self.suffix_cache.get(key)
  if suffix is None:
   regs=ss[-1];fl=[self.truth if b else -self.truth for b in flag];suffix=[]
   for t in range(cut,len(self.code)):
    regs,fl=self.free(regs,fl,t) if t in self.editable else self.fixed(regs,fl,self.code[t])
    suffix.append(regs)
   self.suffix_cache[key]=suffix;self.suffix_builds+=1
  ss+=suffix
  target=sorted(w)
  for j,goal in self.goals.items():
   for t in range(len(self.code)+1):
    for r in range(self.r):self.add(-goal[t][r],ss[t][r][target[j]])
  for jj,(t,r) in self.base['outs'].items():
   j=int(jj)
   if j not in self.free_outputs:self.add(ss[t][r][target[j]])
