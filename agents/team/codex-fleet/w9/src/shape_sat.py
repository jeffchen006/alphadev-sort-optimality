"""Fixed comparison placements, free operands, fixed merge-tree partitions."""
import argparse,itertools,json,time
from pathlib import Path
from merge_sat import Merge,trees,TYPES,OPS,neg,simulate

class Shape(Merge):
    def __init__(self,k,R,tree,positions,solver='cadical195'):
        self.positions=positions
        super().__init__(k,R,tree,solver)
    def case(self,p,info):
        vals=[[v==(p[r] if r<5 else 5) for v in range(6)] for r in range(self.R)]
        lt=eq=False
        for t in range(self.k):
            a=self.select(self.d[t],vals);b=self.select(self.s[t],vals)
            if t in self.positions:
                j=self.positions.index(t);self.cl(self.at[j][t]);self.cl(self.op[t][1])
                kind,data=info[j];lt,eq=(data,False) if kind=='test' else (data[0],data[1])
                for u in range(6):
                    for v in range(6):
                        self.cl(-a[u],-b[v],lt if u<v else neg(lt))
                        self.cl(-a[u],-b[v],eq if u==v else neg(eq))
                self.cl(-a[5]);self.cl(-b[5])
            else:
                self.cl(-self.op[t][1]);take=self.new();self.cl(-self.op[t][0],take)
                for o,cond in ((2,lt),(3,self.mux(lt,True,eq)),(4,self.mux(lt,False,neg(eq))),(5,neg(lt))):self.eqif(self.op[t][o],take,cond)
                nv=[self.mux(take,b[v],a[v]) for v in range(6)]
                for j in range(5):self.cl(-self.out[j][t],nv[j])
                vals=[[self.mux(self.d[t][r],nv[v],vals[r][v]) for v in range(6)] for r in range(self.R)]

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--tree',type=int,default=39);ap.add_argument('--regs',type=int,default=6);ap.add_argument('--seconds',type=float,default=2);ap.add_argument('--count',type=int,default=80);ap.add_argument('--tag',default='shapes39');a=ap.parse_args()
    placements=[(0,)+q for q in itertools.combinations(range(1,16),3)]
    def priority(p):
        w=(p[1]-1,p[2]-p[1]-1,p[3]-p[2]-1,15-p[3])
        return min(sum(abs(x-y) for x,y in zip(w,ref)) for ref in [(3,4,3,2),(4,3,3,2),(4,4,2,2),(4,4,3,1)]),p
    placements.sort(key=priority);rows=[]
    for positions in placements[:a.count]:
        start=time.process_time();e=Shape(16,a.regs,trees(1023,4)[a.tree],positions);result=None
        while result is None and time.process_time()-start<a.seconds:
            e.solver.conf_budget(1000);result=e.solver.solve_limited()
        row={'positions':positions,'status':'SAT' if result is True else 'UNSAT' if result is False else 'UNKNOWN','cpu':time.process_time()-start,'vars':e.nv,'clauses':e.nc,'stats':e.solver.accum_stats()}
        if result:
            p,o=e.decode();assert all(simulate(p,w,a.regs)[o[j]]==j for w in TYPES for j in range(5))
            row['program']=p;row['outputs']=o;rn=lambda r:'P'+str(r) if r<5 else 'S'+str(r-5)
            lines=['# sorted pair/triple merge fragment']
            for t,(op,d,s) in enumerate(p):
                lines.append(f'{OPS[op]} {rn(d)}, {rn(s)}');lines.extend(f'out {j}, {rn(d)}' for j in range(5) if o[j]==t)
            Path(f'candidates/{a.tag}_{len(rows)}.s').write_text('\n'.join(lines)+'\n')
        rows.append(row);print(json.dumps(row),flush=True);e.solver.delete()
        Path(f'artifacts/{a.tag}.json').write_text(json.dumps({'args':vars(a),'results':rows},indent=2)+'\n')
        if result:break
if __name__=='__main__':main()
