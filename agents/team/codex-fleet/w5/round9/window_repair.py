"""Four consecutive instructions become three; outside CMOV predicates are free."""
from pathlib import Path
import argparse,importlib.util,itertools,json,os,random,resource,sys,time
sys.dont_write_bytecode=True
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent/'round4/src'))
from flag_sat import FoldEnc,OPS,CASES,GOALS,emit
sys.path.insert(0,str(HERE.parent/'round5'))
from fusion_sat import concrete
spec=importlib.util.spec_from_file_location('external_kissat',HERE.parent/'round7/kissat_repair.py')
external_module=importlib.util.module_from_spec(spec);spec.loader.exec_module(external_module)
external_module.HERE=HERE

def solve(args,solver):
    began=time.monotonic();manifest=json.loads((HERE/'manifest.json').read_text());row=manifest[args.seed]
    original=[tuple(x) for x in row['program']];start=args.start
    if args.control:
        start=max(i for i,x in enumerate(original) if x[0]==1)
        original.insert(start,original[start])
    p=original[:start]+original[start:start+3]+original[start+4:]
    nr=row['registers']+3
    e=FoldEnc(5,len(p),R=nr,iset='I1',outmode='snap',rules=())
    selectors=[(e.op[i].copy(),e.d[i][:],e.s[i][:]) for i in range(len(p))]
    for i,(o,d,s) in enumerate(p):
        if start<=i<start+3:continue
        op,dv,sv=selectors[i]
        e.cl(dv[d]);e.cl(sv[s]);e.d[i]=[r==d for r in range(nr)];e.s[i]=[r==s for r in range(nr)]
        if o>=2:
            e.cl(-op['cmp']);e.cl(-op['mov']);e.op[i]['cmp']=False;e.op[i]['mov']=False
        else:
            e.cl(op[OPS[o]]);e.op[i]={x:x==OPS[o] for x in op}
    rnd=random.Random(82026);distinct=[i for i,x in enumerate(CASES) if len(set(x))==5]
    chosen=set(rnd.sample(distinct,12))
    # Keep later initial formulas small. Counterexamples still cover all 541
    # weak orders before a proposal can be returned as a candidate.
    chosen.add(CASES.index((0,0,0,0,0)))
    if args.all_cases:chosen.update(range(541))
    for t in sorted(chosen):e.add_type(CASES[t])
    pushed=0
    for iteration in itertools.count():
        for clause in e.clauses[pushed:]:solver.add_clause(clause)
        pushed=len(e.clauses)
        print(json.dumps(dict(step='solve',seed=args.seed,start=start,k=len(p),registers=nr,
                              iteration=iteration,types=len(chosen),clauses=pushed,seconds=time.monotonic()-began)),flush=True)
        if not solver.solve():
            print(json.dumps(dict(status='UNSAT',types=len(chosen),seconds=time.monotonic()-began,stats=solver.accum_stats())),flush=True);return
        positive={x for x in solver.get_model() if x>0};q=[]
        for op,dv,sv in selectors:
            opx=next(x for x,v in op.items() if v in positive)
            d=next(r for r,v in enumerate(dv) if v in positive);s=next(r for r,v in enumerate(sv) if v in positive)
            q.append((OPS.index(opx),d,s))
        for i,((o,d,s),(qo,qd,qs)) in enumerate(zip(p,q)):
            assert start<=i<start+3 or ((d,s)==(qd,qs) and (qo==o or o>=2 and qo>=2))
        columns,_=concrete(q,nr);witness=[];added=set()
        for goal in GOALS:
            exact=[(t,r) for t,r,col in columns if col==goal];witness.append(exact[0] if exact else None)
            if not exact:
                for _,_,col in columns:
                    if all(col[t]==goal[t] for t in chosen):
                        added.update([t for t in range(541) if col[t]!=goal[t] and t not in chosen][:2])
        if all(x is not None for x in witness):
            emit(q,witness,args.output)
            print(json.dumps(dict(status='CANDIDATE',file=args.output,k=len(q),types=len(chosen),seconds=time.monotonic()-began)),flush=True);return
        assert added,'No counterexample for a non-sorting SAT model'
        for t in sorted(added):e.add_type(CASES[t])
        chosen|=added

def main():
    ap=argparse.ArgumentParser();ap.add_argument('seed',type=int);ap.add_argument('start',type=int);ap.add_argument('output')
    ap.add_argument('--seconds',type=float,default=900);ap.add_argument('--control',action='store_true');ap.add_argument('--all-cases',action='store_true')
    args=ap.parse_args();assert os.getpriority(os.PRIO_PROCESS,0)==19
    # The sandbox permits CPUs 76-77. Use exactly one CPU. CPU 76 was
    # saturated by ordinary-priority work; move later queries to CPU 77.
    os.sched_setaffinity(0,{77})
    # Keep the waiting batch parent on the same CPU for later job launches.

    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    solver=external_module.ExternalSolver(args.seconds,Path(args.output).stem)
    try:solve(args,solver)
    except external_module.Limit as error:
        print(json.dumps(dict(status=str(error),stats=solver.accum_stats())),flush=True)
    except MemoryError:
        print(json.dumps(dict(status='UNKNOWN_MEMORY_LIMIT',stats=solver.accum_stats())),flush=True)
    finally:solver.close()
if __name__=='__main__':main()
