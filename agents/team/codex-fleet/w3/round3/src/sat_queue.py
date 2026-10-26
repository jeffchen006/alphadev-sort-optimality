#!/usr/bin/env python3
"""One single-threaded SAT run at a time, after the routing batch exits."""
import json, os, resource, subprocess, time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
resource.setrlimit(resource.RLIMIT_AS, (2900 * 1024**2, 2900 * 1024**2))
os.sched_setaffinity(0, {min(os.sched_getaffinity(0))})
start = time.monotonic()
index = ROOT / 'round3/logs/sat.jsonl'

def run(script, tag, args, limit=600):
    log = ROOT / 'round3/logs' / (tag + '.log')
    cmd = ['/usr/bin/time', '-v', 'nice', '-n', '19', 'python3', str(ROOT/'round3/src'/script),
           '--tag', tag, '--timeout', str(limit)] + args
    begin = time.monotonic()
    with log.open('w') as f:
        p = subprocess.run(cmd, stdout=f, stderr=subprocess.STDOUT, cwd=ROOT)
    txt = log.read_text()
    result = [s for s in txt.splitlines() if '"event": "RESULT"' in s or
              s.startswith(('JUDGE', 'Traceback', 'ALL_PERMUTATIONS', 'MEM_JUDGE'))]
    rss=[int(s.split(':',1)[1]) for s in txt.splitlines() if 'Maximum resident set size (kbytes):' in s]
    row = dict(tag=tag, script=script, args=args, timeout=limit, rc=p.returncode,
               max_rss_kib=max(rss,default=0),
               result=result, seconds=round(time.monotonic()-begin, 3),
               elapsed=round(time.monotonic()-start, 3))
    with index.open('a') as f:
        f.write(json.dumps(row)+'\n')
    print(json.dumps(row), flush=True)
    return txt

# These controls test the copied encodings and the new history constraints.
for script, tag, args in [
    ('experiments.py', 'control_exact53', ['--control','--exact','--all','--origin']),
    ('experiments.py', 'control_union53', ['--control','--union','--all','--origin']),
    ('register_sat.py', 'control_flexible53', ['--control','--phasecap','1']),
    ('register_sat.py', 'control_partial53', ['--control','--phasecap','1','--partial-init']),
]:
    if 'JUDGE PASS ' not in run(script, tag, args, 60):
        raise SystemExit('Control failed: '+tag)

# Extend each of the eleven round-2 solver timeouts. The models keep all 120
# strict orders and the same budgets. New clauses remove equivalent choices.
for adaptive in [False, True]:
    run('experiments.py', ('adaptive' if adaptive else 'fixed')+'_t5_allorient_exact',
        ['--all','--origin','--exact']+(['--adaptive'] if adaptive else []))
for R, mask, adaptive, partial in [(6,0,False,False),(8,10,True,False),(8,6,True,True)]:
    tag = 'partial_flex_R8' if partial else f"flex_R{R}_m{mask}_{'adapt' if adaptive else 'fixed'}"
    run('register_sat.py', tag,
        ['--registers',str(R),'--mask',str(mask),'--tree','5','--phasecap','8']+
        (['--adaptive'] if adaptive else [])+(['--partial-init'] if partial else []))
for adaptive in [False, True]:
    run('experiments.py', 'complete_'+('adaptive' if adaptive else 'fixed')+'_mv5',
        ['--complete','--all','--origin','--movbound','5']+(['--adaptive'] if adaptive else []))
for gates in [19,20,21,22]:
    run('experiments.py', f'adaptive_extra_select_g{gates}',
        ['--adaptive','--adaptive-prefix','--union','--origin','--all','--free-last',
         '--gates',str(gates)])

# New gate/copy budgets for the prefix with one extra conditional select.
for gates in [17,18,23]:
    run('experiments.py', f'new_extra_select_g{gates}',
        ['--adaptive','--adaptive-prefix','--union','--origin','--all','--free-last',
         '--gates',str(gates)], 600)
print(json.dumps(dict(event='QUEUE_COMPLETE',elapsed=time.monotonic()-start)),flush=True)
