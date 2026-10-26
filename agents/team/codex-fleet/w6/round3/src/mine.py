"""Mine saved assembly programs for k=32 cores with no mov."""
from collections import Counter
import hashlib
import json
from pathlib import Path

seen = {}
counts = Counter()
folders = ('verified', 'round2/verified', 'round2/candidates', 'candidates')
def save(folder, complete=False):
    counts['unique_zero_mov_cores'] = len(seen)
    Path('round3/artifacts/zero_mov_inventory.json').write_text(
        json.dumps({'counts':dict(counts), 'programs':list(seen.values()),
                    'last_folder':folder, 'complete':complete},indent=2))
    print(json.dumps({'folder':folder, **dict(counts)}),flush=True)
for folder in folders:
    for path in sorted(Path(folder).glob('*.s')):
        counts['files'] += 1
        lines = [s.split('#')[0].strip() for s in path.read_text().splitlines()]
        core = [s for s in lines if s and not s.startswith('out')]
        if len(core) != 32 or any(s.startswith('mov ') for s in core):
            continue
        counts['zero_mov_files'] += 1
        # Deduplicate input and scratch renaming. Normalize condition reversal.
        regs, body = {}, []
        for line in core:
            op, d, s = line.replace(',', '').split()
            for r in (d,s):
                if r not in regs:
                    c = r[0]
                    regs[r] = c+str(sum(x[0] == c for x in regs))
            body.append((op,regs[d],regs[s]))
        body = tuple(body)
        if body in seen:
            seen[body]['copies'] += 1
            continue
        h = hashlib.sha256(repr(body).encode()).hexdigest()[:16]
        target = Path('round3/candidates') / f'nomov_{h}.s'
        target.write_text(path.read_text())
        seen[body] = {'source':str(path), 'target':str(target), 'copies':1}
        save(folder)
    save(folder)
save(folders[-1], True)
