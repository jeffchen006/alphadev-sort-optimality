import itertools,json,time
import numpy as np
j=json.load(open('codex_work/rules.json'))
def term(s):return sum(1<<S for S in range(32) if any(all(S>>int(i)&1 for i in m) for m in s.split('|')))
def name(t):
    ss=[s for s in range(1,32) if t>>s&1]
    return '|'.join(''.join(str(i) for i in range(5) if s>>i&1) for s in ss if not any(u!=s and u&s==u for u in ss))
base=[term(s) for s in j['names']];extra=sorted({t for a,b in itertools.combinations(base,2) for t in (a&b,a|b)}-set(base))
W=np.array([v for v in itertools.product(range(5),repeat=5) if set(v)==set(range(len(set(v))))],dtype=np.int8)
def col(t):
    ss=[s for s in range(1,32) if t>>s&1]
    mins=[s for s in ss if not any(u!=s and u&s==u for u in ss)]
    return np.maximum.reduce([W[:,[i for i in range(5) if s>>i&1]].min(axis=1) for s in mins])
basecols=np.array([col(t) for t in base]);t0=time.monotonic();found=[];stats={}
target=sum(1<<(j['names'].index(s)-5) for s in ['01234','0|1|2|3|4','0123|0124|0134|0234|1234','012|013|023|123|014|024|124|034|134|234','01|02|12|03|13|23|04|14|24|34'])
for ni,t in enumerate(extra):
    pool=base+[t];cols=np.concatenate([basecols,col(t)[None,:]],axis=0);ix={v:i for i,v in enumerate(pool)}
    rules=[]
    for a,b in itertools.combinations(range(len(pool)),2):
        for op,r in [('min',pool[a]&pool[b]),('max',pool[a]|pool[b])]:
            if r in ix and r not in (pool[a],pool[b]):rules.append((a,b,ix[r]))
    A=cols[[r[0] for r in rules]];B=cols[[r[1] for r in rules]];R=cols[[r[2] for r in rules]]
    bits=[0 if i<5 else 1<<(i-5) for i in range(len(pool))];blocks=[]
    for p,q in itertools.combinations(range(len(pool)),2):
        f=cols[p]-cols[q];ok=np.zeros(len(rules),dtype=bool)
        for cf in [f<0,f<=0,f>0,f>=0]:
            ok|=np.all(np.where(cf,B,A)==R,axis=1)|np.all(np.where(cf,A,B)==R,axis=1)
        rs=[(bits[a]|bits[b],bits[r]) for (a,b,r),yes in zip(rules,ok) if yes]
        if rs:blocks.append((bits[p]|bits[q],rs,p,q))
    layer=[0];seen={0:None};win=None
    for k in range(1,10):
        new=[]
        for mask in layer:
            for req,rs,p,q in blocks:
                if mask&req!=req:continue
                mm=mask
                while True:
                    old=mm
                    for ab,r in rs:
                        if mm&ab==ab:mm|=r
                    if old==mm:break
                if mm!=mask and mm not in seen:seen[mm]=(mask,p,q);new.append(mm)
                if mm&target==target:win=mm;break
            if win is not None:break
        if win is not None:break
        layer=new
    stats[k]=stats.get(k,0)+1
    if k<=8 and win is not None:
        path=[];m=win
        while m:
            prev,p,q=seen[m];path.append((name(pool[p]),name(pool[q]),[name(pool[i]) for i in range(5,len(pool)) if (m^prev)&bits[i]]));m=prev
        item={'extra':name(t),'c':k,'path':list(reversed(path))};found.append(item);print('CANDIDATE',item,flush=True)
    if (ni+1)%20==0:print('done',ni+1,'seconds',round(time.monotonic()-t0,1),'stats',stats,flush=True)
    if time.monotonic()-t0>100:break
json.dump(found,open('codex_work/extra_cmp_candidates.json','w'))
print('FINAL',ni+1,'of',len(extra),'seconds',round(time.monotonic()-t0,1),'stats',stats,flush=True)
