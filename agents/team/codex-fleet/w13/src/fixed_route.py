#!/usr/bin/env python3
"""Minimize copies in one fixed selector graph, with free output times."""
import itertools,json,collections,subprocess,argparse
from pathlib import Path
P=list(itertools.permutations(range(5)))
def topo(gs,edges):
    left=set(gs);order=[]
    while left:
        ready=sorted(x for x in left if not any(x in edges.get(y,set()) for y in left))
        if not ready:return None
        x=ready[0];left.remove(x);order.append(x)
    return order
def route(code,fold=False):
    cols={i:tuple(p[i] for p in P) for i in range(5)};alias={i:i for i in range(5)}
    attrs={};cmps=[];flags=None;nn=5;block=0
    for op,d,s in code:
        d,s=alias[d],alias[s]
        if op==1:
            cmps.append((d,s));block+=1;flags=tuple((a>b)-(a<b) for a,b in zip(cols[d],cols[s]));continue
        c=tuple(b if (f<0 if op==2 else f>0 if op==3 else f<=0 if op==4 else f>=0) else a for a,b,f in zip(cols[d],cols[s],flags))
        replacement=next((x for x in cols if cols[x]==c),None) if fold else None
        if replacement is None:cols[nn]=c;attrs[nn]=(block,op,d,s);alias[nn]=nn
        else:alias[nn]=replacement
        nn+=1
    outputs={k:next((x for x,c in cols.items() if c==(k,)*120),None) for k in range(5)}
    if any(x is None for x in outputs.values()):return None
    live=set()
    def need(x):
        if x in live:return
        live.add(x)
        if x in attrs:
            _,_,d,s=attrs[x];need(d);need(s)
    for pair in cmps:
        for x in pair:need(x)
    for x in outputs.values():need(x)
    gates={x:attrs[x] for x in attrs if x in live};uses=collections.defaultdict(list)
    for g,(b,op,d,s) in gates.items():uses[d].append(('g',g));uses[s].append(('g',g))
    for b,pair in enumerate(cmps,1):
        for x in pair:uses[x].append(('c',b))
    orders={};inplace=set()
    for b in range(1,len(cmps)+1):
        gs=[g for g,a in gates.items() if a[0]==b];edges={g:set() for g in gs}
        for g in gs:
            for x in gates[g][2:]:
                if x in gs:edges[x].add(g)
        candidates=[]
        for g in gs:
            d=gates[g][2];ok=all((who<=b if kind=='c' else gates[who][0]<=b) for kind,who in uses[d])
            if ok:candidates.append(g)
        best=[];bestorder=topo(gs,edges)
        for bits in range(1<<len(candidates)):
            sel=[g for i,g in enumerate(candidates) if bits>>i&1]
            if len(sel)<=len(best) or len({gates[g][2] for g in sel})<len(sel):continue
            es={g:set(v) for g,v in edges.items()}
            for g in sel:
                for kind,who in uses[gates[g][2]]:
                    if kind=='g' and who!=g and gates[who][0]==b:es[who].add(g)
            order=topo(gs,es)
            if order is not None:best,bestorder=sel,order
        orders[b]=bestorder;inplace.update(best)
    reg={i:f'P{i}' for i in range(5)};lines=[];fresh=0;done=set()
    for b,pair in enumerate(cmps,1):
        gs=orders[b]
        if gs:lines.append(f'cmp {reg[pair[0]]}, {reg[pair[1]]}')
        for g in gs:
            _,op,d,s=gates[g]
            if g in inplace:r=reg[d]
            else:r=f'S{fresh}';fresh+=1;lines.append(f'mov {r}, {reg[d]}')
            lines.append(f'{[None,None,"cmovl","cmovg","cmovle","cmovge"][op]} {r}, {reg[s]}');reg[g]=r
            for k,x in outputs.items():
                if x==g and k not in done:lines.append(f'out {k}, {r}');done.add(k)
    return dict(cost=sum(not l.startswith('out') for l in lines),gates=len(gates),copies=fresh,lines=lines)
def main():
    p=argparse.ArgumentParser();p.add_argument('files',nargs='+');p.add_argument('--tag',default='fixed');p.add_argument('--control',action='store_true');a=p.parse_args()
    counts=collections.Counter();checked=0;controls=0;records=[]
    for file in a.files:
        for idx,line in enumerate(Path(file).read_text().splitlines()):
            graph=json.loads(line)
            for fold in (False,True):
                r=route(graph,fold)
                if r is None:continue
                counts[r['cost']]+=1
                if r['cost']>31 and not (a.control and not controls and r['cost']==32):continue
                stem=a.tag+f'_{checked:06d}';checked+=1
                if r['cost']==32:controls+=1
                out=Path('programs')/(stem+'.s');out.write_text('# n=5 iset=I1 model=out source=w8_fixed_graph\n'+'\n'.join(r['lines'])+'\n')
                v=subprocess.run(['nice','-n','10','python3','src/verify_log.py',str(out),stem],capture_output=True,text=True)
                records.append(dict(file=file,index=idx,fold=fold,cost=r['cost'],gates=r['gates'],copies=r['copies'],program=str(out),judge=v.stdout+v.stderr))
                print(json.dumps(records[-1]),flush=True)
    result=dict(histogram=dict(sorted(counts.items())),verified_candidates=checked,records=records)
    Path('logs',a.tag+'_fixed.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k!='records'}),flush=True)
if __name__=='__main__':main()
