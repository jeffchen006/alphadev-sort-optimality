"""Free-operand compare-removal SAT with constant-folded rank transitions.

The bounded queries use scratch=7 and initial flags=equal. A SAT result needs
independent full checking and both strict judges. Time limits are unknown.
"""
import argparse, itertools, json, random, resource, sys, time
from pathlib import Path
sys.dont_write_bytecode=True
HERE=Path(__file__).resolve().parents[1]
ROOT=HERE.parents[4]
sys.path.insert(0,'/path/to/repo/agents/sat')
sys.path.insert(0,str(HERE.parent/'round3'))
from rank_encode import RankEnc
from pysat.card import CardEnc, EncType
from pysat.solvers import Solver
from repair_sat import emit
sys.path.insert(0,str(HERE.parent.parent/'w6/src'))
from window_sat import concrete, CASES, GOALS, OPS

class FoldEnc(RankEnc):
    def select_(self,selectors,values):
        for i,s in enumerate(selectors):
            if s is True:return values[i][:]
        active=[(s,values[i]) for i,s in enumerate(selectors) if s is not False]
        if all(v==active[0][1] for s,v in active):return active[0][1][:]
        out=[self.new() for _ in range(3)]
        for s,v in active:
            for b,z in enumerate(out):
                self.cl(-s,self.neg(v[b]),z)
                self.cl(-s,v[b],-z)
        return out


def solve(args):
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    began=time.monotonic()
    row=json.loads((HERE/'manifest.json').read_text())[args.index]
    original=[tuple(x) for x in row['program']]
    delete=args.delete
    p=[x for i,x in enumerate(original) if i!=delete]
    k=len(p);nr=row['registers']+1
    cs=[i for i,x in enumerate(original) if x[0]==1]
    ci=cs.index(delete)
    first=cs[max(0,ci-args.before)]
    end=cs[ci+args.after+1] if ci+args.after+1<len(cs) else len(original)
    if args.control:
        p=original;k=len(p);first=end=0
    e=FoldEnc(5,k,R=nr,iset='I1',outmode='snap',rules=())
    selectors=[(e.op[i].copy(),e.d[i][:],e.s[i][:]) for i in range(k)]
    changes=[];phase=[];destination_changes=[]
    for i,(o,d,s) in enumerate(p):
        oldi=i+(i>=delete and not args.control)
        inside=first<=oldi<end
        op,dv,sv=selectors[i]
        # Classes and the seven remaining comparison positions stay fixed.
        allowed=[OPS[o]] if o==1 else [x for x in OPS if x!='cmp']
        for x,v in op.items():
            if x not in allowed:e.cl(-v);e.op[i][x]=False
        if len(allowed)==1:
            e.cl(op[allowed[0]])
            e.op[i]={x:x==allowed[0] for x in op}
        ch=e.new()
        e.cl(ch,op[OPS[o]]);e.cl(ch,dv[d]);e.cl(ch,sv[s])
        e.cl(-ch,-op[OPS[o]],-dv[d],-sv[s])
        phase.extend((op[OPS[o]],dv[d],sv[s],-ch))
        free=inside or (args.all_cmps and o==1)
        if args.control or (not free and args.edits==0):
            e.cl(-ch)
            e.op[i]={x:x==OPS[o] for x in op}
            e.d[i]=[r==d for r in range(nr)]
            e.s[i]=[r==s for r in range(nr)]
        elif not free:
            changes.append(ch)
        if args.sources and not args.control and o!=1:
            e.cl(dv[d]);e.d[i]=[r==d for r in range(nr)]
        elif args.dest_edits>=0 and o!=1:
            destination_changes.append(-dv[d])
    if changes:
        card=CardEnc.atmost(changes,args.edits,top_id=e.nvars,encoding=EncType.seqcounter)
        e.nvars=card.nv;e.clauses.extend(card.clauses)
    if destination_changes:
        card=CardEnc.atmost(destination_changes,args.dest_edits,top_id=e.nvars,encoding=EncType.seqcounter)
        e.nvars=card.nv;e.clauses.extend(card.clauses)
    rnd=random.Random(args.random_seed)
    distinct=[i for i,a in enumerate(CASES) if len(set(a))==5]
    chosen=set(rnd.sample(distinct,12))
    columns,_=concrete(p,nr)
    errors=set()
    for goal in GOALS:
        best=min(columns,key=lambda col:sum(a!=b for a,b in zip(col[2],goal)))
        errors.update(t for t in range(541) if best[2][t]!=goal[t])
    # Keep the initial query small. Counterexamples extend the same solver.
    chosen.update(sorted(t for t in errors if len(set(CASES[t]))==5)[:4])
    chosen.update(sorted(t for t in errors if len(set(CASES[t]))<5)[:4])
    for t in sorted(chosen):e.add_type(CASES[t])
    solver=Solver(name='cadical195');solver.set_phases(phase);pushed=0
    for it in itertools.count():
        for c in e.clauses[pushed:]:solver.add_clause(c)
        pushed=len(e.clauses)
        print(json.dumps(dict(step='solve',index=args.index,delete=delete,first=first,end=end,k=k,iteration=it,types=len(chosen),variables=e.nvars,clauses=pushed,seconds=time.monotonic()-began)),flush=True)
        if not solver.solve():
            print(json.dumps(dict(status='UNSAT',types=len(chosen),seconds=time.monotonic()-began,stats=solver.accum_stats())),flush=True);return
        positive={x for x in solver.get_model() if x>0}
        q=[]
        for op,dv,sv in selectors:
            opx=next(x for x,v in op.items() if v in positive)
            d=next(r for r,v in enumerate(dv) if v in positive)
            s=next(r for r,v in enumerate(sv) if v in positive)
            q.append((OPS.index(opx),d,s))
        columns,_=concrete(q,nr);witness=[];added=set()
        for j,goal in enumerate(GOALS):
            exact=[(t,r) for t,r,col in columns if col==goal]
            witness.append(exact[0] if exact else None)
            if not exact:
                for _,_,col in columns:
                    if all(col[t]==goal[t] for t in chosen):
                        added.update([t for t in range(541) if col[t]!=goal[t] and t not in chosen][:4])
                        break
        if all(x is not None for x in witness):
            emit(q,witness,args.output)
            print(json.dumps(dict(status='CANDIDATE',file=args.output,k=k,types=len(chosen),seconds=time.monotonic()-began)),flush=True);return
        # Block a concrete program if strict-scratch correlations caused no new type.
        if not added:
            e.cl(*[-v for i,(o,d,s) in enumerate(q) for v in (selectors[i][0][OPS[o]],selectors[i][1][d],selectors[i][2][s])])
        for t in sorted(added):e.add_type(CASES[t])
        chosen|=added
        print(json.dumps(dict(step='reject',added=len(added),edits=sum(x!=y for x,y in zip(q,p)))),flush=True)

if __name__=='__main__':
    ap=argparse.ArgumentParser()
    ap.add_argument('index',type=int);ap.add_argument('delete',type=int);ap.add_argument('output')
    ap.add_argument('--before',type=int,default=1)
    ap.add_argument('--after',type=int,default=0)
    ap.add_argument('--edits',type=int,default=0)
    ap.add_argument('--all-cmps',action='store_true')
    ap.add_argument('--sources',action='store_true')
    ap.add_argument('--dest-edits',type=int,default=-1)
    ap.add_argument('--control',action='store_true')
    ap.add_argument('--random-seed',type=int,default=5220)
    solve(ap.parse_args())
