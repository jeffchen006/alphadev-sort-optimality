"""Independent evaluation of conditional-permutation source recipes."""
import argparse, collections, itertools, json, re
from pathlib import Path

PERMS=list(itertools.permutations(range(5)))
WEAK=[p for p in itertools.product(range(5),repeat=5) if set(p)==set(range(max(p)+1))]
assert len(WEAK)==541

def recipe(file):
    text=Path(file).read_text().splitlines()
    steps=[]
    for token in text[0].split(';',1)[1].split():
        pair,perm=token.split('/')
        a,b=map(int,pair)
        if perm=='-':
            perm=list(range(5));perm[a],perm[b]=perm[b],perm[a]
        else:perm=list(map(int,perm))
        assert sorted(perm)==list(range(5))
        steps.append((a,b,perm))
    saved=[tuple(map(int,c[1:])) for l in text[1:] for c in l.split(':')]
    assert len(saved)==2*len(steps)
    return steps,saved

def evaluate(steps,orders):
    columns=[[] for _ in range(2*len(steps))];final=[];histories=[]
    for p in orders:
        wires=list(p);history=[]
        for j,(a,b,perm) in enumerate(steps):
            columns[2*j].append(wires[a]);columns[2*j+1].append(wires[b])
            gt=wires[a]>wires[b];history.append((wires[a]>wires[b])-(wires[a]<wires[b]))
            if gt:wires=[wires[k] for k in perm]
        final.append(tuple(wires));histories.append(tuple(history))
    return list(map(tuple,columns)),final,histories

def graph(steps):
    wires=list(range(5));code=[];nn=5
    for a,b,perm in steps:
        code.append([1,wires[a],wires[b]]);old=list(wires)
        for d,s in enumerate(perm):
            if d==s:continue
            code.append([3,old[d],old[s]]);wires[d]=nn;nn+=1
    return code

def is_lattice(col):
    table={0:0,31:1}
    for p,v in zip(PERMS,col):
        for h in range(1,5):
            mask=sum(1<<i for i,x in enumerate(p) if x>=h)
            bit=int(v>=h)
            if mask in table and table[mask]!=bit:return False
            table[mask]=bit
    return all(not table[m] or table[m|(1<<i)] for m in range(32) for i in range(5))

def main():
    p=argparse.ArgumentParser();p.add_argument('manifests',nargs='+');p.add_argument('--layouts',action='store_true');p.add_argument('--tag',default='audit');a=p.parse_args()
    if a.layouts:
        from fixed_route import route
        from run import verify
    records=[];counts=collections.Counter();nlcache={};best={}
    for mf in a.manifests:
        for line in Path(mf).read_text().splitlines():
            row=json.loads(line);steps,saved=recipe(row['file']);cols,final,hist=evaluate(steps,PERMS)
            assert cols==saved,row['file']
            assert len(set(final))==1 and sorted(final[0])==list(range(5)),row['file']
            assert len(set(hist))==120,row['file']
            req=set(cols)|{(k,)*120 for k in range(5)}
            req-={tuple(p[i] for p in PERMS) for i in range(5)}
            assert len(req)==row['required'],row['file']
            for c in req:
                if c not in nlcache:nlcache[c]=is_lattice(c)
            assert sum(not nlcache[c] for c in req)==row['nonlattice'],row['file']
            counts['sources']+=1;counts[f'c{row["c"]}']+=1
            # A source trace is translated to a program only for the best layout.
            if a.layouts:
                for fold in (False,True):
                    r=route(graph(steps),fold)
                    assert r is not None,row['file']
                    counts[f'layout_k{r["cost"]}']+=1
                    if row['c'] not in best or r['cost']<best[row['c']]['cost']:
                        best[row['c']]=dict(source=row['file'],fold=fold,**r)
            records.append(dict(file=row['file'],required=len(req),strict_orders=120,history_classes=120))
    summary=dict(counts=counts,unique_columns=len(nlcache),nonlattice_columns=sum(not v for v in nlcache.values()),best=best)
    Path(f'logs/{a.tag}.json').write_text(json.dumps(summary,indent=2)+'\n')
    if a.layouts:
        for c,r in best.items():
            result=verify(r['lines'],f'{a.tag}_c{c}_k{r["cost"]}')
            print(json.dumps(dict(c=c,cost=r['cost'],source=r['source'],verification=result)),flush=True)
    print(json.dumps({k:v for k,v in summary.items() if k!='best'}),flush=True)

if __name__=='__main__':main()
