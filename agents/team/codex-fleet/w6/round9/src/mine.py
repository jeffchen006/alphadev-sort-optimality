"""Try output snapshots with minimum failure union on newly saved out programs."""
from pathlib import Path
import hashlib,json,re,subprocess
from check import CASES,parse

def mine(path):
    p=[i for i in parse(path) if i[0]!='out']
    regs=sorted({r for _,d,s in p for r in (d,s)}|{f'P{i}' for i in range(5)})
    values={r:[x[int(r[1:])] if r.startswith('P') else 7 for x in CASES] for r in regs}
    flags=[None]*541;goals=list(zip(*(sorted(x) for x in CASES)))
    columns=[]
    def column(t,r):
        a=values[r]
        masks=tuple(sum((a[i]!=goals[j][i])<<i for i in range(541)) for j in range(5))
        columns.append((t,r,masks))
    for r in regs:column(-1,r)
    for t,(op,d,s) in enumerate(p):
        a,b=values[d],values[s]
        if op=='cmp':
            flags=[0 if d==s else None if 7 in (x,y) else (x>y)-(x<y) for x,y in zip(a,b)]
            continue
        if op=='mov':values[d]=b[:]
        else:
            values[d]=[x if x==y else 7 if f is None else y if {'cmovl':f<0,'cmovle':f<=0,'cmovg':f>0,'cmovge':f>=0}[op] else x for x,y,f in zip(a,b,flags)]
        column(t,d)
    domains=[]
    for j in range(5):
        selected={}
        for t,r,errors in columns:selected.setdefault(errors[j],(t,r))
        nondominated=[]
        for m in sorted(selected,key=int.bit_count):
            if not any(a&m==a for a in nondominated):nondominated.append(m)
        domains.append([(m,*selected[m]) for m in nondominated])
    order=sorted(range(5),key=lambda j:len(domains[j]))
    witness=[min(d,key=lambda c:c[0].bit_count()) for d in domains]
    bestmask=0
    for m,_,_ in witness:bestmask|=m
    best=bestmask.bit_count();nodes=0;limited=False;seen=set()
    choice=witness[:]
    def dfs(depth,mask):
        nonlocal best,witness,nodes,limited
        nodes+=1
        if nodes>1000000:limited=True;return
        if mask.bit_count()>=best:return
        key=(depth,mask)
        if key in seen:return
        seen.add(key)
        if depth==5:best=mask.bit_count();witness=choice[:];return
        j=order[depth]
        for item in sorted(domains[j],key=lambda c:(mask|c[0]).bit_count()):
            choice[j]=item;dfs(depth+1,mask|item[0])
            if limited:return
    dfs(0,0)
    result=dict(source=str(path),best_failed_orders=best,nodes=nodes,status='UNKNOWN_AT_NODE_LIMIT' if limited else 'COMPLETE',domain_sizes=[len(d) for d in domains])
    if best<=9:
        dest=Path('round9/candidates',path.stem+'_snapshots.s');body=[]
        for j,(_,t,r) in enumerate(witness):
            if t==-1:body.append(f'out {j}, {r}')
        for t,(op,d,s) in enumerate(p):
            body.append(f'{op} {d}, {s}')
            for j,(_,when,r) in enumerate(witness):
                if when==t:body.append(f'out {j}, {r}')
        dest.write_text(f'# n=5 model=out iset=I1 source=w6-round9-snapshots k={len(p)} failed_orders={best}\n'+'\n'.join(body)+'\n')
        result['retained']=str(dest)
        result['sha256']=hashlib.sha256(dest.read_bytes()).hexdigest()
        subprocess.run(['nice','-n','19','python3','-B','round9/src/verify.py',str(dest)],check=True)
    return result

if __name__=='__main__':
    files=sorted(f for f in Path('round9/candidates').glob('weighted_out*_best*.s') if not f.stem.endswith('_snapshots'))
    conversions=[]
    folder=Path('round9/artifacts/memory_conversions');folder.mkdir(exist_ok=True)
    for source in sorted(f for f in Path('round9/candidates').glob('weighted_mem*_best*.s') if not f.stem.endswith('_snapshots')):
        dest=folder/(source.stem+'_out.s')
        r=subprocess.run(['nice','-n','19','python3','-B',str(Path.cwd().parents[3]/'agents/spec/tools/ad2out.py'),str(source)],capture_output=True,text=True)
        item=dict(source=str(source),converted=str(dest),exit=r.returncode,stderr=r.stderr)
        if r.returncode==0:
            dest.write_text(r.stdout)
            k=int(re.search(r'\bk=(\d+)',r.stdout.splitlines()[0]).group(1));item['k']=k
            subprocess.run(['nice','-n','19','python3','-B','round9/src/verify.py',str(dest)],check=True)
            if k<=31:files.append(dest)
        conversions.append(item)
    rows=[mine(f) for f in files]
    result=dict(conversions=conversions,programs=rows)
    Path('round9/artifacts/snapshot_mining.json').write_text(json.dumps(result,indent=2))
    print(json.dumps(result,indent=2))
