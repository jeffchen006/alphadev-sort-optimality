import sys, itertools
sys.path.insert(0,'.')
from rsat import ev_formula, perms, flag, COND
P=perms()
sk=[l.strip().split(':') for l in open(sys.argv[1]) if l.strip() and l[0]!='#']
prog=[l.split('#')[0].strip() for l in open(sys.argv[2]).read().splitlines()]
prog=[l for l in prog if l and not l.startswith('out')]
col=lambda f: tuple(ev_formula(f,t) for t in P)
tg=[tuple(sorted(t)[k] for t in P) for k in range(5)]
reg={'P%d'%i: tuple(t[i] for t in P) for i in range(5)}
fl=None; j=0; done=set(); g=0; blk=False
def h():
    need=set()
    for i in range(j,len(sk)): need.add(col(sk[i][0])); need.add(col(sk[i][1]))
    for k in range(5):
        if k not in done: need.add(tg[k])
    A=set(reg.values()); miss=len(need-A); bl=len(sk)-j+(1 if j>=1 and not blk else 0)
    return len(sk)-j+max(miss,bl)
for l in prog:
    op,rest=l.split(None,1); d,s=[x.strip() for x in rest.split(',')]
    if op=='cmp':
        a,b=reg[d],reg[s]
        ok={a,b}=={col(sk[j][0]),col(sk[j][1])}
        fl=[flag(x,y) for x,y in zip(a,b)]; j+=1; blk=False
        if not ok: print('CMP MISMATCH at',l)
    elif op=='mov': reg[d]=reg[s]
    else:
        c=COND[op]; blk=True
        if d not in reg: reg[d]=(None,)*120
        reg[d]=tuple(sv if ((f=='l' and 'l' in c) or (f=='g' and 'g' in c) or (f=='e' and c.endswith('e'))) else dv for f,sv,dv in zip(fl,reg[s],reg[d]))
    g+=1
    for k in range(5):
        if tg[k] in reg.values(): done.add(k)
    print(g, l, 'h=',h(), 'g+h=',g+h(), 'ncols=',len(set(reg.values())))
