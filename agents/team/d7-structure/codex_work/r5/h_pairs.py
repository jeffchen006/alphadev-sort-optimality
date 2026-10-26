import itertools,json
from analyse import *
base,rows=trace(readprog(DIR/'w6_c8_k32.s'));h=[]
for d,s in itertools.permutations([15,12,11,5],2):
    v=sel(base[5],base[11],base[d],base[s],'cmovg')
    if v not in base and not any(v==w for _,w in h):h.append((f'{d}_{s}',v))
manifest=[]
for (a,A),(b,B) in itertools.combinations(h,2):
    tag='hpair_'+a+'__'+b;p=list(dict.fromkeys(base+[A,B]));fn=DIR/f'pool_{tag}.txt';writepool(fn,p)
    manifest.append(dict(id=tag,idea='Two alternative conditional pair states under cmp(max34,max012)',file=str(fn.relative_to(ROOT)),size=len(p),selects=[dict(dest=int(a.split('_')[0]),src=int(a.split('_')[1]),flag=[5,11],condition='g'),dict(dest=int(b.split('_')[0]),src=int(b.split('_')[1]),flag=[5,11],condition='g')]))
(DIR/'hpair_manifest.json').write_text(json.dumps(manifest,indent=2));print('H extras',len(h),'pools',len(manifest))
triples=[]
for group in itertools.combinations(h,3):
    tag='htriple_'+'__'.join(a for a,_ in group);p=[v for i,v in enumerate(base) if i!=13]+[v for _,v in group];fn=DIR/f'pool_{tag}.txt';writepool(fn,p)
    triples.append(dict(id=tag,idea='Three conditional pair states; replace the first dead-register select by mov',file=str(fn.relative_to(ROOT)),size=len(p),selects=[dict(dest=int(a.split('_')[0]),src=int(a.split('_')[1]),flag=[5,11],condition='g') for a,v in group]))
(DIR/'htriple_manifest.json').write_text(json.dumps(triples,indent=2));print('H triple pools',len(triples))
