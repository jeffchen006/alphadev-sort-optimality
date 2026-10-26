"""Exact SAT repair of arbitrary instruction positions, with free output snapshots.

The solver uses the sound top-scratch relaxation. UNSAT excludes the stated
finite search domain. A returned candidate must pass the independent judge.
"""
import argparse, itertools, json, random, subprocess, sys, time
from pathlib import Path

# Reject unselected jobs before loading the SAT and SMT libraries.
if __name__=='__main__' and len(sys.argv)>2:
    selection=Path('artifacts/search_selection.json')
    if selection.exists():
        cfg=json.loads(selection.read_text());output=sys.argv[2];reason=None
        if output in cfg.get('skip_outputs',[]):reason='Replaced by a parallel job'
        if Path(output).name.startswith('triples_') and '--free' in sys.argv:
            free=set(map(int,sys.argv[sys.argv.index('--free')+1].split(',')))
            if not free.intersection(cfg.get('triple_keep_any',range(31))):reason='Outside the selected median repair windows'
        if reason:
            print(json.dumps({'status':'SKIPPED','reason':reason,'output':output}),flush=True)
            raise SystemExit(0)

from pysat.card import CardEnc, EncType
from pysat.solvers import Solver
from rank_encode import RankEnc
from reference_window import OPS, CASES, GOALS, read, concrete, reg

ROOT=Path('/path/to/repo')

def emit(program, witnesses, path):
    lines=[f'# n=5 model=out iset=I1 source=w4-copy-of-w7-exact k={len(program)}']
    for j,(t,r) in enumerate(witnesses):
        if t==-1: lines.append(f'out {j}, {reg(r)}')
    for t,(o,d,s) in enumerate(program):
        lines.append(f'{OPS[o]} {reg(d)}, {reg(s)}')
        for j,(when,r) in enumerate(witnesses):
            if when==t: lines.append(f'out {j}, {reg(r)}')
    Path(path).write_text('\n'.join(lines)+'\n')

def solve(a):
    began=time.monotonic(); p,used=read(a.seed); base=used-1
    nr=a.registers or base+2*a.changes
    if a.delete is not None: del p[a.delete]
    k=len(p)
    free=set(map(int,a.free.split(','))) if a.free else set(range(a.prefix,k))
    selection=Path('artifacts/search_selection.json')
    fold=selection.exists() and json.loads(selection.read_text()).get('fold_readonly',False)
    if fold and a.free and len(free)==3 and not a.changes and not a.no_fold_readonly:
        # At most |free| new registers can be written. Every other new register
        # is read-only and has the same top value in the sound relaxation.
        nr=min(nr,base+len(free)+1)
    print(json.dumps({'step':'parameters','free':sorted(free),'registers':nr,'initial_strict_cases':a.initial,'readonly_fold':fold}),flush=True)
    e=RankEnc(5,k,R=nr,iset='I1',outmode='snap',rules=())
    domains=[]; destinations=[]; sources=[]; changed=[]; phases=[]
    for i,(op,d,s) in enumerate(p):
        fixed=i not in free
        domain=[OPS[op]] if fixed or a.operands else ['cmp'] if a.typed and op==1 else [o for o in OPS if o!='cmp'] if a.typed else OPS
        domains.append(domain); destinations.append(d if fixed or a.fixed_dest and op!=1 else None); sources.append(s if fixed else None)
        e.cl(*[e.op[i][o] for o in domain])
        if destinations[-1] is not None: e.cl(e.d[i][destinations[-1]])
        if sources[-1] is not None: e.cl(e.s[i][sources[-1]])
        ch=e.new(); changed.append(ch)
        same=[e.op[i][OPS[op]], e.d[i][d], e.s[i][s]]
        for lit in same: e.cl(ch,lit)
        e.cl(-ch,*[-v for v in same])
        phases.extend(same+[-ch])
        if fixed: e.cl(-ch)
    if a.changes:
        card=CardEnc.atmost(changed,a.changes,top_id=e.nvars,encoding=EncType.seqcounter)
        e.nvars=card.nv;e.clauses.extend(card.clauses)
    if a.maxcmp:
        card=CardEnc.atmost([e.op[i]['cmp'] for i in range(k)],a.maxcmp,top_id=e.nvars,encoding=EncType.seqcounter)
        e.nvars=card.nv;e.clauses.extend(card.clauses)
    # New registers are interchangeable. Number them in first-touch order.
    # Every old register is exempt. Operands are visited destination then source.
    touched=[False]*(nr-base)
    for i in range(k):
        for row in (e.d[i],e.s[i]):
            for r in range(base+1,nr): e.cl(-row[r],touched[r-base-1])
            touched=[e.mux(row[base+j],True,old) for j,old in enumerate(touched)]
    e.configure(p,domains,destinations,sources)
    rng=random.Random(a.random_seed)
    cols,_=concrete(p,nr)
    bad=set()
    for j,g in enumerate(GOALS):
        col=min(cols,key=lambda x:sum(v!=w for v,w in zip(x[2],g)))[2]
        bad.update(t for t in range(541) if col[t]!=g[t])
    strict=[t for t,x in enumerate(CASES) if len(set(x))==5]
    chosen=set(bad)|set(rng.sample(strict,min(len(strict),a.initial)))|{0,1,2}
    if a.all_cases: chosen=set(range(541))
    for t in sorted(chosen):e.add_type(CASES[t])
    with Solver(name=a.solver,with_proof=a.proof) as solver:
        solver.set_phases(phases); pushed=0
        for iteration in itertools.count():
            solver.append_formula(e.clauses[pushed:]);pushed=len(e.clauses)
            print(json.dumps({'step':'solve','iteration':iteration,'cases':len(chosen),'variables':e.nvars,'clauses':pushed,'seconds':time.monotonic()-began}),flush=True)
            if not solver.solve():
                if a.proof:
                    Path(a.output+'.drat').write_text('\n'.join(solver.get_proof())+'\n')
                    with open(a.output+'.cnf','w') as f:
                        f.write(f'p cnf {e.nvars} {len(e.clauses)}\n')
                        for cl in e.clauses:f.write(' '.join(map(str,cl))+' 0\n')
                print(json.dumps({'status':'UNSAT','seconds':time.monotonic()-began,'cases':len(chosen),'registers':nr,'changes':a.changes}),flush=True)
                return
            program,out=e.decode(solver.get_model());q=[(OPS.index(o),d,s) for o,d,s in program]
            cols,_=concrete(q,nr); witnesses=[];added=set();errors=[]
            for j,g in enumerate(GOALS):
                exact=[(t,r) for t,r,col in cols if col==g]
                witnesses.append(exact[0] if exact else None)
                errors.append(min(sum(v!=w for v,w in zip(col,g)) for _,_,col in cols))
                eligible=[col for _,_,col in cols if all(col[t]==g[t] for t in chosen)]
                for _ in range(4):
                    if exact or not eligible:break
                    scores={t:sum(col[t]!=g[t] for col in eligible) for t in range(541) if t not in chosen|added}
                    if not scores or max(scores.values())==0:break
                    t=max(scores,key=scores.get);added.add(t);eligible=[col for col in eligible if col[t]==g[t]]
            edits=[i for i in range(k) if q[i]!=p[i]]
            print(json.dumps({'step':'candidate','iteration':iteration,'errors':errors,'edits':edits,'added':sorted(added),'seconds':time.monotonic()-began}),flush=True)
            if all(w is not None for w in witnesses):
                emit(q,witnesses,a.output)
            elif not added:
                emit(q,[(t-1,r) for t,r in out],a.output)
            else:
                for t in sorted(added):e.add_type(CASES[t])
                chosen|=added
                continue
            log=Path(a.output+'.judge.log')
            with log.open('w') as f:
                result=subprocess.run(['nice','-n','19','python3','-B',str(ROOT/'shared/judge.py'),a.output,'--strict','--model','out'],stdout=f,stderr=subprocess.STDOUT)
            if result.returncode==0 and 'PASS ' in log.read_text():
                print(json.dumps({'status':'PASS','file':a.output,'seconds':time.monotonic()-began}),flush=True);return
            # Only block a concrete program after the reference judge rejects it.
            e.cl(*[-v for i,(op,d,s) in enumerate(q) for v in(e.op[i][OPS[op]],e.d[i][d],e.s[i][s])])
            Path(a.output).rename(a.output+'.rejected.s')

if __name__=='__main__':
    ap=argparse.ArgumentParser()
    ap.add_argument('seed');ap.add_argument('output');ap.add_argument('--registers',type=int,default=0)
    ap.add_argument('--changes',type=int,default=3);ap.add_argument('--prefix',type=int,default=0)
    ap.add_argument('--free',default='');ap.add_argument('--typed',action='store_true');ap.add_argument('--operands',action='store_true')
    ap.add_argument('--fixed-dest',action='store_true');ap.add_argument('--delete',type=int)
    ap.add_argument('--maxcmp',type=int,default=0);ap.add_argument('--initial',type=int,default=16)
    ap.add_argument('--random-seed',type=int,default=711);ap.add_argument('--solver',default='cadical195')
    ap.add_argument('--proof',action='store_true');ap.add_argument('--all-cases',action='store_true')
    ap.add_argument('--no-fold-readonly',action='store_true')
    a=ap.parse_args()
    # Optional task selection is explicit and does not alter any SAT domain.
    selection=Path('artifacts/search_selection.json')
    if selection.exists():
        config=json.loads(selection.read_text())
        if a.output in config.get('skip_outputs',[]):
            print(json.dumps({'status':'SKIPPED','reason':'Replaced by a parallel job','output':a.output}),flush=True)
            raise SystemExit(0)
        if Path(a.output).name.startswith('triples_'):
            positions=set(map(int,a.free.split(',')))
            if not positions.intersection(config.get('triple_keep_any',range(31))):
                print(json.dumps({'status':'SKIPPED','reason':'Outside the selected median repair windows','free':sorted(positions)}),flush=True)
                raise SystemExit(0)
    solve(a)
