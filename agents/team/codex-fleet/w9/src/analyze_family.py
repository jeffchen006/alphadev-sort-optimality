"""Describe sorted pieces at the fifth comparison of every retained c8 seed."""
import itertools,json
from collections import Counter
from pathlib import Path
ROOT=Path('/path/to/repo')
BASE=ROOT/'agents/team/codex-fleet/w6'
CASES=[w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(max(w)+1))]
def read(path):
    p=[]
    for line in path.read_text().splitlines():
        line=line.split('#')[0].replace(',',' ').split()
        if line and line[0]!='out':p.append(tuple(line))
    return p
def state(p):
    names=sorted({r for _,a,b in p for r in (a,b)}|{f'P{i}' for i in range(5)})
    regs={r:tuple(w[int(r[1:])] if r[0]=='P' else 7 for w in CASES) for r in names};flag=(0,)*len(CASES)
    for op,d,s in p:
        a,b=regs[d],regs[s]
        if op=='cmp':flag=tuple((x>y)-(x<y) for x,y in zip(a,b))
        elif op=='mov':regs[d]=b
        else:
            yes=lambda f:f<0 if op=='cmovl' else f<=0 if op=='cmovle' else f>0 if op=='cmovg' else f>=0
            regs[d]=tuple(y if yes(f) else x for x,y,f in zip(a,b,flag))
    return regs,flag
files=sorted(set(BASE.glob('verified/*.s'))|set(BASE.glob('round2/verified/*.s'))|set(BASE.glob('round3/verified/*.s')))
seen=set();rows=[]
for file in files:
    p=read(file)
    if sum(op=='cmp' for op,_,_ in p)!=8 or tuple(p) in seen:continue
    seen.add(tuple(p));at=[i for i,x in enumerate(p) if x[0]=='cmp'][4];r,f=state(p[:at]);pieces=[]
    for pair in itertools.combinations(range(5),2):
        triple=tuple(i for i in range(5) if i not in pair);cols=[]
        for group in (pair,triple):
            for rank in range(len(group)):cols.append(tuple(sorted(w[i] for i in group)[rank] for w in CASES))
        roles=[[reg for reg,col in r.items() if col==goal] for goal in cols]
        if all(roles):pieces.append({'pair':pair,'triple':triple,'roles':roles,'extra_roles':sum(len(v)-1 for v in roles)})
    rows.append({'path':str(file),'prefix_k':at,'suffix_k':len(p)-at,'prefix_counts':dict(Counter(op for op,_,_ in p[:at])),'pieces':pieces})
summary={'programs':len(rows),'pair_triple':sum(bool(x['pieces']) for x in rows),'prefix_lengths':dict(Counter(x['prefix_k'] for x in rows)),'copy_patterns':dict(Counter(str(tuple(len(v) for v in x['pieces'][0]['roles'])) if x['pieces'] else 'none' for x in rows))}
Path('artifacts/family_analysis.json').write_text(json.dumps({'summary':summary,'programs':rows},indent=2)+'\n');print(json.dumps(summary,indent=2))
