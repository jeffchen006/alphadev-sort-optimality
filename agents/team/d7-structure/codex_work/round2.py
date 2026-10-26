import itertools,re,json,os
import numpy as np
ROOT='codex_work'
W=np.array([w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(len(set(w))))],dtype=np.int8)
X=[tuple(map(int,W[:,i])) for i in range(5)]
OUT=[tuple(map(int,np.sort(W,axis=1)[:,i])) for i in range(5)]
conds={'l':lambda a,b:a<b,'le':lambda a,b:a<=b,'g':lambda a,b:a>b,'ge':lambda a,b:a>=b}
def sel(a,b,p,q,c='l'):
    return tuple(map(int,np.where(conds[c](np.array(p),np.array(q)),np.array(b),np.array(a))))
def lo(a,b):return tuple(min(x,y) for x,y in zip(a,b))
def hi(a,b):return tuple(max(x,y) for x,y in zip(a,b))
def simulate(fn):
    pool=list(X); names=['x%d'%i for i in range(5)];regs={'P%d'%i:X[i] for i in range(5)};fl=None;events=[]
    for line in open(fn):
        m=re.match(r'(mov|cmp|cmovl|cmovle|cmovg|cmovge|out)\s+([^, ]+),\s*(\S+)',line)
        if not m:continue
        op,d,s=m.groups()
        if op=='out':continue
        D=regs.get(d,(None,)*541);S=regs.get(s,(None,)*541)
        if op=='cmp':fl=(D,S);events.append(('cmp',D,S,dict(regs)));continue
        if op=='mov':v=S
        else:
            cs={'l':(-1,),'le':(-1,0),'g':(1,),'ge':(0,1)}[op[4:]]
            v=tuple((y if (a>b)-(a<b) in cs else x) if a is not None and b is not None else (x if x==y else None) for x,y,a,b in zip(D,S,*fl))
        regs[d]=v
        if None not in v and v not in pool:pool.append(v);names.append('%s:%s,%s'%(op,d,s))
    return pool,names,events
def lattice(c):
    # Threshold compatibility is necessary and sufficient here.
    binary={tuple(w):v for w,v in zip(W,c) if max(w)<=1}
    for w,v in zip(W,c):
        for t in range(1,5):
            if (v>=t)!=bool(binary[tuple(int(x>=t) for x in w)]):return False
    return True
def tname(c):
    if not lattice(c):return 'NL'
    bv={sum(int(x)<<i for i,x in enumerate(w)):v for w,v in zip(W,c) if max(w)<=1};bv[31]=1
    ss=[s for s in range(1,32) if bv[s]]
    return '|'.join(''.join(str(i) for i in range(5) if s>>i&1) for s in ss if not any(u!=s and u&s==u for u in ss))
manifest=[]
def save(tag,idea,cols,notes=None):
    pool=list(dict.fromkeys(X+list(cols)+OUT))
    assert len(pool)<=27,(tag,len(pool))
    fn=ROOT+'/pool_'+tag+'.txt'
    with open(fn,'w') as f:
        for c in pool:f.write(' '.join(map(str,c))+'\n')
    entry={'tag':tag,'idea':idea,'file':fn,'size':len(pool),'notes':notes}
    manifest.append(entry)
    return pool
def flush():json.dump(manifest,open(ROOT+'/round2_manifest.json','w'),indent=2)
if __name__=='__main__':
    for fn in ['ex_prog1.txt','ex_pos33.txt']:
        p,n,e=simulate(fn)
        print(fn,'size',len(p),'nonlattice',[i for i,c in enumerate(p) if not lattice(c)])
        for i,c in enumerate(p):print(i,n[i],tname(c))
        print('cmps',[(p.index(a),p.index(b)) for _,a,b,_ in e])
    p,_,_=simulate('ex_pos33.txt');save('merge23','sort2 + sort3 + adaptive merge',p);flush()
