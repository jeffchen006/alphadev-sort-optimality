"""Fixed-flag feasibility with per-case dependencies through the suffix.

This is a necessary test for preserving original suffix branches and required
values. It permits different entry registers in each flag outcome. It does
not claim to exclude all output-equivalent replacements.
"""
from flag_audit import *
ALL=(1<<541)-1

def dependencies(p,output,states,end):
    live={};flags=0
    def add(r,mask):live[r]=live.get(r,0)|mask
    for t in range(len(p),end,-1):
        for when,j,r in output:
            if when==t:add(r,ALL)
        op,d,s=p[t-1]
        if op==0:
            needed=live.pop(d,0);add(s,needed)
        elif op==1:
            add(d,flags);add(s,flags);flags=0
        else:
            needed=live.get(d,0)
            active={2:(1,),3:(0,1),4:(2,),5:(0,2)}[op]
            mask=sum(1<<i for i,f in enumerate(states[t-1][1]) if f in active)
            live[d]=needed&~mask;add(s,needed&mask);flags|=needed
    return {r:mask for r,mask in live.items() if mask},flags

def maskfeasible(entry,flags,goals):
    # Each target contains a dense rank vector and its required-case mask.
    for f in range(3):
        ix0=[i for i,x in enumerate(flags) if x==f]
        for name,col,mask in goals:
            ix=[i for i in ix0 if mask>>i&1]
            if not ix:continue
            key=bytes(col[i] for i in ix)
            if not any(key==bytes(v[i] for i in ix) for v in entry):
                return False,dict(target=name,flag=f,required_cases=len(ix))
    return True,None

def audit_mask(row):
    p=row['program'];nr=row['registers']+1
    states,cols=trace(p,nr);output=outs(row['source']);cs=[i for i,x in enumerate(p) if x[0]==1]
    result=[]
    for z,ci in enumerate(cs):
        end=cs[z+1] if z+1<len(cs) else len(p)
        live,neededflags=dependencies(p,output,states,end)
        assert not neededflags, (ci,end)
        for mode in ['drop','merge_free']:
            if mode=='merge_free' and z==0:continue
            first=ci if mode=='drop' else cs[z-1]
            goals=[('live'+str(r),states[end][0][r],mask) for r,mask in live.items()]
            prefix={col for r,col in cols[first]}
            for when,j,r in output:
                if first<when<=end and GOALS[j] not in prefix:goals.append(('out'+str(j),GOALS[j],ALL))
            entry,fl=states[first];pairs=[];reasons=[]
            if mode=='drop':
                ok,reason=maskfeasible(entry,fl,goals)
                if ok:pairs.append(None)
                else:reasons.append(reason)
            else:
                for a in range(nr):
                    for b in range(a,nr):
                        flags=bytes(1 if x<y else 2 if x>y else 0 for x,y in zip(entry[a],entry[b]))
                        ok,reason=maskfeasible(entry,flags,goals)
                        if ok:pairs.append((a,b))
                        else:reasons.append(reason)
            result.append(dict(index=row['index'],delete=ci,start=first,end=end,mode=mode,feasible=bool(pairs),pairs=pairs,reasons=reasons[:1],goals=len(goals)))
    return result

if __name__=='__main__':
    began=time.monotonic();rows=[]
    for seed in json.loads((HERE/'manifest.json').read_text()):
        rows.extend(audit_mask(seed))
        if seed['index']%10==0:print(json.dumps(dict(index=seed['index'],seconds=time.monotonic()-began,feasible=sum(x['feasible'] for x in rows))),flush=True)
    out=dict(cases=541,scratch=7,initial_flags='eq',rows=rows,seconds=time.monotonic()-began)
    (HERE/'masked_audit.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps(dict(done=True,windows=len(rows),feasible=sum(x['feasible'] for x in rows),seconds=out['seconds'])),flush=True)
