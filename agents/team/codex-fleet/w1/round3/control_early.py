"""Positive control with a deliberately delayed, stable minimum output."""
from pathlib import Path
import subprocess
import analyze

HERE = Path(__file__).resolve().parent
JUDGE = Path('/path/to/repo/shared/judge.py')
source = sorted(analyze.SOURCE.glob('*.s'))[0]
body = [line for line in source.read_text().splitlines()
        if line.strip() and not line.startswith('#')]
where = next(i for i, line in enumerate(body) if line.startswith('out 0,'))
out = body.pop(where)
register = out.split(',')[1].strip()
assert all(line.startswith('out ') or line.split()[0] == 'cmp'
           or line.split()[1].rstrip(',') != register for line in body[where:])
body.append(out)
base = HERE / 'delayed_control32.s'
base.write_text('# n=5 model=out iset=I1 source=w1-delayed-control k=32\n'
                + '\n'.join(body) + '\n')
_, problem = analyze.analyze(base)
analyze.export([problem], HERE / 'delayed_problem.txt')


def judge(path, model='out'):
    result = subprocess.run(['nice', '-n', '19', 'python3', str(JUDGE),
                             str(path), '--strict', '--model', model],
                            capture_output=True, text=True)
    path.with_suffix('.judge.log').write_text(result.stdout + result.stderr)
    print(result.stdout.strip(), flush=True)
    assert result.returncode == 0 and result.stdout.startswith('PASS ')


judge(base)
with (HERE / 'delayed_control_search.log').open('w') as log:
    result = subprocess.run(['nice', '-n', '19', './round3/reuse', '32', '0', '0', '1',
                             '36', '500000', 'round3/delayed_early', '20', '30',
                             'round3/delayed_problem.txt'], stdout=log, stderr=subprocess.STDOUT)
assert result.returncode == 0
controls = list(HERE.glob('delayed_early_d*_delayed_control32.s'))
assert len(controls) == 1
control = controls[0]
instructions = 0
for line in control.read_text().splitlines():
    if line.startswith('out 0,'):
        assert instructions < 32
        print('early output 0 after core instruction', instructions, 'base deadline 32', flush=True)
    elif line.strip() and not line.startswith(('#', 'out ')):
        instructions += 1
judge(control)
mem = HERE / 'control_mem42.s'
subprocess.run(['nice', '-n', '19', 'python3', 'round3/lower.py', str(control), str(mem)], check=True)
judge(mem, 'mem')
