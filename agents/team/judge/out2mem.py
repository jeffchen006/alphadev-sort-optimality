#!/usr/bin/env python3
# out-form -> mem-form (Lemma 4.1): P_i -> fresh S, loads first, stores at end. Usage: out2mem.py in out iset
import sys,re
fn,outfn,iset=sys.argv[1:4]
prog=[];outs={};n=None
for l in open(fn):
    m=re.search(r'n=(\d+)',l)
    if l.startswith('#') and n is None and m: n=int(m.group(1))
    l=l.split('#')[0].strip()
    if not l: continue
    if l.startswith('out'):
        j,r=l[3:].split(','); outs[int(j)]=r.strip()
    else:
        op,r=l.split(None,1); d,s=[x.strip() for x in r.split(',')]; prog.append((op,d,s))
regs=[x for _,d,s in prog for x in (d,s)]
ms=max([int(x[1:]) for x in regs+list(outs.values()) if x[0]=='S']+[-1])
base=ms+1
ren=lambda x:'S%d'%(base+int(x[1:])) if x[0]=='P' else x
for j in range(n): outs.setdefault(j,'P%d'%j)
L=['mov S%d, P%d'%(base+i,i) for i in range(n)]
L+=['%s %s, %s'%(o,ren(d),ren(s)) for o,d,s in prog]
L+=['mov P%d, %s'%(j,ren(outs[j])) for j in range(n)]
open(outfn,'w').write('# n=%d R=%d iset=%s model=mem source=%s L=%d (k=%d)\n'%(n,base+2*n,iset,fn,len(L),len(prog))+'\n'.join(L)+'\n')
