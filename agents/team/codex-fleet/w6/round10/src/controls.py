"""Check router output with the strict judge; check its cached bounds."""
import ctypes
import hashlib
import json
import os
from pathlib import Path
import resource
import subprocess
import sys
import time
import numpy as np
import generate as g
from run import verify

resource.setrlimit(resource.RLIMIT_AS,(2800*1024*1024,)*2)
os.environ.update(OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1',ROOTORDER=os.environ.get('CONTROL_ROOTORDER','1'),CHECKLB='1',CHECKCPL='1')
tag=os.environ.get('CONTROL_TAG','')
rows=[]
source=g.ROOT/'agents/team/codex-fleet/w2/programs/control_c10_k33.s'
code,names=g.load(source)
# The general trace routine filters to nine comparisons. Trace this ten-cmp
# control directly, with explicit strict-permutation columns.
r=np.full((len(names),120),7,dtype=np.uint8);r[:5]=g.P.T
flags=np.zeros(120,dtype=np.int8);sk=[]
for op,d,s in code:
    if op=='cmp':
        sk.append(r[[d,s]].copy());flags=(r[d]>r[s]).astype(np.int8)-(r[d]<r[s]).astype(np.int8)
    elif op=='mov':r[d]=r[s]
    else:
        take={'cmovl':flags<0,'cmovle':flags<=0,'cmovg':flags>0,'cmovge':flags>=0}[op]
        r[d]=np.where(take,r[s],r[d])
sk=np.array(sk,dtype=np.uint8)
assert sk.shape==(10,2,120)
control=Path('round10/artifacts/control33.txt')
control.write_text('# Positive control c10 k33; both operand orientations\n'+''.join(';'.join('='+''.join(map(str,x))+':='+''.join(map(str,y)) for x,y in ((a,b),(b,a)))+'\n' for a,b in sk))
for name,engine in [('fast','round10/bin/dagx_flags_fast'),('safe','round10/bin/dagx_flags_safe')]:
    log=Path(f'round10/logs/control33_{name}{tag}.log');cmd=[engine,str(control),'33','1']
    t=time.monotonic();status='UNKNOWN_TIMEOUT';rc=None
    with log.open('w') as f:
        try:
            p=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,timeout=120)
            rc=p.returncode;status='FOUND' if 'RESULT FOUND' in log.read_text() and rc==0 else 'ERROR'
        except subprocess.TimeoutExpired:pass
    row=dict(name=name,engine=engine,command=cmd,status=status,exit_code=rc,log=str(log),wall_seconds=time.monotonic()-t)
    if status=='FOUND':row['judges']=verify(log,f'control33_{name}{tag}')
    rows.append(row)
    Path(f'round10/artifacts/controls{tag}.json').write_text(json.dumps(rows,indent=2))
    print(name,status,row['wall_seconds'],flush=True)

# Independent permutation-map controls for both duplicate filters.
lib=g.lib;lib.operandkey.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p]
def opkey(x):
    x=np.ascontiguousarray(x);out=ctypes.create_string_buffer(240*len(x))
    lib.operandkey(x.ctypes.data,len(x),out);return out.raw
baseflag=g.key(sk);baseop=opkey(sk);checks=0
perms=[tuple(p) for p in g.P];index={p:i for i,p in enumerate(perms)}
for perm in perms:
    lookup=[index[tuple(p[i] for i in perm)] for p in perms]
    renamed=sk[:,:,lookup]
    assert g.key(renamed)==baseflag
    assert opkey(renamed)==baseop
    checks+=2
for j in range(10):
    changed=sk.copy();changed[j]=changed[j,::-1]
    assert g.key(changed)==baseflag
    assert opkey(changed)==baseop
    checks+=2
dual=4-sk[:,:,::-1]
assert opkey(dual)==baseop;checks+=1
Path('round10/artifacts/canonical_controls.json').write_text(json.dumps(dict(checks=checks,status='MATCH',source=str(source)),indent=2))
print('canonical controls MATCH',checks,flush=True)
