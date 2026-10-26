import itertools
W=[w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(len(set(w))))]
for x in W:
    # Four distinct gates, one comparison, one copy.
    a=min(x[0],x[1]); d=x[0]; b=max(x[2],x[3]); e=x[2]
    n=min(b,d);p=max(a,e)
    A,B,N,P,T=a,b,n,p,a
    f=(a>b)-(a<b)
    if f<=0:A=B
    if f<=0:B=T
    if f>0:N=T
    if f>0:P=B
    assert (A,B,N,P)==(max(a,b),min(a,b),max(a,n),min(p,b))
    # An adaptive comparison acts on a non-lattice select.
    A,B,C=x[2],x[3],x[4]
    if x[0]<x[1]:B=A
    if B>C:B=C
    assert B==min(x[2] if x[0]<x[1] else x[3],x[4])
print('four-gate block and adaptive select checked on all',len(W),'weak orders')
