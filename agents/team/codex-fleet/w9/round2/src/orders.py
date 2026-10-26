"""Enumerate all comparison orders after a necessary information test.

A history class is the set of input orders with the same previous flags.
An operand can be computed from prior flags only if one original input identity
supplies it throughout each class. A flag result can be obtained only if some
pair of input identities supplies that result throughout each class. The tests
relax the data-instruction budget. They do not certify a short program.
"""
import hashlib
import itertools
import json
from pathlib import Path
import time

ROOT=Path('/path/to/repo')
HERE=Path(__file__).resolve().parents[1]
CASES=list(itertools.permutations(range(5)))
INDEX={p:i for i,p in enumerate(CASES)}
ALL=(1<<120)-1
TRANS=[[INDEX[tuple(p[j] for j in q)] for p in CASES] for q in CASES]

def read(path):
    regs={f'P{i}':i for i in range(5)};p=[]
    for line in path.read_text().splitlines():
        z=line.split('#')[0].replace(',',' ').split()
        if not z or z[0]=='out':continue
        op,a,b=z
        for x in (a,b):
            if x not in regs:regs[x]=len(regs)
        p.append((op,regs[a],regs[b]))
    return p,len(regs)

def compare_columns(p,R,cases=CASES):
    r=[tuple(t[j] if j<5 else 7 for t in cases) for j in range(R)]
    f=None;columns=[]
    for op,a,b in p:
        if op=='cmp':
            f=bytes((x>y)-(x<y)+1 for x,y in zip(r[a],r[b]))
            columns.append((r[a],r[b],f))
        elif op=='mov':r[a]=r[b]
        else:
            pred={'cmovl':lambda x:x==0,'cmovle':lambda x:x<=1,
                  'cmovg':lambda x:x==2,'cmovge':lambda x:x>=1}[op]
            r[a]=tuple(y if pred(c) else x for x,y,c in zip(r[a],r[b],f))
    return columns

def canonical(cols):
    flags=[c[2] for c in cols];best=None;mapping=None
    for qi,tr in enumerate(TRANS):
        data=[]
        for i,f in enumerate(flags):
            g=bytes(f[t] for t in tr);h=bytes(2-x for x in g)
            data.append((min(g,h),i,g>h))
        data.sort();key=tuple(d[0] for d in data)
        if best is None or key<best:best,mapping=key,(qi,data)
    return best,mapping

def partitions(flags):
    masks=[[sum(1<<i for i,x in enumerate(f) if x==v) for v in range(3)] for f in flags]
    result={0:[ALL]}
    for subset in range(1,256):
        bit=subset&-subset;j=bit.bit_length()-1
        result[subset]=[part&m for part in result[subset^bit] for m in masks[j] if part&m]
    return result

def enumerate_orders(cols):
    flags=[c[2] for c in cols];parts=partitions(flags)
    pairs=[bytes((p[i]>p[j])-(p[i]<p[j])+1 for p in CASES) for i in range(5) for j in range(5)]
    matches=[[sum(1<<t for t in range(120) if f[t]==g[t]) for g in pairs] for f in flags]
    operand_matches=[[[sum(1<<t for t,p in enumerate(CASES) if p[i]==col[t]) for i in range(5)]
                      for col in c[:2]] for c in cols]
    ready_flags={};ready_operands={}
    for subset in range(256):
        ready_flags[subset]=[];ready_operands[subset]=[]
        for j in range(8):
            if subset>>j&1:continue
            if all(any(part&~m==0 for m in matches[j]) for part in parts[subset]):ready_flags[subset].append(j)
            if all(all(any(part&~m==0 for m in side) for part in parts[subset]) for side in operand_matches[j]):ready_operands[subset].append(j)
    def generate(ready):
        def dfs(subset,path):
            if subset==255:yield path;return
            for j in ready[subset]:yield from dfs(subset|1<<j,path+[j])
        return list(dfs(0,[]))
    return generate(ready_flags),generate(ready_operands)

def main():
    began=time.process_time();base=ROOT/'agents/team/codex-fleet/w6'
    files=sorted(base.glob('verified/*.s'))+sorted(base.glob('round2/verified/*.s'))
    files+=sorted(base.glob('round3/verified/*.s'))
    files+=sorted((HERE.parent/'candidates').glob('*out.s'))
    rows=[];groups={};seen=set()
    for file in files:
        p,R=read(file)
        if sum(op=='cmp' for op,_,_ in p)!=8 or len(p)>33:continue
        col=compare_columns(p,R);raw=tuple(c[2] for c in col)
        if raw in seen:continue
        seen.add(raw);key,mapping=canonical(col)
        if key not in groups:
            # Canonical inputs and orientations make every family comparable.
            flags=[bytes(f) for f in key]
            qi,data=mapping;tr=TRANS[qi]
            canonical_cols=[]
            for f,j,flip in data:
                a,b,_=col[j];a=tuple(a[t] for t in tr);b=tuple(b[t] for t in tr)
                canonical_cols.append((b,a,f) if flip else (a,b,f))
            valid,exact=enumerate_orders(canonical_cols)
            ident=hashlib.sha256(b''.join(flags)).hexdigest()[:12]
            groups[key]={'id':ident,'source':str(file),'flags':[list(f) for f in flags],
                         'valid_flag_orders':valid,'valid_operand_orders':exact,
                         'original_orders':[], 'sources':[]}
            print(json.dumps({'family':ident,'flag_orders':len(valid),'operand_orders':len(exact),'cpu':time.process_time()-began}),flush=True)
        row=groups[key]
        # data is in canonical comparator order. Invert to obtain source order.
        order=[next(k for k,d in enumerate(mapping[1]) if d[1]==j) for j in range(8)]
        if order not in row['original_orders']:row['original_orders'].append(order)
        row['sources'].append(str(file))
    rows=list(groups.values())
    for row in rows:
        old={tuple(x) for x in row['original_orders']}
        row['new_flag_orders']=[x for x in row['valid_flag_orders'] if tuple(x) not in old]
    result={'source_flag_sequences':len(seen),'families':rows,'cpu':time.process_time()-began,
            'orders_considered_per_family':40320,'case_count':120}
    (HERE/'artifacts/orders.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'summary':{'source_flag_sequences':len(seen),'families':len(rows),
           'valid':sum(len(x['valid_flag_orders']) for x in rows),
           'new':sum(len(x['new_flag_orders']) for x in rows),'cpu':result['cpu']}}),flush=True)

if __name__=='__main__':main()
