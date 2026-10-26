"""Freeze unresolved cases and record tenfold limits in gate-count order."""
import collections
import itertools
import json
from pathlib import Path

inputs = {''.join(str(p[i]) for p in itertools.permutations(range(5))) for i in range(5)}
def required(file):
    columns = {c[1:] for line in Path(file).read_text().splitlines()
               if line.startswith('=') for c in line.split(':')}
    return len((columns | {str(i)*120 for i in range(5)}) - inputs)

if __name__ == '__main__':
    original = Path('sk/round2_original_open.json')
    if not original.exists(): original.write_text(Path('sk/open_cases.json').read_text())
    previous = collections.defaultdict(list)
    for file in Path('logs').glob('*/results.jsonl'):
        if file.parent.name.startswith('round2'): continue
        for line in file.read_text().splitlines():
            row = json.loads(line)
            previous[row['file']].append(row)
    queue = []
    for row in json.loads(original.read_text()):
        old_limit = max(r['node_limit'] for f in row['equivalent_files'] for r in previous[f])
        queue.append(dict(**row, required_gates=required(row['file']),
                          previous_node_limit=old_limit, node_limit=10*old_limit))
    queue.sort(key=lambda r:(r['required_gates'],r['node_limit'],r['file']))
    Path('sk/round2_rerun.json').write_text(json.dumps(queue,indent=2)+'\n')
    known = {r['file'] for m in ('broad_nonlattice','two_priority_new','mutation2_nonlattice')
             for r in json.loads(Path('sk/'+m+'.json').read_text())}
    known.update(str(p) for p in Path('sk/net9_41_mutation').glob('*.txt'))
    prior = Path('/path/to/repo/agents/team/d6-qd/runs/nlsk_net41')
    known.update(str(p) for p in prior.glob('*.txt'))
    Path('sk/round2_excluded_files.txt').write_text('\n'.join(sorted(known))+'\n')
    print(json.dumps(dict(cases=len(queue),gate_counts=dict(sorted(collections.Counter(r['required_gates'] for r in queue).items())),
                          limits=dict(sorted(collections.Counter(r['node_limit'] for r in queue).items())))))
