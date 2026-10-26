from pathlib import Path
from collections import Counter
import hashlib,json,re
HERE=Path(__file__).resolve().parent
summary={}
for name in ['collect_orig_a','collect_orig_b','collect_retimed']:
    path=HERE/'logs'/f'{name}.log'
    if not path.exists():continue
    txt=path.read_text();rows=[];near=[]
    for line in txt.splitlines():
        if line.startswith('SEED '):rows.append({k:float(v) if '.' in v else int(v) for k,v in re.findall(r'(\w+)=([0-9.]+)',line)})
        if line.startswith('NEAR '):near.append({k:int(v) for k,v in re.findall(r'(index|qualifying|retained|seenhist)=([0-9]+)',line)})
    summary[name]=dict(done='DONE 'in txt,seeds=len(rows),complete=sum(x['complete'] for x in rows),unknown=sum(not x['complete'] for x in rows),qualifying=sum(x['qualifying'] for x in near),retained=sum(x['retained'] for x in near),**{k:sum(x[k] for x in rows) for k in ['nodes','insertions','leaves']},rows=rows)
for name in ['near_flags','near_pairs']:
    path=HERE/'logs'/f'{name}.log'
    if not path.exists():continue
    done=next((x for x in reversed(path.read_text().splitlines()) if x.startswith('DONE ')),None)
    summary[name]=dict(done=done is not None,**({k:int(v) for k,v in re.findall(r'(seeds|tested|near|retained)=([0-9]+)',done)} if done else {}))
ledger=HERE/'judge_ledger.jsonl'
judges=[json.loads(x) for x in ledger.read_text().splitlines()] if ledger.exists() else []
for row in judges:
    row['intact']=hashlib.sha256(Path(row['file']).read_bytes()).hexdigest()==row['sha256']
summary['judges']=judges
(HERE/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:{a:b for a,b in v.items() if a!='rows'} if isinstance(v,dict) else v for k,v in summary.items()},indent=2))
