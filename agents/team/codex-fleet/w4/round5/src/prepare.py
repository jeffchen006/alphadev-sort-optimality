"""Retain the 112 prepared scopes and add 16 scopes per w6 representative."""
from collections import Counter
import hashlib
import itertools
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT/'round5'
sys.path.insert(0,str(ROOT/'round4/src'))
from analyze import parse, simulate
from analyze_failures import dependencies, CASES
from reference_window import read


def choose(code):
    cones, losses = Counter(), Counter()
    failed = 0
    for x in CASES:
        output,_,_ = simulate(code,x)
        wrong = {j for j in range(5) if output[j] != sorted(x)[j]}
        if not wrong:
            continue
        failed += 1
        outs,traces = dependencies(code,x)
        cones.update(set().union(*(set(outs[j]['dependencies']) for j in wrong)))
        losses.update({t['position'] for t in traces if set(t['lost_goal_indices'])&wrong})
    core = [i for i in code if i[0] != 'out']
    comparisons = {i for i,(op,_,_) in enumerate(core) if op == 'cmp'}
    pool = sorted(set(i for i,_ in cones.most_common(10))|set(i for i,_ in losses.most_common(6)))
    options = [w for w in itertools.combinations(pool,4)
               if set(w)&comparisons and len(set(w)-comparisons)>=2 and w[-1]-w[0]>3]
    score = lambda w:sum(cones[i]+2*losses[i] for i in w)
    chosen, pairs = [],set()
    while options and len(chosen)<16:
        w=max(options,key=lambda v:(sum(p not in pairs for p in itertools.combinations(v,2)),
                                   score(v),tuple(-i for i in v)))
        options.remove(w);chosen.append(list(w));pairs.update(itertools.combinations(w,2))
    return chosen,failed


def main():
    tasks=[];seeds=[]
    for task in json.loads((ROOT/'round4/repair/tasks.json').read_text()):
        task=dict(task,seconds=600,group='recovered')
        original=Path(task['seed']);copy=BASE/'seeds'/original.name
        copy.write_bytes(original.read_bytes())
        task.update(seed=str(copy),seed_sha256=hashlib.sha256(copy.read_bytes()).hexdigest())
        tasks.append(task)
    peer=ROOT.parent/'w6'
    for i,line in enumerate((peer/'round6/artifacts/near_representatives_clean.txt').read_text().splitlines()):
        source=peer/line;copy=BASE/'seeds'/f'w6_rep{i:02d}.s'
        copy.write_bytes(source.read_bytes());code=parse(copy)
        windows,failed=choose(code)
        program,nr=read(copy)
        assert len(program)==31 and len(windows)==16
        row=dict(tag=f'w6_rep{i:02d}',seed=str(copy),source=str(source),
                 sha256=hashlib.sha256(copy.read_bytes()).hexdigest(),k=len(program),
                 failing_weak_orders=failed,registers=nr,windows=windows)
        seeds.append(row)
        for j,w in enumerate(windows):
            tasks.append(dict(tag=f'w6_rep{i:02d}_quad{j:02d}',seed=str(copy),seed_sha256=row['sha256'],
                window=w,registers=nr,seconds=600,group='w6',assumptions=['G1','G2','G3','G4','A2','A11']))
    (BASE/'logs/tasks.json').write_text(json.dumps(tasks,indent=2)+'\n')
    (BASE/'logs/w6_seeds.json').write_text(json.dumps(seeds,indent=2)+'\n')
    print(json.dumps(dict(tasks=len(tasks),groups=dict(Counter(t['group'] for t in tasks)),
                         w6_failures=[s['failing_weak_orders'] for s in seeds])))


if __name__=='__main__':
    main()
