#!/usr/bin/env python3
"""New operand orientations and outcome-dependent second pairs; two CPU jobs."""
import concurrent.futures,hashlib,itertools,json,random,subprocess,sys,time
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent))
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'src'))
from experiments import skeleton
from trees import trees
from batch_dag import key
ROOT=Path(__file__).resolve().parents[2]

def generate():
    seen=set()
    for d in ['sk','sk/mixed','sk/phase']:
        for fn in (ROOT/d).glob('*.txt'):
            try:seen.add(key(fn))
            except Exception:pass
    jobs=[];rng=random.Random(20261025)
    ts=trees(tuple(range(15)),4)
    for adaptive in [True,False]:
      for mask in (range(16) if adaptive else [0,6,8,10,12]):
       for ti,tr in enumerate(ts):
        base=skeleton(tr,mask,adaptive)
        F=[[(a>b)-(a<b) for a,b in row] for row in base]
        for pattern in ['same','first','second','third','xor12','xor13','xor23','xor123','random0','random1']:
            ob=[[tuple(pair) for pair in row] for row in base]
            flips={}
            for j in range(1,7):
                for t in range(120):
                    hist=tuple(F[q][t] for q in range(j))
                    if pattern.startswith('random'):
                        if (j,hist) not in flips:flips[j,hist]=rng.randrange(2)
                        flip=flips[j,hist]
                    else:
                        bits={'same':[],'first':[0],'second':[1],'third':[2],'xor12':[0,1],'xor13':[0,2],'xor23':[1,2],'xor123':[0,1,2]}[pattern]
                        flip=sum(F[q][t]>0 for q in bits if q<j)%2
                    if flip:ob[j][t]=tuple(reversed(ob[j][t]))
            name=f"{'adaptive' if adaptive else 'fixed'}_m{mask}_t{ti}_{pattern}"
            text='# round2 outcome-dependent operand orientation\n'+''.join('='+''.join(str(a) for a,b in row)+':='+''.join(str(b) for a,b in row)+'\n' for row in ob)
            fn=ROOT/'round2/sk'/f'{name}.txt';fn.write_text(text)
            sig=key(fn)
            if sig in seen:fn.unlink();continue
            seen.add(sig);jobs.append(fn)
    return jobs

def main():
    start=time.monotonic();jobs=generate()
    print(json.dumps(dict(event='GENERATED',jobs=len(jobs))),flush=True)
    def run(fn):
        log=ROOT/'round2/logs'/f'{fn.stem}.dag'
        if log.exists():return {'skip':str(fn)}
        with log.open('w') as f:
            p=subprocess.run(['nice','-n','19','timeout','35',str(ROOT/'src/dagx'),str(fn),'31','1','400000'],stdout=f,stderr=subprocess.STDOUT)
        lines=log.read_text().splitlines()
        result=lines[-1] if lines else 'EMPTY'
        return dict(file=str(fn.relative_to(ROOT)),rc=p.returncode,result=result,elapsed=round(time.monotonic()-start,2))
    with concurrent.futures.ThreadPoolExecutor(max_workers=int(sys.argv[1]) if len(sys.argv)>1 else 2) as ex:
        for res in ex.map(run,jobs):print(json.dumps(res),flush=True)
if __name__=='__main__':main()
