import itertools,json,re,os
import numpy as np
ROOT='codex_work/r3'
W=np.array([w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(len(set(w))))],dtype=np.int8)
X=[tuple(map(int,W[:,i])) for i in range(5)]
OUT=[tuple(map(int,np.sort(W,axis=1)[:,i])) for i in range(5)]
def ev(s):
    return tuple(map(int,np.maximum.reduce([W[:,[int(i) for i in m]].min(axis=1) for m in s.split('|')])))
def mn(a,b):return tuple(min(x,y) for x,y in zip(a,b))
def mx(a,b):return tuple(max(x,y) for x,y in zip(a,b))
def select(p,q,t,f,cn='l'):
    P,Q=np.array(p),np.array(q)
    cond={'l':P<Q,'le':P<=Q,'g':P>Q,'ge':P>=Q}[cn]
    return tuple(map(int,np.where(cond,np.array(t),np.array(f))))
def load(fn):return [tuple(map(int,l.split())) for l in open(fn)]
manifest=json.load(open(ROOT+'/manifest.json')) if os.path.exists(ROOT+'/manifest.json') else []
def save(tag,idea,cols,notes=None):
    pool=list(dict.fromkeys(X+list(cols)+OUT));assert len(pool)<=27,(tag,len(pool))
    fn=ROOT+'/pool_'+tag+'.txt'
    with open(fn,'w') as f:
        for c in pool:f.write(' '.join(map(str,c))+'\n')
    key=set(pool)
    for e in manifest:
        if key==set(load(e['file'])):print('duplicate skipped',tag,e['tag']);return
    manifest.append({'tag':tag,'idea':idea,'file':fn,'size':len(pool),'notes':notes})
def flush():json.dump(manifest,open(ROOT+'/manifest.json','w'),indent=2)
def simulate(fn):
    regs={'P%d'%i:X[i] for i in range(5)};fl=None;events=[];pool=list(X);gates=[];copies=[]
    for line in open(fn):
        m=re.match(r'(mov|cmp|cmovl|cmovle|cmovg|cmovge|out)\s+([^, ]+),\s*(\S+)',line)
        if not m:continue
        op,d,s=m.groups()
        if op=='out':continue
        D=regs.get(d);S=regs[s]
        if op=='cmp':fl=(D,S);events.append((D,S));continue
        if op=='mov':v=S;copies.append(S)
        else:
            v=select(*fl,S,D,op[4:])
            if v not in pool:
                gates.append(('min' if v==mn(D,S) else ('max' if v==mx(D,S) else 'other'),D,S,v))
        regs[d]=v
        if v not in pool:pool.append(v)
    pairs={frozenset((a,b)) for op,a,b,r in gates if op in ('min','max') and any({op2,op}=={'min','max'} and frozenset((a2,b2))==frozenset((a,b)) for op2,a2,b2,r2 in gates)}
    return pool,events,gates,copies,len(pairs)
if __name__=='__main__':
    base=load('pools/net9_41.txt')
    A,B,C,D,E=ev('012'),ev('01|02|12'),ev('0|1|2'),ev('34'),ev('3|4')
    T=mn(C,E);U=mx(A,T);V=mn(A,E);H=mx(V,D);Z=mx(B,D)
    extras={
      'p':mx(A,D),'r':mx(A,E),'l':mn(C,D),'f':mn(B,E),'j':mn(B,D),'m':mx(C,D),
      'a3':mn(A,X[3]),'a4':mn(A,X[4]),'v3':mn(V,X[3]),'v4':mn(V,X[4]),
      'a01':ev('01'),'a02':ev('02'),'core':mn(X[0],ev('1|2')),
      'b3':mn(B,X[3]),'b4':mn(B,X[4]),'c3':mn(C,X[3]),'c4':mn(C,X[4])}
    pairs=[('p','r'),('p','l'),('p','core'),('p','f'),('p','j'),('l','m'),('j','f'),('a3','a4'),('v3','v4'),('a01','a02'),('a01','p'),('a02','p'),('b3','b4'),('c3','c4'),('p','c3'),('p','c4')]
    for a,b in pairs:save('41_'+a+'_'+b,'net41 + paired factors '+a+'/'+b,base+[extras[a],extras[b]])
    # Fan-out-two refactoring: p=max(A,D), OUT0=min(A,D), H=min(p,E).
    for a,b in [('core','r'),('v3','v4')]:
        save('41_ref_'+a+'_'+b,'replace min(A,E) by max(A,D), plus '+a+'/'+b,[c for c in base if c!=V]+[extras['p'],extras[a],extras[b]])
    # These flags are absent from the original nine-comparison skeleton.
    for cn in ['l','le']:
        routes=[select(C,D,A,U,cn),select(C,D,B,H,cn),select(C,D,C,Z,cn)]
        save('41_cd_'+cn,'three routes for max012 vs min34 ('+cn+')',base+routes)
        pivots=[select(B,E,A,C,cn),select(B,E,D,T,cn)]
        save('41_be_'+cn,'selected pivots for median012 vs max34 ('+cn+')',base+pivots)
    # Identify the other family member outside the common five-full class.
    flush()
    import glob,collections
    fam=[]
    for fn in sorted(glob.glob('fam32/net9_*_k32.s')):
        p,flags,g,c,q=simulate(fn);fam.append((fn,q,len(g),len(c),sum(t[0]=='other' for t in g)))
    json.dump(fam,open(ROOT+'/family_counts.json','w'),indent=2)
    print('family',fam)
    flush();print('saved',len(manifest),'pools')
