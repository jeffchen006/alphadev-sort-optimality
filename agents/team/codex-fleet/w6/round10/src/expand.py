"""Preserve operand-distinct c9 structures and change repeat operands."""
import ctypes
import hashlib
import itertools
import json
from pathlib import Path
import numpy as np
import generate as g

lib=g.lib
lib.operandkey.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p]
def opkey(sk):
    a=np.ascontiguousarray(sk,dtype=np.uint8);out=ctypes.create_string_buffer(a.shape[0]*240)
    lib.operandkey(a.ctypes.data,a.shape[0],out)
    return out.raw
def masks(a,b):
    f=(a>b).astype(np.int8)-(a<b).astype(np.int8)
    return frozenset(bytes(x) for x in (f<0,f>0,f<=0,f>=0) if not np.all(x) and np.any(x))
def explicit(c):return '='+''.join(map(str,c))

def main():
    out=Path('round10/sk_expanded');out.mkdir(exist_ok=True)
    seeds=[Path(x['file']) for x in json.loads(Path('round6/artifacts/near_inventory.json').read_text())['representatives']]
    seeds+=list(Path('round5/verified').glob('*.s'))
    # Recover all exact old exclusion keys from the raw exclusion files.
    oldflag=set()
    for folder in [g.ROOT/'agents/team/codex-fleet/w2/sk',g.ROOT/'agents/team/d1-skeleton/sk']:
        for fn in sorted(folder.rglob('*.txt')):
            try:sk=g.readsk(fn)
            except (ValueError,IndexError,UnicodeDecodeError):continue
            if sk is not None:oldflag.add(g.key(sk))
    prior=json.loads(Path('round10/artifacts/manifest.json').read_text())
    seen={opkey(g.readsk(Path(x['file']))) for x in prior}
    sources=[];basekeys=set();records=[];excluded=0
    for fn in seeds:
        code,names=g.load(fn);t=g.trace(code,names)
        if t is None:continue
        sk,pools=t;bk=opkey(sk)
        if bk in basekeys:continue
        basekeys.add(bk);base=len(sources);sources.append(str(fn))
        for repeat in range(8):
            a,b=sk[repeat];wanted=masks(a,b)
            for pos in range(repeat+2,10):
                ext=np.insert(sk,pos,sk[repeat],axis=0)
                if g.key(ext) in oldflag:excluded+=1;continue
                # Exact column pair: retain operand distinctions omitted in pass 1.
                ok=opkey(ext)
                if ok not in seen:
                    seen.add(ok);dest=out/f'e{len(records):05d}.txt'
                    dest.write_text(f'# exact source={fn} repeat={repeat} insert={pos}\n'+''.join(explicit(x)+':'+explicit(y)+'\n' for x,y in ext))
                    records.append(dict(file=str(dest),seed=str(fn),base=base,repeat=repeat,insert=pos,kind='operand_distinct_exact',sha256=hashlib.sha256(dest.read_bytes()).hexdigest()))
                # Recreate the flag partition with different operand columns.
                # All pool columns were present at or before this insertion.
                columns=[np.frombuffer(x,dtype=np.uint8) for x in sorted(pools[pos-1])]
                alts=[];keys=set()
                for x,y in itertools.combinations(columns,2):
                    if {bytes(x),bytes(y)}=={bytes(a),bytes(b)}:continue
                    if masks(x,y)!=wanted:continue
                    newer=ext.copy();newer[pos]=[x,y];k=opkey(newer)
                    if k in seen or k in keys:continue
                    keys.add(k);alts.append((x,y))
                if not alts:continue
                seen.update(keys);dest=out/f'e{len(records):05d}.txt'
                lines=[]
                for j,(x,y) in enumerate(ext):
                    if j==pos:lines.append(';'.join(explicit(u)+':'+explicit(v) for u,v in alts))
                    else:lines.append(explicit(x)+':'+explicit(y))
                dest.write_text(f'# transformed source={fn} repeat={repeat} insert={pos} alternatives={len(alts)}\n'+'\n'.join(lines)+'\n')
                records.append(dict(file=str(dest),seed=str(fn),base=base,repeat=repeat,insert=pos,kind='transformed_repeat_operands',alternatives=len(alts),sha256=hashlib.sha256(dest.read_bytes()).hexdigest()))
        print('expanded base',base,fn,'queries',len(records),flush=True)
    Path('round10/artifacts/expanded_manifest.json').write_text(json.dumps(records,indent=2))
    Path('round10/artifacts/expanded_generation.json').write_text(json.dumps(dict(sources=sources,bases=len(sources),queries=len(records),oldflag_classes=len(oldflag),excluded=excluded,comparison_alternatives=sum(r.get('alternatives',1) for r in records)),indent=2))
    print('EXPANDED',len(records),'bases',len(sources),flush=True)

if __name__=='__main__':main()
