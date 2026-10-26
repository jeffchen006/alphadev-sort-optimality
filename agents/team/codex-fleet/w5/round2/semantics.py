"""Compare retained comparison structures over all 541 weak orders."""
import hashlib
import itertools
import json
from pathlib import Path

HERE=Path(__file__).resolve().parent
cases=[a for a in itertools.product(range(5),repeat=5) if set(a)==set(range(max(a)+1))]
lookup={a:i for i,a in enumerate(cases)}
maxima=[max(a) for a in cases]
columns=[bytes(a[j] for a in cases) for j in range(5)]
permutations=list(itertools.permutations(range(5)))
maps={}
def mapping(g,reverse):
    key=(g,reverse)
    if key not in maps:
        maps[key]=[lookup[tuple(maxima[t]-a[g[j]] if reverse else a[g[j]] for j in range(5))] for t,a in enumerate(cases)]
    return maps[key]

def comparison_columns(path):
    regs={f'P{i}':columns[i] for i in range(5)}
    flag=(3,)*541
    comparisons=[]
    for line in path.read_text().splitlines():
        line=line.split('#')[0].strip()
        if not line or line.startswith('out '):continue
        op,d,s=line.replace(',','').split()
        a,b=regs.get(d,bytes([7])*541),regs.get(s,bytes([7])*541)
        if op=='cmp':
            comparisons.append((a,b))
            flag=tuple(3 if x==7 or y==7 else 1 if x<y else 2 if x>y else 0 for x,y in zip(a,b))
        elif op=='mov':regs[d]=b
        else:
            active={'cmovl':(1,), 'cmovle':(0,1), 'cmovg':(2,), 'cmovge':(0,2)}[op]
            regs[d]=bytes((x if x==y else 7) if f==3 else y if f in active else x for x,y,f in zip(a,b,flag))
    return comparisons

def canonical(comparisons,selected=None):
    if selected is None:selected=range(541)
    fa=next((i for i,v in enumerate(columns) if v==comparisons[0][0]),None)
    fb=next((i for i,v in enumerate(columns) if v==comparisons[0][1]),None)
    signatures=[]
    for g in permutations:
        if fa is not None and fb is not None and fa!=fb and {g[fa],g[fb]}!={0,1}:continue
        for reverse in (False,True):
            mp=mapping(g,reverse);parts=[]
            for pair in comparisons:
                vals=[bytes(maxima[t]-v[mp[t]] if reverse and v[mp[t]]!=7 else v[mp[t]] for t in selected) for v in pair]
                parts.extend(sorted(vals))
            signatures.append(b''.join(parts))
    return min(signatures)

rows=[];known=set();known_distinct=set();novel={};novel_distinct={}
distinct_cases=[t for t,a in enumerate(cases) if len(set(a))==5]
sources=[Path(row['source']) for row in json.loads((HERE/'manifest.json').read_text())]
for category,paths in [('seed',sources),('walk',sorted((HERE/'verified').glob('walk_*.s')))]:
    for path in paths:
        if path.stem.endswith('_mem'):continue
        comparisons=comparison_columns(path)
        signature=canonical(comparisons)
        distinct_signature=canonical(comparisons,distinct_cases)
        ident=hashlib.sha256(signature).hexdigest()[:24]
        row={'category':category,'file':str(path),'comparisons':len(comparisons),'signature':ident,
             'new_against_seeds':category=='walk' and signature not in known,
             'new_on_distinct_inputs':category=='walk' and distinct_signature not in known_distinct,
             'unknown_comparison_entries':sum(v.count(7) for pair in comparisons for v in pair)}
        rows.append(row)
        if category=='seed':
            known.add(signature);known_distinct.add(distinct_signature)
        else:
            if signature not in known:novel.setdefault(ident,[]).append(str(path))
            if distinct_signature not in known_distinct:
                ident_distinct=hashlib.sha256(distinct_signature).hexdigest()[:24]
                novel_distinct.setdefault(ident_distinct,[]).append(str(path))
summary={'cases':len(cases),'seed_classes':len(known),'new_walk_classes':len(novel),
         'seed_classes_distinct':len(known_distinct),'new_walk_classes_distinct':len(novel_distinct),
         'new_representatives':novel,'new_representatives_distinct':novel_distinct,'rows':rows}
(HERE/'comparison_structures.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='rows'},indent=2))
