"""Check every saved SAT model; retain every distinct <=6 failure program."""
from pathlib import Path
import json,os,resource,subprocess,sys,time
os.environ.update(OMP_NUM_THREADS='1',OPENBLAS_NUM_THREADS='1',PYTHONDONTWRITEBYTECODE='1')
resource.setrlimit(resource.RLIMIT_AS,(2800*1024*1024,)*2)
HERE=Path(__file__).resolve().parents[2];ROOT=HERE.parents[3]
sys.path[:0]=[str(HERE/'src'),str(HERE/'round3/src'),str(ROOT/'agents/sat')]
from encode import Enc
from window_sat import read,concrete,OPS,GOALS
from satrep import emit

queries=json.loads(Path('round8/artifacts/sat_ledger.json').read_text())
models=0;unique=set();retained=[];began=time.monotonic();hist={}
for row in queries:
    p,nr=read(row['source'])
    e=Enc(5,len(p),R=nr,iset='I1',outmode='snap',rules=())
    for log in sorted(Path('round8/candidates').glob(row['name']+'.iter*.kissat.log')):
        text=log.read_text()
        if 's SATISFIABLE' not in text:continue
        models+=1
        model=[int(x) for line in text.splitlines() if line.startswith('v ') for x in line.split()[1:] if x!='0']
        cand,_=e.decode(model);q=[(OPS.index(o),d,s) for o,d,s in cand]
        key=tuple(q)
        if key in unique:continue
        unique.add(key)
        columns,_=concrete(q,nr)
        nearest=[min(columns,key=lambda c:sum(x!=y for x,y in zip(c[2],g))) for g in GOALS]
        errors=[sum(x!=y for x,y in zip(c[2],g)) for c,g in zip(nearest,GOALS)]
        failed=sum(any(nearest[j][2][t]!=GOALS[j][t] for j in range(5)) for t in range(541))
        hist[failed]=hist.get(failed,0)+1
        if failed>6:continue
        path=Path('round8/candidates',f'mined_le6_{len(retained):04d}.s')
        emit(q,[(t,r) for t,r,c in nearest],path)
        subprocess.run(['nice','-n','19','python3','-B','round8/src/verify.py',str(path)],check=True)
        retained.append(dict(file=str(path),failed_orders=failed,error_sum=sum(errors),source_model=str(log)))

summary=dict(models=models,unique_programs=len(unique),failure_histogram=hist,
             retained=retained,seconds=time.monotonic()-began)
Path('round8/artifacts/mined_models.json').write_text(json.dumps(summary,indent=2))
print(json.dumps(summary,indent=2))
