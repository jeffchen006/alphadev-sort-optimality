"""Reproduce round 3 sequentially, with one CPU and less than 3 GB RAM."""
import json
import os
from pathlib import Path
import re
import resource
import subprocess
import time

HERE = Path(__file__).resolve().parent
WORK = HERE.parent
JUDGE = Path('/path/to/repo/shared/judge.py')
os.chdir(WORK)
os.sched_setaffinity(0, {min(os.sched_getaffinity(0))})
os.nice(19)
memory_cap = 2800 * 1024**2
resource.setrlimit(resource.RLIMIT_AS, (memory_cap, memory_cap))
records = []


def run(args, stem, measured=False):
    start = time.monotonic()
    log_path = HERE / f'{stem}.log'
    command = ['nice', '-n', '19', *map(str, args)]
    with log_path.open('w') as out:
        if measured:
            with (HERE / f'{stem}.resources').open('w') as err:
                result = subprocess.run(['/usr/bin/time', '-v', *command], stdout=out, stderr=err)
        else:
            result = subprocess.run(command, stdout=out, stderr=subprocess.STDOUT)
    records.append({'args': list(map(str, args)), 'exit': result.returncode,
                    'log': str(log_path.relative_to(WORK)),
                    'seconds': time.monotonic() - start})
    (HERE / 'reproduction.json').write_text(json.dumps(records, indent=2) + '\n')
    print(stem, 'exit', result.returncode, 'seconds', round(records[-1]['seconds'], 3), flush=True)
    assert result.returncode == 0, log_path.read_text()[-4000:]
    return log_path


def handle_found(log):
    for line in log.read_text().splitlines():
        match = re.match(r'CANDIDATE file=(\S+) k=(\d+)', line)
        if not match or int(match[2]) > 31:
            continue
        source, k = Path(match[1]), int(match[2])
        check = run(['python3', JUDGE, source, '--strict', '--model', 'out'], 'found_out_judge')
        assert check.read_text().startswith('PASS ')
        mem = HERE / 'found_mem.s'
        run(['python3', 'round3/lower.py', source, mem], 'found_lower')
        check = run(['python3', JUDGE, mem, '--strict', '--model', 'mem'], 'found_mem_judge')
        assert check.read_text().startswith('PASS ')
        report = WORK / 'RESULTS.md'
        report.write_text(f'FOUND k={k} total={k+10} strict out+mem PASS: {source}, '
                          f'{mem.relative_to(WORK)}\n\n' + report.read_text())
        print(f'FOUND k={k}', source, flush=True)
        raise SystemExit(0)


run(['g++', '-O3', '-std=c++17', '-march=native', 'round3/reuse.cpp', '-o', 'round3/reuse'], 'build')
run(['python3', 'round3/analyze.py'], 'analysis')
run(['python3', 'round3/structure.py'], 'structure')
for stem, mode, width, column_limit, seconds in [
    ('masked31', 0, 0, 500000, 30),
    ('drop31_final', 1, 0, 500000, 30),
    ('loose31_exact', 2, 0, 500000, 30),
    ('loose_drop31', 3, 0, 500000, 30),
    ('waive_input31', 5, 10000, 100000, 2),
    ('freecmp_early31', 20, 0, 500000, 30),
    ('copydrop_free31', 22, 0, 500000, 30),
]:
    log = run(['./round3/reuse', '31', width, '0', '143', '36', column_limit,
               f'round3/{stem}', mode, seconds], stem, True)
    handle_found(log)
run(['python3', 'round3/crosscheck.py', '0', '143'], 'crosscheck', True)
run(['./round3/reuse', '32', '0', '0', '143', '36', '500000',
     'round3/control32', '0', '30'], 'controls32', True)
run(['python3', 'round3/judge_controls.py'], 'control_judges')
run(['./round3/reuse', '32', '0', '0', '1', '36', '500000',
     'round3/early_control32', '20', '30'], 'early_control32', True)
run(['python3', JUDGE, 'round3/early_control32_d-1_c8_10040eff416c0867.s',
     '--strict', '--model', 'out'], 'early_control32_judge')
run(['python3', 'round3/control_deleted.py'], 'deleted_control_judges')
run(['python3', 'round3/control_early.py'], 'delayed_control_judges')
run(['python3', 'round3/summarize.py', '--append'], 'summary')
print('COMPLETE round 3 reproduction', flush=True)
