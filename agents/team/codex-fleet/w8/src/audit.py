#!/usr/bin/env python3
"""Merge results by canonical skeleton, without treating limits as negatives."""
from pathlib import Path
import json,collections,hashlib
from priority_dedup import key
groups=collections.defaultdict(list);filekeys={}
for manifest in ['sk/broad_nonlattice.json','sk/two_priority_new.json','sk/mutation2_nonlattice.json']:
    for row in json.loads(Path(manifest).read_text()):
        f=row['file'];k=key(f);groups[k].append(f);filekeys[f]=k
statuses=collections.defaultdict(set);attempts=collections.Counter();calls=0
for resultfile in sorted(Path('logs').glob('*/results.jsonl')):
    for line in resultfile.read_text().splitlines():
        row=json.loads(line);f=row['file']
        if f not in filekeys:continue
        statuses[filekeys[f]].add(row['status']);attempts[row['status']]+=1;calls+=row.get('calls',0)
priorfile=Path('sk/nonlattice_prior_keys.txt');prior=set()
if priorfile.exists():
    for l in priorfile.read_bytes().splitlines():prior.add(hashlib.sha256(l).digest())
verdicts={};openrows=[]
for k,files in groups.items():
    ss=statuses[k];v='FOUND' if 'FOUND' in ss else 'NONE' if 'NONE' in ss else 'UNRESOLVED' if ss else 'UNTESTED'
    if v=='UNTESTED' and k in prior:v='PRIOR_MATCH'
    verdicts[k]=v
    if v in ('UNRESOLVED','UNTESTED') and k not in prior:openrows.append(dict(file=files[0],equivalent_files=files,statuses=sorted(ss)))
prior_matches=[dict(file=fs[0],equivalent_files=fs,verdict=verdicts[k]) for k,fs in groups.items() if k in prior]
result=dict(source_records=sum(len(v) for v in groups.values()),canonical_skeletons=len(groups),verdicts=dict(collections.Counter(verdicts.values())),new_skeletons=sum(k not in prior for k in groups),new_verdicts=dict(collections.Counter(v for k,v in verdicts.items() if k not in prior)),attempts=dict(attempts),recorded_calls=calls,prior_cache_available=priorfile.exists(),prior_canonical_keys=len(prior),prior_matches=len(prior_matches),open_cases=openrows,prior_match_records=prior_matches)
Path('logs/audit.json').write_text(json.dumps(result,indent=2)+'\n');Path('sk/open_cases.json').write_text(json.dumps(openrows,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k not in ('open_cases','prior_match_records')},indent=2))
