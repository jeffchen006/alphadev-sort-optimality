"""Local CEGIS with unrestricted window instructions and external kissat.

The rank encoder fixes scratch above every input and initial flags to equality.
UNSAT is a local relaxed-state exclusion. A candidate needs the strict judge.
"""
from pathlib import Path
import argparse, collections, json, os, random, re, resource, subprocess, sys, time

HERE = Path(__file__).resolve().parents[2]
ROOT = HERE.parents[3]
sys.path[:0] = [str(HERE/'round7/src'), str(HERE/'round3/src'), str(HERE/'src'), str(ROOT/'agents/sat')]
from rank_encode import RankEnc
from binary_encode import BinaryEnc
from window_sat import OPS, CASES, GOALS, concrete, read
from satrep import emit

KISSAT = ROOT/'bin/kissat'


def analyze(program, nr):
    columns, states = concrete(program, nr)
    nearest = [min(columns, key=lambda c:sum(x!=y for x,y in zip(c[2],g))) for g in GOALS]
    bad = sorted({t for j,g in enumerate(GOALS) for t in range(541) if nearest[j][2][t]!=g[t]})
    weights = [0]*len(program)
    detail = []
    for case in bad:
        vals = list(CASES[case])+[7]*(nr-5)
        deps = [set() for _ in range(nr)]
        flag, fdeps = 0, set()
        snapshots = {}
        for i,(op,d,s) in enumerate(program):
            if op == 1:
                flag = (vals[d]>vals[s])-(vals[d]<vals[s])
                fdeps = deps[d]|deps[s]|{i}
            else:
                take = op==0 or (flag<0 if op==2 else flag<=0 if op==3 else flag>0 if op==4 else flag>=0)
                old = vals[d]
                if take:
                    vals[d] = vals[s]
                    deps[d] = deps[s]|{i}|(fdeps if op else set())
                else:
                    deps[d] = deps[d]|fdeps|{i}
                for j,g in enumerate(GOALS):
                    if nearest[j][:2] == (i,d) and nearest[j][2][case]!=g[case]:
                        for slot in deps[d]: weights[slot]+=1
                        detail.append({'case':case,'input':CASES[case],'output':j,'snapshot':[i,d],
                                       'got':vals[d],'want':g[case],'dependencies':sorted(deps[d])})
                if old!=vals[d] and old==GOALS[2][case]:
                    # Give priority to writes that discard the required median.
                    weights[i]+=2
                    for slot in fdeps: weights[slot]+=1
            snapshots[i] = (vals[:], [set(x) for x in deps])
    windows = []
    for width in (6,7,8):
        for start in range(len(program)-width+1):
            score = sum(weights[start:start+width])/width
            # This is a priority score only, never a pruning rule.
            windows.append({'start':start,'width':width,'score':round(score,5)})
    windows.sort(key=lambda w:(-w['score'],w['width'],w['start']))
    return dict(failed_orders=len(bad),bad_cases=bad,output_errors=[sum(x!=y for x,y in zip(c[2],g)) for c,g in zip(nearest,GOALS)],
                weights=weights,failures=detail,windows=windows)


def solve(args):
    # Stop the dispatcher only between search jobs, when a restart is requested.
    # Some executors isolate /proc between exec sessions. This child can see its
    # own ancestors. The exact command match prevents signalling another job.
    request=Path('round8/artifacts/restart.request')
    if request.exists():
        import signal
        parent=os.getppid()
        while parent>1:
            proc=Path('/proc',str(parent))
            command=proc.joinpath('cmdline').read_bytes().split(b'\0')
            if b'round8/src/run.py' in command:
                Path('round8/artifacts/restart_ack.json').write_text(json.dumps(dict(reason=request.read_text(),interrupted_query=args.output)))
                request.unlink()
                os.kill(parent,signal.SIGTERM)
                return
            parent=int(proc.joinpath('stat').read_text().split()[3])
        raise RuntimeError('Restart requested, but dispatcher ancestor was not found')
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024*1024,)*2)
    began=time.monotonic()
    p,nr=read(args.seed)
    nr=nr-1+args.fresh
    analysis=analyze(p,nr)
    e=(BinaryEnc if args.binary else RankEnc)(5,len(p),R=nr,iset='I1',outmode='snap',rules=())
    domains=[];destinations=[];sources=[]
    free=set(range(args.start,args.start+args.width))
    for i,(op,d,s) in enumerate(p):
        fixed=i not in free or args.control
        if fixed:
            domain=[OPS[op]]
            e.cl(e.op[i][OPS[op]]);e.cl(e.d[i][d]);e.cl(e.s[i][s])
        elif args.typed:
            domain=['cmp'] if op==1 else [o for o in OPS if o!='cmp']
            e.cl(*[e.op[i][o] for o in domain])
        else:
            domain=OPS
        domains.append(domain)
        destinations.append(d if fixed else None)
        sources.append(s if fixed else None)
    e.configure(p,domains,destinations,sources)
    covered=[]
    # A valid wider repair must differ outside each completed smaller window.
    # These cuts preserve every all-541-order solution in the same register bound.
    if args.typed and args.fresh==1 and args.width>6:
        args.covered_windows=True
    if args.covered_windows:
        assert args.typed and args.fresh==1
        ledger=json.loads(Path('round7/artifacts/query_ledger.json').read_text())
        long_ledger=Path('round8/artifacts/sat_ledger.json')
        if long_ledger.exists():
            ledger+=json.loads(long_ledger.read_text())
        if args.seed==json.loads(Path('round6/artifacts/near_inventory.json').read_text())['representatives'][0]['file']:
            ledger=ledger+[dict(typed=True,status='UNSAT',source=args.seed,start=12,width=6,name='t00_w6_i12')]
        for previous in ledger:
            if not previous['typed'] or previous['status']!='UNSAT' or previous['source']!=args.seed:continue
            inner=set(range(previous['start'],previous['start']+previous['width']))
            if not inner<free:continue
            # If every instruction outside the closed subwindow stayed fixed,
            # this would be a solution to its completed UNSAT query.
            outside=sorted(free-inner)
            e.cl(*[-v for i in outside for v in (e.op[i][OPS[p[i][0]]],e.d[i][p[i][1]],e.s[i][p[i][2]])])
            covered.append(dict(query=previous['name'],must_change_one_of=outside))
    rnd=random.Random(args.random_seed)
    strict=[i for i,x in enumerate(CASES) if len(set(x))==5]
    chosen=set(analysis['bad_cases'])|set(rnd.sample(strict,args.strict_types))
    if not chosen:chosen=set(rnd.sample(range(541),12))
    shared=set()
    seed_match=re.search(r'_(s\d+)_w',Path(args.output).stem)
    if seed_match:
        for previous in list(Path('round7/logs').glob('*_'+seed_match.group(1)+'_w*.log')) + list(Path('round8/logs').glob('*_'+seed_match.group(1)+'_w*.log')):
            for line in previous.read_text().splitlines():
                try:ev=json.loads(line)
                except ValueError:continue
                if ev.get('step')=='candidate':shared.update(ev.get('new_cases',[]))
        chosen|=shared
    print(json.dumps(dict(step='initial_cases',seed=args.seed,chosen=sorted(chosen),
                          shared=sorted(shared),start=args.start,width=args.width,
                          typed=args.typed,registers=nr,seconds_limit=args.seconds,covered=covered)),flush=True)
    for t in sorted(chosen):e.add_type(CASES[t])
    output=Path(args.output)
    output.parent.mkdir(parents=True,exist_ok=True)
    cnf=output.with_suffix('.cnf')
    best=(analysis['failed_orders'],sum(analysis['output_errors']))
    status='UNKNOWN'
    for iteration in range(10000):
        remain=args.seconds-(time.monotonic()-began)
        if remain<=0:break
        with cnf.open('w') as f:
            f.write(f'p cnf {e.nvars} {len(e.clauses)}\n')
            for clause in e.clauses:f.write(' '.join(map(str,clause))+' 0\n')
        meta=dict(step='solve',iteration=iteration,cases=len(chosen),variables=e.nvars,clauses=len(e.clauses),seconds=time.monotonic()-began)
        print(json.dumps(meta),flush=True)
        try:
            r=subprocess.run([str(KISSAT),'-q',str(cnf)],stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True,timeout=max(.01,args.seconds-(time.monotonic()-began)))
        except subprocess.TimeoutExpired:
            print(json.dumps(dict(status='UNKNOWN',reason='wall limit',seconds=time.monotonic()-began)),flush=True)
            break
        slog=output.with_suffix(f'.iter{iteration}.kissat.log')
        slog.write_text(r.stdout+r.stderr)
        if r.returncode==20:
            status='UNSAT'
            print(json.dumps(dict(status=status,cases=len(chosen),seconds=time.monotonic()-began)),flush=True)
            break
        if r.returncode!=10:
            status='ERROR'
            print(json.dumps(dict(status=status,exit=r.returncode,stderr=r.stderr[-2000:])),flush=True)
            break
        model=[int(lit) for line in r.stdout.splitlines() if line.startswith('v ') for lit in line.split()[1:] if lit!='0']
        cand,outmap=e.decode(model)
        q=[(OPS.index(op),d,s) for op,d,s in cand]
        columns,_=concrete(q,nr)
        witnesses=[];nearest=[];new=set();errors=[]
        for j,g in enumerate(GOALS):
            exact=[(t,r) for t,r,c in columns if c==g]
            witnesses.append(exact[0] if exact else None)
            near=min(columns,key=lambda c:sum(x!=y for x,y in zip(c[2],g)))
            nearest.append(near)
            errors.append(sum(x!=y for x,y in zip(near[2],g)))
            eligible=[c for _,_,c in columns if all(c[t]==g[t] for t in chosen)]
            for _ in range(3):
                if exact or not eligible:break
                counts={t:sum(c[t]!=g[t] for c in eligible) for t in range(541) if t not in chosen|new}
                if not counts or max(counts.values())==0:break
                t=max(counts,key=counts.get)
                new.add(t)
                eligible=[c for c in eligible if c[t]==g[t]]
        failed=sum(any(nearest[j][2][t]!=GOALS[j][t] for j in range(5)) for t in range(541))
        if (failed,sum(errors))<best:
            best=(failed,sum(errors))
            emit(q,[(t,r) for t,r,_ in nearest],output.with_name(output.stem+'_near.s'))
        print(json.dumps(dict(step='candidate',iteration=iteration,errors=errors,failed_orders=failed,new_cases=sorted(new))),flush=True)
        if all(w is not None for w in witnesses):
            emit(q,witnesses,output)
            status='CANDIDATE'
            print(json.dumps(dict(status=status,file=str(output),seconds=time.monotonic()-began)),flush=True)
            break
        if not new:
            # The relaxed encoding can use scratch garbage; ask the judge before blocking.
            emit(q,[(when-1,r) for when,r in outmap],output)
            log=output.with_suffix('.rescue_judge.log')
            with log.open('w') as f:
                judged=subprocess.run(['nice','-n','19','python3','-B',str(ROOT/'shared/judge.py'),str(output),'--strict','--model','out'],stdout=f,stderr=subprocess.STDOUT)
            if judged.returncode==0 and 'PASS ' in log.read_text():
                status='CANDIDATE'
                print(json.dumps(dict(status=status,file=str(output),strict_rescue=True)),flush=True)
                break
            output.unlink()
            e.cl(*[-v for i,(op,d,s) in enumerate(q) if i in free for v in (e.op[i][OPS[op]],e.d[i][d],e.s[i][s])])
        for t in sorted(new):e.add_type(CASES[t])
        chosen|=new
    print(json.dumps(dict(step='finished',status=status,best=best,cases=len(chosen),seconds=time.monotonic()-began)),flush=True)
    if not args.keep_cnf:cnf.unlink(missing_ok=True)


if __name__=='__main__':
    ap=argparse.ArgumentParser()
    ap.add_argument('seed');ap.add_argument('output')
    ap.add_argument('--start',type=int,default=12);ap.add_argument('--width',type=int,default=6)
    ap.add_argument('--fresh',type=int,default=1);ap.add_argument('--seconds',type=float,default=25)
    ap.add_argument('--strict-types',type=int,default=6);ap.add_argument('--random-seed',type=int,default=7201)
    ap.add_argument('--typed',action='store_true');ap.add_argument('--control',action='store_true')
    ap.add_argument('--binary',action='store_true')
    ap.add_argument('--covered-windows',action='store_true')
    ap.add_argument('--keep-cnf',action='store_true');ap.add_argument('--analyze',action='store_true')
    a=ap.parse_args()
    if a.analyze:
        p,nr=read(a.seed);print(json.dumps(analyze(p,nr),indent=2))
    else:solve(a)
