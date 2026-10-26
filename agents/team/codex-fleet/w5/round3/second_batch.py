"""One CPU job at a time: encoder checks, scored repair, exact suffix repair."""
from pathlib import Path
import hashlib
import json
import subprocess
import sys
import time

from verify import verify, JUDGE

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
NEAR = ROOT.parent/'w6/round2/candidates/near14_frozen.s'
rows = []


def run(name, command, cap=600):
    log = HERE/'logs'/(name+'.log')
    began = time.monotonic()
    code = None
    status = 'UNKNOWN'
    with log.open('w') as stream:
        try:
            code = subprocess.run(['nice', '-n', '19']+command, cwd=ROOT,
                                  stdout=stream, stderr=subprocess.STDOUT,
                                  timeout=cap).returncode
        except subprocess.TimeoutExpired:
            status = 'TIMEOUT'
    if code is not None:
        status = 'EXIT_'+str(code)
        for line in log.read_text().splitlines():
            try:
                item = json.loads(line)
                if 'status' in item:
                    status = item['status']
            except (ValueError, TypeError):
                pass
    row = dict(name=name, command=command, cap=cap, status=status, code=code,
               seconds=time.monotonic()-began, log=str(log))
    rows.append(row)
    (HERE/'second_batch.json').write_text(json.dumps(rows, indent=2)+'\n')
    print(json.dumps(row), flush=True)
    return row


def retained(prefix):
    for source in (HERE/'candidates').glob(prefix+'*.s'):
        if source.stem.endswith('_near'):
            p = subprocess.run(['nice', '-n', '19', sys.executable, '-B', JUDGE,
                                str(source), '--strict', '--model', 'out'],
                               capture_output=True, text=True)
            log = HERE/'logs'/('judge_'+source.stem+'.log')
            log.write_text(p.stdout+p.stderr)
            print(p.stdout+p.stderr, end='', flush=True)
            if p.stdout.startswith('PASS '):
                assert verify(source)
                return True
        elif source.stem.endswith('_k31'):
            assert verify(source)
            return True
    return False


assert run('rank_transition_check', [sys.executable, '-B', 'round3/test_rank.py'], 60)['code'] == 0
control = HERE/'candidates/rank_control32.s'
assert run('rank_control32', [sys.executable, '-B', 'round3/repair_sat.py',
           str(ROOT.parent/'w6/round2/verified/c8_100fdc9beb7f87fb.s'), str(control),
           '--control', '--rank'], 60)['status'] == 'CANDIDATE'
assert verify(control)
assert run('build_near_score', ['g++', '-O3', '-std=c++17', '-msse4.1',
           'round3/near_repair.cpp', '-o', 'round3/near_score_repair'], 60)['code'] == 0
run('near14_exact2_scored', ['round3/near_score_repair', 'round3/seeds/near14_frozen.txt',
                           'round3/candidates/near14_exact2_scored', '1'], 120)
if retained('near14_exact2_scored'):
    raise SystemExit(0)
assert run('build_near_repair3', ['g++', '-O3', '-std=c++17', '-msse4.1',
           'round3/near_repair3.cpp', '-o', 'round3/near_repair3'], 60)['code'] == 0
run('near14_suffix_cmp2cmov', ['round3/near_repair3', 'round3/seeds/near14_frozen.txt',
                             'round3/candidates/near14_suffix3', '15'], 600)
if retained('near14_suffix3'):
    raise SystemExit(0)
run('rank_near14_general3', [sys.executable, '-B', 'round3/repair_sat.py', str(NEAR),
                            str(HERE/'candidates/rank_near14_general3.s'),
                            '--changes', '3', '--rank'], 300)
if (HERE/'candidates/rank_near14_general3.s').exists():
    verify(HERE/'candidates/rank_near14_general3.s')
