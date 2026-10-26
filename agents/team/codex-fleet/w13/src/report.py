"""Summarize durable records. Run after a serial stage or at final shutdown."""
import collections,hashlib,json
from pathlib import Path

def main():
    ledgers=[];batches=[];allrecords=[]
    for file in sorted(Path('logs').glob('*/results.jsonl')):
        rows=[json.loads(l) for l in file.read_text().splitlines() if l.strip()]
        allrecords.extend(rows)
        batches.append(dict(batch=file.parent.name,records=len(rows),statuses=dict(collections.Counter(r['status'] for r in rows)),calls=sum(r.get('calls') or 0 for r in rows),cpu_seconds=sum(r.get('cpu_seconds') or 0 for r in rows)))
    unique={}
    for r in allrecords:
        if r['k']==31:
            old=unique.get(r['sha256'])
            if old is None or r['status']=='NONE' or old['status']!='NONE' and r['node_limit']>old['node_limit']:unique[r['sha256']]=r
    closed=[r for r in unique.values() if r['status']=='NONE']
    openrows=[r for r in unique.values() if r['status']!='NONE']
    Path('sk/open_cases.json').write_text(json.dumps(sorted(openrows,key=lambda r:(r['c'],r['required'],-r['node_limit'],r['file'])),indent=2)+'\n')
    passes=[];failures=[]
    p=Path('logs/judges.jsonl')
    if p.exists():
        for line in p.read_text().splitlines():
            for r in json.loads(line):
                (passes if r['passed'] else failures).append(r)
    result=dict(batches=batches,unique_tested=len(unique),unique_closed=len(closed),unique_open=len(openrows),closed_by_c=dict(collections.Counter(r['c'] for r in closed)),open_by_c=dict(collections.Counter(r['c'] for r in openrows)),judge_passes=passes,judge_failures=failures)
    Path('logs/report.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ('judge_passes','judge_failures')}),flush=True)

if __name__=='__main__':main()
