import sys
sys.path.insert(0,'.')
from rsat import ev_formula, perms, flag
P=perms()
sk=[l.strip().split(':') for l in open(sys.argv[1]) if l.strip() and l[0]!='#']
col=lambda f: tuple(ev_formula(f,t) for t in P)
names={}
def nm(c):
    return names.get(c,'?')
for k in range(5): names[tuple(sorted(t)[k] for t in P)]='out%d'%k
for f in ['0','1','2','3','4']: names[col(f)]='x'+f
for a,b in sk:
    for f in (a,b):
        names.setdefault(col(f),f)
F=[[flag(x,y) for x,y in zip(col(a),col(b))] for a,b in sk]
cols=list(names)
deadline={}
for c in cols: deadline[c]=len(sk)  # outputs: end
for j,(a,b) in enumerate(sk):
    for f in (a,b):
        c=col(f); deadline[c]=min(deadline[c],j)  # must exist before cmp j (0-based) i.e. created in block <= j
COND={'l':lambda f:f=='l','g':lambda f:f=='g','le':lambda f:f!='g','ge':lambda f:f!='l'}
for M in cols:
    if names[M].startswith('x'): continue
    opts=[]
    for j in range(1,len(sk)+1):
        if j>deadline[M]: break
        for cn,cf in COND.items():
            for D in cols:
                for S in cols:
                    if D==S or D==M or S==M: continue
                    if all((S[i] if cf(F[j-1][i]) else D[i])==M[i] for i in range(120)):
                        opts.append('b%d:%s %s<-%s'%(j,cn,nm(D),nm(S)))
    print('%-28s dl=%d  %s'%(names[M],deadline[M],' | '.join(opts) if opts else 'NONE (needs intermediate)'))
