"""Lower each new strict out result to the counted memory model and judge it."""
import hashlib
import json
from pathlib import Path
import re
import subprocess

ROOT = Path('/path/to/repo')
destination = Path('round2/verified_mem')
destination.mkdir(exist_ok=True)
records = []
for source in sorted(Path('round2/verified').glob('*.s')):
    instructions = []
    for line in source.read_text().splitlines():
        line = line.split('#')[0].strip()
        if line:
            instructions.append(line)
    k = sum(not line.startswith('out ') for line in instructions)
    memory = [f'mov S{i}, P{i}' for i in range(5)]
    for line in instructions:
        line = re.sub(r'S(\d+)', lambda m: f'S{5+int(m[1])}', line)
        line = re.sub(r'P(\d+)', lambda m: f'S{m[1]}', line)
        if line.startswith('out '):
            j, register = line[4:].split(', ')
            line = f'mov P{j}, {register}'
        memory.append(line)
    target = destination / source.name
    assert len(memory) == k + 10
    target.write_text(f'# n=5 model=mem iset=I1 source=w6-round2 core={k} L={k+10}\n'
                      + '\n'.join(memory) + '\n')
    result = subprocess.run(['nice', '-n', '19', 'python3', str(ROOT/'shared/judge.py'),
                             str(target), '--strict', '--model', 'mem'],
                            capture_output=True, text=True)
    log = Path('round2/logs') / (target.stem + '_mem_judge.log')
    log.write_text(result.stdout + result.stderr)
    passed = result.returncode == 0 and 'PASS ' in result.stdout
    records.append({'source': str(source), 'path': str(target), 'core': k,
                    'total': len(memory), 'pass': passed, 'log': str(log),
                    'out_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
                    'mem_sha256': hashlib.sha256(target.read_bytes()).hexdigest()})
    Path('round2/artifacts/memory_judges.json').write_text(json.dumps(records, indent=2))
    print(target, 'PASS' if passed else 'FAIL', flush=True)
    if not passed:
        raise SystemExit(1)
