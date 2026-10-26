#!/usr/bin/env python3
"""Round-2 exact SSA experiments. Each run uses one single-threaded SAT solver."""
import argparse,itertools,json,random,sys,time
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'src'))
from trees import trees
from mixed import logs as oldlogs
from ssa_orient import Enc,P,solve,simulate
ROOT=Path(__file__).resolve().parents[2]

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

def run(a):
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
              copybound=(24-a.gates if a.gates else None),movbound=a.movbound,
              alternatives=[[[row[t] for t in types] for row in prof] for prof in alternatives] if alternatives else None,
              prefixdepth=2 if a.complete else 3)
        if a.stage:
            prof=list(map(int,a.stage.split(',')));assert len(prof)==7 and sum(prof)==m
            g=0
            for b,n in enumerate(prof):
                for q in range(n):e.cl(e.blk[g][b]);g+=1
        print(json.dumps(dict(event='ENC',tag=a.tag,it=it,types=len(types),vars=e.nv,clauses=len(e.cs),elapsed=time.monotonic()-start)),flush=True)
        st,model=solve(e,str(ROOT/'round2/logs'/f'{a.tag}_i{it}'),a.timeout,seed=a.seed)
        print(json.dumps(dict(event='RESULT',tag=a.tag,it=it,status=st,elapsed=time.monotonic()-start)),flush=True)
        if st!='SATISFIABLE':return
        prog=e.decode(model)
        path=ROOT/'round2/programs'/f'{a.tag}_i{it}.s';path.write_text('\n'.join(prog)+'\n')
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
    ap=argparse.ArgumentParser();ap.add_argument('--tag',required=True);ap.add_argument('--tree',type=int,default=5);ap.add_argument('--mask',type=int,default=0);ap.add_argument('--adaptive',action='store_true');ap.add_argument('--adaptive-prefix',action='store_true');ap.add_argument('--origin',action='store_true');ap.add_argument('--exact',action='store_true');ap.add_argument('--paired',action='store_true');ap.add_argument('--all',action='store_true');ap.add_argument('--control',action='store_true');ap.add_argument('--union',action='store_true');ap.add_argument('--complete',action='store_true');ap.add_argument('--free-last',action='store_true');ap.add_argument('--init',type=int,default=36);ap.add_argument('--timeout',type=int,default=120);ap.add_argument('--seed',type=int,default=42);ap.add_argument('--movbound',type=int);ap.add_argument('--gates',type=int);ap.add_argument('--stage');run(ap.parse_args())
