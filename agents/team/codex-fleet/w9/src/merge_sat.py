"""SAT merge search with free register operands and branch-specific polarity.

Each supplied binary decision tree fixes partitions, not operand identities.
The query uses ten strict interleavings. Candidates need strict verification.
"""
import argparse,functools,itertools,json,time
from pathlib import Path
from pysat.solvers import Solver

OPS=['mov','cmp','cmovl','cmovle','cmovg','cmovge']
TYPES=sorted(p for p in itertools.permutations(range(5)) if p[0]<p[1] and p[2]<p[3]<p[4])
PAIRS=list(itertools.product(range(2),range(2,5)))
TRUTH=[sum((p[a]<p[b])<<i for i,p in enumerate(TYPES)) for a,b in PAIRS]
@functools.cache
def trees(mask,depth):
    if mask.bit_count()==1:return (None,)
    if mask.bit_count()>2**depth or depth==0:return ()
    return tuple((i,l,r) for i,t in enumerate(TRUTH) if mask&t and mask&~t
                 for l in trees(mask&t,depth-1) for r in trees(mask&~t,depth-1))
def neg(x):return not x if isinstance(x,bool) else -x

class Merge:
    def __init__(self,k,R,tree,solver='cadical195'):
        self.k,self.R=k,R;self.nv=0;self.nc=0;self.solver=Solver(name=solver)
        self.op=[self.row(6) for i in range(k)];self.d=[self.row(R) for i in range(k)];self.s=[self.row(R) for i in range(k)]
        self.at=[self.row(k) for j in range(4)]
        for t in range(k):
            self.cl(-self.op[t][1],*[self.at[j][t] for j in range(4)])
            for j in range(4):self.cl(-self.at[j][t],self.op[t][1])
            for j in range(4):
                for l in range(j):self.cl(-self.at[j][t],-self.at[l][t])
            for r in range(R):self.cl(-self.d[t][r],-self.s[t][r])
        for j in range(1,4):
            for t in range(k):self.cl(-self.at[j][t],*self.at[j-1][:t])
        # This is a search restriction: the first instruction compares P0/P2.
        # Other root tests are selected by the tree and receive the same orientation convention.
        self.cl(self.op[0][1]);a,b=PAIRS[tree[0]];self.cl(self.d[0][a]);self.cl(self.s[0][b])
        self.out=[self.row(k) for j in range(5)]
        for j in range(5):
            for t in range(k):self.cl(-self.out[j][t],-self.op[t][1])
        self.pol={};self.pad={};self.caseinfo=[]
        for p in TYPES:
            node=tree;path=();info=[]
            for level in range(4):
                if node is None:
                    key=(path,level)
                    if key not in self.pad:self.pad[key]=self.row(3)
                    info.append(('pad',self.pad[key]))
                else:
                    if path not in self.pol:self.pol[path]=self.new()
                    a,b=PAIRS[node[0]];yes=p[a]<p[b]
                    info.append(('test',self.pol[path] if yes else neg(self.pol[path])))
                    node=node[1] if yes else node[2];path=path+(yes,)
            self.caseinfo.append(info)
        self.cl(self.pol[()]) # first comparison is ascending group order
        for p,info in zip(TYPES,self.caseinfo):self.case(p,info)
    def new(self):self.nv+=1;return self.nv
    def cl(self,*c):
        if any(x is True for x in c):return
        c=[x for x in c if x is not False]
        self.solver.add_clause(c);self.nc+=1
    def row(self,n):
        a=[self.new() for _ in range(n)];self.cl(*a)
        for x,y in itertools.combinations(a,2):self.cl(-x,-y)
        return a
    def eqif(self,g,a,b):self.cl(neg(g),neg(a),b);self.cl(neg(g),a,neg(b))
    def mux(self,g,a,b):
        if g is True:return a
        if g is False:return b
        if a==b:return a
        v=self.new();self.eqif(g,v,a);self.eqif(neg(g),v,b);return v
    def select(self,choice,regs):
        values=[self.new() for v in range(6)]
        for r in range(self.R):
            for v in range(6):self.eqif(choice[r],values[v],regs[r][v])
        return values
    def case(self,p,info):
        vals=[[v==(p[r] if r<5 else 5) for v in range(6)] for r in range(self.R)]
        lt=eq=False
        for t in range(self.k):
            a=self.select(self.d[t],vals);b=self.select(self.s[t],vals)
            take=self.new();self.cl(-self.op[t][0],take);self.cl(-self.op[t][1],-take)
            for o,condition in ((2,lt),(3,self.mux(lt,True,eq)),(4,self.mux(lt,False,neg(eq))),(5,neg(lt))):self.eqif(self.op[t][o],take,condition)
            nv=[self.mux(take,b[v],a[v]) for v in range(6)]
            for j in range(5):self.cl(-self.out[j][t],nv[j])
            vals=[[self.mux(self.d[t][r],nv[v],vals[r][v]) for v in range(6)] for r in range(self.R)]
            nlt,neq=self.new(),self.new()
            self.eqif(-self.op[t][1],nlt,lt);self.eqif(-self.op[t][1],neq,eq)
            for u in range(6):
                for v in range(6):
                    self.cl(-self.op[t][1],-a[u],-b[v],nlt if u<v else -nlt)
                    self.cl(-self.op[t][1],-a[u],-b[v],neq if u==v else -neq)
            # Comparison on the unknown sentinel is outside this search.
            self.cl(-self.op[t][1],-a[5]);self.cl(-self.op[t][1],-b[5])
            for j,(kind,data) in enumerate(info):
                at=self.at[j][t]
                if kind=='test':self.eqif(at,nlt,data);self.cl(-at,-neq)
                else:self.eqif(at,nlt,data[0]);self.eqif(at,neq,data[1])
            lt,eq=nlt,neq
    def decode(self):
        m=set(self.solver.get_model());one=lambda row:next(i for i,x in enumerate(row) if x in m)
        return [(one(o),one(d),one(s)) for o,d,s in zip(self.op,self.d,self.s)],[one(o) for o in self.out]

def simulate(prog,p,R):
    r=list(p)+[7]*(R-5);lt=eq=False;columns=[]
    for o,d,s in prog:
        if o==1:lt,eq=r[d]<r[s],r[d]==r[s]
        elif o==0 or (lt if o==2 else lt or eq if o==3 else not(lt or eq) if o==4 else not lt):r[d]=r[s]
        columns.append(r[d])
    return columns
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--first',type=int,default=0);ap.add_argument('--last',type=int,default=104);ap.add_argument('--k',type=int,default=16);ap.add_argument('--regs',type=int,default=7);ap.add_argument('--seconds',type=float,default=10);ap.add_argument('--tag',default='trees');ap.add_argument('--solver',default='cadical195');a=ap.parse_args()
    ts=trees(1023,4);assert len(ts)==104;results=[]
    for ti in range(a.first,min(a.last,len(ts))):
        start=time.process_time();e=Merge(a.k,a.regs,ts[ti],a.solver);status=None
        while time.process_time()-start<a.seconds and status is None:
            e.solver.conf_budget(2000);status=e.solver.solve_limited()
        result={'tree':ti,'status':'SAT' if status is True else 'UNSAT' if status is False else 'UNKNOWN','cpu':time.process_time()-start,'vars':e.nv,'clauses':e.nc,'stats':e.solver.accum_stats()}
        if status:
            p,o=e.decode();result['program']=p;result['outputs']=o
            assert all(simulate(p,w,a.regs)[o[j]]==j for w in TYPES for j in range(5))
            rn=lambda r:'P'+str(r) if r<5 else 'S'+str(r-5)
            lines=['# sorted pair/triple merge fragment; needs a prefix and strict judge']
            for t,(op,d,s) in enumerate(p):
                lines.append(f'{OPS[op]} {rn(d)}, {rn(s)}')
                lines.extend(f'out {j}, {rn(d)}' for j in range(5) if o[j]==t)
            Path(f'candidates/{a.tag}_{ti}.s').write_text('\n'.join(lines)+'\n')
        results.append(result);print(json.dumps(result),flush=True);e.solver.delete()
        Path(f'artifacts/{a.tag}.json').write_text(json.dumps({'args':vars(a),'results':results},indent=2)+'\n')
if __name__=='__main__':main()
