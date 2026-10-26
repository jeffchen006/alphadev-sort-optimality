"""Trace CMOV value reuse on the round-2 seeds using all weak orders."""
import itertools
import json
from pathlib import Path

HERE=Path(__file__).resolve().parent
cases=[a for a in itertools.product(range(5), repeat=5) if set(a)==set(range(max(a)+1))]
report=[]
for row in json.loads((HERE/'manifest.json').read_text()):
    lines=Path(row['seed']).read_text().splitlines()
    nr,k=map(int,lines[0].split())
    regs=[tuple(a[r] for a in cases) if r<5 else (7,)*541 for r in range(nr)]
    flags=(3,)*541
    cmovs=[]
    for at,line in enumerate(lines[1:]):
        op,d,s=line.split();d=int(d);s=int(s)
        a,b=regs[d],regs[s]
        if op=='cmp':
            flags=tuple(3 if x==7 or y==7 else 1 if x<y else 2 if x>y else 0 for x,y in zip(a,b))
            continue
        if op=='mov':regs[d]=b;continue
        active={'cmovl':(1,), 'cmovle':(0,1), 'cmovg':(2,), 'cmovge':(0,2)}[op]
        val=tuple((x if x==y else 7) if f==3 else y if f in active else x for x,y,f in zip(a,b,flags))
        cmovs.append({'at':at,'op':op,'dest':d,'source':s,
                      'changes':sum(x!=y for x,y in zip(a,val)),
                      'existing_result':[r for r,v in enumerate(regs) if v==val],
                      'partial_scratch':7 in val})
        regs[d]=val
    report.append({**row,'k':k,'registers':nr,'cmovs':cmovs})
(HERE/'cmov_audit.json').write_text(json.dumps(report,indent=2)+'\n')
print('seeds',len(report),'cmovs',sum(len(r['cmovs']) for r in report),
      'noops',sum(c['changes']==0 for r in report for c in r['cmovs']),
      'reused_results',sum(bool(c['existing_result']) for r in report for c in r['cmovs']))
for r in report:
    for c in r['cmovs']:
        if c['existing_result']:print(r['index'],c)
