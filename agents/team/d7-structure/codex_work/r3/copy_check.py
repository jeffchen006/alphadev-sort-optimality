import os,time,json
try:os.sched_setaffinity(0,set(sorted(os.sched_getaffinity(0))[:2]))
except (AttributeError,OSError):pass
from design import *
pool=load('pools/net9_41.txt');ix={c:i for i,c in enumerate(pool)}
rules=[]
for a,b in itertools.combinations(range(len(pool)),2):
    for op,r in [('min',mn(pool[a],pool[b])),('max',mx(pool[a],pool[b]))]:
        if r in ix and ix[r] not in (a,b):rules.append((op,a,b,ix[r]))
target=sum(1<<ix[c] for c in OUT);initial=31;t0=__import__('time').monotonic()
report={'rules':len(rules),'layers':[]};layer={(initial,initial):0}
for k in range(1,19):
    nxt={};use={}
    for (made,live),q in layer.items():
        for op,a,b,r in rules:
            ab=(1<<a)|(1<<b);rb=1<<r
            if live&ab!=ab or made&rb:continue
            mm=made|rb
            if mm not in use:
                useful=0
                for _,u,v,w in rules:
                    if not mm>>w&1:useful|=(1<<u)|(1<<v)
                use[mm]=useful
            for dest in (a,b):
                for keep in (0,1):
                    qq=q+keep
                    if qq>4:continue
                    ll=((live|rb) if keep else ((live&~(1<<dest))|rb))&use[mm]
                    key=(mm,ll)
                    if qq<nxt.get(key,99):nxt[key]=qq
    layer=nxt;wins=[q for (m,l),q in layer.items() if m&target==target]
    report['layers'].append([k,len(layer),min(wins) if wins else None]);print(report['layers'][-1],flush=True)
    if not layer:break
report['scope']='distinct-term min/max gates, unlimited free flags/registers, at most four copies'
report['seconds']=__import__('time').monotonic()-t0
json.dump(report,open(ROOT+'/copy_check.json','w'),indent=2)
