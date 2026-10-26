#!/usr/bin/env python3
"""Summarize completed round-2 searches without treating limits as negatives."""
import collections,json,re
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]

def main():
 base={};calls=0;passes=0;byfamily={};solver=[]
 for fn in [ROOT/'round2/logs/route_batch.jsonl']+sorted((ROOT/'round2/logs').glob('retry_routes_*.jsonl')):
  for line in fn.read_text().splitlines():
   r=json.loads(line)
   if 'file' not in r:continue
   result=r['result'];m=re.search(r'RESULT (\w+).*calls=(\d+)',result)
   status=m[1] if m else 'TIMEOUT' if r['rc']==124 else 'UNKNOWN'
   base[r['file']]=status;calls+=int(m[2]) if m else 0
 stats=collections.Counter(base.values())
 for path,status in base.items():
  family=Path(path).stem.split('_')[0];byfamily.setdefault(family,collections.Counter())[status]+=1
 for fn in sorted((ROOT/'round2/logs').glob('*.log')):
  for line in fn.read_text().splitlines():
   if line.startswith('{'):
    r=json.loads(line)
    if r.get('event')=='RESULT':solver.append(r)
 out=dict(routing=dict(distinct=len(base),statuses=dict(stats),calls=calls,families={k:dict(v) for k,v in byfamily.items()}),sat=solver)
 (ROOT/'round2/logs/summary.json').write_text(json.dumps(out,indent=2)+'\n')
 print(json.dumps(out,indent=2))
if __name__=='__main__':main()
