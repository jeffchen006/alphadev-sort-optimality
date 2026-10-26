from round2 import *
manifest.extend(json.load(open('codex_work/round2_manifest.json')))
base,_,_=simulate('ex_prog1.txt');mer,_,_=simulate('ex_pos33.txt')
cs=json.load(open('codex_work/scan_candidates.json'))
ids=[3138,3139,4615,4616,4619,4620,6213,6233]
for i in ids:
    save('base_sur%d'%i,'base + six-gate comparison surrogate '+cs[i]['name'],base+[tuple(cs[i]['col'])],{'candidate_id':i,'construct':cs[i]['construct']})
for k,ii in enumerate([(3138,4615,6213),(3139,4616,6214),(3138,4619,6235),(3139,4620,6233)]):
    save('base_sur3_%d'%k,'base + three comparison surrogates '+','.join(map(str,ii)),base+[tuple(cs[i]['col']) for i in ii],{'candidate_ids':ii})
# Align the merge's input pair with x1,x2 and its triple with x3,x4,x0.
rows={tuple(map(int,w)):i for i,w in enumerate(W)};perm=[1,2,3,4,0]
indices=[rows[tuple(int(w[i]) for i in perm)] for w in W]
aligned=[tuple(c[k] for k in indices) for c in mer]
groups=[('low',[9,10,11,12]),('clip',[10,11,12,13]),('high',[15,16,18,19]),('bridge',[9,13,15,16]),('core',[9,10,15,16]),('middle',[11,12,15,19])]
for tag,ii in groups:
    save('hybrid_'+tag,'aligned adaptive merge + base '+tag+' terms',aligned+[base[i] for i in ii],{'base_term_indices':ii,'input_permutation':perm})
# Do not run equal pools twice.
keep=[];seen=set()
for e in manifest:
    key=frozenset(open(e['file']).read().splitlines())
    if key in seen:print('duplicate not run',e['tag']);continue
    keep.append(e);seen.add(key)
manifest[:]=keep;flush()
print('total distinct pools',len(manifest))
for e in manifest[-18:]:print(e['tag'],e['size'])
