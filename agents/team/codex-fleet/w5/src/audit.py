"""Value traces, CMOV reuse, and symmetry of the comparison/value graph."""
from pathlib import Path
from itertools import product, permutations
import json
import numpy as np

HERE=Path(__file__).resolve().parents[1]
manifest=json.loads((HERE/'seeds/manifest.json').read_text())
cases=np.array([x for x in product(range(5),repeat=5)
                if set(x)==set(range(max(x)+1))],dtype=np.uint8)
index={tuple(x):i for i,x in enumerate(cases)}
maxval=cases.max(axis=1)
involutions=[p for p in permutations(range(5)) if all(p[p[i]]==i for i in range(5))]
maps=[]
for p in involutions:
    mirrored=maxval[:,None]-cases[:,p]
    maps.append(np.array([index[tuple(x)] for x in mirrored]))

def load(path):
    lines=Path(path).read_text().splitlines()
    nr,k=map(int,lines[0].split())
    return nr,[(o,int(a),int(b)) for o,a,b in map(str.split,lines[1:])]

def trace(nr,p):
    r=np.full((nr,541),255,dtype=np.uint8);r[:5]=cases.T
    f=np.full(541,3,dtype=np.uint8)
    hist=[];terms={x.tobytes() for x in r[:5]};comparisons=set()
    for k,(op,d,s) in enumerate(p):
        before=r.copy();flags=f.copy()
        if op=='cmp':
            a,b=r[d].tobytes(),r[s].tobytes()
            comparisons.add(tuple(sorted((a,b))))
            f=np.where((r[d]==255)|(r[s]==255),3,np.where(r[d]<r[s],1,np.where(r[d]>r[s],2,0)))
        elif op=='mov':r[d]=r[s]
        else:
            mask={'cmovl':f==1,'cmovg':f==2,'cmovle':f!=2,'cmovge':f!=1}[op]
            r[d]=np.where(f==3,np.where(r[d]==r[s],r[d],255),np.where(mask,r[s],r[d]))
        if op!='cmp' and np.all(r[d]!=255):terms.add(r[d].tobytes())
        hist.append((before,flags,r.copy()))
    return hist,terms,comparisons

report=[];symmetric=[]
for row in manifest:
    nr,p=load(row['seed']);hist,terms,compares=trace(nr,p)
    cmovs=[]
    for k,((op,d,s),(before,flags,after)) in enumerate(zip(p,hist)):
        if not op.startswith('cmov'):continue
        active={'cmovl':flags==1,'cmovg':flags==2,'cmovle':flags!=2,'cmovge':flags!=1}[op]
        equivalent=[j for j in range(nr) if np.array_equal(before[j],after[d])]
        active_equal=[j for j in range(nr) if np.array_equal(before[j,active],after[d,active])]
        inactive_equal=[j for j in range(nr) if np.array_equal(before[j,~active],after[d,~active])]
        cmovs.append(dict(instruction=k,op=op,dest=d,source=s,active_count=int(active.sum()),
                         existing_result=equivalent,active_equal=active_equal,inactive_equal=inactive_equal,
                         changes=int(np.count_nonzero(before[d]!=after[d]))))
    syms=[]
    for perm,mapping in zip(involutions,maps):
        def dual(t):return (maxval-np.frombuffer(t,dtype=np.uint8)[mapping]).astype(np.uint8).tobytes()
        if all(dual(t) in terms for t in terms):
            cmp_ok=all(tuple(sorted((dual(a),dual(b)))) in compares for a,b in compares)
            syms.append({'input_permutation':perm,'comparison_symmetry':cmp_ok})
    report.append(dict(index=row['index'],source=row['source'],terms=len(terms),comparisons=len(compares),
                       cmovs=cmovs,symmetries=syms))
    if syms:symmetric.append(dict(index=row['index'],symmetries=syms))
    print(row['index'],'terms',len(terms),'cmovs',len(cmovs),'noops',sum(c['changes']==0 for c in cmovs),
          'existing results',sum(bool(c['existing_result']) for c in cmovs),'symmetries',syms,flush=True)
(HERE/'analysis/cmov_audit.json').write_text(json.dumps(report,indent=2)+'\n')
(HERE/'analysis/symmetric_seeds.json').write_text(json.dumps(symmetric,indent=2)+'\n')
