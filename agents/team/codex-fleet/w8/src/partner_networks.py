#!/usr/bin/env python3
"""Enumerate six-comparator completions after a partner-carry prefix."""
import itertools, json, collections, time
from pathlib import Path

P=list(itertools.permutations(range(5)))
PAIRS=list(itertools.combinations(range(5),2))
INPUTS={tuple(p[i] for p in P) for i in range(5)}

def lattice(col):
    tab={0:False,31:True}
    for p,v in zip(P,col):
        for t in range(1,5):
            m=sum(1<<i for i,x in enumerate(p) if x>=t)
            b=v>=t
            if m in tab and tab[m]!=b:return False
            tab[m]=b
    return all(not tab[m] or tab[m|1<<i] for m in range(32) for i in range(5))

def prefix(mode):
    states=[]; operands=[([],[]) for _ in range(3)]
    for p in P:
        q=list(p)
        for j,(a,b) in enumerate(((0,1),(2,3))):
            operands[j][0].append(q[a]);operands[j][1].append(q[b])
            if q[a]>q[b]:q[a],q[b]=q[b],q[a]
        a,b=(1,3) if mode=='max' else (0,2)
        operands[2][0].append(q[a]);operands[2][1].append(q[b])
        if q[a]>q[b]:q[0],q[2]=q[2],q[0];q[1],q[3]=q[3],q[1]
        states.append(tuple(q))
    return states,[(tuple(a),tuple(b)) for a,b in operands]

def main():
    out=Path('sk/partner');out.mkdir(parents=True,exist_ok=True)
    manifest=[]; counts=collections.Counter();seen=set();start=time.monotonic()
    for mode in ('max','min'):
        full,pre=prefix(mode);states=tuple(sorted(set(full)))
        def rec(st,seq):
            counts['nodes']+=1
            left=6-len(seq)
            if len(st)>(1<<left):return
            if not left:
                if len(st)!=1:return
                counts['completions']+=1
                cols=full[:];sk=pre[:]
                for a,b in seq:
                    sk.append((tuple(p[a] for p in cols),tuple(p[b] for p in cols)))
                    cols=[tuple(min(p[a],p[b]) if i==a else max(p[a],p[b]) if i==b else p[i] for i in range(5)) for p in cols]
                key=tuple(tuple(sorted(pair)) for pair in sk)
                if key in seen:counts['duplicates']+=1;return
                seen.add(key)
                required={c for pair in sk for c in pair}|{(i,)*120 for i in range(5)}
                noninput=len(required-INPUTS)
                nl=sum(not lattice(c) for c in required)
                counts['required_%d'%noninput]+=1
                if not nl:counts['lattice_only']+=1;return
                if noninput>22:counts['too_many_required']+=1;return
                idx=len(manifest);file=out/f'p{idx:06d}.txt'
                file.write_text('# partner-carry '+mode+' suffix='+str(seq)+'\n'+'\n'.join('='+''.join(map(str,a))+':='+''.join(map(str,b)) for a,b in sk)+'\n')
                manifest.append(dict(file=str(file),mode=mode,suffix=seq,required=noninput,nonlattice=nl))
                return
            for ix,(a,b) in enumerate(PAIRS):
                if seq and not set(seq[-1])&{a,b} and seq[-1]>(a,b):continue
                ns=tuple(sorted({tuple(min(p[a],p[b]) if i==a else max(p[a],p[b]) if i==b else p[i] for i in range(5)) for p in st}))
                if ns==st:continue
                rec(ns,seq+[(a,b)])
        rec(states,[])
    Path('sk/partner_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    result=dict(counts=counts,retained=len(manifest),seconds=time.monotonic()-start)
    Path('logs/partner_generation.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result),flush=True)
if __name__=='__main__':main()
