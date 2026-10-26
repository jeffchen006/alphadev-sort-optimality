"""Bounded SAT repairs for the audited CMOV pairs. Time limits are UNKNOWN."""
from pathlib import Path
import argparse,itertools,json,random,resource,sys,time
sys.dont_write_bytecode=True
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent/'round4/src'))
from flag_sat import FoldEnc,OPS,CASES,GOALS,Solver,emit

def concrete(program,nr):
    """Exact relaxed execution; this does not use unknown-value propagation."""
    registers=[tuple(x[r] for x in CASES) if r<5 else (7,)*541 for r in range(nr)]
    flags=(0,)*541;columns=[(-1,r,col) for r,col in enumerate(registers)];states=[(registers[:],flags)]
    for t,(o,d,s) in enumerate(program):
        a,b=registers[d],registers[s]
        if o==0:registers[d]=b
        elif o==1:flags=tuple((x>y)-(x<y) for x,y in zip(a,b))
        else:
            registers[d]=tuple(y if (f<0 if o==2 else f<=0 if o==3 else f>0 if o==4 else f>=0) else x for x,y,f in zip(a,b,flags))
        if o!=1:columns.append((t,d,registers[d]))
        states.append((registers[:],flags))
    return columns,states

def solve(args):
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    began=time.monotonic()
    row=json.loads((HERE/'manifest.json').read_text())[args.seed]
    original=[tuple(x) for x in row['program']];a,b=args.first,args.second
    assert a<b and original[a][0]>=2 and original[b][0]>=2
    mapping=[i for i in range(len(original)) if i not in (a,b)]
    p=[original[i] for i in mapping]
    pos=sum(i<a for i in mapping)
    p.insert(pos,original[b]);mapping.insert(pos,-1)
    cs=[i for i,x in enumerate(original) if x[0]==1]
    c=max(i for i,x in enumerate(cs) if x<a)
    first=cs[max(0,c-1)]
    after=next((i for i,x in enumerate(cs) if x>b),len(cs))
    end=cs[after+1] if after+1<len(cs) else len(original)
    if args.control:p=original;mapping=list(range(len(original)));first=end=0
    nr=row['registers']+1;k=len(p)
    e=FoldEnc(5,k,R=nr,iset='I1',outmode='snap',rules=())
    selectors=[(e.op[i].copy(),e.d[i][:],e.s[i][:]) for i in range(k)]
    phase=[]
    for i,(o,d,s) in enumerate(p):
        op,dv,sv=selectors[i];inside=mapping[i]==-1 or first<=mapping[i]<end
        phase.extend((op[OPS[o]],dv[d],sv[s]))
        if not inside:
            e.cl(op[OPS[o]]);e.cl(dv[d]);e.cl(sv[s])
            e.op[i]={x:x==OPS[o] for x in op};e.d[i]=[r==d for r in range(nr)];e.s[i]=[r==s for r in range(nr)]
        else:
            if o==1:
                e.cl(op['cmp']);e.op[i]={x:x=='cmp' for x in op}
            else:
                e.cl(-op['cmp']);e.op[i]['cmp']=False
                if mapping[i]!=-1:
                    e.cl(dv[d]);e.d[i]=[r==d for r in range(nr)]
    rnd=random.Random(532626+args.seed)
    distinct=[i for i,x in enumerate(CASES) if len(set(x))==5]
    chosen=set(rnd.sample(distinct,16));chosen.update(i for i,x in enumerate(CASES) if len(set(x))<=2)
    for t in sorted(chosen):e.add_type(CASES[t])
    solver=Solver(name='cadical195');solver.set_phases(phase);pushed=0
    for iteration in itertools.count():
        for clause in e.clauses[pushed:]:solver.add_clause(clause)
        pushed=len(e.clauses)
        print(json.dumps(dict(step='solve',seed=args.seed,pair=[a,b],window=[first,end],k=k,iteration=iteration,types=len(chosen),clauses=pushed,seconds=time.monotonic()-began)),flush=True)
        if not solver.solve():
            print(json.dumps(dict(status='UNSAT',types=len(chosen),seconds=time.monotonic()-began)),flush=True);return
        positive={x for x in solver.get_model() if x>0};q=[]
        for op,dv,sv in selectors:
            opx=next(x for x,v in op.items() if v in positive)
            d=next(r for r,v in enumerate(dv) if v in positive);s=next(r for r,v in enumerate(sv) if v in positive)
            q.append((OPS.index(opx),d,s))
        columns,_=concrete(q,nr);witness=[];added=set()
        for goal in GOALS:
            exact=[(t,r) for t,r,col in columns if col==goal]
            witness.append(exact[0] if exact else None)
            if not exact:
                for _,_,col in columns:
                    if all(col[t]==goal[t] for t in chosen):
                        added.update([t for t in range(541) if col[t]!=goal[t] and t not in chosen][:4]);break
        if all(x is not None for x in witness):
            emit(q,witness,args.output)
            path=Path(args.output);path.write_text(path.read_text().replace('source=w5-round3-sat','source=w5-round5-fusion-sat'))
            print(json.dumps(dict(status='CANDIDATE',file=args.output,k=k,types=len(chosen),seconds=time.monotonic()-began)),flush=True);return
        assert added, 'A relaxed SAT model must have a relaxed output witness or a new input counterexample.'
        for t in sorted(added):e.add_type(CASES[t])
        chosen|=added

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('seed',type=int);ap.add_argument('first',type=int);ap.add_argument('second',type=int);ap.add_argument('output');ap.add_argument('--control',action='store_true')
    solve(ap.parse_args())
