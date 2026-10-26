from design import *
import glob
base=load('pools/net9_41.txt');base_set=set(base)
A,B,C,D,E=ev('012'),ev('01|02|12'),ev('0|1|2'),ev('34'),ev('3|4')
T=mn(C,E);U=mx(A,T);V=mn(A,E);H=mx(V,D);Z=mx(B,D);P=mx(A,D)
rows={tuple(map(int,w)):i for i,w in enumerate(W)}
def permute(cols,p):
    ind=[rows[tuple(int(w[i]) for i in p)] for w in W]
    return [tuple(c[k] for k in ind) for c in cols]
# Align net103's sorted triple and pair with net41's groups.
n103=permute(load('pools/net9_103.txt'),[3,1,4,0,2])
M=mx(C,D);core=mn(X[0],ev('1|2'))
for tag,extra in [('vm',[V,M]),('vcore',[V,core]),('mcore',[M,core]),('vj',[V,mn(B,D)]),('mr',[M,mx(B,E)]),('vinputs',[mn(V,X[3]),mn(V,X[4])])]:
    save('103_'+tag,'aligned net103 + bounded sources '+tag,n103+extra)
# Add nearby network term sets, under input relabelling and reversal.
binary=[(i,sum(int(x)<<k for k,x in enumerate(w))) for i,w in enumerate(W) if max(w)<=1]
def bits(c):return (1<<31)|sum(1<<s for i,s in binary if c[i])
def frombits(t):
    ss=[s for s in range(1,32) if t>>s&1]
    mins=[s for s in ss if not any(u!=s and u&s==u for u in ss)]
    return tuple(max(min(int(w[i]) for i in range(5) if s>>i&1) for s in mins) for w in W)
basebits={bits(c) for c in base}
perms=list(itertools.permutations(range(5)))
maps=[[sum(1<<p[i] for i in range(5) if s>>i&1) for s in range(32)] for p in perms]
cache={}
def act(t,pi,rev):
    key=(t,pi,rev)
    if key in cache:return cache[key]
    if rev:t=sum(1<<s for s in range(32) if not(t>>(31^s)&1))
    val=sum(1<<maps[pi][s] for s in range(32) if t>>s&1);cache[key]=val;return val
near=[]
for fn in sorted(glob.glob('pools/net9_*.txt')):
    num=int(fn.split('_')[-1].split('.')[0])
    if num==41:continue
    ts=[bits(c) for c in load(fn)[5:]];best=None
    for pi in range(120):
        for rev in [0,1]:
            extra=set(act(t,pi,rev) for t in ts)-basebits
            if best is None or len(extra)<best[0]:best=(len(extra),pi,rev,extra)
    if best[0]==2:near.append((num,best))
seen=set()
for num,(dist,pi,rev,extra) in near:
    key=frozenset(extra)
    if key in seen:continue
    seen.add(key)
    save('41_union%d'%num,'net41 union relabelled net%d'%num,base+[frombits(t) for t in extra],{'network':num,'permutation':perms[pi],'reversal':rev,'extra_bits':list(extra)})
    if len(seen)>=8:break
json.dump({'distance2_networks':[(n,v[:3]) for n,v in near]},open(ROOT+'/nearby.json','w'),indent=2)
# Full c=8 merge pools, using exactly net41's sort3 and sort2 core.
corecols=[c for c in simulate('fam32/net9_41_k32.s')[0] if c in {ev(s) for s in ['12','1|2','0|12','012','0|1|2','01|02|12','34','3|4']}]
assert len(corecols)==8
Ra=select(E,C,P,E,'g');Rb=select(E,C,C,B,'g');Rc=select(E,C,B,P,'g');Rm=mn(Ra,Rb)
assert [mn(A,D),mn(Rm,Rc),mx(Rm,Rc),mx(Ra,Rb),mx(C,E)]==OUT
adaptive=corecols+[P,Ra,Rb,Rc,Rm]+OUT
save('merge8','eight-comparison merge aligned to net41 core',adaptive)
for tag,omit in [('t',T),('u',U),('v',V),('h',H),('z',Z)]:
    save('41_merge8_no'+tag,'net41 minus '+tag+' plus full adaptive merge',[c for c in base if c!=omit]+adaptive)
# The alternate merge needs only four terms absent from net41.
Sb=select(E,C,P,B,'g');Sc=select(E,C,B,P,'g');Sm=mn(T,Sb)
assert [mn(A,D),mn(Sm,Sc),mx(Sm,Sc),mx(T,Sb),mx(C,E)]==OUT
save('41_merge8_exchange','all net41 + alternate c8 middle exchange',base+[P,Sb,Sc,Sm])
flush();print('total pools',len(manifest))
for e in manifest[21:]:print(e['tag'],e['size'])
