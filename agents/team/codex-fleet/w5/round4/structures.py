"""Classify retained k=32 comparison columns against the frozen seeds."""
from pathlib import Path
import hashlib,json,time
HERE=Path(__file__).resolve().parent
# Read definitions only; do not run the old report or write in round2.
text=(HERE.parent/'round2/semantics.py').read_text().split('rows=[];known=')[0]
space={'__file__':str(HERE/'dummy.py')}
exec(compile(text,'round2 semantics definitions','exec'),space)
comparison_columns=space['comparison_columns'];canonical=space['canonical']
CASES=space['cases'];distinct=[i for i,a in enumerate(CASES) if len(set(a))==5]
known=set();known_distinct=set();rows=[];began=time.monotonic()
for seed in json.loads((HERE/'manifest.json').read_text()):
    columns=comparison_columns(Path(seed['source']))
    known.add(canonical(columns));known_distinct.add(canonical(columns,distinct))
for path in sorted((HERE/'candidates').glob('*.s')):
    lines=[x for x in path.read_text().splitlines() if x and not x.startswith(('#','out'))]
    if len(lines)!=32 or not path.name.startswith(('restart_a','bridge_short')):continue
    columns=comparison_columns(path);full=canonical(columns);strict=canonical(columns,distinct)
    rows.append(dict(file=str(path),comparisons=len(columns),new_full=full not in known,new_distinct=strict not in known_distinct,signature=hashlib.sha256(full).hexdigest()[:24]))
summary=dict(known_full_classes=len(known),known_distinct_classes=len(known_distinct),samples=len(rows),new_full_classes=len({r['signature'] for r in rows if r['new_full']}),new_distinct_samples=sum(r['new_distinct'] for r in rows),rows=rows,seconds=time.monotonic()-began)
(HERE/'comparison_structures.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='rows'}))
