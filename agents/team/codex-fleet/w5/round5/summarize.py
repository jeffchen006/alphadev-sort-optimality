from pathlib import Path
import re,json,hashlib
HERE=Path(__file__).resolve().parent
summary={}
for name in ['fuse','retime','free_a','free_b','retimed_free_a','retimed_free_b']:
    log=HERE/'logs'/f'{name}.log'
    if not log.exists():continue
    text=log.read_text();rows=[]
    for line in text.splitlines():
        if line.startswith('SEED '):rows.append({k:float(v) if '.' in v else int(v) for k,v in re.findall(r'(\w+)=([0-9.]+)',line)})
    summary[name]=dict(done='DONE ' in text,seeds=len(rows),complete=sum(r.get('complete',1) for r in rows),unknown=sum(not r.get('complete',1) for r in rows),found=sum(r['found'] for r in rows),**{k:sum(r[k] for r in rows) for k in ['nodes','insertions','leaves','solutions','rewritten','keepfails']},seconds=rows[-1]['seconds'] if rows else 0,rows=rows)
ledger=HERE/'judge_ledger.jsonl'
judges=[json.loads(x) for x in ledger.read_text().splitlines()] if ledger.exists() else []
for row in judges:
    path=Path(row['file']);row['current_hash']=hashlib.sha256(path.read_bytes()).hexdigest();row['intact']=row['current_hash']==row['sha256']
summary['judge_files']=len(judges);summary['judge_passes']=sum(r['passed'] for r in judges)
(HERE/'verified_integrity.json').write_text(json.dumps(judges,indent=2)+'\n')
(HERE/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:{a:b for a,b in v.items() if a!='rows'} if isinstance(v,dict) else v for k,v in summary.items()},indent=2))
