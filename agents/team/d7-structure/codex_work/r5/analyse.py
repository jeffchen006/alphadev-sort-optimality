import itertools, json, pathlib, sys
sys.dont_write_bytecode=True
ROOT=pathlib.Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from pool_from_prog import W, sim
from show import progs
from gates import tname
DIR=pathlib.Path(__file__).resolve().parent
CS={'cmovl':(-1,), 'cmovle':(-1,0), 'cmovg':(1,), 'cmovge':(1,0)}
X=[tuple(w[i] for w in W) for i in range(5)]
def mn(a,b): return tuple(map(min,a,b))
def mx(a,b): return tuple(map(max,a,b))
def sel(a,b,d,s,c): return tuple(y if (p>q)-(p<q) in CS[c] else x for p,q,x,y in zip(a,b,d,s))
def name(col):
    bits=[0]+[int(col[W.index(tuple(int(bool(S>>i&1)) for i in range(5)))]) for S in range(1,31)]+[1]
    t=sum(1<<i for i,v in enumerate(bits) if v)
    mins=[S for S in range(1,32) if t>>S&1 and not any(U!=S and U&S==U for U in range(1,32) if t>>U&1)]
    check=tuple(max(min(w[i] for i in range(5) if S>>i&1) for S in mins) for w in W)
    return tname(t) if check==col else None
def readprog(path): return next(progs(str(path)))
def trace(prog):
    regs={f'P{i}':v for i,v in enumerate(X)}; rows=[]; flag=None; pool=list(X)
    for ins in prog:
        op,args=ins.split(None,1); d,s=map(str.strip,args.split(','))
        if op=='out': rows.append(dict(ins=ins,term=pool.index(regs[s]),regs={k:pool.index(v) for k,v in regs.items()})); continue
        if op=='cmp': flag=(regs[d],regs[s]); res=regs[d]
        elif op=='mov': res=regs[s]; regs[d]=res
        else: res=sel(*flag,regs.get(d,(None,)*541),regs[s],op); regs[d]=res
        if res not in pool: pool.append(res)
        rows.append(dict(ins=ins,term=pool.index(res),flag=[pool.index(v) for v in flag] if flag else None,regs={k:pool.index(v) for k,v in regs.items()}))
    return pool,rows
def writepool(path,pool):
    assert len(set(pool))==len(pool) and pool[:5]==X and len(pool)<=27
    path.write_text(''.join(' '.join(map(str,v))+'\n' for v in pool))
if __name__=='__main__':
    pool,rows=trace(readprog(DIR/'w6_c8_k32.s'))
    writepool(DIR/'pool_baseline.txt',pool)
    meta=dict(names=[name(v) for v in pool],rows=rows)
    (DIR/'terms.json').write_text(json.dumps(meta,indent=2))
    for i,v in enumerate(pool): print(i,name(v) or 'NONLATTICE')
    for i,row in enumerate(rows): print(i,row['ins'],row['term'],meta['names'][row['term']] or 'N',row.get('flag'))
