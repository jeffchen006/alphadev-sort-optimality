# Independent parser and scalar simulator for emitted out-model witnesses.
import itertools,sys,pathlib,re
p=pathlib.Path(sys.argv[1]); ins=[]
for line in p.read_text().splitlines():
 s=line.split('#')[0].replace(',',' ').split()
 if s:ins.append(s)
weak=[w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(max(w)+1))]
for w in weak:
 for initial in (-1,0,1,2):
  r={f'P{i}':w[i] for i in range(5)};out={};flag=initial
  for op,d,s in ins:
   if op=='out':out[int(d)]=r[s];continue
   if op=='mov':r[d]=r[s];continue
   if op=='cmp':flag=(r[d]>r[s])-(r[d]<r[s]);continue
   assert d in r and s in r
   take=flag<0 if op=='cmovl' else flag<=0 if op=='cmovle' else flag>0 if op=='cmovg' else flag>=0
   if take:r[d]=r[s]
  assert [out.get(i,r[f'P{i}']) for i in range(5)]==sorted(w)
print('Independent scalar PASS:',p,'541 weak orders, 4 initial flags; every scratch read initialized.')
# Use a register for each input, then replace every out with its memory store.
regs=sorted({s for op,d,s in ins if op!='out'}|{d for op,d,s in ins if op!='out'})
rmap={name:f'S{i}' for i,name in enumerate(regs)}
mem=['# n=5 R=64 iset=I1 model=mem source=w1_round2_copy_reuse']+[f'mov {rmap[f"P{i}"]}, P{i}' for i in range(5)]
for op,d,s in ins:
 mem.append(f'mov P{d}, {rmap[s]}' if op=='out' else f'{op} {rmap[d]}, {rmap[s]}')
mp=p.with_name(p.stem.replace('_out','')+'_mem.s');mp.write_text('\n'.join(mem)+'\n');print('Wrote',mp)
