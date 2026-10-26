"""Positive control: append an unused copy, then remove it with mode 22."""
from pathlib import Path
import subprocess
import analyze

HERE = Path(__file__).resolve().parent
# Keep the shared judge path explicit; it is outside this worker's writable root.
JUDGE = Path('/path/to/repo/shared/judge.py')
source = sorted(analyze.SOURCE.glob('*.s'))[0]
base = HERE / 'padded_control33.s'
body = [line for line in source.read_text().splitlines()
        if line.strip() and not line.startswith('#')]
base.write_text('# n=5 model=out iset=I1 source=w1-padded-control k=33\n'
                + '\n'.join(body) + '\nmov S9, P0\n')
_, p = analyze.analyze(base)
analyze.export([p], HERE / 'padded_problem.txt')


def judge(path):
    result = subprocess.run(['nice', '-n', '19', 'python3', str(JUDGE),
                             str(path), '--strict', '--model', 'out'],
                            capture_output=True, text=True)
    path.with_suffix('.judge.log').write_text(result.stdout + result.stderr)
    print(result.stdout.strip(), flush=True)
    assert result.returncode == 0 and result.stdout.startswith('PASS ')


judge(base)
with (HERE / 'deleted_control_search.log').open('w') as out:
    result = subprocess.run(['nice', '-n', '19', './round3/reuse', '32', '0', '0', '1',
                             '36', '500000', 'round3/deleted_control', '22', '30',
                             'round3/padded_problem.txt'], stdout=out, stderr=subprocess.STDOUT)
assert result.returncode == 0
controls = sorted(HERE.glob('deleted_control_d*_padded_control33.s'))
assert controls
for path in controls:
    judge(path)
print('COMPLETE deleted-copy positive controls', len(controls), flush=True)
