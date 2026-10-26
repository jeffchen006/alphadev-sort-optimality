"""Freeze sources and identify the median accumulator chain."""
from pathlib import Path
import hashlib,json,sys
sys.dont_write_bytecode=True
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent/'round5'))
from fusion_sat import concrete,GOALS

def median_chain(row):
    p=[tuple(x) for x in row['program']]
    names={f'P{i}':i for i in range(5)};written={};t=-1;median=None
    for line in Path(row['source']).read_text().splitlines():
        line=line.split('#')[0].strip()
        if not line:continue
        op,d,s=line.replace(',',' ').split()
        if op=='out':
            if d=='2':median=(written.get(names[s],-1),names[s])
            continue
        for r in (d,s):
            if r not in names:names[r]=len(names)
        t+=1
        if op!='cmp':written[names[d]]=t
    assert median is not None and median[0]>=0
    columns,_=concrete(p,row['registers']+2)
    assert next(col for when,r,col in columns if (when,r)==median)==GOALS[2]
    def previous(r,before):
        return next((i for i in range(before-1,-1,-1) if p[i][0]!=1 and p[i][1]==r),-1)
    spine=[];node=median[0]
    while node>=0:
        spine.append(node);o,d,s=p[node]
        node=previous(s if o==0 else d,node)
    def visit(node,seen):
        if node<0 or node in seen:return
        seen.add(node);o,d,s=p[node]
        visit(previous(s,node),seen)
        if o>=2:visit(previous(d,node),seen)
    value_slice=set();visit(median[0],value_slice)
    return dict(median_snapshot=list(median),chain=sorted(spine),value_slice=sorted(value_slice),
                exact_median_snapshots=[[t,r] for t,r,col in columns if col==GOALS[2]])

def main():
    rows=json.loads((HERE.parent/'round5/manifest.json').read_text());queue=[];audit=[]
    for row in rows:
        source=Path(row['source']);assert hashlib.sha256(source.read_bytes()).hexdigest()==row['sha256']
        info=median_chain(row);audit.append(dict(index=row['index'],**info))
        windows=[s for s in range(30) if set(range(s,s+3))&set(info['chain'])]
        for s in windows:
            queue.append(dict(seed=row['index'],start=s,width=3,replacement=2,
                              chain_overlap=sorted(set(range(s,s+3))&set(info['chain'])),
                              median_distance=abs((s+1)-info['median_snapshot'][0])))
    # Interleave seeds at the terminal median operation before earlier windows.
    queue.sort(key=lambda r:(r['median_distance'],r['seed'],r['start']))
    (HERE/'manifest.json').write_text(json.dumps(rows,indent=2)+'\n')
    (HERE/'median_audit.json').write_text(json.dumps(audit,indent=2)+'\n')
    (HERE/'queue.json').write_text(json.dumps(queue,indent=2)+'\n')
    print(json.dumps(dict(seeds=len(rows),queries=len(queue),chain_lengths=sorted(set(len(x['chain']) for x in audit)),
                          median_producer_counts=sorted(set(len(x['exact_median_snapshots']) for x in audit)))))
if __name__=='__main__':main()
