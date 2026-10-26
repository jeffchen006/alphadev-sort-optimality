"""Positive controls for the two fixed-flag feasibility checks."""
from masked_audit import *
count=0
for row in json.loads((HERE/'manifest.json').read_text()):
    p=row['program'];nr=row['registers']+1
    states,cols=trace(p,nr);output=outs(row['source'])
    cs=[i for i,x in enumerate(p) if x[0]==1]
    for z,ci in enumerate(cs):
        end=cs[z+1] if z+1<len(cs) else len(p)
        entry=states[ci][0];flags=states[ci+1][1]
        goals=required(p,output,states,cols,ci,end)
        assert feasible(entry,flags,goals)[0],(row['index'],ci)
        live,neededflags=dependencies(p,output,states,end)
        assert not neededflags
        g=[('live'+str(r),states[end][0][r],mask) for r,mask in live.items()]
        prefix={col for r,col in cols[ci]}
        for when,j,r in output:
            if ci<when<=end and GOALS[j] not in prefix:g.append(('out'+str(j),GOALS[j],ALL))
        assert maskfeasible(entry,flags,g)[0],(row['index'],ci)
        count+=1
print(json.dumps(dict(comparison_blocks=count,unmasked_controls=count,masked_controls=count,failures=0)))
