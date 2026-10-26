"""Implied structural cuts for exact fixed-column SAT routing.

A node cannot hold two different complete columns. A produced column must
select the same input identity on each class with the same flag history.
The latter fact gives an earliest possible comparison block for each target.
These cuts follow from full initialized selection semantics.
"""
import fixed_sat

class CutEncoding(fixed_sat.FixedEncoding):
    def __init__(self,k,types,cols,history=True):
        super().__init__(k,types,cols,history)
        n=5;c=len(cols)//2;m=k-c;nt=len(types)
        flags=[[(a>b)-(a<b) for a,b in zip(cols[2*j],cols[2*j+1])] for j in range(c)]
        refs=[]
        for j in range(c):
            for side in range(2):refs.append((self.cmp[j][side],tuple(types[t].index(cols[2*j+side][t]) for t in range(nt)),j))
        for rank in range(n):refs.append((self.out[rank],tuple(ty.index(rank) for ty in types),c))
        targets={col for _,col,_ in refs};earliest={}
        for col in targets:
            for b in range(c+1):
                groups={};ok=True
                for t in range(nt):
                    key=tuple(flags[j][t] for j in range(b))
                    if key in groups and groups[key]!=col[t]:ok=False;break
                    groups[key]=col[t]
                if ok:earliest[col]=b;break
            assert col in earliest
        for picks,col,deadline in refs:
            low=earliest[col]
            for x,pick in enumerate(picks):
                if x<n:
                    if col!=(x,)*nt:self.cl(-pick)
                else:
                    g=x-n
                    for b in range(c):
                        if b+1<low or b+1>deadline:self.cl(-pick,-self.blk[g][b])
        for i,(p,col,_) in enumerate(refs):
            for q,col2,_ in refs[i+1:]:
                if col==col2:continue
                for x in range(n+m):self.cl(-p[x],-q[x])

if __name__=='__main__':
    fixed_sat.FixedEncoding=CutEncoding
    fixed_sat.main()
