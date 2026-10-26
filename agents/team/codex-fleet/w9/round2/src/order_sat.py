"""SAT search with a fixed order of comparison flag columns.

All register operands, data opcodes, comparison positions, and output snapshots
are free. Scratch starts at a sentinel above the inputs. Comparisons must read
input-derived values. Every candidate requires the strict judge.
"""
import argparse
import itertools
import json
from pathlib import Path
import random
import sys
import time
import subprocess

from orders import HERE,ROOT,CASES as STRICT,canonical,compare_columns,read
sys.path.insert(0,str(HERE.parent/'src'))
from encode import Enc
from triple_encode import TripleRankEnc
from pysat.solvers import Solver

CASES=[p for p in itertools.product(range(5),repeat=5)
       if set(p)==set(range(max(p)+1))]

class OrderEnc(TripleRankEnc):
    def __init__(self,k,R,flags,positions=None,prefix=(),polarity=False):
        super().__init__(5,k,R=R,iset='I1',outmode='snap',rules=('canon',))
        self.target_flags=flags
        self.fixed_prefix=list(prefix)
        self.free_polarity=polarity
        self.history=[[tuple(flags[h][t] for h in range(j)) for t in range(541)] for j in range(8)]
        self.flip={}
        prefix_cmps=sum(op=='cmp' for op,_,_ in prefix)
        for j in range(8):
            for key in set(self.history[j]):
                self.flip[j,key]=self.new() if polarity and j>=max(1,prefix_cmps) else False
        self.at=[[self.new() for _ in range(k)] for j in range(8)]
        for row in self.at:self.exactly_one(row)
        for t in range(k):
            self.cl(-self.op[t]['cmp'],*[self.at[j][t] for j in range(8)])
            for j in range(8):self.cl(-self.at[j][t],self.op[t]['cmp'])
            for j in range(1,8):
                self.cl(-self.at[j][t],*self.at[j-1][:t])
        self.cl(self.at[0][0])
        for j in range(5):
            for r in range(5):self.cl(-self.osnap[j][r])
        # Every non-comparison writes one register. Self writes can pad <= k.
        if positions is not None:
            for j,t in enumerate(positions):self.cl(self.at[j][t])
        j=0
        for t,(op,d,s) in enumerate(prefix):
            self.cl(self.op[t][op]);self.cl(self.d[t][d]);self.cl(self.s[t][s])
            if op=='cmp':self.cl(self.at[j][t]);j+=1

    def add_type(self,ranks):
        start=len(self.clauses);ci=CASES.index(tuple(ranks))
        top=max(ranks)+1;V=top+1
        vals=[[v==(ranks[r] if r<5 else top) for v in range(V)] for r in range(self.R)]
        lt=gt=False;nvs=[]
        for t in range(self.k):
            if t<len(self.fixed_prefix):
                op,d,s=self.fixed_prefix[t];dv,sv=vals[d],vals[s]
                if op=='cmp':
                    u,v=dv.index(True),sv.index(True);lt,gt=u<v,u>v
                    nv=dv
                else:
                    take={'mov':True,'cmovl':lt,'cmovle':not gt,'cmovg':gt,'cmovge':not lt}[op]
                    nv=sv if take else dv;vals=list(vals);vals[d]=nv
                nvs.append(nv)
                continue
            def select(row):
                result=[self.new() for _ in range(V)]
                for r in range(self.R):
                    for v in range(V):
                        self.cl(self.neg(row[r]),self.neg(vals[r][v]),result[v])
                        self.cl(self.neg(row[r]),vals[r][v],-result[v])
                return result
            dv,sv=select(self.d[t]),select(self.s[t])
            wr=self.new()
            for op,flag in [('mov',True),('cmp',False),('cmovl',lt),('cmovle',self.neg(gt)),('cmovg',gt),('cmovge',self.neg(lt))]:
                self.cl(-self.op[t][op],self.neg(flag),wr)
                self.cl(-self.op[t][op],flag,-wr)
            nv=[self.mux(wr,sv[v],dv[v]) for v in range(V)];nvs.append(nv)
            vals=[[self.mux(self.d[t][r],nv[v],vals[r][v]) for v in range(V)] for r in range(self.R)]
            c=self.op[t]['cmp']
            self.cl(-c,-dv[top]);self.cl(-c,-sv[top])
            nlt,ngt=self.new(),self.new()
            self.cl(c,self.neg(lt),nlt);self.cl(c,lt,-nlt)
            self.cl(c,self.neg(gt),ngt);self.cl(c,gt,-ngt)
            for j in range(8):
                f=self.target_flags[j][ci];at=self.at[j][t]
                flip=self.flip[j,self.history[j][ci]]
                want_lt=False if f==1 else self.neg(flip) if f==0 else flip
                want_gt=False if f==1 else self.neg(want_lt)
                self.cl(-at,self.neg(want_lt),nlt);self.cl(-at,want_lt,-nlt)
                self.cl(-at,self.neg(want_gt),ngt);self.cl(-at,want_gt,-ngt)
                for u in range(V):
                    for v in range(V):
                        if (u==v)!=(f==1):self.cl(-at,-dv[u],-sv[v])
                        elif u!=v:self.cl(-at,-dv[u],-sv[v],want_lt if u<v else want_gt)
            lt,gt=nlt,ngt
        for j,goal in enumerate(sorted(ranks)):
            for t in range(self.k):self.cl(-self.osnap[j][5+t],nvs[t][goal])
        self.types.append(tuple(ranks))
        return start

def family_data(row,order):
    p,R=read(Path(row['source']));col=compare_columns(p,R)
    key,(qi,data)=canonical(col);perm=STRICT[qi]
    weak=compare_columns(p,R,[tuple(w[j] for j in perm) for w in CASES])
    flags=[]
    for _,j,flip in data:
        f=weak[j][2];flags.append(bytes(2-x for x in f) if flip else f)
    assert tuple(bytes(f[CASES.index(w)] for w in STRICT) for f in flags)==key
    return [flags[j] for j in order]

def evaluate(p,R,with_unsafe=False):
    regs=[tuple(w[r] if r<5 else 7 for w in CASES) for r in range(R)]
    f=(1,)*541;cols=[];flags=[];unsafe=set()
    for t,(op,d,s) in enumerate(p):
        if op=='cmp':
            unsafe.update(t for t,(x,y) in enumerate(zip(regs[d],regs[s])) if x==7 or y==7)
            f=bytes((x>y)-(x<y)+1 for x,y in zip(regs[d],regs[s]));flags.append(f)
        elif op=='mov':regs[d]=regs[s]
        else:
            test={'cmovl':lambda x:x==0,'cmovle':lambda x:x<=1,'cmovg':lambda x:x==2,'cmovge':lambda x:x>=1}[op]
            regs[d]=tuple(y if test(z) else x for x,y,z in zip(regs[d],regs[s],f))
        cols.append(regs[d])
    return (cols,flags,unsafe) if with_unsafe else (cols,flags)

def emit(p,out,path):
    reg=lambda r:f'P{r}' if r<5 else f'S{r-5}'
    lines=['# n=5 model=out iset=I1 source=w9-round2-order-sat']
    for t,(op,d,s) in enumerate(p):
        lines.append(f'{op} {reg(d)}, {reg(s)}')
        lines.extend(f'out {j}, {reg(r)}' for j,(when,r) in enumerate(out) if when==t+1)
    path.write_text('\n'.join(lines)+'\n')

def solve(row,order,a,prefix=(),source=None,positions=None,phase=None):
    start=time.process_time();flags=family_data(row,order)
    e=OrderEnc(a.k,a.regs,flags,positions=positions,prefix=prefix,polarity=getattr(a,'polarity',False))
    # First comparison operands are fixed if its full flag column identifies a
    # unique pair of original inputs. This removes redundant register choices.
    candidates=[(i,j) for i in range(5) for j in range(5)
                if all((w[i]>w[j])-(w[i]<w[j])+1==flags[0][t] for t,w in enumerate(CASES))]
    if len(candidates)==1:
        i,j=candidates[0];e.cl(e.d[0][i]);e.cl(e.s[0][j])
    chosen={CASES.index(w) for w in random.Random(917).sample(STRICT,a.types)}
    # One tie is enough to preserve the distinction between strict and weak
    # conditional moves in the first SAT instance.
    chosen.add(CASES.index((0,0,0,0,0)))
    for t in sorted(chosen):e.add_type(CASES[t])
    result=None;iterations=0;pushed=0;last=None;model_records=[]
    with Solver(name=a.solver) as sat:
        while time.process_time()-start<a.seconds:
            for cl in e.clauses[pushed:]:sat.add_clause(cl)
            pushed=len(e.clauses)
            if phase is not None:
                sat.set_phases([literal for t,(op,d,s) in enumerate(phase)
                                for literal in (e.op[t][op],e.d[t][d],e.s[t][s])
                                if literal is not False])
                phase=None
            sat.conf_budget(250)
            result=sat.solve_limited()
            if result is False:break
            if result is None:continue
            iterations+=1;p,out=e.decode(sat.get_model());cols,actual,unsafe=evaluate(p,a.regs,True)
            bad=[];orientation={};orientation_bad=set()
            if getattr(a,'polarity',False):
                for j in range(8):
                    for t in range(541):
                        f,g=flags[j][t],actual[j][t]
                        if (f==1)!=(g==1):orientation_bad.add(t);continue
                        if f==1:continue
                        key=(j,e.history[j][t]);sign=f!=g
                        if e.flip[key] is False and sign:orientation_bad.add(t)
                        if key in orientation and orientation[key][0]!=sign:
                            orientation_bad.update((t,orientation[key][1]))
                        else:orientation[key]=(sign,t)
            for t,w in enumerate(CASES):
                mismatch=t in orientation_bad if getattr(a,'polarity',False) else any(actual[j][t]!=flags[j][t] for j in range(8))
                wrong=any(cols[when-1][t]!=sorted(w)[j] for j,(when,r) in enumerate(out))
                if mismatch or wrong or t in unsafe:bad.append(t)
            # The subset solver may select an output snapshot that works only
            # on its encoded cases. Preserve any globally correct alternative.
            global_out=[]
            for j in range(5):
                goal=tuple(sorted(w)[j] for w in CASES)
                global_out.append(next(((t+1,p[t][1]) for t,col in enumerate(cols) if p[t][0]!='cmp' and col==goal),None))
            if all(w is not None for w in global_out):out=global_out
            output_failures=sum(any(cols[when-1][t]!=sorted(w)[j] for j,(when,r) in enumerate(out)) for t,w in enumerate(CASES))
            model_record={'iteration':iterations,'output_failed_orders':output_failures,'target_failed_orders':len(bad),'unsafe_orders':len(unsafe)}
            if getattr(a,'save_models',False) or output_failures==0:
                path=HERE/'candidates'/f"model_{a.tag}_{row['id']}_{''.join(map(str,order))}_{iterations}_k{a.k}.s"
                emit(p,out,path)
                log=HERE/'logs'/f'{path.stem}_strict.log'
                with log.open('w') as stream:
                    checked=subprocess.run(['nice','-n','19','python3','-B',str(ROOT/'shared/judge.py'),str(path),'--strict','--model','out'],stdout=stream,stderr=subprocess.STDOUT)
                passed=checked.returncode==0 and 'PASS' in log.read_text()
                model_record.update(path=str(path),judge_log=str(log),strict_pass=passed)
                if passed:
                    last={'path':str(path),'program':p,'outputs':out,'strict_pass':True}
                    model_records.append(model_record);break
            model_records.append(model_record)
            if not bad:
                path=HERE/'candidates'/f"sat_{row['id']}_{''.join(map(str,order))}_k{a.k}.s"
                emit(p,out,path);last={'path':str(path),'program':p,'outputs':out};break
            new=[t for t in bad if t not in chosen][:a.add]
            assert new, 'SAT model and concrete evaluator disagree on encoded cases'
            for t in new:e.add_type(CASES[t])
            chosen.update(new);result=None
        stats=sat.accum_stats()
    return {'family':row['id'],'order':order,'k':a.k,'regs':a.regs,
            'status':'SAT_CANDIDATE' if last else 'UNSAT' if result is False else 'UNKNOWN',
            'cpu':time.process_time()-start,'cases':len(chosen),'iterations':iterations,
            'variables':e.nvars,'clauses':len(e.clauses),'stats':stats,
            'prefix_length':len(prefix),'source':source or row['source'],
            'polarity':getattr(a,'polarity',False),'positions':positions,'models':model_records,**(last or {})}

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--seconds',type=float,default=3)
    ap.add_argument('--regs',type=int,default=8);ap.add_argument('--k',type=int,default=31)
    ap.add_argument('--types',type=int,default=8);ap.add_argument('--add',type=int,default=4)
    ap.add_argument('--solver',default='cadical195');ap.add_argument('--first',type=int,default=0)
    ap.add_argument('--count',type=int,default=653);ap.add_argument('--tag',default='order_sat')
    ap.add_argument('--polarity',action='store_true')
    ap.add_argument('--save-models',action='store_true')
    a=ap.parse_args();families=json.loads((HERE/'artifacts/orders.json').read_text())['families']
    tasks=[(r,o) for r in families for o in r['new_flag_orders']]
    # Test orders far from known programs first. These change the suffix as
    # well as the independent sort preparation.
    def novelty(task):
        r,o=task
        return -min(sum(x!=y for x,y in zip(o,p)) for p in r['original_orders']),r['id'],o
    tasks.sort(key=novelty)
    dest=HERE/'artifacts'/f'{a.tag}.jsonl'
    with dest.open('a') as stream:
        for ti,(row,order) in enumerate(tasks[a.first:a.first+a.count],a.first):
            result=solve(row,order,a);result['index']=ti
            text=json.dumps(result);print(text,flush=True);stream.write(text+'\n');stream.flush()
            if result['status']=='SAT_CANDIDATE':break

if __name__=='__main__':main()
