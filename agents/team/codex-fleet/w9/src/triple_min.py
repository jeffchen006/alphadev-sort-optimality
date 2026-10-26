"""Search an eleven-instruction sort3 that retains two physical minima."""
import argparse,itertools,json,time
from pathlib import Path
from pysat.card import CardEnc,EncType
from pysat.solvers import Solver
from triple_encode import TripleRankEnc

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--seconds',type=float,default=120);ap.add_argument('--registers',type=int,default=5);ap.add_argument('--k',type=int,default=11);ap.add_argument('--tag',default='triple_min11');ap.add_argument('--pairfirst',action='store_true');ap.add_argument('--solver',default='cadical195');ap.add_argument('--shapes',action='store_true');a=ap.parse_args()
    start=time.monotonic();e=TripleRankEnc(3,a.k,R=a.registers,iset='I1',outmode='snap',rules=())
    ops=['mov','cmp','cmovl','cmovle','cmovg','cmovge'];domains=[ops]*a.k;dst=[None]*a.k;src=[None]*a.k
    e.cl(e.op[0]['cmp']);e.cl(e.d[0][0]);e.cl(e.s[0][1]);domains[0]=['cmp'];dst[0]=0;src[0]=1
    if a.pairfirst:
        for i,(op,d,s) in enumerate([('cmp',0,1),('mov',3,0),('cmovg',0,1),('cmovg',1,3)]):
            e.cl(e.op[i][op]);e.cl(e.d[i][d]);e.cl(e.s[i][s]);domains[i]=[op];dst[i]=d;src[i]=s
    c=CardEnc.equals([e.op[i]['cmp'] for i in range(a.k)],bound=3,top_id=e.nvars,encoding=EncType.seqcounter);e.nvars=c.nv;e.clauses.extend(c.clauses)
    roles=[[e.new() for r in range(a.registers)] for j in range(4)]
    for row in roles:e.exactly_one(row)
    for i in range(4):
        for j in range(i):
            for r in range(a.registers):e.cl(-roles[i][r],-roles[j][r])
    for r in range(a.registers):
        for s in range(r+1):e.cl(-roles[0][r],-roles[1][s])
    e.configure([],domains,dst,src);e.role_targets=list(zip((0,0,1,2),roles));e.safe_compare=True
    for case in itertools.product(range(3),repeat=3):
        if set(case)==set(range(max(case)+1)):e.add_type(case)
    solver=Solver(name=a.solver,bootstrap_with=e.clauses);result=None;attempts=0
    shape_rows=[]
    if a.shapes:
        choices=list(itertools.combinations(range(4 if a.pairfirst else 1,a.k),2));completed=set()
        for budget in (1000,5000,20000,100000,500000):
            for positions in choices:
                if positions in completed:continue
                if time.monotonic()-start>=a.seconds:break
                solver.conf_budget(budget);status=solver.solve_limited(assumptions=[e.op[i]['cmp'] for i in positions]);attempts+=1
                shape_rows.append({'positions':positions,'budget':budget,'status':'SAT' if status is True else 'UNSAT' if status is False else 'UNKNOWN'})
                if status is False:completed.add(positions)
                elif status is True:result=True;break
            if result or len(completed)==len(choices) or time.monotonic()-start>=a.seconds:break
        if len(completed)==len(choices):result=False
    else:
        while result is None and time.monotonic()-start<a.seconds:
            solver.conf_budget(3000);result=solver.solve_limited();attempts+=1
    row={'status':'SAT' if result is True else 'UNSAT' if result is False else 'UNKNOWN','seconds':time.monotonic()-start,'variables':e.nvars,'clauses':len(e.clauses),'attempts':attempts,'stats':solver.accum_stats(),'args':vars(a)}
    if a.shapes:row['shape_results']=shape_rows
    if result:
        model=solver.get_model();m=set(model);p,_=e.decode(model);r=[next(i for i,v in enumerate(rr) if v in m) for rr in roles];row['program']=p;row['roles']=r
        Path('candidates/'+a.tag+'.json').write_text(json.dumps({'program':p,'roles':r},indent=2)+'\n')
    Path('artifacts/'+a.tag+'.json').write_text(json.dumps(row,indent=2)+'\n');print(json.dumps(row),flush=True)
if __name__=='__main__':main()
