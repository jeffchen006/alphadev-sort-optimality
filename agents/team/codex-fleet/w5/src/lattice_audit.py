"""Check whether each comparison operand is a min/max expression of inputs.

For each operand, form its candidate max-of-mins expression from Boolean
inputs. Then evaluate that expression on all 541 weak orders. A mismatch
shows that this operand is not that expression. A mismatch with the unique
Boolean candidate excludes every min/max expression for that operand.
"""
from pathlib import Path
from itertools import product
import numpy as np
import json,sys

cases=np.array([a for a in product(range(5),repeat=5) if set(a)==set(range(max(a)+1))],dtype=np.uint8)
idx={tuple(a):i for i,a in enumerate(cases)}
lines=Path(sys.argv[1]).read_text().splitlines();nr,k=map(int,lines[0].split())
r=np.full((nr,541),255,dtype=np.uint8);r[:5]=cases.T;f=np.full(541,3)
def classify(v):
    if np.any(v==255):return {'kind':'unknown'}
    truth=[False]*32;truth[31]=True
    for mask in range(1,31):truth[mask]=bool(v[idx[tuple((mask>>i)&1 for i in range(5))]])
    mins=[mask for mask in range(1,32) if truth[mask] and not any(truth[sub] and sub!=mask and sub&mask==sub for sub in range(1,32))]
    ev=np.zeros(541,dtype=np.uint8)
    for mask in mins:ev=np.maximum(ev,cases[:,[i for i in range(5) if mask>>i&1]].min(axis=1))
    bad=np.flatnonzero(v!=ev)
    if len(bad):
        t=int(bad[0]);return {'kind':'not_minmax','case':cases[t].tolist(),'actual':int(v[t]),'candidate_minmax':int(ev[t])}
    return {'kind':'minmax','dnf_masks':mins}
report=[]
for k,line in enumerate(lines[1:]):
    op,d,s=line.split();d=int(d);s=int(s)
    if op=='cmp':
        report.append({'instruction':k,'dest':d,'source':s,'dest_type':classify(r[d]),'source_type':classify(r[s])})
        f=np.where((r[d]==255)|(r[s]==255),3,np.where(r[d]<r[s],1,np.where(r[d]>r[s],2,0)))
    elif op=='mov':r[d]=r[s]
    else:
        mask={'cmovl':f==1,'cmovle':f!=2,'cmovg':f==2,'cmovge':f!=1}[op]
        r[d]=np.where(f==3,np.where(r[d]==r[s],r[d],255),np.where(mask,r[s],r[d]))
print(json.dumps(report,indent=2))
