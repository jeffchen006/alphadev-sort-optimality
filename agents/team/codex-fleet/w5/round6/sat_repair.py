"""Two arbitrary instruction replacements, with counterexample refinement.

The first query uses the actual failing weak orders and twelve strict orders.
The scratch value is 7 and initial flags are equal. Only the strict judge can
accept a proposal. A completed UNSAT excludes this finite relaxed neighborhood.
"""
from pathlib import Path
import argparse,itertools,json,random,resource,sys,time
sys.dont_write_bytecode=True
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent/'round4/src'))
from flag_sat import FoldEnc,OPS,CASES,GOALS,Solver,emit
from pysat.card import CardEnc,EncType
sys.path.insert(0,str(HERE.parent/'round5'))
from fusion_sat import concrete
sys.path.insert(0,'/path/to/repo/agents/team/codex-fleet/w6/src')
from window_sat import read

def solve(args):
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    began=time.monotonic();p,nr=read(args.seed)
    # read() provides one extra register. Keep precisely that alphabet.
    assert len(p)==31 or args.control or args.allow32
    e=FoldEnc(5,len(p),R=nr,iset='I1',outmode='snap',rules=())
    selectors=[(e.op[i].copy(),e.d[i][:],e.s[i][:]) for i in range(len(p))]
    slots=set(map(int,args.slots.split(','))) if args.slots else None
    changes=[];phase=[]
    for i,(o,d,s) in enumerate(p):
        op,dv,sv=selectors[i];ch=e.new();changes.append(ch)
        if args.predicates and o>=2:
            # Predicate rewrites are free. Two further slots can change any
            # operand or opcode, including conversion to CMP or MOV.
            e.cl(ch,-op['cmp']);e.cl(ch,-op['mov']);e.cl(ch,dv[d]);e.cl(ch,sv[s])
            e.cl(-ch,op['cmp'],op['mov'],-dv[d],-sv[s])
        else:
            e.cl(ch,op[OPS[o]]);e.cl(ch,dv[d]);e.cl(ch,sv[s])
            e.cl(-ch,-op[OPS[o]],-dv[d],-sv[s])
        phase.extend((op[OPS[o]],dv[d],sv[s],-ch))
        if args.control:
            e.cl(-ch);e.op[i]={x:x==OPS[o] for x in op};e.d[i]=[r==d for r in range(nr)];e.s[i]=[r==s for r in range(nr)]
        elif slots is not None and i not in slots:
            e.cl(-ch)
            e.d[i]=[r==d for r in range(nr)];e.s[i]=[r==s for r in range(nr)]
            if args.predicates and o>=2:
                e.op[i]['cmp']=False;e.op[i]['mov']=False
            else:e.op[i]={x:x==OPS[o] for x in op}
    card=CardEnc.atmost(changes,0 if args.control else 2,top_id=e.nvars,encoding=EncType.seqcounter)
    e.nvars=card.nv;e.clauses.extend(card.clauses)
    data=json.loads(Path(args.meta).read_text()) if args.meta else {}
    chosen={CASES.index(tuple(x)) for x in data.get('failing_orders',[])}
    rnd=random.Random(62026);distinct=[i for i,x in enumerate(CASES) if len(set(x))==5]
    chosen.update(rnd.sample(distinct,12))
    if args.all_cases:chosen.update(range(541))
    for t in sorted(chosen):e.add_type(CASES[t])
    solver=Solver(name='cadical195');solver.set_phases(phase);pushed=0
    for iteration in itertools.count():
        for clause in e.clauses[pushed:]:solver.add_clause(clause)
        pushed=len(e.clauses)
        print(json.dumps(dict(step='solve',iteration=iteration,types=len(chosen),clauses=pushed,seconds=time.monotonic()-began)),flush=True)
        if not solver.solve():
            print(json.dumps(dict(status='UNSAT',types=len(chosen),seconds=time.monotonic()-began,stats=solver.accum_stats())),flush=True);return
        positive={x for x in solver.get_model() if x>0};q=[]
        for op,dv,sv in selectors:
            opx=next(x for x,v in op.items() if v in positive)
            d=next(r for r,v in enumerate(dv) if v in positive);s=next(r for r,v in enumerate(sv) if v in positive)
            q.append((OPS.index(opx),d,s))
        free_edits=[i for i,((o,d,s),(qo,qd,qs)) in enumerate(zip(p,q))
                    if (d,s)!=(qd,qs) or
                    (qo!=o and not(args.predicates and o>=2 and qo>=2))]
        assert len(free_edits)<=2 or args.control
        if slots is not None:assert set(free_edits)<=slots
        columns,_=concrete(q,nr);witness=[];added=set()
        for goal in GOALS:
            exact=[(t,r) for t,r,col in columns if col==goal];witness.append(exact[0] if exact else None)
            if not exact:
                # A shared output selector must use a column valid on all
                # encoded cases. Add counterexamples for every such column.
                for _,_,col in columns:
                    if all(col[t]==goal[t] for t in chosen):
                        added.update([t for t in range(541) if col[t]!=goal[t] and t not in chosen][:2])
        if all(x is not None for x in witness):
            emit(q,witness,args.output)
            print(json.dumps(dict(status='CANDIDATE',file=args.output,k=len(q),edits=[i for i in range(len(p)) if p[i]!=q[i]],free_slot_edits=free_edits,types=len(chosen),seconds=time.monotonic()-began)),flush=True);return
        assert added,'Concrete SAT witness must produce a new counterexample.'
        for t in sorted(added):e.add_type(CASES[t])
        chosen|=added

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('seed');ap.add_argument('output');ap.add_argument('--meta');ap.add_argument('--control',action='store_true');ap.add_argument('--predicates',action='store_true');ap.add_argument('--slots');ap.add_argument('--allow32',action='store_true');ap.add_argument('--all-cases',action='store_true')
    solve(ap.parse_args())
