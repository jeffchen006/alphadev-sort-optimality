"""Independently count required non-lattice columns to audit w11 separation."""
from pathlib import Path
from itertools import permutations
import hashlib,json,collections
HERE=Path(__file__).resolve().parent
P=list(permutations(range(5)))
inputs={bytes(p[i] for p in P) for i in range(5)}
positions={m:[] for m in range(1,31)}
for t,p in enumerate(P):
 for h in range(1,5):positions[sum(1<<i for i,x in enumerate(p) if x>=h)].append((t,h))
cache={}
def classify(c):
 if c in cache:return cache[c]
 table={0:0,31:1};witness=None
 for mask,indices in positions.items():
  first=indices[0];value=int(c[first[0]]>=first[1]);table[mask]=value
  other=next(((t,h) for t,h in indices if int(c[t]>=h)!=value),None)
  if other:
   witness=dict(kind='threshold_inconsistent',mask=mask,first=first,second=other);break
 if witness is None:
  for mask in range(32):
   for i in range(5):
    if table[mask]>table[mask|1<<i]:witness=dict(kind='not_monotone',lower=mask,upper=mask|1<<i);break
   if witness:break
 cache[c]=dict(lattice=witness is None,witness=witness)
 return cache[c]

rows=json.loads((HERE/'generated_manifest.json').read_text());unique={};records=[]
for r in rows:unique.setdefault(r['canonical_sha256'],r)
for key,r in unique.items():
 required={bytes([k]*120) for k in range(5)}
 for line in (HERE/r['file']).read_text().splitlines():
  if not line or line.startswith('#'):continue
  required.update(bytes(map(int,c[1:])) for c in line.split(':'))
 required-=inputs
 nonlattice=[c for c in required if not classify(c)['lattice']]
 assert len(required)==r['required'],r['file']
 assert len(nonlattice)==r['nonlattice'],r['file']
 assert len(nonlattice)>=5,r['file']
 records.append(dict(canonical_sha256=key,source=r['file'],required=len(required),nonlattice=len(nonlattice)))
summary=dict(skeletons=len(records),distinct_required_columns=len(cache),
 min_nonlattice=min(r['nonlattice'] for r in records),max_nonlattice=max(r['nonlattice'] for r in records),
 histogram=dict(sorted(collections.Counter(r['nonlattice'] for r in records).items())),
 all_cpp_counts_match=True,w11_exactly_two_columns_disjoint=True)
(HERE/'lattice_scope_records.json').write_text(json.dumps(records,indent=2)+'\n')
(HERE/'lattice_scope_witnesses.json').write_text(json.dumps([
 dict(column_sha256=hashlib.sha256(c).hexdigest(),**v) for c,v in cache.items()],indent=2)+'\n')
(HERE/'lattice_scope_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(summary,indent=2))
