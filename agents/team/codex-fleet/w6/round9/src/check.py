"""Independent scalar checks for emitted programs and objective values."""
from pathlib import Path
import itertools,json,random,re,subprocess,sys

CASES=[x for x in itertools.product(range(5),repeat=5) if set(x)==set(range(max(x)+1))]
assert len(CASES)==541

def parse(path):
    return [tuple(s.replace(',',' ').split()) for line in Path(path).read_text().splitlines()
            if (s:=line.split('#')[0].strip())]

def inspect(path,focus_inputs,weights):
    text=Path(path).read_text();head=text.splitlines()[0]
    memory='model=mem' in head;instructions=parse(path)
    result=dict(weak_fail=0,weak_error_sum=0,focus_fail=0,median_error=0,median_lost=0)
    failure_inputs=[]
    for inputs in CASES:
        values={f'P{i}':x for i,x in enumerate(inputs)};flag=None;outputs=[7]*5
        for op,d,s in instructions:
            if op=='out':outputs[int(d)]=values.get(s,7);continue
            a,b=values.get(d,7),values.get(s,7)
            if memory:
                assert op=='mov' or d.startswith('S') and s.startswith('S')
                assert op!='mov' or not(d.startswith('P') and s.startswith('P'))
            if op=='cmp':flag=0 if d==s else None if 7 in (a,b) else (a>b)-(a<b)
            elif op=='mov':values[d]=b
            elif flag is None:values[d]=a if a==b else 7
            else:
                take={'cmovl':flag<0,'cmovle':flag<=0,'cmovg':flag>0,'cmovge':flag>=0}[op]
                values[d]=b if take else a
        if memory:outputs=[values[f'P{i}'] for i in range(5)]
        goal=sorted(inputs);wrong=[a!=b for a,b in zip(outputs,goal)];failed=any(wrong)
        lost=wrong[2] and goal[2] not in values.values()
        result['weak_fail']+=failed;result['weak_error_sum']+=sum(wrong)
        result['focus_fail']+=failed and inputs in focus_inputs
        result['median_error']+=wrong[2];result['median_lost']+=lost
        if failed:failure_inputs.append(inputs)
    fw,mw,lw=weights
    result['fitness']=result['weak_fail']+(fw-1)*result['focus_fail']+mw*result['median_error']+lw*result['median_lost']+.001*result['weak_error_sum']
    for key,value in result.items():
        reported=float(re.search(r'\b'+key+r'=([\d.]+)',head).group(1))
        assert abs(value-reported)<1e-7,(str(path),key,value,reported)
    return dict(file=str(path),**result,failure_inputs=failure_inputs)

def smoke():
    inv=json.loads(Path('round6/artifacts/near_inventory.json').read_text())['representatives'];rows=[]
    rng=random.Random(9501)
    for mode in ('out','mem'):
        for index in range(30):
            source=Path(inv[index%15]['file' if mode=='out' else 'source'])
            p=[i for i in parse(source) if i[0]!='out']
            registers=sorted({r for _,d,s in p for r in (d,s)})
            scratch=[r for r in registers if r.startswith('S')]
            if index>=15:
                for _ in range(1+index%5):
                    at=rng.randrange(len(p));op=rng.choice(('mov','cmp','cmovl','cmovle','cmovg','cmovge'))
                    rr=registers if mode=='out' or op=='mov' else scratch
                    d,s=rng.choices(rr,k=2)
                    if mode=='mem' and op=='mov' and d.startswith('P') and s.startswith('P'):s=rng.choice(scratch)
                    p[at]=(op,d,s)
            seed=Path(f'round9/artifacts/check_{mode}_{index:02d}.s')
            seed.write_text('\n'.join(f'{op} {d}, {s}' for op,d,s in p)+'\n')
            prefix=seed.with_suffix('');log=seed.with_suffix('.log')
            command=['nice','-n','19','round9/bin/weighted',str(seed),str(prefix),mode,'0',str(9501+index),'2','4','2','4','2']
            r=subprocess.run(command,capture_output=True,text=True,check=True);log.write_text(r.stdout+r.stderr)
            focus_line=next(l for l in r.stderr.splitlines() if l.startswith('FOCUS inputs='))
            focus={tuple(map(int,s)) for s in focus_line.split('=')[1].split(',') if s}
            for suffix in ('_best_fail.s','_best_objective.s'):
                rows.append(inspect(str(prefix)+suffix,focus,(4,2,4)))
    result=dict(status='MATCH',files=len(rows),cases_per_file=541,records=rows)
    Path('round9/artifacts/scorer_controls.json').write_text(json.dumps(result,indent=2))
    print(json.dumps(dict(status='MATCH',files=len(rows),cases_per_file=541)))

if __name__=='__main__':smoke()
