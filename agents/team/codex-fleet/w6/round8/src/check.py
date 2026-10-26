"""Compare saved snapshot scores with an independent scalar executor."""
from pathlib import Path
import itertools,json,re,subprocess

cases=[a for a in itertools.product(range(5),repeat=5) if set(a)==set(range(max(a)+1))]
assert len(cases)==541

def parse(path):
    result=[]
    for line in Path(path).read_text().splitlines():
        line=line.split('#')[0].strip()
        if line:result.append(tuple(line.replace(',',' ').split()))
    return result

def evaluate(path):
    instructions=parse(path);failed=errors=0
    for inputs in cases:
        vals={f'P{i}':v for i,v in enumerate(inputs)};outputs=[None]*5;flag=None
        for op,d,s in instructions:
            if op=='out':outputs[int(d)]=vals.get(s,7);continue
            a,b=vals.get(d,7),vals.get(s,7)
            if op=='cmp':
                flag=0 if d==s else None if 7 in (a,b) else (a>b)-(a<b)
            elif op=='mov':vals[d]=b
            elif flag is None:vals[d]=a if a==b else 7
            else:
                take={'cmovl':flag<0,'cmovle':flag<=0,'cmovg':flag>0,'cmovge':flag>=0}[op]
                vals[d]=b if take else a
        wrong=[a!=b for a,b in zip(outputs,sorted(inputs))]
        failed+=any(wrong);errors+=sum(wrong)
    return failed,errors

files=sorted(Path('round8/candidates').glob('failure*_near.s'))+sorted(Path('round8/candidates').glob('failure*_le6_*.s'))
rows=[]
for f in files:
    header=f.read_text().splitlines()[0]
    reported=tuple(int(re.search(key+r'=(\d+)',header).group(1)) for key in ('weak_fail','weak_error_sum'))
    observed=evaluate(f)
    assert reported==observed,(str(f),reported,observed)
    rows.append(dict(file=str(f),failed_orders=observed[0],output_errors=observed[1]))
Path('round8/artifacts/score_check.json').write_text(json.dumps(dict(status='MATCH',files=len(rows),cases_per_file=541,records=rows),indent=2))
print(json.dumps(dict(status='MATCH',files=len(rows),cases_per_file=541)))
