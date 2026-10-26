#!/usr/bin/env python3
"""Round-2 exact SSA experiments. Each run uses one single-threaded SAT solver."""
import argparse,itertools,json,random,sys,time
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'src'))
from trees import trees
from mixed import logs as oldlogs
from ssa_orient import Enc,P,solve,simulate
ROOT=Path(__file__).resolve().parents[2]

def history_preflight():
    """Check the current tree-choice clauses before starting a target run."""
    import subprocess
    log=ROOT/'round3/logs/history_control53.log'
    if log.exists() and 'JUDGE PASS ' in log.read_text():return
    cmd=['nice','-n','19','python3',str(Path(__file__).resolve()),'--tag','history_control53',
         '--control','--complete','--all','--origin','--timeout','60']
    with log.open('w') as stream:
        q=subprocess.run(cmd,stdout=stream,stderr=subprocess.STDOUT)
    if q.returncode or 'JUDGE PASS ' not in log.read_text():
        raise SystemExit('Tree-choice history control failed: '+str(log))
    print('PREFLIGHT history_control53 strict PASS',flush=True)

def adaptive(x,tree,mask=0,switch=True):
    # Select a second disjoint pair according to the first comparison.
    # One branch pairs (2,3); the other branch pairs (2,4).
    swap=switch and x[0]>x[1]
    inds=[0,1,2,4,3] if swap else list(range(5))
    xx=tuple(x[i] for i in inds)
    return oldlogs(xx,tree,mask,'last','actual')

def skeleton(tree,mask,adaptive_pair=False):
    rows=[adaptive(x,tree,mask,adaptive_pair) for x in P]
    return [[row[j] for row in rows] for j in range(7)]

def trace_inputs(program,ty):
    r={f'P{i}':ty[i] for i in range(5)};flag=0;out=[]
    for line in program:
        if not line or line.startswith('#'):continue
        op,rest=line.split(None,1);d,s=[q.strip() for q in rest.split(',')]
        if op=='out':continue
        if op=='cmp':out.append((r[d],r[s]));flag=(r[d]>r[s])-(r[d]<r[s])
        elif op=='mov' or op=='cmovl' and flag<0 or op=='cmovg' and flag>0 or op=='cmovle' and flag<=0 or op=='cmovge' and flag>=0:r[d]=r[s]
    return out

def operand_ages(e):
    """early[j,side,cut] says the cmp operand predates comparisons after cut."""
    ans={}
    for j in range(1,e.c):
      for side in range(2):
       for cut in range(j):
        early=e.new();ans[j,side,cut]=early
        for x in range(5):e.cl(-e.cmps[j][side][x],early)
        for g in range(e.m):
         for b in range(e.c):
          e.cl(-e.cmps[j][side][5+g],-e.blk[g][b],early if b+1<=cut else -early)
    return ans

def limit_early(e,ages,j,cut,cap,guard=()):
    if cap==0:
        for side in range(2):e.cl(*guard,-ages[j,side,cut])
    elif cap==1:e.cl(*guard,-ages[j,0,cut],-ages[j,1,cut])

def selected_history_equalities(e,alternatives,types,depth):
    """Share origin values within histories of the selected residual tree.

    Deduplicate identical history classes before adding guarded equalities.
    A class can belong to many tree choices; one guard covers all such choices.
    """
    prefixgroups={}
    for t in range(len(types)):
        prefixgroups.setdefault(tuple(e.F[j][t] for j in range(depth)),[]).append(t)
    classes={};owners={}
    for prefixhist,grp in prefixgroups.items():
        choices=e.tree_choices[prefixhist]
        for opt,prof in zip(choices,alternatives):
            for b in range(depth,6):
                byhist={}
                for t in grp:
                    h=tuple(prof[q][types[t]] for q in range(b+1))
                    if None not in h:byhist.setdefault(h,[]).append(t)
                for ts in byhist.values():
                    if len(ts)<2:continue
                    key=(b,tuple(ts));classes.setdefault(key,set()).add(opt)
                    owners[key]=set(choices)
    added=0
    for (b,ts),opts in classes.items():
        active=e.new()
        if opts==owners[b,ts]:e.cl(active)
        else:
            for opt in opts:e.cl(-opt,active)
            e.cl(-active,*sorted(opts))
        t0=ts[0]
        for t in ts[1:]:
            for bit in range(3):
                for g in range(e.m):
                    e.eq(e.val[5+g][t][bit],e.val[5+g][t0][bit],-active,-e.blk[g][b])
                for side in range(2):
                    e.eq(e.cmpval[b+1][side][t][bit],e.cmpval[b+1][side][t0][bit],-active)
                added+=2*(e.m+2)
    print(json.dumps(dict(event='HISTORY_CLASSES',classes=len(classes),equalities_clauses=added)),flush=True)

def run(a):
    if (ROOT/'RESULTS.md').read_text().startswith('FOUND '):
        print('TARGET_ALREADY_FOUND',flush=True);return
    if not a.control and (a.complete or a.union):history_preflight()
    start=time.monotonic();rng=random.Random(a.seed)
    fixed=None
    if a.control:
        fixed=(ROOT/'programs/construct_fj_k53.s').read_text().splitlines()
        rows=[trace_inputs(fixed,p) for p in P]
        ob=[[row[j] for row in rows] for j in range(7)]
        # Reverse canonical comparison orientation independently after each history.
        for j in range(7):
            cls={}
            for t in range(120):
                hist=tuple((rows[t][q][0]>rows[t][q][1])-(rows[t][q][0]<rows[t][q][1]) for q in range(j))
                if hist not in cls:cls[hist]=rng.randrange(2)
                if cls[hist]:ob[j][t]=tuple(reversed(ob[j][t]))
        m=46
    else:
        tr=trees(tuple(range(15)),4)[a.tree]
        ob=skeleton(tr,a.mask,a.adaptive)
        m=24
    F=[[(u>v)-(u<v) for u,v in row] for row in ob]
    alternatives=None
    if a.complete:
        assert not a.exact
        alternatives=[]
        ts=trees(tuple(range(15)),4)
        for mask in [0,15]:
          bytree=[skeleton(tr,mask,a.adaptive) for tr in ts]
          for tl in range(6):
           for tr in range(6):
            alt=[]
            for j in range(7):
                alt.append([bytree[tl if bytree[0][2][t][0]<bytree[0][2][t][1] else tr][j][t] for t in range(120)])
            prof=[[(u>v)-(u<v) for u,v in row] for row in alt]
            groups={}
            for t in range(120):groups.setdefault(tuple(prof[j][t] for j in range(6)),[]).append(t)
            for group in groups.values():
                if len(group)==1:prof[6][group[0]]=None
            alternatives.append(prof)
        for j in range(2,7):F[j]=[None]*120
    elif a.union:
        alternatives=[]
        for tr in trees(tuple(range(15)),4):
            alt=skeleton(tr,a.mask,a.adaptive)
            prof=[[(u>v)-(u<v) for u,v in row] for row in alt]
            if a.free_last:
                groups={}
                for t in range(120):groups.setdefault(tuple(prof[j][t] for j in range(6)),[]).append(t)
                for group in groups.values():
                    if len(group)==1:prof[6][group[0]]=None
            alternatives.append(prof)
        for j in range(3,7):F[j]=[None]*120
    if a.free_last:
        groups={}
        for t in range(120):groups.setdefault(tuple(F[j][t] for j in range(6)),[]).append(t)
        for group in groups.values():
            if len(group)==1:F[6][group[0]]=None
    types=list(range(120)) if a.all else sorted(rng.sample(range(120),a.init))
    prefix=[]
    if a.adaptive_prefix:
        prefix=['cmp P0, P1','mov S0, P3','cmovg S0, P4','cmp P2, S0']
    if fixed is None and prefix:fixed=prefix
    for it in range(15):
        ff=[[row[t] for t in types] for row in F]
        oo=[[row[t] for t in types] for row in ob] if a.exact else None
        e=Enc(ff,[P[t] for t in types],a.gates or m,operands=oo,fixed=fixed,orient=True,
              origin=a.origin,paired=a.paired,gates=a.gates is not None,
              copybound=(None if a.free_copy else 24-a.gates) if a.gates else None,movbound=a.movbound,
              alternatives=[[[row[t] for t in types] for row in prof] for prof in alternatives] if alternatives else None,
              prefixdepth=2 if a.complete else 3)
        if not a.control:
            # Global operand reversal in one comparison can be absorbed by
            # swapping l/g predicates in that phase. Fix its sign on one order.
            # Do not constrain comparisons already fixed by the prefix.
            for j in range(2 if prefix else 0,7):
                for t in range(len(types)):
                    if alternatives:
                        if any(prof[j][types[t]] in (None,0) for prof in alternatives):continue
                    elif ff[j][t] in (None,0):continue
                    e.cl(e.fl[j][t][0]);break
        ages=operand_ages(e)
        if a.exact:
            # Before cut, each register has one input origin per flag history.
            # Both operand origins must belong to every required unordered pair
            # in that history. Fewer than two common origins limit old operands.
            for j in range(1,7):
                for cut in range(j):
                    groups={}
                    for t in range(len(types)):
                        h=tuple(ff[q][t] for q in range(cut))
                        if None not in h:groups.setdefault(h,[]).append(t)
                    cap=2
                    for ts in groups.values():
                        common=set(range(5))
                        strict=True
                        for t in ts:
                            pair={P[types[t]].index(v) for v in ob[j][types[t]]}
                            strict &= len(pair)==2;common &= pair
                        if strict:cap=min(cap,len(common))
                    limit_early(e,ages,j,cut,cap)
        if alternatives and a.origin:
            # Redundant propagation clauses: under one chosen tree, operands
            # have one input origin per prior history. Enumerate which input
            # pairs can realize that comparison partition (in either direction).
            depth=2 if a.complete else 3
            selected_history_equalities(e,alternatives,types,depth)
            prefixgroups={}
            for t in range(len(types)):
                prefixgroups.setdefault(tuple(ff[j][t] for j in range(depth)),[]).append(t)
            for prefixhist,grp in prefixgroups.items():
                for opt,prof0 in zip(e.tree_choices[prefixhist],alternatives):
                    prof=[[row[t] for t in types] for row in prof0]
                    domains={}
                    for j in range(depth,7):
                        classes={}
                        for t in grp:
                            h=tuple(prof[q][t] for q in range(j))
                            if None not in h:classes.setdefault(h,[]).append(t)
                        for h,ts in classes.items():
                            constrained=[t for t in ts if prof[j][t] is not None]
                            if not constrained:continue
                            t=ts[0];cv=e.cmpval[j];possible=set();strict=True
                            for u,v in itertools.product(range(5),repeat=2):
                                fs=[(P[types[q]][u]>P[types[q]][v])-(P[types[q]][u]<P[types[q]][v]) for q in constrained]
                                want=[prof[j][q] for q in constrained]
                                if fs==want or fs==[-f for f in want]:
                                    possible.update((u,v));strict &= u!=v;continue
                                mismatch=[(-cv[s][t][b] if (val>>b)&1 else cv[s][t][b])
                                          for s,val in enumerate((u,v)) for b in range(3)]
                                e.cl(-opt,*mismatch)
                            domains[j,h]=(possible,strict)
                        for cut in range(j):
                            coarse={}
                            for h in classes:
                                if (j,h) in domains:coarse.setdefault(h[:cut],[]).append(domains[j,h])
                            cap=2
                            for parts in coarse.values():
                                common=set(range(5))
                                for possible,_ in parts:common &= possible
                                if any(strict for _,strict in parts):cap=min(cap,len(common))
                            limit_early(e,ages,j,cut,cap,(-opt,))
                    for b in range(depth-1,7):
                        groups={}
                        for t in grp:
                            h=tuple(prof[q][t] for q in range(b+1))
                            if None not in h:groups.setdefault(h,[]).append(t)
                        for out in range(5):
                            if any(len({P[types[t]].index(out) for t in ts})>1 for ts in groups.values()):
                                for g in range(e.m):e.cl(-opt,-e.out[out][5+g],-e.blk[g][b])
        if a.stage:
            prof=list(map(int,a.stage.split(',')));assert len(prof)==7 and sum(prof)==m
            g=0
            for b,n in enumerate(prof):
                for q in range(n):e.cl(e.blk[g][b]);g+=1
        print(json.dumps(dict(event='ENC',tag=a.tag,it=it,types=len(types),vars=e.nv,clauses=len(e.cs),elapsed=time.monotonic()-start)),flush=True)
        st,model=solve(e,str(ROOT/'round3/logs'/f'{a.tag}_i{it}'),a.timeout,seed=a.seed)
        print(json.dumps(dict(event='RESULT',tag=a.tag,it=it,status=st,elapsed=time.monotonic()-start)),flush=True)
        if st!='SATISFIABLE':return
        prog=e.decode(model)
        path=ROOT/'round3/programs'/f'{a.tag}_i{it}.s';path.write_text('\n'.join(prog)+'\n')
        # All decoded models are checked by the strict reference judge.
        import subprocess
        jr=subprocess.run(['nice','-n','19','python3',str(ROOT.parents[3]/'shared/judge.py'),str(path),'--strict','--model','out'],capture_output=True,text=True)
        print('JUDGE',jr.stdout,jr.stderr,flush=True)
        from candidate import check
        check(path,jr.stdout+jr.stderr)
        bad=[t for t,ty in enumerate(P) if not simulate(prog,ty)[0]]
        if not bad:
            print('ALL_PERMUTATIONS',str(path),flush=True);return
        print('COUNTEREXAMPLES',len(bad),flush=True)
        types=sorted(set(types+rng.sample(bad,min(12,len(bad)))))

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('--tag',required=True);ap.add_argument('--tree',type=int,default=5);ap.add_argument('--mask',type=int,default=0);ap.add_argument('--adaptive',action='store_true');ap.add_argument('--adaptive-prefix',action='store_true');ap.add_argument('--origin',action='store_true');ap.add_argument('--exact',action='store_true');ap.add_argument('--paired',action='store_true');ap.add_argument('--all',action='store_true');ap.add_argument('--control',action='store_true');ap.add_argument('--union',action='store_true');ap.add_argument('--complete',action='store_true');ap.add_argument('--free-last',action='store_true');ap.add_argument('--free-copy',action='store_true');ap.add_argument('--init',type=int,default=36);ap.add_argument('--timeout',type=int,default=120);ap.add_argument('--seed',type=int,default=42);ap.add_argument('--movbound',type=int);ap.add_argument('--gates',type=int);ap.add_argument('--stage');run(ap.parse_args())
