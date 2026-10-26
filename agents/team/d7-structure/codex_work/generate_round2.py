from round2 import *
base,_,be=simulate('ex_prog1.txt');mer,_,me=simulate('ex_pos33.txt')
save('merge23','sort2 + sort3 + adaptive merge',mer)
# Reverse and partial routes at the max-of-groups comparison in pos33.
p,q=mer[6],mer[12]
route_pairs=[(mer[6],mer[14]),(mer[14],mer[11]),(mer[11],mer[12])]
reverse=[sel(a,b,p,q,'le') for a,b in route_pairs]
for i,v in enumerate(reverse):save('merge_rev%d'%i,'adaptive merge: opposite route %d'%i,mer+[v])
save('merge_rev_all','adaptive merge: three opposite routes',mer+reverse)
# Lattice functions with the same Boolean table as non-lattice merge columns.
def lattice_projection(c):
    bv={sum(int(x)<<i for i,x in enumerate(w)):v for w,v in zip(W,c) if max(w)<=1};bv[31]=1
    out=[]
    for w in W:
        out.append(sum(bool(bv[sum(int(x>=t)<<i for i,x in enumerate(w))]) for t in range(1,5)))
    return tuple(out)
projected=list(dict.fromkeys(lattice_projection(c) for c in mer if not lattice(c)))
projected=[c for c in projected if c not in mer]
save('merge_projected','adaptive merge + lattice counterparts',mer+projected)
for i,(a,b) in enumerate([(15,16),(16,17),(15,19),(17,19)]):
    save('merge_cross%d'%i,'adaptive merge: min/max cross route %d:%d'%(a,b),mer+[lo(mer[a],mer[b]),hi(mer[a],mer[b])])
# Attach the companion from an ordered pair to its low or high winner.
for tag,fp,fq,a,b in [('low',6,7,5,8),('high',5,8,6,7)]:
    r=[sel(base[a],base[b],base[fp],base[fq]),sel(base[b],base[a],base[fp],base[fq])]
    save('base_'+tag+'_both','base + two paired satellites ('+tag+')',base+r)
    save('base_'+tag+'_one','base + one paired satellite ('+tag+')',base+r[:1])
# Adaptive pivots at central and boundary comparisons of the base circuit.
designs=[('split',0,10,9,16),('right',0,16,13,12),('middle',12,15,13,18),('last',15,13,12,18)]
for tag,fp,fq,a,b in designs:
    r=[sel(base[a],base[b],base[fp],base[fq]),sel(base[b],base[a],base[fp],base[fq])]
    save('base_'+tag,'base + adaptive pivot pair ('+tag+')',base+r)
# Ford-Johnson: order two pairs by their maxima; route their associated lows.
l0,h0=lo(X[0],X[1]),hi(X[0],X[1]);l1,h1=lo(X[2],X[3]),hi(X[2],X[3])
a=sel(l1,l0,h0,h1,'le');p=sel(l0,l1,h0,h1,'le')
b,c=lo(h0,h1),hi(h0,h1)
core=[l0,h0,l1,h1,a,p,b,c]
def median_chain(x,u,v,side):
    z=hi(x,u) if side==0 else lo(x,v)
    return (lo(z,v) if side==0 else hi(z,u)),z
def insert3(x,chain,mode):
    u,v,w=chain
    o1,z1=median_chain(x,u,v,mode&1);o2,z2=median_chain(x,v,w,(mode>>1)&1)
    out=[lo(x,u),o1,o2,hi(x,w)]
    pivot=sel(w,u,x,v,'l')
    return out,[z1,z2]+out+[pivot]
# Seven-comparison design: insert x4, then the pending low (which is below c).
for m1,m2 in [(0,0),(1,1),(2,2),(3,3),(0,3),(3,0),(1,2),(2,1)]:
    chain1,t1=insert3(X[4],[a,b,c],m1)
    chain2,t2=insert3(p,chain1[:3],m2)
    # p <= c <= chain1[3], so the last value of chain1 stays the maximum.
    assert chain2+[chain1[3]]==OUT
    save('fj7_%d%d'%(m1,m2),'FJ: x4 first, clamp variants %d/%d'%(m1,m2),core+t1+t2)
# Eight-comparison design: insert pending low first, then x4 into sorted four.
d0=lo(p,a);z=hi(p,a);d1=lo(z,b);d2=hi(p,b);chain=[d0,d1,d2,c]
assert all(all(v[i]<=v[i+1] for i in range(3)) for v in zip(*chain))
for mode,side in [(0,0),(7,0),(2,1),(5,1)]:
    mids=[median_chain(X[4],chain[i],chain[i+1],(mode>>i)&1) for i in range(3)]
    pivot=sel(chain[3] if side==0 else chain[2],chain[1] if side==0 else chain[0],X[4],chain[2] if side==0 else chain[1])
    cols=core+[d0,z,d1,d2]+[lo(X[4],chain[0]),hi(X[4],chain[3])]+[v for pair in mids for v in pair]+[pivot]
    save('fj8_%d%d'%(mode,side),'FJ: pending low first, clamp %d pivot %d'%(mode,side),cols)
flush()
print('saved',len(manifest),'pools')
for e in manifest:print(e['tag'],e['size'])
