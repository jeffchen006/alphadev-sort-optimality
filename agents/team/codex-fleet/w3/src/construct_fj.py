"""Construct a seven-comparison Ford-Johnson circuit with two binary insertions."""
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
from ssa_sat import P,simulate
from dag_reference import Search
nodes=[[tuple(ty[i] for ty in P),0,'in',None,None,None] for i in range(5)];cmpuse={};flags=[]
def cmp(a,b):
 cmpuse[len(flags)+1]=(a,b);flags.append(tuple((x>y)-(x<y) for x,y in zip(nodes[a][0],nodes[b][0])))
def mux(d,s,cond='cmovl'):
 stage=len(flags);mask=[f<0 if cond=='cmovl' else f>0 if cond=='cmovg' else f<=0 if cond=='cmovle' else f>=0 for f in flags[-1]]
 col=tuple(y if t else x for t,x,y in zip(mask,nodes[d][0],nodes[s][0]));nodes.append([col,stage,'gate',d,s,cond]);return len(nodes)-1
def pair(a,b):
 cmp(a,b);return mux(a,b,'cmovg'),mux(b,a,'cmovg')
def insert(x,a,b,c):
 cmp(x,b)
 pivot=mux(c,a)
 s0=mux(a,x);s1=mux(b,a);s2=mux(x,b)
 d1=mux(b,x);d2=mux(c,b);d3=mux(x,c)
 cmp(x,pivot)
 return mux(a,s0),mux(d1,s1),mux(d2,s2),mux(d3,c)
a,b=pair(0,1);c,d=pair(2,3)
cmp(b,d)
a,b,c,d=mux(a,c,'cmovg'),mux(b,d,'cmovg'),mux(c,a,'cmovg'),mux(d,b,'cmovg')
w0,w1,w2,w3=insert(4,a,b,d)
o0,o1,o2,o3=insert(c,w0,w1,w2)
outs=[o0,o1,o2,o3,w3]
assert all(nodes[x][0]==tuple([j]*120) for j,x in enumerate(outs))
dummy=Search.__new__(Search);dummy.nodes=nodes;dummy.cmpuse=cmpuse;dummy.c=7;dummy.tg=[tuple([j]*120) for j in range(5)]
ip=[];order=[]
for b in range(1,8):
 res=dummy.max_inplace([g for g in range(5,len(nodes)) if nodes[g][1]==b],0)
 assert res is not None;ip+=res[0];order+=res[1]
prog=dummy.emit(ip,order);k=sum(not l.startswith('out') for l in prog)
fn=f'programs/construct_fj_k{k}.s';Path(fn).write_text('# n=5 R=100 iset=I1 model=out source=w3_construct_fj\n'+'\n'.join(prog)+'\n')
print('k',k,'cmov',len(nodes)-5,'mov',len(nodes)-5-len(ip),'file',fn)
with open('sk/construct_fj.txt','w') as f:
 for j,(a,b) in cmpuse.items():f.write('='+''.join(map(str,nodes[a][0]))+':='+''.join(map(str,nodes[b][0]))+'\n')
