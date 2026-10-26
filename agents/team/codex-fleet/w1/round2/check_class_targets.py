# Check that comparison-structure classes also preserve the complete target blocks.
import itertools,json,time
start=time.monotonic();pp=list(itertools.permutations(range(5)));row={w:i for i,w in enumerate(pp)}
weak=[w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(max(w)+1))];ix=[i for i,w in enumerate(weak) if len(set(w))==5]
trans=[]
for g in pp:
 for rev in (False,True):trans.append(([row[tuple(4-w[g[j]] if rev else w[g[j]] for j in range(5))] for w in pp],rev))
plans=json.load(open('round2/plans.json'));representatives={};matches=0
for p in plans:
 cols=[''.join(str(c[i]) for i in ix) for c in p['terms']]
 for b in p['blocks']:
  if b['cmp']:assert all(x!=y for x,y in zip(cols[b['a']],cols[b['b']])),('equal identities',p['network'])
 def signature(vals):
  blocks=[]
  for b in p['blocks']:
   if b['cmp']:blocks.append([tuple(sorted((vals[b['a']],vals[b['b']]))),[]])
   blocks[-1][1].extend((vals[b['x']],vals[b['y']]))
  return tuple((ab,tuple(sorted(ts))) for ab,ts in blocks)
 sig=signature(cols)
 if p['class'] not in representatives:representatives[p['class']]=sig;matches+=1;continue
 expected=representatives[p['class']];first=p['blocks'][0];ok=False
 for ids,rev in trans:
  def mapcol(c):return ''.join(chr(ord('0')+4-int(c[i])) if rev else c[i] for i in ids)
  if tuple(sorted((mapcol(cols[first['a']]),mapcol(cols[first['b']]))))!=expected[0][0]:continue
  if signature([mapcol(c) for c in cols])==expected:ok=True;break
 assert ok,('target family differs',p['network'],p['class'])
 matches+=1
print('All',matches,'plans match the full comparison and unordered target-block signatures of',len(representatives),'representatives.')
print('All comparison operands differ on every strict order in every base plan.')
print('seconds',round(time.monotonic()-start,3))
