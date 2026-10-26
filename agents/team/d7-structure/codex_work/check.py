import itertools, re, time, json
import numpy as np
t0=time.monotonic()
W=np.array([v for v in itertools.product(range(5),repeat=5) if set(v)==set(range(len(set(v))))],dtype=np.int8)
assert len(W)==541
def term(s):
    return sum(1<<S for S in range(32) if any(all(S>>int(i)&1 for i in m) for m in s.split('|')))
def name(t):
    ss=[s for s in range(1,32) if t>>s&1]
    return '|'.join(''.join(str(i) for i in range(5) if s>>i&1) for s in ss if not any(u!=s and u&s==u for u in ss))
g=[]
for line in open('ex_gates1.txt'):
    m=re.match(r'  (min|max)\(([^,]+), ([^)]+)\) = (\S+)',line)
    if m:g.append((m[1],term(m[2]),term(m[3]),term(m[4])))
pool=list(dict.fromkeys([term(str(i)) for i in range(5)]+[x[3] for x in g]))
ix={t:i for i,t in enumerate(pool)}
cols=[]
for t in pool:
    mins=[s for s in range(1,32) if t>>s&1 and not any(u!=s and u&s==u and t>>u&1 for u in range(1,32))]
    cols.append(np.maximum.reduce([W[:,[i for i in range(5) if s>>i&1]].min(axis=1) for s in mins]))
cols=np.array(cols)
rules=[]
for a,b in itertools.combinations(range(len(pool)),2):
    for op,r in [('min',pool[a]&pool[b]),('max',pool[a]|pool[b])]:
        if r in ix and r not in (pool[a],pool[b]): rules.append((op,a,b,ix[r]))
print('terms',len(pool),'alternative min/max rules',len(rules),flush=True)
for op,a,b,r in rules:
    if not any(op==o and {pool[a],pool[b]}=={x,y} and pool[r]==z for o,x,y,z in g):
        print('ALT',op,name(pool[a]),name(pool[b]),'->',name(pool[r]),flush=True)
blocks=[]
conds=[lambda f:f<0,lambda f:f<=0,lambda f:f>0,lambda f:f>=0]
for p,q in itertools.combinations(range(len(pool)),2):
    fl=np.sign(cols[p]-cols[q]); rr=[]
    for op,a,b,r in rules:
        for d,s in [(a,b),(b,a)]:
            for cn,cond in zip(['l','le','g','ge'],conds):
                if np.array_equal(np.where(cond(fl),cols[s],cols[d]),cols[r]):
                    rr.append((a,b,r,d,s,cn));break
            else:continue
            break
    if rr: blocks.append((p,q,rr))
json.dump({'names':[name(t) for t in pool],'blocks':blocks,'rules':rules},open('codex_work/rules.json','w'))
print('blocks',len(blocks),'setup seconds',time.monotonic()-t0,flush=True)
# Distinct-term closure. This deliberately permits all alternate decompositions.
bits=[0 if i<5 else 1<<(i-5) for i in range(len(pool))]
bb=[]
for p,q,rr in blocks:
    req=bits[p]|bits[q]
    rs=list(set((bits[a]|bits[b],bits[r]) for a,b,r,*_ in rr if r>=5))
    bb.append((req,rs,p,q))
full=(1<<(len(pool)-5))-1
seen={0:None}; layer=[0]
for depth in range(1,10):
    new=[]
    for mask in layer:
        for req,rs,p,q in bb:
            if mask&req!=req:continue
            mm=mask
            while True:
                old=mm
                for ab,r in rs:
                    if mm&ab==ab:mm|=r
                if old==mm:break
            if mm!=mask and mm not in seen:
                seen[mm]=(mask,p,q);new.append(mm)
    print('depth',depth,'states',len(new),'elapsed',time.monotonic()-t0,flush=True)
    if full in seen:
        path=[];m=full
        while m:
            prev,p,q=seen[m];path.append((name(pool[p]),name(pool[q]),[name(pool[i]) for i in range(5,len(pool)) if (m^prev)&bits[i]]));m=prev
        print('PATH',list(reversed(path)),flush=True);break
    layer=new
    if time.monotonic()-t0>130:break
# Q1: zero-copy full comparator with C=min(a,d), b<=d.
a,b,d=W[:,0],np.minimum(W[:,1],W[:,2]),W[:,1]
c=np.minimum(a,d);f=a<b
assert np.array_equal(np.where(f,b,a),np.maximum(a,b))
assert np.array_equal(np.where(f,c,b),np.minimum(a,b))
print('Q1 checked on 541 weak orders',flush=True)
# Two full comparators share one copy, when d <= b.
a=W[:,0];d=W[:,1];b=np.maximum(W[:,1],W[:,2]);s=a.copy()
f=a<b; A=np.where(f,b,a);B=np.where(f,s,b)
f=s<d; S=np.where(f,d,s);D=np.where(f,B,d)
assert np.array_equal(A,np.maximum(a,b)) and np.array_equal(B,np.minimum(a,b))
assert np.array_equal(S,np.maximum(a,d)) and np.array_equal(D,np.minimum(a,d))
print('two full comparators / one copy checked on 541 weak orders',flush=True)
# General selects that produce a pool lattice term but are not a binary gate.
bycol={c.tobytes():i for i,c in enumerate(cols)}
unusual=set(); gb=[]
for p,q in itertools.combinations(range(len(pool)),2):
    fl=np.sign(cols[p]-cols[q]); rr=set()
    for cn,cond in zip(['l','le','g','ge'],conds):
        cf=cond(fl)
        for a,b in itertools.permutations(range(len(pool)),2):
            r=bycol.get(np.where(cf,cols[b],cols[a]).tobytes())
            if r is not None and r not in (a,b):
                rr.add((a,b,r))
                if pool[r] not in (pool[a]&pool[b],pool[a]|pool[b]):unusual.add((a,b,r,p,q,cn))
    if rr:gb.append((p,q,rr))
print('non-gate lattice selects',len(unusual),flush=True)
for a,b,r,p,q,cn in sorted(unusual)[:12]:print('SELECT',name(pool[a]),name(pool[b]),'->',name(pool[r]),'cmp',name(pool[p]),name(pool[q]),cn,flush=True)
json.dump({'names':[name(t) for t in pool],'selects':list(unusual)},open('codex_work/selects.json','w'))
