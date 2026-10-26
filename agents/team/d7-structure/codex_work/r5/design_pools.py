import pathlib,itertools,json,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parent))
from analyse import *
base,rows=trace(readprog(DIR/'w6_c8_k32.s'))
manifest=[]; used=set()
def add(tag,idea,extras,remove=()):
    p=[v for i,v in enumerate(base) if i not in remove]
    p=list(dict.fromkeys(p+list(extras)))
    key=frozenset(p)
    if key in used or len(p)>27:return
    used.add(key);fn=DIR/f'pool_{tag}.txt';writepool(fn,p)
    manifest.append(dict(id=tag,idea=idea,file=str(fn.relative_to(ROOT)),size=len(p)))
add('control','Original 25-term pool',[])
# a: alternative upper and lower middle bounds, plus a seed that retains the other half.
# Every candidate is exact on all 541 weak orders, not just binary inputs.
upper=[('CEmin',mn(base[11],base[5])),('CDmax',mx(base[11],base[6])),('BEmax',mx(base[12],base[5])),('BCpair',mn(base[7],base[5])),('BEm in'.replace(' ',''),mn(base[12],base[5])),('LEmax',mx(base[15],base[5])),('CLmin',mn(base[11],base[15]))]
lower=[('BLmin',mn(base[12],base[15])),('BLmax',mx(base[12],base[15])),('BDmax',mx(base[12],base[6])),('AEmax',mx(base[10],base[5])),('ADmin',mn(base[10],base[6])),('C1E1min',mn(base[19],base[16])),('C1L1min',mn(base[19],base[17])),('C1L1max',mx(base[19],base[17]))]
for (a,A),(b,B) in itertools.product(upper,lower):
    add('bound_'+a+'_'+b,'Preserve max(3,4); alternate middle bounds',[A,B])
# b: choose alternative final pivots. These flags are not limited to the eight old flags.
tail=[12,16,17,19]
for a,b in itertools.combinations(tail,2):
    for d,s in itertools.permutations(tail,2):
        for c in CS:
            v=sel(base[a],base[b],base[d],base[s],c)
            # Supply min/max of the chosen pivot pair as a companion rebuild.
            if v in base:continue
            for op,f in [('lo',mn),('hi',mx)]:
                add(f'tail_{a}_{b}_{d}_{s}_{c}_{op}','Change last two pivots and conditional pair tracking',[v,f(base[a],base[b])])
# a/c: H=cmp(E,C) variants. Move the old C into another useful pair tracking column,
# and permit a new flag on a bound that was absent from the old circuit.
for a,b in [(11,6),(12,5),(11,15),(12,15),(10,5),(7,5)]:
    for d,s in [(11,12),(15,12),(11,15),(5,15),(12,5),(11,6),(5,7)]:
        for c in ['cmovl','cmovg']:
            v=sel(base[a],base[b],base[d],base[s],c)
            add(f'early_{a}_{b}_{d}_{s}_{c}','Move max output and start merge before sort3 finishes',[v,mn(base[a],base[b])])
(DIR/'manifest.json').write_text(json.dumps(manifest,indent=2))
print('pools',len(manifest))
from collections import Counter
print(Counter((m['idea'],m['size']) for m in manifest))
