from round2 import *
manifest.extend(json.load(open('codex_work/round2_manifest.json')))
mer,_,_=simulate('ex_pos33.txt')
s,t,u,v,w=mer[5],mer[6],mer[9],mer[11],mer[12]
E=hi(s,u);r=lo(t,w);B=sel(v,E,t,w,'g');C=sel(E,v,t,w,'g');D=lo(r,B)
assert [mer[13],lo(D,C),hi(D,C),hi(r,B),hi(t,w)]==OUT
core=mer[5:13]
tail=[mer[13],E,hi(t,w),r,B,C,D,hi(r,B),lo(D,C),hi(D,C)]
normal=core+tail
altz=lo(mer[8],X[4]);altcore=[altz if c==mer[10] else c for c in core]
caps=[lo(B,w),hi(r,u),hi(D,u)]
save('merge_m1','merge: smaller group maximum + exchanged middle pair',normal)
save('merge_m1_altcore','same merge, dual sort3 intermediate',altcore+tail)
save('merge_m1_bothcore','same merge, both sort3 intermediates',normal+[altz])
save('merge_m1_routes','same merge + original three route columns',normal+[mer[15],mer[17],mer[19]])
save('merge_m1_caps','same merge + three bounded copy sources',normal+caps)
save('merge_m1_altcaps','dual sort3 + bounded copy sources',altcore+tail+caps)
save('merge_m1_capsroute','same merge + bounded sources and original first route',normal+caps+[mer[15]])
def proj(c):
    bv={sum(int(x)<<i for i,x in enumerate(w)):v for w,v in zip(W,c) if max(w)<=1};bv[31]=1
    return tuple(sum(bool(bv[sum(int(x>=t)<<i for i,x in enumerate(w))]) for t in range(1,5)) for w in W)
save('merge_m1_projected','same merge + lattice counterparts',normal+[proj(c) for c in [B,C,D]])
keep=[];seen=set()
for e in manifest:
    key=frozenset(open(e['file']).read().splitlines())
    if key in seen:print('duplicate not run',e['tag']);continue
    keep.append(e);seen.add(key)
manifest[:]=keep;flush()
print('total distinct',len(manifest))
for e in manifest[-8:]:print(e['tag'],e['size'])
