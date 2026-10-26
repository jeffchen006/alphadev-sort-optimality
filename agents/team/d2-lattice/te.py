# T-elimination (PRUNING.md Lemma NG rules a-e) on k=32 optima; then: are all columns lattice? still correct?
import sys,gzip,itertools
from collections import Counter
n=5; P=list(itertools.permutations(range(n)))
ORD=[sorted(range(n),key=lambda i:-p[i]) for p in P]
def progs(f):
    cur=None
    for l in gzip.open(f,'rt'):
        l=l.strip()
        if l.startswith('#'):
            if cur: yield cur
            cur=[]; continue
        if l: op,r=l.split(None,1); a,b=[x.strip() for x in r.split(',')]; cur.append([op,a,b])
    if cur: yield cur
cond={'cmovl':lambda f:f==1,'cmovg':lambda f:f==2,'cmovle':lambda f:f!=2,'cmovge':lambda f:f!=1}
LC={}
def lattice(col):
    if col in LC: return LC[col]
    g={}; ok=True
    for p,o,v in zip(P,ORD,col):
        idx=p.index(v)
        for k in range(n+1):
            B=frozenset(o[:k]); val=idx in B
            if g.setdefault(B,val)!=val: ok=False; break
        if not ok: break
    if ok:
        for B,val in g.items():
            if val and any(i not in B and not g[B|{i}] for i in range(n)): ok=False; break
    LC[col]=ok; return ok
def run(pr):
    """returns (kinds of columns, correct)"""
    reg={f'P{i}':tuple(p[i] for p in P) for i in range(n)}; T=(None,)*len(P); fl=[0]*len(P)
    get=lambda r: reg.get(r,T); kinds=Counter(); outs={}
    for op,a,b in pr:
        if op=='out': outs[int(a)]=get(b); continue
        if op=='cmp': A,B=get(a),get(b); fl=[0 if (x is None and y is None) or x==y else (1 if (y is None or (x is not None and x<y)) else 2) for x,y in zip(A,B)]; continue
        if op=='mov': reg[a]=get(b); col=reg[a]
        else: D,S=get(a),get(b); col=reg[a]=tuple(s if cond[op](f) else d for s,d,f in zip(S,D,fl))
        if all(x is None for x in col): kinds['allT']+=1
        elif any(x is None for x in col): kinds['Tpartial']+=1
        elif lattice(col): kinds['lat']+=1
        else: kinds['nonlat']+=1
    for j in range(n):
        if j not in outs: outs[j]=get(f'P{j}')
    ok=all(outs[j]==tuple(sorted(p)[j] for p in P) for j in range(n))
    return kinds,ok
def reads(ins):
    op,a,b=ins
    if op=='out': return [b]
    if op=='mov': return [b]
    return [a,b]
def te(pr):
    pr=[list(x) for x in pr]; left=0
    while True:
        written=set(f'P{i}' for i in range(n)); hit=None
        for t,ins in enumerate(pr):
            for r in reads(ins):
                if r not in written: hit=(t,r); break
            if hit: break
            if ins[0] in ('mov',) or ins[0].startswith('cmov'): written.add(ins[1])
        if not hit: return pr,left
        t,S=hit; op,a,b=pr[t]
        other=[r for r in reads(pr[t]) if r!=S]
        if any(r not in written for r in other) or (op=='mov' and a not in written and a!=S and False):
            pass
        if op.startswith('cmov'):
            E=b if a==S else a
            if E==S or E not in written: return pr,left+1   # two pristine: garbage mov, stop
            pr[t]=['mov',S,E]
        elif op=='mov':  # mov D,S -> mov S,D
            D=a
            if D not in written: return pr,left+1
            pr[t]=['mov',S,D]
        elif op=='cmp':
            X=b if a==S else a
            if X==S: new=[]   # cmp S,S: delete
            else:
                if X not in written: return pr,left+1
                new=[['mov',S,X]]
            rest=[]; u=t+1
            while u<len(pr) and pr[u][0]!='cmp':
                o2,a2,b2=pr[u]
                if o2 in ('cmovl','cmovg'): pass
                elif o2 in ('cmovle','cmovge'): rest.append(['mov',a2,b2])
                else: rest.append(pr[u])
                u+=1
            pr=pr[:t]+new+rest+pr[u:]
        else: return pr,left+1
lim=int(sys.argv[2]); st=Counter(); ex=[]
for i,pr in enumerate(progs(sys.argv[1])):
    if i>=lim: break
    k0,ok0=run(pr)
    hasT=k0['Tpartial']>0 or k0['allT']>0
    if not hasT: st['noT']+=1; continue
    pr2,left=te(pr); k1,ok1=run(pr2)
    L=sum(1 for x in pr2 if x[0]!='out')
    key=('T' if k0['Tpartial'] else 'allT-only', 'nonlat0' if k0['nonlat'] else 'lat0', 'nonlat1' if k1['nonlat'] else 'lat1',
         'Tleft' if (k1['Tpartial'] or left) else '', 'ok' if ok1 else 'WRONG', f'L{L}')
    st[key]+=1
    if k1['nonlat'] and not k0['nonlat'] and len(ex)<3: ex.append(pr2)
for k,v in sorted(st.items(),key=str): print(k,v)
for e in ex: print('---'); print('\n'.join(f'{o} {a}, {b}' for o,a,b in e))
