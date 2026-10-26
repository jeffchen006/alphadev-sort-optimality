"""Round-robin selected short gaps and transformed repeat operands."""
import collections
import json
from pathlib import Path

rows=json.loads(Path('round10/artifacts/expanded_manifest.json').read_text())
initial=json.loads(Path('round10/artifacts/manifest.json').read_text())
# Prefer regenerated flags from changed values; use all source structures.
# For each structure, first try a short delay at the middle comparisons.
bybase=collections.defaultdict(list)
for row in rows:
    bybase[row['base']].append(row)
for base,items in bybase.items():
    items.sort(key=lambda x:(x['kind']!='transformed_repeat_operands',x['insert']-x['repeat'],abs(x['repeat']-4),x['repeat']))
selected=[]
for i in range(8):
    for base in sorted(bybase):
        if i<len(bybase[base]):selected.append(bybase[base][i])
# Include the original distinct flag classes as a separate baseline tranche.
initial.sort(key=lambda x:(x['insert']-x['repeat'],abs(x['repeat']-4),x['base']))
for row in initial:
    if row['insert']-row['repeat']==2:selected.append(row)
Path('round10/artifacts/selected_manifest.json').write_text(json.dumps(selected,indent=2))
print('selected',len(selected),'bases',len(bybase),'kinds',dict(collections.Counter(x.get('kind','initial_exact') for x in selected)))
