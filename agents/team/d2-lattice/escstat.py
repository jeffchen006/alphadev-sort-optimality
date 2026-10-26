# non-lattice columns in k=32 optima: how many, lifetime, how they are used
import sys
from collections import Counter
src=open('te.py').read().split("lim=int(sys.argv[2])")[0]; exec(src)
st=Counter(); life=Counter(); nn=Counter(); use=Counter(); cre=Counter()
lim=int(sys.argv[2])
for i,pr in enumerate(progs(sys.argv[1])):
    if i>=lim: break
    pr2,left=te(pr)
    reg={f'P{j}':tuple(p[j] for p in P) for j in range(n)}; T=(None,)*len(P); fl=[0]*len(P)
    get=lambda r: reg.get(r,T); ins=[x for x in pr2 if x[0]!='out']
    born={}; esc=[]  # (reg, t_born, col)
    for t,(op,a,b) in enumerate(ins):
        # uses of live escape values
        for e in esc:
            if e['dead']: continue
            if op=='cmp' and e['reg'] in (a,b): e['uses'].append(('cmp',t))
            elif op.startswith('cmov') and b==e['reg']: e['uses'].append(('src',t))
            elif op.startswith('cmov') and a==e['reg']: e['uses'].append(('dst',t))
            elif op=='mov' and b==e['reg']: e['uses'].append(('movsrc',t))
        if op=='cmp': A,B=get(a),get(b); fl=[0 if x==y else (1 if x<y else 2) for x,y in zip(A,B)]; continue
        if op=='mov': reg[a]=get(b)
        else: D,S=get(a),get(b); reg[a]=tuple(s if cond[op](f) else d for s,d,f in zip(S,D,fl))
        for e in esc:
            if not e['dead'] and e['reg']==a and reg[a]!=e['col']: e['dead']=True; e['end']=t
        col=reg[a]
        if op.startswith('cmov') and not lattice(col):
            esc.append(dict(reg=a,t=t,col=col,uses=[],dead=False,end=None,dsl=(lattice(D),lattice(S))))
    if not esc: continue
    st['progs']+=1; nn[len(esc)]+=1
    for e in esc:
        end=e['end'] if e['end'] is not None else max([u[1] for u in e['uses']],default=e['t'])
        last=max([u[1] for u in e['uses']],default=e['t'])
        life[last-e['t']]+=1
        use[tuple(sorted(set(u[0] for u in e['uses'])))]+=1
        cre[e['dsl']]+=1
print(st); print('n_escape per prog',sorted(nn.items())); print('life (last use - birth, instructions)',sorted(life.items()))
print('use kinds',use.most_common()); print('operands lattice (D,S)',cre)
