import sys,gzip,itertools
P=list(itertools.permutations(range(5))); T=None
def progs(f):
    cur=None
    for l in gzip.open(f,'rt'):
        l=l.strip()
        if l.startswith('#'):
            if cur: yield cur
            cur=[]; continue
        if l: op,r=l.split(None,1); a,b=[x.strip() for x in r.split(',')]; cur.append((op,a,b))
    if cur: yield cur
cond={'cmovl':lambda f:f==1,'cmovg':lambda f:f==2,'cmovle':lambda f:f!=2,'cmovge':lambda f:f!=1}
stat={'minmax':0,'other':0}; n=0; lim=int(sys.argv[2])
for pr in progs(sys.argv[1]):
    n+=1
    if n>lim: break
    reg={f'P{i}':tuple(p[i] for p in P) for i in range(5)}; fl=None; ok=True
    for op,a,b in pr:
        if op=='out': continue
        if op=='mov': reg[a]=reg.get(b); continue
        if op=='cmp': A,B=reg.get(a),reg.get(b); fl=[1 if x<y else 2 if x>y else 0 for x,y in zip(A,B)] if A and B else None; continue
        D,S=reg.get(a),reg.get(b)
        if D is None or S is None or fl is None: ok=False; reg[a]=None; continue
        R=tuple(s if cond[op](f) else d for s,d,f in zip(S,D,fl)); reg[a]=R
        if R!=tuple(map(min,D,S)) and R!=tuple(map(max,D,S)): ok=False
    stat['minmax' if ok else 'other']+=1
print(stat)
