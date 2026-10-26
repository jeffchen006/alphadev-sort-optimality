"""Separate alternative repeat operands to strengthen fixed-operand bounds."""
import collections
import hashlib
import json
from pathlib import Path
import generate as g
from expand import opkey
import numpy as np

out=Path('round10/sk_single');out.mkdir(exist_ok=True)
rows=json.loads(Path('round10/artifacts/expanded_manifest.json').read_text())
inputs={bytes(x) for x in g.P.T}
targets={bytes([i]*120) for i in range(5)}
groups=collections.defaultdict(list);seen=set()
for row in rows:
    if row.get('kind')!='transformed_repeat_operands':continue
    lines=[l.strip() for l in Path(row['file']).read_text().splitlines() if l.strip() and not l.startswith('#')]
    pos=row['insert']
    for altidx,alt in enumerate(lines[pos].split(';')):
        chosen=lines.copy();chosen[pos]=alt
        sk=np.array([[g.column(x) for x in l.split(';')[0].split(':')] for l in chosen],dtype=np.uint8)
        k=opkey(sk)
        if k in seen:continue
        seen.add(k)
        required=({bytes(x) for pair in sk for x in pair}|targets)-inputs
        # A large set of required columns can tighten the routing bound.
        # This is priority only. No omitted case inherits a negative result.
        meta=dict(row,alternative=altidx,required_noninput=len(required),parent=row['file'])
        groups[row['base']].append((meta,chosen))
for base,items in groups.items():
    items.sort(key=lambda z:(-z[0]['required_noninput'],z[0]['insert']-z[0]['repeat'],abs(z[0]['repeat']-4),z[0]['alternative']))
selected=[];inventory=[]
for rank in range(max(map(len,groups.values()))):
    for base in sorted(groups):
        if rank>=len(groups[base]):continue
        meta,lines=groups[base][rank]
        dest=out/f's{len(inventory):05d}.txt'
        dest.write_text(f'# parent={meta["parent"]} alternative={meta["alternative"]}\n'+'\n'.join(lines)+'\n')
        meta=dict(meta,file=str(dest),rank_in_base=rank,kind='fixed_transformed_repeat',alternatives=1,sha256=hashlib.sha256(dest.read_bytes()).hexdigest())
        inventory.append(meta)
        if rank<2:selected.append(meta)
Path('round10/artifacts/singleton_inventory.json').write_text(json.dumps(inventory,indent=2))
Path('round10/artifacts/singleton_manifest.json').write_text(json.dumps(selected,indent=2))
initial=json.loads(Path('round10/artifacts/manifest.json').read_text())
macro=[x for x in initial if 'macro9one' in x['seed']]
Path('round10/artifacts/macro_manifest.json').write_text(json.dumps(macro,indent=2))
print('singleton inventory',len(inventory),'selected',len(selected),'bases',len(groups),'required columns',dict(collections.Counter(x['required_noninput'] for x in selected)),flush=True)
