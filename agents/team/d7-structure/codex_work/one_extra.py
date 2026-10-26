import json,itertools,time
j=json.load(open('codex_work/rules.json'))
def term(s):return sum(1<<S for S in range(32) if any(all(S>>int(i)&1 for i in m) for m in s.split('|')))
def name(t):
    ss=[s for s in range(1,32) if t>>s&1]
    return '|'.join(''.join(str(i) for i in range(5) if s>>i&1) for s in ss if not any(u!=s and u&s==u for u in ss))
base=[term(s) for s in j['names']];extra=sorted({t for a,b in itertools.combinations(base,2) for t in (a&b,a|b)}-set(base))
initial=31
outs=['01234','0|1|2|3|4','0123|0124|0134|0234|1234','012|013|023|123|014|024|124|034|134|234','01|02|12|03|13|23|04|14|24|34']
target=sum(1<<base.index(term(s)) for s in outs)
t0=time.monotonic();stats={};found=[]
for ni,t in enumerate(extra):
    pool=base+[t];ix={v:i for i,v in enumerate(pool)};rules=[]
    for a,b in itertools.combinations(range(len(pool)),2):
        for op,r in [('min',pool[a]&pool[b]),('max',pool[a]|pool[b])]:
            if r in ix and r not in (pool[a],pool[b]):rules.append((op,a,b,ix[r]))
    layer={initial};seen=set(layer);ming=None
    for k in range(1,19):
        new=set()
        for m in layer:
            for _,a,b,r in rules:
                ab=(1<<a)|(1<<b);rb=1<<r
                if m&ab==ab and not m&rb:new.add(m|rb)
        new-=seen;seen|=new;layer=new
        if any(m&target==target for m in new):ming=k;break
    stats[ming]=stats.get(ming,0)+1
    if ming is not None and ming<18:print('GATE CANDIDATE',name(t),ming,flush=True)
    # Test G+Q<=22, with this one extra term available.
    layer={(initial,initial):0};hist=[]
    for k in range(1,20):
        new={};pr={}
        useful_cache={}
        for (made,live),q in layer.items():
            for op,a,b,r in rules:
                ab=(1<<a)|(1<<b);rb=1<<r
                if live&ab!=ab or made&rb:continue
                mm=made|rb
                if mm not in useful_cache:
                    useful_cache[mm]=0
                    for _,u,v,w in rules:
                        if not mm>>w&1:useful_cache[mm]|=(1<<u)|(1<<v)
                useful=useful_cache[mm]
                for dest in (a,b):
                    for keep in (0,1):
                        qq=q+keep
                        if qq>min(4,22-k):continue
                        ll=((live|rb) if keep else ((live&~(1<<dest))|rb))&useful
                        key=(mm,ll)
                        if qq<new.get(key,99):new[key]=qq;pr[key]=((made,live),op,a,b,r,dest,keep)
        hist.append(pr);layer=new
        wins=[(key,q) for key,q in layer.items() if key[0]&target==target]
        if wins:
            key,q=min(wins,key=lambda x:x[1]);path=[]
            for h in reversed(hist):
                z=h[key];path.append(z[1:]);key=z[0]
            item={'extra':name(t),'G':k,'Q':q,'names':[name(v) for v in pool],'path':list(reversed(path))}
            found.append(item);print('COPY CANDIDATE',item,flush=True);break
        if not layer:break
    if (ni+1)%20==0:print('done',ni+1,'of',len(extra),'seconds',round(time.monotonic()-t0,1),'stats',stats,flush=True)
    if time.monotonic()-t0>100:break
json.dump(found,open('codex_work/one_extra_candidates.json','w'))
print('FINAL done',ni+1,'of',len(extra),'seconds',round(time.monotonic()-t0,1),'stats',stats,'candidates',len(found),flush=True)
