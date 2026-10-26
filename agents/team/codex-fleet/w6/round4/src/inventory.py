"""Record a superset of the requested saved k=32 variants."""
import hashlib
import json
from pathlib import Path

paths = sorted(Path('verified').glob('*.s'))
paths += sorted(Path('round2/verified').glob('*.s'))
paths += sorted(Path('round3/verified').glob('*.s'))
rows = []
for path in paths:
    lines = [line.split('#')[0].strip() for line in path.read_text().splitlines()]
    core = [line for line in lines if line and not line.startswith('out ')]
    assert len(core) == 32, (path, len(core))
    rows.append({'path':str(path), 'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
                 'mov':sum(line.startswith('mov ') for line in core),
                 'cmp':sum(line.startswith('cmp ') for line in core)})
Path('round4/artifacts/inventory.json').write_text(json.dumps(rows,indent=2))
Path('round4/artifacts/all.txt').write_text(''.join(row['path']+'\n' for row in rows))
zero = [row for row in rows if row['path'].startswith('round3/') and row['mov'] == 0]
assert len(zero) == 6
Path('round4/artifacts/nomov.txt').write_text(''.join(row['path']+'\n' for row in zero))
print(json.dumps({'all':len(rows),'by_folder':{folder:sum(row['path'].startswith(folder+'/') for row in rows)
                for folder in ('verified','round2','round3')},'nomov':len(zero)}))
