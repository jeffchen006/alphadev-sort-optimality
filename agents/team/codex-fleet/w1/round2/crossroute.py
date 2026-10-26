# Independent tuple-state allocation search. All 120 strict orders. Five copies.
# It uses threshold sets, not the C++ per-case matching loop or packed counters.
import json,itertools,time
start=time.monotonic();plans=json.load(open('round2/plans.json'))
weak=[w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(max(w)+1))]
ix=[i for i,w in enumerate(weak) if len(set(w))==5]
assert len(ix)==120
ALL=(1<<120)-1;total=0
for number,p in enumerate(plans):
 values=[tuple(int(col[i]) for i in ix) for col in p['terms']]
 thr=[tuple(sum(1<<j for j,x in enumerate(col) if x>=t) for t in range(1,5)) for col in values]
 diff=[[0]*23 for _ in range(23)]
 for a in range(23):
  for b in range(23):
   for x,y in zip(thr[a],thr[b]):diff[a][b]|=x^y
 blocks=[]
 for b in p['blocks']:
  if b['cmp']:blocks.append([b['a'],b['b'],[]])
  blocks[-1][2].extend([b['x'],b['y']])
 rule={}
 for a,b,targets in blocks:
  lt=gt=0
  for x,y in zip(thr[a],thr[b]):lt|=(ALL^x)&y;gt|=x&(ALL^y)
  for t in targets:
   rr=[]
   for flag in (lt,ALL^gt,gt,ALL^lt):
    ds={d for d in range(23) if not(diff[t][d]&(ALL^flag))};ss={s for s in range(23) if not(diff[t][s]&flag)}
    rr.append((ds,ss))
   rule[t]=rr
 layer={(0,1,2,3,4)}
 made=set(range(5));count=0
 for j,(a,b,targets) in enumerate(blocks):
  future={x for bb in blocks[j+1:] for x in bb[:2]}
  layer={r for r in layer if a in r and b in r}
  layers=[set() for _ in range(1<<len(targets))];layers[0]=layer
  for mask in range((1<<len(targets))-1):
   already=made|{t for i,t in enumerate(targets) if mask>>i&1}
   for i,t in enumerate(targets):
    if mask>>i&1:continue
    needed=future&(already|{t});out=layers[mask|(1<<i)]
    for r in layers[mask]:
     have=set(r);ds=set()
     for d,s in rule[t]:
      if have&s:ds|=have&d
     if ds and len(r)<10:out.add(tuple(sorted(r+(t,))))
     for d in ds:
      if d in needed and r.count(d)==1:continue
      rr=list(r);rr.remove(d);rr.append(t);out.add(tuple(sorted(rr)))
  layer=layers[-1];made.update(targets);count+=len(layer)
  if not layer:break
 assert not layer,('candidate with <=5 copies',number)
 total+=count
 if (number+1)%20==0:print('plans',number+1,'boundary_states',total,'seconds',round(time.monotonic()-start,3),flush=True)
print('INDEPENDENT: no <=5-copy routing for all 198 c=8 plans; k=8+18+5=31 excluded in this family.',flush=True)
print('boundary_states',total,'seconds',round(time.monotonic()-start,3),flush=True)
