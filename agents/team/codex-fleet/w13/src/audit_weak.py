"""Check saved source recipes on all weak input orders. No instruction claim."""
import argparse,collections,json,os
from pathlib import Path
from audit import recipe,evaluate,PERMS,WEAK

def main():
    p=argparse.ArgumentParser();p.add_argument('manifests',nargs='+');p.add_argument('--tag',required=True);a=p.parse_args()
    if os.nice(0)<10:os.nice(10-os.nice(0))
    rows=[];bad=[];counts=collections.Counter()
    for mf in a.manifests:
        for line in Path(mf).read_text().splitlines():
            row=json.loads(line);steps,_=recipe(row['file'])
            _,strict,_=evaluate(steps,PERMS[:1]);layout=strict[0]
            _,weak,_=evaluate(steps,WEAK)
            failure=next(((ty,end) for ty,end in zip(WEAK,weak) if any(end[i]>end[j] for i in range(5) for j in range(5) if layout[i]<layout[j])),None)
            counts['sources']+=1;counts['weak_cases']+=len(WEAK)
            if failure:bad.append(dict(file=row['file'],input=failure[0],final=failure[1],layout=layout))
    result=dict(counts=counts,bad=bad)
    Path('logs',a.tag+'.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)

if __name__=='__main__':main()
