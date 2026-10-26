"""Route six new structures on one CPU slot; limits remain incomplete."""
from collections import Counter
import json
from pathlib import Path
import subprocess
import time

def instructions(path):
    return [s for s in path.read_text().splitlines()
            if s and not s.startswith(('#', 'out'))]

def flags(path):
    text = (Path('round2/artifacts/skeletons')/(path.stem+'.skel')).read_text()
    result = b''
    for line in text.splitlines():
        if not line or line.startswith('#'):
            continue
        a, b = [s[1:] for s in line.split(':')]
        f = bytes((x > y) - (x < y) + 1 for x, y in zip(a, b))
        result += min(f, bytes(2-v for v in f))
    return result

files = sorted(Path('round2/verified').glob('*.s'))
old = {p.stem for p in Path('verified').glob('*.s')}
old |= {r['program'].split('/')[-1][:-2]
        for r in json.loads(Path('round2/artifacts/initial_routing.json').read_text())}
zero = [p for p in files if not any(s.startswith('mov ') for s in instructions(p))]
assert len(zero) == 1
one = [p for p in files if p.stem not in old
       and sum(s.startswith('mov ') for s in instructions(p)) == 1]
selected = [zero[0]]
vectors = {p: flags(p) for p in [*zero, *one]}
while len(selected) < 6 and one:
    chosen = max(one, key=lambda p: min(sum(x != y for x, y in zip(vectors[p], vectors[q]))
                                       for q in selected))
    selected.append(chosen)
    one.remove(chosen)
Path('round2/artifacts/selected_routing_inputs.json').write_text(json.dumps(list(map(str, selected)), indent=2))

records = []
for index, source in enumerate(selected):
    log = Path('round2/logs')/(source.stem+'_selected_route31.log')
    skel = Path('round2/artifacts/skeletons')/(source.stem+'.skel')
    began = time.monotonic()
    limit, seconds = (60000000, 180) if index == 0 else (10000000, 60)
    with log.open('w') as output:
        rc = subprocess.run(['nice', '-n', '19', 'timeout', f'{seconds}s',
                             './dagx', str(skel), '31', '1', str(limit)],
                            stdout=output, stderr=subprocess.STDOUT).returncode
    text = log.read_text()
    results = [s for s in text.splitlines() if s.startswith('RESULT ')]
    row = {'source': str(source), 'skeleton': str(skel), 'node_limit': limit,
           'wall_limit': seconds, 'returncode': rc, 'result': results,
           'seconds': time.monotonic()-began, 'log': str(log)}
    records.append(row)
    Path('round2/artifacts/selected_routing.json').write_text(json.dumps(records, indent=2))
    print(json.dumps(row), flush=True)
    if 'SOLUTION cost=' not in text:
        continue
    body = text.split('\nSOLUTION ', 1)[1].split('\n', 1)[1].split('\nEND', 1)[0]
    candidate = Path('round2/candidates')/(source.stem+'_route31.s')
    candidate.write_text('# n=5 model=out iset=I1 source=w6-selected-routing\n'+body+'\n')
    judge_log = Path('round2/logs')/(candidate.stem+'_judge.log')
    with judge_log.open('w') as output:
        rc = subprocess.run(['nice', '-n', '19', 'python3',
            '/path/to/repo/shared/judge.py',
            str(candidate), '--strict', '--model', 'out'], stdout=output,
            stderr=subprocess.STDOUT).returncode
    row['strict_out_pass'] = rc == 0 and 'PASS ' in judge_log.read_text()
    Path('round2/artifacts/selected_routing.json').write_text(json.dumps(records, indent=2))
    if row['strict_out_pass']:
        print('STRICT_OUT_PASS', candidate, flush=True)
        break
