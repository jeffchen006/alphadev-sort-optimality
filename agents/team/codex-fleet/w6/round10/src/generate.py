"""New c10 skeletons: nonlattice c9 seeds plus one delayed flag repeat."""
import ctypes
import hashlib
import itertools
import json
from pathlib import Path
import numpy as np

ROOT=Path('/path/to/repo')
HERE=Path.cwd()
P=np.array(list(itertools.permutations(range(5))),dtype=np.uint8)
lib=ctypes.CDLL(str(HERE/'round10/bin/canon.so'));lib.init()
lib.flagkey.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p]
def key(sk):
    a=np.ascontiguousarray(sk,dtype=np.uint8)
    out=ctypes.create_string_buffer(a.shape[0]*120)
    lib.flagkey(a.ctypes.data,a.shape[0],out)
    return out.raw

def column(s):
    if s.startswith('='):
        if len(s)!=121:raise ValueError('length')
        a=np.frombuffer(s[1:].encode(),dtype=np.uint8)-48
    else:
        a=np.max([np.min(P[:,list(map(int,t))],axis=1) for t in s.split('|')],axis=0)
    if np.max(a)>4:raise ValueError('rank')
    return a
def readsk(fn):
    rows=[]
    for line in fn.read_text().splitlines():
        line=line.split('#')[0].strip()
        if not line:continue
        line=line.split()[0].split(';')[0]
        a,b=line.split(':');rows.append([column(a),column(b)])
    if len(rows)!=10:return None
    return np.array(rows,dtype=np.uint8)

def load(fn):
    names={f'P{i}':i for i in range(5)};code=[]
    for line in fn.read_text().splitlines():
        line=line.split('#')[0].strip()
        if not line or line.startswith('out'):continue
        op,d,s=line.replace(',',' ').split()
        for v in (d,s):names.setdefault(v,len(names))
        code.append((op,names[d],names[s]))
    return code,names
def trace(code,names):
    r=np.full((len(names),120),7,dtype=np.uint8);r[:5]=P.T
    flags=np.zeros(120,dtype=np.int8);rows=[];pool=set();blocks=[]
    for op,d,s in code:
        if op=='cmp':
            if np.max(r[[d,s]])>4:return None
            if rows:blocks.append(set(pool))
            rows.append(r[[d,s]].copy())
            flags=(r[d]>r[s]).astype(np.int8)-(r[d]<r[s]).astype(np.int8)
        elif op=='mov':r[d]=r[s]
        else:
            cond={'cmovl':flags<0,'cmovle':flags<=0,'cmovg':flags>0,'cmovge':flags>=0}[op]
            r[d]=np.where(cond,r[s],r[d])
        for col in r:
            if np.max(col)<=4:pool.add(bytes(col))
    blocks.append(set(pool))
    sk=np.array(rows,dtype=np.uint8)
    if len(sk)!=9:return None
    f=(sk[:,0]>sk[:,1]).astype(np.int8)-(sk[:,0]<sk[:,1]).astype(np.int8)
    if len({bytes(x) for x in f.T})!=120:return None
    return sk,blocks

def main():
    old={};counts={};skipped=0
    folders=[ROOT/'agents/team/codex-fleet/w2/sk',ROOT/'agents/team/d1-skeleton/sk',ROOT/'agents/team/d1-skeleton/skel_out']
    for folder in folders:
        n=0
        if not folder.is_dir():continue
        for fn in sorted(folder.rglob('*.txt')):
            try:sk=readsk(fn)
            except (ValueError,IndexError,UnicodeDecodeError):skipped+=1;continue
            if sk is None:continue
            old.setdefault(key(sk),str(fn));n+=1
        counts[str(folder)]=n
        print('exclusions',folder,n,'classes',len(old),flush=True)
    seeds=[Path(x['file']) for x in json.loads(Path('round6/artifacts/near_inventory.json').read_text())['representatives']]
    seeds += list(Path('round5/verified').glob('*.s'))
    seeds += list(Path('round9/candidates').glob('*out*best_objective.s'))
    sources=[];seen=set();manifest=[];basekeys=set();excluded=0
    def add(fn,code,names,recipe):
        nonlocal excluded
        traced=trace(code,names)
        if traced is None:return
        sk,blocks=traced;bk=key(sk)
        if bk in basekeys:return
        basekeys.add(bk);baseid=len(sources)
        sources.append(dict(seed=str(fn),recipe=recipe,code=code,names=names))
        for j in range(8):
            for pos in range(j+2,10):
                ext=np.insert(sk,pos,sk[j],axis=0);k=key(ext)
                if k in old:excluded+=1;continue
                if k in seen:continue
                seen.add(k);ix=len(manifest)
                dest=Path(f'round10/sk/r{ix:05d}.txt')
                dest.write_text(f'# source={fn} base={baseid} repeat={j} insert={pos}\n'+''.join('='+''.join(map(str,a))+':='+''.join(map(str,b))+'\n' for a,b in ext))
                manifest.append(dict(file=str(dest),seed=str(fn),base=baseid,repeat=j,insert=pos,recipe=recipe,sha256=hashlib.sha256(dest.read_bytes()).hexdigest(),flag_key_sha256=hashlib.sha256(k).hexdigest(),noninput_operands=len(set(bytes(col) for pair in ext for col in pair)-set(bytes(col) for col in P.T))))
    for fn in seeds:
        code,names=load(fn);add(fn,code,names,None)
    Path('round10/artifacts/base_manifest.json').write_text(json.dumps(sources,indent=2))
    Path('round10/artifacts/manifest.json').write_text(json.dumps(manifest,indent=2))
    Path('round10/artifacts/exclusions.json').write_text(json.dumps(dict(folders=counts,flag_classes=len(old),skipped_unreadable=skipped,excluded_generated=excluded,bases=len(sources),queries=len(manifest)),indent=2))
    print('GENERATED',len(manifest),'bases',len(sources),'excluded',excluded,flush=True)

if __name__=='__main__':main()
