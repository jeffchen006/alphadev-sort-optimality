#!/usr/bin/env python3
"""CEGIS window synthesis. Packed bit planes encode weak-order cases.
Replacements preserve output snapshots outside the window. Inside outputs can
use any replacement snapshot. Scratch reads require an unconditional definition.
"""
import argparse,itertools,json,random,time,pathlib,sys
import z3
OPS=['mov','cmp','cmovl','cmovle','cmovg','cmovge']

def read(fn):
 p=[]; outs={}; names=['P'+str(i) for i in range(5)]
 for line in open(fn):
  line=line.split('#')[0].strip()
  if not line:continue
  op,ab=line.split(None,1);a,b=map(str.strip,ab.split(','))
  if op=='out':outs.setdefault(len(p),[]).append((int(a),b));continue
  for r in [a,b]:
   if r not in names:names.append(r)
  p.append((op,a,b))
 return p,outs,names

def run(p,outs,ty,names,initial=False):
 st={r:(ty[int(r[1:])] if r.startswith('P') else 5) for r in names};f=0;out={}; traces=[(st.copy(),f)]
 for i,(op,a,b) in enumerate(p):
  x,y=st[a],st[b]
  if op=='cmp': f=(x>y)-(x<y)
  elif op=='mov' or (op=='cmovl' and f<0) or (op=='cmovle' and f<=0) or (op=='cmovg' and f>0) or (op=='cmovge' and f>=0):st[a]=y
  for j,r in outs.get(i+1,[]):out[j]=st[r]
  traces.append((st.copy(),f))
 return [out.get(j,st['P'+str(j)]) for j in range(5)],traces

class Window:
 def __init__(self,p,outs,names,a,b,delta=1,maxcmp=True,seed=0,equiv=False,initial_cases=8,fixedflags=False):
  self.p,self.outs,self.names,self.a,self.b=p,outs,names,a,b
  self.equiv=equiv
  self.fixedflags=fixedflags
  self.live=set();killed=set();self.flaglive=False
  flagseen=False
  for i,(op,d,s) in enumerate(p[b:],b+1):
   reads=[s] if op=='mov' else [d,s]
   self.live.update(r for r in reads if r not in killed)
   if op.startswith('cmov') and not flagseen:self.flaglive=True
   if op=='cmp':flagseen=True
   if op=='mov':killed.add(d)
   self.live.update(r for _,r in outs.get(i,[]) if r not in killed)
  self.m=b-a-delta;self.R=len(names);self.sol=z3.SolverFor('QF_BV');self.sol.set(random_seed=seed)
  self.choices=[];self.snap={};self.ct=0
  def oh(n,tag):
   v=[z3.Bool(f'{tag}_{i}') for i in range(n)];self.sol.add(z3.PbEq([(x,1) for x in v],1));return v
  initialized=set('P'+str(i) for i in range(5))
  for op,d,s in p[:a]:
   if op=='mov':initialized.add(d)
  ini=[r in initialized for r in names]
  self.oh=oh
  free=[r for r in range(self.R) if not ini[r] and names[r] not in self.live]
  for t in range(self.m):
   op=oh(6,f'op{t}');d=oh(self.R,f'd{t}');s=oh(self.R,f's{t}');self.choices.append((op,d,s))
   for r in range(self.R):
    self.sol.add(z3.Not(z3.And(d[r],s[r])))
    self.sol.add(z3.Implies(s[r],ini[r]))
    self.sol.add(z3.Implies(z3.And(d[r],z3.Not(op[0])),ini[r]))
   for r,prev in zip(free[1:],free[:-1]):
    self.sol.add(z3.Implies(z3.And(d[r],z3.Not(ini[r])),ini[prev]))
   ini=[z3.Or(ini[r],z3.And(op[0],d[r])) for r in range(self.R)]
  if maxcmp:self.sol.add(z3.PbEq([(x[0][1],1) for x in self.choices],sum(op=='cmp' for op,d,s in p[a:b])))
  self.counters=[]
  if fixedflags:
   nc=sum(op=='cmp' for op,d,s in p[a:b]);cur=[z3.BoolVal(i==0) for i in range(nc+1)]
   for t,(op,d,s) in enumerate(self.choices):
    self.counters.append(cur)
    nxt=[z3.Bool(f'c{t}_{j}') for j in range(nc+1)]
    self.sol.add(*[nxt[j]==z3.Or(z3.And(cur[j],z3.Not(op[1])),z3.And(cur[j-1],op[1]) if j else False) for j in range(nc+1)])
    cur=nxt
   self.sol.add(cur[-1])
  for t in range(a+1,b+1):
   for j,r in outs.get(t,[]):
    self.snap[j]=oh((self.m+1)*self.R,f'out{j}')
 def batch(self,types):
  B=len(types);mask=(1<<B)-1;BV=lambda x:z3.BitVecVal(x,B)
  def pack(values):return tuple(BV(sum(((v>>q)&1)<<i for i,v in enumerate(values))) for q in range(3))
  prs=[run(self.p,self.outs,ty,self.names)[1][self.a] for ty in types]
  st={r:pack([p[0][r] for p in prs]) for r in self.names}
  lt=BV(sum((p[1]<0)<<i for i,p in enumerate(prs)));gt=BV(sum((p[1]>0)<<i for i,p in enumerate(prs)))
  def select(sel,values):
   return tuple(z3.simplify(z3.Or(False,False)) for _ in []) if False else tuple(z3.simplify(reduce_or([z3.If(s,values[i][q],BV(0)) for i,s in enumerate(sel)])) for q in range(3))
  def less(x,y):return (~x[2]&y[2]) | (~(x[2]^y[2]) & ((~x[1]&y[1]) | (~(x[1]^y[1]) & ~x[0]&y[0])))
  def eq(x,y):return ~reduce_or([x[q]^y[q] for q in range(3)])
  hist=[st]
  for t,(op,d,s) in enumerate(self.choices):
   dv=select(d,list(st.values()));sv=select(s,list(st.values()))
   if self.fixedflags:
    indices=[i+1 for i,(o,_,_) in enumerate(self.p[self.a:self.b],self.a) if o=='cmp']
    traces=[run(self.p,self.outs,ty,self.names)[1] for ty in types]
    for j,ix in enumerate(indices):
     fl=[tr[ix][1] for tr in traces]
     wantl=BV(sum((f<0)<<i for i,f in enumerate(fl)));wantg=BV(sum((f>0)<<i for i,f in enumerate(fl)))
     self.sol.add(z3.Implies(z3.And(op[1],self.counters[t][j]),z3.And(less(dv,sv)==wantl,less(sv,dv)==wantg)))

   take=z3.If(op[0],BV(mask),BV(0)) | z3.If(op[2],lt,BV(0)) | z3.If(op[3],~gt,BV(0)) | z3.If(op[4],gt,BV(0)) | z3.If(op[5],~lt,BV(0))
   ns={}
   for r,old in st.items():
    ix=self.names.index(r);nv=[]
    for q in range(3):
     v=z3.BitVec(f'v{self.ct}_{t}_{ix}_{q}',B);self.sol.add(v==z3.If(d[ix],(sv[q]&take)|(old[q]&~take),old[q]));nv.append(v)
    ns[r]=tuple(nv)
   st=ns;hist.append(st)
   nl=z3.BitVec(f'l{self.ct}_{t}',B);ng=z3.BitVec(f'g{self.ct}_{t}',B)
   self.sol.add(nl==z3.If(op[1],less(dv,sv),lt),ng==z3.If(op[1],less(sv,dv),gt));lt,gt=nl,ng
  expected=[pack([sorted(ty)[j] for ty in types]) for j in range(5)]
  for j,sel in self.snap.items():
   for t in range(self.m+1):
    for ri,r in enumerate(self.names):
     self.sol.add(z3.Implies(sel[t*self.R+ri],z3.And([hist[t][r][q]==expected[j][q] for q in range(3)])))
  if self.equiv:
   ends=[run(self.p,self.outs,ty,self.names)[1][self.b] for ty in types]
   for r in self.live:
    wanted=pack([end[0][r] for end in ends]);self.sol.add(*[st[r][q]==wanted[q] for q in range(3)])
   if self.flaglive:
    self.sol.add(lt==BV(sum((e[1]<0)<<i for i,e in enumerate(ends))),gt==BV(sum((e[1]>0)<<i for i,e in enumerate(ends))))
   self.ct+=1
   return
  for i,(op,a,b) in enumerate(self.p[self.b:],self.b+1):
   x,y=st[a],st[b]
   if op=='cmp':lt,gt=less(x,y),less(y,x)
   elif op=='mov':st[a]=y
   else:
    take={'cmovl':lt,'cmovle':~gt,'cmovg':gt,'cmovge':~lt}[op]
    st[a]=tuple((y[q]&take)|(x[q]&~take) for q in range(3))
   for j,r in self.outs.get(i,[]):self.sol.add(*[st[r][q]==expected[j][q] for q in range(3)])
  self.ct+=1
 def decode(self):
  mod=self.sol.model();get=lambda vs:next(i for i,v in enumerate(vs) if z3.is_true(mod.eval(v,model_completion=True)))
  core=[(OPS[get(op)],self.names[get(d)],self.names[get(s)]) for op,d,s in self.choices]
  out={t:list(v) for t,v in self.outs.items() if t<=self.a}
  for j,sel in self.snap.items():
   v=get(sel);t,ri=divmod(v,self.R);out.setdefault(self.a+t,[]).append((j,self.names[ri]))
  for t,v in self.outs.items():
   if t>self.b:out.setdefault(t-(self.b-self.a-self.m),[]).extend(v)
  return self.p[:self.a]+core+self.p[self.b:],out

def reduce_or(vals):
 r=vals[0]
 for v in vals[1:]:r=r|v
 return r

def write(fn,p,outs):
 with open(fn,'w') as f:
  f.write('# n=5 model=out iset=I1 source=w4-window\n')
  for j,r in outs.get(0,[]):f.write(f'out {j}, {r}\n')
  for t,(op,a,b) in enumerate(p,1):
   f.write(f'{op} {a}, {b}\n')
   for j,r in outs.get(t,[]):f.write(f'out {j}, {r}\n')

def main():
 ap=argparse.ArgumentParser();ap.add_argument('file');ap.add_argument('--a',type=int,required=True);ap.add_argument('--b',type=int,required=True);ap.add_argument('--delta',type=int,default=1);ap.add_argument('--seconds',type=int,default=60);ap.add_argument('--extra',type=int,default=1);ap.add_argument('--seed',type=int,default=0);ap.add_argument('--out',required=True);ap.add_argument('--freecmp',action='store_true');ap.add_argument('--equiv',action='store_true');ap.add_argument('--cases',type=int,default=8);ap.add_argument('--fixed-flags',action='store_true');args=ap.parse_args()
 p,outs,names=read(args.file)
 for i in range(args.extra):names.append('S'+str(100+i))
 w=Window(p,outs,names,args.a,args.b,args.delta,not args.freecmp,args.seed,args.equiv,fixedflags=args.fixed_flags)
 types=[ty for ty in itertools.product(range(5),repeat=5) if set(ty)==set(range(max(ty)+1))]
 rng=random.Random(args.seed);initial=rng.sample(list(itertools.permutations(range(5))),args.cases)
 seen=set(initial);w.batch(initial);t0=time.monotonic();iters=0
 while True:
  left=args.seconds-(time.monotonic()-t0)
  if left<=0: print('TIMEOUT',flush=True);return
  w.sol.set(timeout=int(left*1000));status=w.sol.check();iters+=1
  print(f'window={args.a}:{args.b} m={w.m} status={status} cases={len(seen)} iter={iters} sec={time.monotonic()-t0:.2f}',flush=True)
  if status!=z3.sat:return
  q,oo=w.decode();fails=[ty for ty in types if run(q,oo,ty,names)[0]!=sorted(ty)]
  if not fails:
   write(args.out,q,oo);print('CANDIDATE',args.out,flush=True);return
  more=rng.sample(fails,min(8,len(fails)));assert not seen.intersection(more);seen.update(more);w.batch(more)
if __name__=='__main__':main()
