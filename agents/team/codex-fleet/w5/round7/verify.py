"""Strictly judge retained out programs and their memory translations."""
from pathlib import Path
import hashlib
import json
import subprocess
import sys

HERE = Path(__file__).resolve().parent
JUDGE = '/path/to/repo/shared/judge.py'


def verify(source):
    source = Path(source)
    text = source.read_text()
    out = HERE/'verified'/source.name
    out.write_text(text)
    mem = out.with_name(out.stem+'_mem.s')
    body = ['# n=5 model=mem iset=I1 source=w5-round7']
    body += [f'mov S{i}, P{i}' for i in range(5)]
    k = 0
    def register(x):
        return f'S{int(x[1:])+(5 if x[0]=="S" else 0)}'
    for line in text.splitlines():
        line = line.split('#')[0].strip()
        if not line:
            continue
        op, a, b = line.replace(',', '').split()
        if op == 'out':
            body.append(f'mov P{a}, {register(b)}')
        else:
            k += 1
            body.append(f'{op} {register(a)}, {register(b)}')
    mem.write_text('\n'.join(body)+'\n')
    rows = []
    for path, model in [(out, 'out'), (mem, 'mem')]:
        proc = subprocess.run(['nice', '-n', '19', sys.executable, '-B', JUDGE,
                               str(path), '--strict', '--model', model],
                              capture_output=True, text=True)
        log = HERE/'logs'/f'judge_{path.stem}.log'
        log.write_text(proc.stdout+proc.stderr)
        print(proc.stdout+proc.stderr, end='', flush=True)
        rows.append(dict(file=str(path), model=model, k=k, code=proc.returncode,
                         passed=proc.returncode == 0 and proc.stdout.startswith('PASS '),
                         log=str(log), sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
    with (HERE/'judge_ledger.jsonl').open('a') as f:
        f.writelines(json.dumps(row)+'\n' for row in rows)
    if not all(row['passed'] for row in rows):
        return False
    if k <= 31:
        results = HERE.parent/'RESULTS.md'
        found = f'FOUND k={k} out={out} mem={mem}; both strict judges PASS.\n'
        results.write_text(found+results.read_text())
    return True


if __name__ == '__main__':
    for source in sys.argv[1:]:
        if not verify(source):
            raise SystemExit(1)
