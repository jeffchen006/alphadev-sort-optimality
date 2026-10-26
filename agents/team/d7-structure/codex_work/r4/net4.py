import itertools,json,os
from pathlib import Path
ROOT=Path('codex_work/r4')
try:os.sched_setaffinity(0,set(sorted(os.sched_getaffinity(0))[:2]))
except (AttributeError,OSError):pass
X=tuple(sum(1<<s for s in range(16) if s>>i&1) for i in range(4))
OUT=frozenset(sum(1<<s for s in range(16) if s.bit_count()>=4-j) for j in range(4))
W=[w for w in itertools.product(range(4),repeat=4) if set(w)==set(range(len(set(w))))];assert len(W)==75
maps=[[sum(1<<p[i] for i in range(4) if s>>i&1) for s in range(16)] for p in itertools.permutations(range(4))]
cache={}
def act(t,k,rev):
    key=(t,k,rev)
    if key not in cache:
        q=sum(1<<s for s in range(16) if not(t>>(15^s)&1)) if rev else t
        cache[key]=sum(1<<maps[k][s] for s in range(16) if q>>s&1)
    return cache[key]
def canon(p):return min(tuple(sorted(act(t,k,r) for t in p)) for k in range(24) for r in [0,1])
def col(t):
    ss=[s for s in range(1,16) if t>>s&1];mins=[s for s in ss if not any(u!=s and u&s==u for u in ss)]
    return tuple(max(min(w[i] for i in range(4) if s>>i&1) for s in mins) for w in W)
manifest=[];seen=set();layer={(frozenset(X),frozenset())}
for d in range(1,8):
    nxt=set()
    for ch,p in layer:
        for a,b in itertools.combinations(ch,2):
            lo,hi=a&b,a|b
            if {lo,hi}=={a,b}:continue
            nc=(ch-{a,b})|{lo,hi}
            if len(nc)==4:nxt.add((frozenset(nc),p|{lo,hi}))
    layer=nxt
    print('network depth',d,'states',len(layer),flush=True)
    if d<5:continue
    done={canon(p-set(X)) for ch,p in layer if ch==OUT}
    for ts in sorted(done):
        if ts in seen:continue
        seen.add(ts);tag='n4_net%d_%d'%(d,len(manifest));fn=ROOT/(tag+'.txt')
        terms=list(X)+list(ts)
        with open(fn,'w') as f:
            for t in terms:f.write(' '.join(map(str,col(t)))+'\n')
        manifest.append({'tag':tag,'file':str(fn),'size':len(terms),'network_depth':d,'terms':terms})
json.dump(manifest,open(ROOT/'net4_manifest.json','w'),indent=2)
print('distinct pools',len(manifest),flush=True)
# Adapt the team's pool solver to n=4 and explicit cmp/write budgets.
s=Path('pool_bfs.cpp').read_text()
s=s.replace('NT = 541','NT = 75').replace('outterm[5]','outterm[4]')
s=s.replace('i < 5','i < 4').replace('j < 5','j < 4').replace('NP - 5','NP - 4').replace('t < 5 ? 0u : 1u << (t - 5)','t < 4 ? 0u : 1u << (t - 4)').replace('r < 5','r < 4')
s=s.replace('int NT = 75, NP, K, R;','int NT = 75, NP, K, R, CAPC, CAPW;')
s=s.replace('u8 fa, fb; uint32_t mask;','u8 fa, fb, nc; uint32_t mask;')
s=s.replace('k2 = b; return a;','b |= ((uint64_t)s.nc << 48); k2 = b; return a;')
s=s.replace('int x;','CAPC = atoi(argv[4]); CAPW = atoi(argv[5]); int x;',1)
s=s.replace('5 + K - remC[0]','4 + K - remC[0]').replace('5 + K - creations','4 + K - creations')
s=s.replace('s0.mask = 0; norm(s0);','s0.mask = 0; s0.nc = 0; norm(s0);')
s=s.replace('norm(s); addmask(s);','norm(s); addmask(s);\n      if (s.nc > CAPC || depth - s.nc + remC[s.mask] > CAPW || s.nc + remBf(closure(s.mask,s.fa,s.fb)) > CAPC) return;')
s=s.replace('St t = s; t.fa = min(s.r[a], s.r[b]);','if (s.nc >= CAPC) continue; St t = s; t.nc++; t.fa = min(s.r[a], s.r[b]);')
assert 't.nc++' in s and 'CAPC = atoi' in s and 'NB = NP - 4' in s
(ROOT/'pool4.cpp').write_text(s)
