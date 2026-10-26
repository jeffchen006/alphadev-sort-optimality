"""Decode retained solver models and keep new comparison fingerprints at <=10 errors."""
from pathlib import Path
import hashlib,itertools,json,os,resource,subprocess,sys,time
os.environ.update(OMP_NUM_THREADS='1',OPENBLAS_NUM_THREADS='1',PYTHONDONTWRITEBYTECODE='1')
resource.setrlimit(resource.RLIMIT_AS,(2800*1024*1024,)*2)
HERE=Path(__file__).resolve().parents[2];ROOT=HERE.parents[3]
sys.path[:0]=[str(HERE/'src'),str(HERE/'round3/src'),str(ROOT/'agents/sat')]
import numpy as np
from encode import Enc
from window_sat import read,concrete,OPS,GOALS,CASES
from satrep import emit

strict=[i for i,x in enumerate(CASES) if len(set(x))==5]
perms=np.asarray([CASES[i] for i in strict],dtype=np.int16)
index={tuple(p):i for i,p in enumerate(perms)}
transforms=[np.array([index[tuple((4-p if rev else p)[list(s)])] for p in perms])
            for rev in range(2) for s in itertools.permutations(range(5))]
def fingerprint(program,states):
    cols=[]
    for i,(op,d,s) in enumerate(program):
        if op==1:
            rs=states[i][0]
            cols.append(np.array([[255 if rs[r][t] is None else rs[r][t] for t in strict] for r in (d,s)],dtype=np.uint8))
    best=None
    for n,mp in enumerate(transforms):
        out=[]
        for c in cols:
            x=c[:,mp]
            if n>=120:x=4-x
            a,b=x[0].tobytes(),x[1].tobytes();out.append(min(a,b)+max(a,b))
        key=b''.join(out)
        if best is None or key<best:best=key
    return hashlib.sha256(best).hexdigest()[:24]

began=time.monotonic()
old=json.loads(Path('round6/artifacts/near_inventory.json').read_text())['representatives']
old_signatures={r['signature'] for r in old}
queries=json.loads(Path('round7/artifacts/query_ledger.json').read_text())
if Path('round7/artifacts/refined_ledger.json').exists():queries+=json.loads(Path('round7/artifacts/refined_ledger.json').read_text())
models=0;low=0;classes={};unique=set();new={}
for row in queries:
    p,nr=read(row['source'])
    e=Enc(5,len(p),R=nr,iset='I1',outmode='snap',rules=()) # structural variables precede every case variable
    for log in sorted(Path('round7/candidates').glob(row['name']+'.iter*.kissat.log')):
        text=log.read_text()
        if 's SATISFIABLE' not in text:continue
        models+=1
        model=[int(x) for line in text.splitlines() if line.startswith('v ') for x in line.split()[1:] if x!='0']
        cand,_=e.decode(model);q=[(OPS.index(o),d,s) for o,d,s in cand]
        key=tuple(q)
        if key in unique:continue
        unique.add(key)
        columns,states=concrete(q,nr)
        nearest=[min(columns,key=lambda c:sum(x!=y for x,y in zip(c[2],g))) for g in GOALS]
        errors=[sum(x!=y for x,y in zip(c[2],g)) for c,g in zip(nearest,GOALS)]
        failed=sum(any(nearest[j][2][t]!=GOALS[j][t] for j in range(5)) for t in range(541))
        if failed>10:continue
        low+=1
        sig=fingerprint(q,states)
        classes[sig]=classes.get(sig,0)+1
        if sig in old_signatures:continue
        data=dict(source_model=str(log),source_seed=row['source'],failed_orders=failed,error_sum=sum(errors),signature=sig)
        if sig not in new or (failed,sum(errors))<(new[sig][0]['failed_orders'],new[sig][0]['error_sum']):
            new[sig]=(data,q,[(t,r) for t,r,c in nearest])
retained=[]
for sig,(data,q,witnesses) in sorted(new.items()):
    path=Path('round7/candidates','mined_'+sig+'.s');emit(q,witnesses,path)
    data['file']=str(path)
    subprocess.run(['nice','-n','19','python3','-B','round7/src/verify.py',str(path)],check=True)
    retained.append(data)
summary=dict(models=models,unique_programs=len(unique),low_error_programs=low,low_error_classes=len(classes),
             new_classes=len(new),representatives=retained,seconds=time.monotonic()-began)
Path('round7/artifacts/mined_models.json').write_text(json.dumps(summary,indent=2))
print(json.dumps(summary,indent=2))
