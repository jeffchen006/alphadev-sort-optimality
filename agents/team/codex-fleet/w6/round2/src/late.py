"""Run the final sequential search jobs on one CPU slot."""
import json
from pathlib import Path
import shutil
import subprocess
import time

ROOT = Path('/path/to/repo')
records = []


def run(args, stem):
    began = time.monotonic()
    with Path(f'round2/logs/{stem}.log').open('w') as out:
        result = subprocess.run(['nice', '-n', '19', *map(str, args)],
                                stdout=out, stderr=subprocess.STDOUT)
    row = {'args': list(map(str, args)), 'exit': result.returncode,
           'log': f'round2/logs/{stem}.log', 'seconds': time.monotonic()-began}
    records.append(row)
    Path('round2/artifacts/late_runs.json').write_text(json.dumps(records, indent=2))
    print(json.dumps(row), flush=True)
    return result.returncode


def judge(path, model='out', stem=None):
    stem = stem or path.stem + '_judge'
    rc = run(['python3', ROOT/'shared/judge.py', path, '--strict', '--model', model], stem)
    return rc == 0 and 'PASS ' in Path(f'round2/logs/{stem}.log').read_text()


def found(path):
    if not path.exists() or not judge(path):
        return False
    k = sum(bool(s.strip()) and not s.startswith(('#', 'out'))
            for s in path.read_text().splitlines())
    if k > 31:
        return False
    run(['python3', 'src/lower.py', path, 'round2/artifacts/found'], 'found_lower')
    out = Path('round2/artifacts/found_out.s')
    mem = Path('round2/artifacts/found_mem.s')
    assert judge(out) and judge(mem, 'mem')
    report = Path('RESULTS.md')
    text = report.read_text()
    report.write_text(f'FOUND k={k} total={k+10} strict out+mem PASS: {out}, {mem}\n\n'+text)
    return True


run(['python3', ROOT/'shared/judge.py', 'round2/candidates/b31a_near.s',
     '--strict', '--model', 'out'], 'b31a_near_judge')
control = Path('round2/candidates/slots_control32.s')
rc = run(['timeout', '25s', 'python3', 'round2/src/source_slots_sat.py',
          'round2/verified/c8_156fdd193572fb27.s', control, '--control'], 'slots_control')
assert rc == 0 and judge(control)
for name, seed, changes, extra in [
    ('slots_free31', 'c8_156fdd193572fb27', 5, ['--free-dest']),
    ('slots_sources31', 'c8_15bdbe5ff6cbe16f', 8, []),
]:
    target = Path(f'round2/candidates/{name}.s')
    run(['timeout', '90s', 'python3', 'round2/src/source_slots_sat.py',
         f'round2/verified/{seed}.s', target, '--changes', str(changes), *extra], name)
    if found(target):
        raise SystemExit(0)

assert run(['g++', '-O3', '-march=native', '-std=c++17',
            'round2/src/canonical.cpp', '-o', 'round2/canonical'], 'canonical_build') == 0
run(['./round2/canonical', 'round2/verified/c8_156fdd193572fb27.s',
     'round2/candidates/n32b', '33', '0.8', '1.5', '300', '7101', '8', '0.35'], 'n32b')
if found(Path('round2/candidates/n32b_k31.s')):
    raise SystemExit(0)

inputs = sorted(Path('verified').glob('*.s')) + sorted(Path('round2/verified').glob('*.s'))
inputs += sorted(Path('round2/candidates').glob('n32b_structure_*.s'))
assert run(['./round2/analyze', *inputs], 'analyze_n32b') == 0
known = {p.stem for p in Path('verified').glob('*.s')} | {
    p.stem for p in Path('round2/verified').glob('*.s')}
retained = []
for source in sorted(Path('round2/artifacts/skeletons').glob('*.s')):
    if source.stem in known:
        continue
    target = Path('round2/verified') / source.name
    if judge(source):
        shutil.copyfile(source, target)
        retained.append(str(target))
Path('round2/artifacts/n32b_retained.json').write_text(json.dumps(retained, indent=2))
assert run(['python3', 'round2/src/memory_audit.py'], 'memory_audit') == 0
