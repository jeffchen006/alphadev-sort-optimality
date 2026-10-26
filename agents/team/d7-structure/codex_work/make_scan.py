from round2 import *
base,_,events=simulate('ex_prog1.txt');arr=np.array(base,dtype=np.int8);ix={c:i for i,c in enumerate(base)}
rules=[]
for a,b in itertools.combinations(range(23),2):
    for op,v in [(0,lo(base[a],base[b])),(1,hi(base[a],base[b]))]:
        if v in ix and ix[v] not in (a,b):rules.append((a,b,ix[v]))
flags=[(ix[a],ix[b]) for _,a,b,_ in events]
threshold=np.array([[sum(int(x>=t)<<i for i,x in enumerate(w)) for t in range(1,5)] for w in W])
binaryrows={sum(int(x)<<i for i,x in enumerate(w)):k for k,w in enumerate(W) if max(w)<=1}
thresholds=np.arange(1,5)
def islat(v):
    bv=np.ones(32,dtype=np.int8)
    for s,k in binaryrows.items():bv[s]=v[k]
    return np.array_equal(bv[threshold],v[:,None]>=thresholds)
candidates={};info=[]
for fi,(p,q) in enumerate(flags):
    for a,b in itertools.permutations(range(23),2):
        for cn,cf in [('l',arr[p]<arr[q]),('le',arr[p]<=arr[q])]:
            v=np.where(cf,arr[b],arr[a]);key=v.tobytes()
            if tuple(map(int,v)) in ix or islat(v):continue
            if key not in candidates:
                candidates[key]=len(info);info.append({'name':'f%d_%d_%d_%s'%(fi,a,b,cn),'construct':[],'col':list(map(int,v))})
            info[candidates[key]]['construct'].append([p,q,a,b])
with open('codex_work/scan_input.txt','w') as f:
    f.write('%d %d\n'%(len(info),len(rules)))
    for c in base:f.write(' '.join(map(str,c))+'\n')
    for a,b,r in rules:f.write('%d %d %d\n'%(a,b,r))
    for e in info:
        f.write(' '.join(map(str,e['col']))+'\n')
        constructions=list(dict.fromkeys(map(tuple,e['construct'])))
        f.write(str(len(constructions))+'\n')
        for row in constructions:f.write(' '.join(map(str,row))+'\n')
json.dump(info,open('codex_work/scan_candidates.json','w'))
print('candidates',len(info),'base rules',len(rules))
