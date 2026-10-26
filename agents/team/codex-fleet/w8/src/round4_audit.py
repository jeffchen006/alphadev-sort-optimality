"""Independently evaluate the new rotation traces and repeated comparisons."""
import collections,hashlib,itertools,json,re,resource,subprocess,os
from pathlib import Path
from fixed_route import route
from round2_run import verify
P=list(itertools.permutations(range(5)))
LATTICE_CACHE={}
def lattice(col):
    if col in LATTICE_CACHE:return LATTICE_CACHE[col]
    tab={0:0,31:1}
    for t,p in enumerate(P):
        for h in range(1,5):
            mask=sum(1<<i for i in range(5) if p[i]>=h);bit=int(col[t]>=h)
            if mask in tab and tab[mask]!=bit:
                LATTICE_CACHE[col]=False;return False
            tab[mask]=bit
    answer=all(not tab[m] or tab[m|(1<<i)] for m in range(32) for i in range(5))
    LATTICE_CACHE[col]=answer;return answer

def saved(file):
    return [[tuple(map(int,c[1:])) for c in l.split(':')] for l in Path(file).read_text().splitlines() if l.startswith('=')]

def rotation(file):
    first=Path(file).read_text().splitlines()[0]
    steps=[tuple(map(int,re.findall(r'\d',s))) for s in first.split(';',1)[1].split()]
    if len(steps)!=9:raise ValueError(file)
    rows=[[] for _ in range(18)];final=[];hist=[]
    for p in P:
        wires=list(p);h=[]
        for j,step in enumerate(steps):
            a,b=step[:2];rows[2*j].append(wires[a]);rows[2*j+1].append(wires[b]);h.append((wires[a]>wires[b])-(wires[a]<wires[b]))
            if wires[a]>wires[b]:
                wires[a],wires[b]=wires[b],wires[a]
                if len(step)==5:
                    c,d,e=step[2:];wires[c],wires[d],wires[e]=wires[d],wires[e],wires[c]
        final.append(tuple(wires));hist.append(tuple(h))
    observed=[tuple(x) for pair in saved(file) for x in pair]
    assert observed==list(map(tuple,rows)),file
    assert any(not lattice(c) for c in observed),file
    assert len(set(final))==1 and len(set(hist))==120,file
    assert sorted(final[0])==list(range(5)),file
    # Construct a fresh-node selector graph from the wire permutations.
    wires=list(range(5));code=[];nn=5
    for step in steps:
        a,b=step[:2];code.append([1,wires[a],wires[b]])
        code.append([3,wires[a],wires[b]]);code.append([3,wires[b],wires[a]])
        wires[a],wires[b]=nn,nn+1;nn+=2
        if len(step)==5:
            c,d,e=step[2:]
            code.extend([[3,wires[c],wires[d]],[3,wires[d],wires[e]],[3,wires[e],wires[c]]])
            wires[c],wires[d],wires[e]=nn,nn+1,nn+2;nn+=3
    return code

def main():
    os.nice(19-os.nice(0));resource.setrlimit(resource.RLIMIT_AS,(3*1024**3,3*1024**3))
    rows=json.loads(Path('sk/round4_rotation.json').read_text());counts=collections.Counter();best=[]
    for row in rows:
        code=rotation(row['file'])
        for fold in (False,True):
            r=route(code,fold)
            assert r is not None,row['file']
            counts[r['cost']]+=1
            if not best or r['cost']<best[0]['cost']:best=[dict(source=row['file'],fold=fold,**r)]
            elif r['cost']==best[0]['cost'] and len(best)<3:best.append(dict(source=row['file'],fold=fold,**r))
    result=dict(rotation_sources_checked=len(rows),fixed_layouts=sum(counts.values()),fixed_cost_histogram=dict(sorted(counts.items())),best_layouts=best)
    sources={};repeats=json.loads(Path('sk/round4_repeat10.json').read_text())
    for row in repeats:
        file=row['file'];source=row['source'];pairs=sources.setdefault(source,saved(source))
        expected=pairs[:row['after']]+[pairs[row['repeat']-1]]+pairs[row['after']:]
        assert saved(file)==expected,file
    for file,pairs in sources.items():
        histories=[tuple((a[t]>b[t])-(a[t]<b[t]) for a,b in pairs) for t in range(120)]
        assert len(set(histories))==120,file
    result.update(repeated_skeletons_checked=len(repeats),repeat_sources_checked=len(sources),rotation_unique_columns_checked=len(LATTICE_CACHE),rotation_unique_nonlattice_columns=sum(not v for v in LATTICE_CACHE.values()))
    Path('logs/round4_semantic_audit.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k!='best_layouts'}),flush=True)
    controls=[]
    for i,r in enumerate(best):
        f=Path(f'programs/round4_rotation_control_{i}.s')
        f.write_text('# n=5 iset=I1 model=out source='+r['source']+'\n'+'\n'.join(r['lines'])+'\n')
        check=subprocess.run(['python3','src/verify_log.py',str(f),f.stem],capture_output=True,text=True)
        passed=check.returncode==0 and check.stdout.count('PASS ')==2
        controls.append(dict(source=r['source'],file=str(f),cost=r['cost'],strict_pass=passed,judge=check.stdout+check.stderr))
        print(json.dumps(controls[-1]),flush=True)
        if passed and r['cost']<=31:
            p=Path('RESULTS.md');p.write_text(f"FOUND k={r['cost']} {f}; strict out and mem PASS\n"+check.stdout+'\n'+p.read_text())
    Path('logs/round4_rotation_controls.json').write_text(json.dumps(controls,indent=2)+'\n')
    # Positive router check with a harmless adjacent repeated input comparison.
    known=[l for l in Path('sk/known32.txt').read_text().splitlines() if l and not l.startswith('#')]
    target=Path('sk/round4_repeat_control.txt');target.write_text('\n'.join(known[:1]+known)+'\n')
    check=subprocess.run(['./dagx_order',str(target),'33','1','2000000'],capture_output=True,text=True,env=os.environ|{'ROUTE_ORDER':'0'})
    txt=check.stdout+check.stderr;Path('logs/round4_repeat_positive.log').write_text(txt)
    positive=dict(router_found='RESULT FOUND' in txt)
    if positive['router_found']:positive.update(verify(txt,'round4_repeat_positive'))
    Path('logs/round4_repeat_positive.json').write_text(json.dumps(positive,indent=2)+'\n')
    print(json.dumps(positive),flush=True)
if __name__=='__main__':main()
