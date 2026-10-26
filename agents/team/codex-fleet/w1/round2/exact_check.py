# Independent scalar implementation of the flag-history bound and omission search.
# It operates on strict-order input identities; values are decoded only for comparisons.
import itertools,functools,pathlib,re
perms=list(itertools.permutations(range(5)))
inputs=[sum(1<<s for s in range(32) if s>>i&1) for i in range(5)]
networks=[]
for line in open('networks.txt'):
 ts=inputs[:];sq=[]
 for pair in line.split():
  a,b=(int(x,16) for x in pair.split(':'));sq.append((ts.index(a),ts.index(b)));ts.extend((a&b,a|b))
 networks.append(sq)
# Check every *functional* result independently, including old-value snapshots.
expected=[]
for line in open('round2/omit8.log'):
 m=re.match(r'FUNCTIONAL network=(\d+) c=8 modes=(.*),',line)
 if m:expected.append((int(m[1]),tuple(map(int,m[2].split(',')))))
weak=[w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(max(w)+1))]
assert len(expected)==198 and len(weak)==541
for ni,modes in expected:
 for w in weak:
  r=list(range(5));f=None;seen=[set() for _ in range(5)]
  for (ai,bi),mode in zip(networks[ni],modes):
   a,b=r[ai],r[bi]
   if mode==16:f=w[a]>w[b];x,y=(b,a) if f else (a,b)
   else:
    options=(a,b,a if f else b,b if f else a);x,y=options[mode//4],options[mode%4]
   r.extend((x,y))
  vals=[w[i] for i in r];assert all(x in vals for x in sorted(w))
  # The test above alone is weak: check columns over the full weak-order set below.
 cols=[[] for _ in range(23)]
 for w in weak:
  r=list(w);flag=None
  for j,((a,b),mode) in enumerate(zip(networks[ni],modes)):
   A,B=r[a],r[b]
   if mode==16:flag=A>B;X,Y=(B,A) if flag else (A,B)
   else:
    opts=(A,B,A if flag else B,B if flag else A);X,Y=opts[mode//4],opts[mode%4]
   r.extend((X,Y))
  for t,x in enumerate(r):cols[t].append(x)
 for j in range(5):assert [sorted(w)[j] for w in weak] in cols
print('All 198 functional plans independently checked on all 541 weak orders.')
