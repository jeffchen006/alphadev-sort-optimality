"""Select twenty sources by distinct CMP register-pair count."""
from pathlib import Path
from collections import Counter
import hashlib,json,sys
sys.dont_write_bytecode=True
HERE=Path(__file__).resolve().parent

def main():
    rows=json.loads((HERE.parent/'round5/manifest.json').read_text())
    ranking=[]
    for row in rows:
        assert hashlib.sha256(Path(row['source']).read_bytes()).hexdigest()==row['sha256']
        assert row['index']==rows.index(row) and len(row['program'])==32
        pairs=[sorted((d,s)) for o,d,s in row['program'] if o==1]
        ranking.append(dict(seed=row['index'],distinct_cmp_pairs=len(set(map(tuple,pairs))),cmp_order=pairs))
    ranking.sort(key=lambda r:(r['distinct_cmp_pairs'],r['seed']))
    selected=ranking[:20]
    queue=[dict(seed=row['seed'],start=s,width=4,replacement=3,distinct_cmp_pairs=row['distinct_cmp_pairs'])
           for row in selected for s in range(29)]
    # Interleave sources, with later windows first. Every selected window remains in the queue.
    rank={r['seed']:i for i,r in enumerate(selected)}
    queue.sort(key=lambda r:(-r['start'],rank[r['seed']]))
    for name,value in [('manifest',rows),('selection',dict(rule='distinct unordered CMP register pairs; source index breaks ties',
         selected=selected,ranking=ranking,score_counts=dict(Counter(r['distinct_cmp_pairs'] for r in ranking)))),('queue',queue)]:
        (HERE/f'{name}.json').write_text(json.dumps(value,indent=2)+'\n')
    print(json.dumps(dict(sources=len(rows),selected=[r['seed'] for r in selected],queries=len(queue))))

if __name__=='__main__':main()
