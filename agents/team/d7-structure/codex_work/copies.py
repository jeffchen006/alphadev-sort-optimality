import json, collections, time
d=json.load(open('codex_work/rules.json')); names=d['names']; rules=d['rules']
n=len(names); full=(1<<n)-1; initial=(1<<5)-1
target=sum(1<<names.index(s) for s in ['01234','0|1|2|3|4','0123|0124|0134|0234|1234','012|013|023|123|014|024|124|034|134|234','01|02|12|03|13|23|04|14|24|34'])
layer={initial};seen=set(layer)
for k in range(1,19):
    new=set()
    for m in layer:
        for _,a,b,r in rules:
            ab=(1<<a)|(1<<b); rb=1<<r
            if m&ab==ab and not m&rb:new.add(m|rb)
    new-=seen;seen|=new;layer=new
    wins=[m for m in new if m&target==target]
    print('G',k,'states',len(new),'targets',len(wins),flush=True)
    if wins:break
# Min-copy DP: a new min/max result overwrites either input. Preserve its old
# value for one copy, or consume it for zero. Ignore flags and cmp liveness.
# All 18 results are required by the gate-count check above.
t0=time.monotonic();layer={(initial,initial):0}
for k in range(1,19):
    new={}
    for (made,live),q in layer.items():
        for _,a,b,r in rules:
            ab=(1<<a)|(1<<b); rb=1<<r
            if live&ab!=ab or made&rb:continue
            mm=made|rb
            # No future gate uses: discard for this relaxed copy lower bound.
            useful=0
            for _,u,v,w in rules:
                if not mm>>w&1:useful|=(1<<u)|(1<<v)
            for dest in (a,b):
                for keep in (0,1):
                    qq=q+keep
                    if qq>4:continue
                    ll=((live|rb) if keep else ((live&~(1<<dest))|rb))&useful
                    key=(mm,ll)
                    if qq<new.get(key,99):new[key]=qq
    layer=new
    print('copy DP G',k,'states',len(new),'elapsed',round(time.monotonic()-t0,2),flush=True)
    if not layer or time.monotonic()-t0>90:break
print('final min Q <=4',min((v for (m,l),v in layer.items() if m==full),default=None),flush=True)
