#!/usr/bin/env python3
"""Canonicalize strict-order final states under input renaming and reversal."""
import collections,itertools,json,sys
from pathlib import Path
from insertion_sat import parse,run,ROOT
P=list(itertools.permutations(range(4)))
I={p:i for i,p in enumerate(P)}
transforms=[]
for rev in (False,True):
 for rename in P:
  order=[I[tuple((3-p[rename[j]]) if rev else p[rename[j]]) for j in range(4))] for p in P]
  transforms.append((rev,order))
raw=collections.Counter({int(i):int(n) for i,n in (ln.split() for ln in (ROOT/'round4/logs/raw_classes.tsv').read_text().splitlines())})
classes={};groups=[];flag_unions={};lost=0
for ii,(i,count) in enumerate(sorted(raw.items())):
 path=ROOT/f'round4/classes/raw{i}.s'
 prefix=[row for row in parse(path) if row[0]!='out']
 rows=[run(prefix,p+(4,)) for p in P]
 names=sorted(set().union(*(r[0] for r in rows)) - {'P4'})
 cols=[tuple(r[0][n] for r in rows) for n in names]
 flags=tuple(r[1] for r in rows)
 if any(not set(range(4))<=set(col[t] for col in cols) for t in range(24)):
  lost+=count
  continue
 candidates=[]
 for rev,order in transforms:
  ff=tuple(-flags[t] if rev else flags[t] for t in order)
  candidates.append((ff,rev,order))
 minflag=min(x[0] for x in candidates)
 keys=[]
 for ff,rev,order in candidates:
  if ff!=minflag:continue
  cc=tuple(sorted(tuple(3-col[t] if rev and col[t]<4 else col[t] for t in order) for col in cols))
  keys.append((ff,cc,rev,order))
 ff,cc,rev,order=min(keys,key=lambda x:(x[0],x[1]))
 key=(ff,cc)
 if key not in classes:
  classes[key]=len(groups)
  groups.append(dict(id=len(groups),representative=i,count=0,raw=[],flags=ff,columns=cc,transform=[rev,order]))
 group=groups[classes[key]];group['count']+=count;group['raw'].append(i)
 fk=ff
 if fk not in flag_unions:flag_unions[fk]=set()
 flag_unions[fk].update(cc)
 if ii%500==0:print(json.dumps(dict(processed=ii,canonical=len(groups),flags=len(flag_unions))),flush=True)
(ROOT/'round4/logs/classes.json').write_text(json.dumps(groups))
union=[dict(id=i,flags=f,columns=sorted(c)) for i,(f,c) in enumerate(sorted(flag_unions.items()))]
(ROOT/'round4/logs/flag_unions.json').write_text(json.dumps(union))
print(json.dumps(dict(raw=len(raw),canonical=len(groups),programs=sum(raw.values()),lost_value=lost,flag_unions=len(union),union_sizes=[len(g['columns']) for g in union])),flush=True)
