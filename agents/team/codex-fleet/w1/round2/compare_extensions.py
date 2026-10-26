import itertools,re,json,time
start=time.monotonic();perm=list(itertools.permutations(range(5)))
weak=[w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(max(w)+1))]
inputs=[sum(1<<s for s in range(32) if s>>i&1) for i in range(5)]
nets=[]
for line in open('networks.txt'):
 ts=inputs[:];sq=[]
 for tok in line.split():
  a,b=(int(x,16) for x in tok.split(':'));sq.append((ts.index(a),ts.index(b)));ts.extend((a&b,a|b))
 nets.append(sq)
def read(path):
 out=[]
 for l in open(path):
  m=re.match(r'FUNCTIONAL network=(\d+) c=8 modes=(.*),',l)
  if m:out.append((int(m[1]),tuple(map(int,m[2].split(',')))))
 return out
def sim(ni,modes,cases):
 cols=[[] for _ in range(23)]
 for w in cases:
  r=list(w);flag=None
  for (a,b),m in zip(nets[ni],modes):
   A,B=r[a],r[b]
   if m==16:flag=A>B;X,Y=(B,A) if flag else (A,B)
   elif m<1000:
    opts=(A,B,A if flag else B,B if flag else A);X,Y=opts[m//4],opts[m%4]
   else:
    m-=1000;x,y=m//1024,m%1024;d,s=x//32,x%32;X=r[s] if flag else r[d];d,s=y//32,y%32;Y=r[s] if flag else r[d]
   r.extend((X,Y))
  for i,x in enumerate(r):cols[i].append(x)
 return tuple(map(tuple,cols))
base=read('round2/omit8.log');strict={i:sim(i,m,perm) for i,m in base};weakbase={i:sim(i,m,weak) for i,m in base}
for path in ('round2/extend1.log','round2/extend2.log'):
 rows=read(path);assert len(rows)==198;ties=0
 for i,m in rows:
  assert sim(i,m,perm)==strict[i],('new strict columns',path,i)
  wc=sim(i,m,weak)
  assert all(tuple(sorted(w)[j] for w in weak) in wc for j in range(5)),('weak failure',path,i)
  ties+=wc!=weakbase[i]
 print(path,': all 198 plans match the base strict columns; all pass 541-order scalar simulation; different weak-column plans',ties,flush=True)
print('seconds',round(time.monotonic()-start,3),flush=True)
