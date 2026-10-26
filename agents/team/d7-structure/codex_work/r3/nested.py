from design import *
base=load('pools/net9_41.txt')
A,B,C,D,E=ev('012'),ev('01|02|12'),ev('0|1|2'),ev('34'),ev('3|4')
for first,second in [('l','l'),('le','le'),('l','le'),('le','l')]:
    # Four-comparison merge decision tree:
    # compare B,D; compare (B<D ? C:B),E;
    # compare (B<D ? C:A),D; compare (V<E ? C:A),E.
    V=select(B,D,C,B,first)
    L=select(B,D,C,A,first)
    N=select(V,E,C,A,second)
    save('41_nested_'+first+'_'+second,'base + three nested merge pivots '+first+'/'+second,base+[V,L,N],{'first_flag':'B,D','V':'first ? C:B','L':'first ? C:A','N':'(V '+second+' E) ? C:A'})
flush();print('pools',len(manifest))
