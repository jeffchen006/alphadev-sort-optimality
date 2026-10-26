"""Necessary fixed-flag value tests over all weak orders, with a sentinel.

For one unchanged flag outcome, MOV/CMOV can only copy an entry register.
The test permits an independent entry source for each of eq/lt/gt. It does
not impose an instruction count. Failure excludes exact window effects for
that entry state and that flag column, even with arbitrarily many writes.
"""
from pathlib import Path
import itertools, json, time
HERE=Path(__file__).resolve().parents[1]
OPS=['mov','cmp','cmovl','cmovle','cmovg','cmovge']
CASES=[a for a in itertools.product(range(5),repeat=5) if set(a)==set(range(max(a)+1))]
GOALS=[bytes(a[j] for a in map(sorted,CASES)) for j in range(5)]

def trace(p,nr):
    rs=[bytes(a[r] for a in CASES) if r<5 else bytes([7])*541 for r in range(nr)]
    fl=bytes(541);states=[(rs[:],fl)];cols=[(r,x) for r,x in enumerate(rs)]
    atcols=[cols[:]]
    for op,d,s in p:
        a,b=rs[d],rs[s]
        if op==0:rs[d]=b
        elif op==1:fl=bytes(1 if x<y else 2 if x>y else 0 for x,y in zip(a,b))
        else:
            active={2:(1,),3:(0,1),4:(2,),5:(0,2)}[op]
            rs[d]=bytes(y if f in active else x for x,y,f in zip(a,b,fl))
        states.append((rs[:],fl))
        if op!=1:cols=cols+[(d,rs[d])]
        atcols.append(cols)
    return states,atcols

def outs(path):
    regs={f'P{i}':i for i in range(5)};result=[];t=0
    for line in Path(path).read_text().splitlines():
        line=line.split('#')[0].strip()
        if not line:continue
        op,d,s=line.replace(',','').split()
        if op=='out':result.append((t,int(d),regs[s]));continue
        for x in(d,s):
            if x not in regs:regs[x]=len(regs)
        t+=1
    return result

def required(p,output,states,cols,first,end):
    live=set()
    for t in range(len(p),end,-1):
        live.update(r for when,j,r in output if when==t)
        op,d,s=p[t-1]
        if op==0:live.discard(d);live.add(s)
        elif op==1:live.update((d,s))
        else:live.update((d,s))
    # Outputs exactly at end are provided either by a final register or a window snapshot.
    goals=[('live'+str(r),states[end][0][r]) for r in sorted(live)]
    prefix={col for r,col in cols[first]}
    for when,j,r in output:
        if first<when<=end and GOALS[j] not in prefix:goals.append(('out'+str(j),GOALS[j]))
    return goals

def feasible(entry,flags,goals):
    witnesses=[]
    for f in range(3):
        ix=[t for t,x in enumerate(flags) if x==f]
        if not ix:continue
        bank={bytes(col[t] for t in ix) for col in entry}
        for name,col in goals:
            key=bytes(col[t] for t in ix)
            if key not in bank:
                return False,dict(target=name,flag=f,cases=len(ix))
    return True,None

def audit(row):
    p=row['program'];nr=row['registers']+1
    states,cols=trace(p,nr);output=outs(row['source']);cs=[i for i,x in enumerate(p) if x[0]==1]
    result=[]
    for z,ci in enumerate(cs):
        end=cs[z+1] if z+1<len(cs) else len(p)
        entry,fl=states[ci];goals=required(p,output,states,cols,ci,end)
        ok,reason=feasible(entry,fl,goals)
        result.append(dict(index=row['index'],delete=ci,start=ci,end=end,mode='drop',feasible=ok,reason=reason))
        if z==0:continue
        first=cs[z-1];entry,_=states[first];goals=required(p,output,states,cols,first,end)
        pairs=[]
        for a in range(nr):
            for b in range(a,nr):
                flags=bytes(1 if x<y else 2 if x>y else 0 for x,y in zip(entry[a],entry[b]))
                ok,reason=feasible(entry,flags,goals)
                if ok:pairs.append((a,b))
        result.append(dict(index=row['index'],delete=ci,start=first,end=end,mode='merge_free',feasible=bool(pairs),pairs=pairs,pairs_tested=nr*(nr+1)//2))
    return result

if __name__=='__main__':
    began=time.monotonic();rows=[]
    for seed in json.loads((HERE/'manifest.json').read_text()):
        rows.extend(audit(seed))
        if seed['index']%10==0:print(json.dumps(dict(index=seed['index'],seconds=time.monotonic()-began,feasible=sum(x['feasible'] for x in rows))),flush=True)
    out=dict(cases=len(CASES),scratch=7,initial_flags='eq',rows=rows,seconds=time.monotonic()-began)
    (HERE/'flag_audit.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps(dict(done=True,windows=len(rows),feasible=sum(x['feasible'] for x in rows),pairs=sum(x.get('pairs_tested',0) for x in rows),seconds=out['seconds'])),flush=True)
