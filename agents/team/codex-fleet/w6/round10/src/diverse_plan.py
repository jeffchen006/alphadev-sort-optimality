"""Extend the fixed-pair batch across repeat stages without changing files."""
import collections
import json
from pathlib import Path

inventory=json.loads(Path('round10/artifacts/singleton_inventory.json').read_text())
existing=json.loads(Path('round10/artifacts/singleton_manifest.json').read_text())
groups=collections.defaultdict(list)
for row in inventory:groups[row['base']].append(row)
perbase={};seen={x['file'] for x in existing}
for base,items in groups.items():
    chosen=[x for x in existing if x['base']==base]
    usedrepeats={x['repeat'] for x in chosen}
    usedpositions={(x['repeat'],x['insert']) for x in chosen}
    while len(chosen)<8:
        available=[x for x in items if x['file'] not in seen]
        if not available:break
        available.sort(key=lambda x:(x['repeat'] in usedrepeats,(x['repeat'],x['insert']) in usedpositions,-x['required_noninput'],x['insert']-x['repeat'],x['rank_in_base']))
        x=available[0];chosen.append(x);seen.add(x['file'])
        usedrepeats.add(x['repeat']);usedpositions.add((x['repeat'],x['insert']))
    perbase[base]=chosen
plan=[]
for rank in range(8):
    for base in sorted(perbase):
        if rank<len(perbase[base]):plan.append(perbase[base][rank])
Path('round10/artifacts/diverse_manifest.json').write_text(json.dumps(plan,indent=2))
print('diverse fixed-pair plan',len(plan),'queries',len(perbase),'bases',flush=True)
