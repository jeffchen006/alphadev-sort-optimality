"""Lower an out-model program to the counted memory model."""
import json
from pathlib import Path
import re
import sys

source, target = map(Path, sys.argv[1:])
scratch = {}
body = []
for raw in source.read_text().splitlines():
    line = raw.split('#')[0].strip()
    if not line:
        continue

    def renumber(match):
        register = match.group()
        if register not in scratch:
            scratch[register] = len(scratch)
        return f'S{5 + scratch[register]}'

    line = re.sub(r'S\d+', renumber, line)
    line = re.sub(r'P(\d+)', lambda m: f'S{m[1]}', line)
    if line.startswith('out '):
        j, register = line[4:].split(',')
        line = f'mov P{j.strip()}, {register.strip()}'
    body.append(line)
body = [f'mov S{i}, P{i}' for i in range(5)] + body
target.write_text(f'# n=5 model=mem iset=I1 source=w1-round3 L={len(body)}\n'
                  + '\n'.join(body) + '\n')
print(json.dumps({'source': str(source), 'memory_file': str(target), 'L': len(body)}))
