"""Convert a concrete program to mov/cmov pairs without changing its gate order."""
from pathlib import Path
import sys

def paired(lines):
 cur={f'P{i}':i for i in range(5)};nodes={i:('input',) for i in range(5)};events=[];outs={};nextnode=5
 for line in lines:
  if not line.strip() or line.lstrip().startswith('#'):continue
  op,rest=line.split(None,1);d,s=[x.strip() for x in rest.split(',')]
  if op=='out':outs[int(d)]=cur[s]
  elif op=='mov':cur[d]=cur[s]
  elif op=='cmp':events.append(('cmp',cur[d],cur[s]))
  else:
   nodes[nextnode]=(op,cur[d],cur[s]);events.append(('gate',nextnode));cur[d]=nextnode;nextnode+=1
 # Defaults can reuse their register exactly at their final use.
 last={}
 for t,ev in enumerate(events):
  used=ev[1:] if ev[0]=='cmp' else nodes[ev[1]][1:]
  for x in used:last[x]=t
 regs={i:f'P{i}' for i in range(5)};nr=0;out=['# n=5 R=50 iset=I1 model=out source=w3_paired_control']
 for j,x in outs.items():
  if x<5:out.append(f'out {j}, {regs[x]}')
 for t,ev in enumerate(events):
  if ev[0]=='cmp':out.append(f'cmp {regs[ev[1]]}, {regs[ev[2]]}')
  else:
   x=ev[1];op,d,s=nodes[x]
   if last[d]!=t:
    dest=f'S{nr}';nr+=1;out.append(f'mov {dest}, {regs[d]}')
   else:dest=regs[d]
   out.append(f'{op} {dest}, {regs[s]}');regs[x]=dest
   for j,n in outs.items():
    if n==x:out.append(f'out {j}, {dest}')
 return out
if __name__=='__main__':
 src=Path(sys.argv[1]);out=Path(sys.argv[2]);lines=paired(src.read_text().splitlines());out.write_text('\n'.join(lines)+'\n');print('instructions',sum(not l.startswith(('#','out')) for l in lines))
