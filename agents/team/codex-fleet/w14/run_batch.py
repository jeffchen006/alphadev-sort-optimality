#!/usr/bin/env python3
"""Serial, resumable dagx runner. No node limit; wall limits remain unknown."""
import argparse
import collections
import hashlib
import json
import os
from pathlib import Path
import re
import resource
import subprocess
import time

ROOT = Path(__file__).resolve().parent
PROJECT = ROOT.parents[3]
JUDGE = PROJECT / 'shared/judge.py'
RESULT = re.compile(r'^RESULT (NONE|FOUND|LIMIT) K=31 calls=(\d+) leaves=(\d+) sols=(\d+) best=(-?\d+) time=([0-9.]+)s', re.M)


def limits():
    resource.setrlimit(resource.RLIMIT_AS, (3_000_000_000, 3_000_000_000))
    if os.getpriority(os.PRIO_PROCESS, 0) < 10:
        os.setpriority(os.PRIO_PROCESS, 0, 10)


def history():
    result = {}
    if (ROOT / 'runs.jsonl').exists():
        for line in (ROOT / 'runs.jsonl').read_text().splitlines():
            row = json.loads(line)
            result[row['sha256']] = row
    return result


def write_status(manifest, latest, current=None):
    counts = collections.Counter(r['status'] for r in latest.values())
    data = dict(assigned=len(manifest), attempted=len(latest), counts=dict(counts),
                remaining=len(manifest)-len(latest), current=current,
                attempts=sum(1 for _ in open(ROOT/'runs.jsonl')) if (ROOT/'runs.jsonl').exists() else 0,
                updated=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
    tmp = ROOT/'status.json.tmp'
    tmp.write_text(json.dumps(data, indent=2)+'\n')
    tmp.replace(ROOT/'status.json')
    tmp = ROOT/'resolved.txt.tmp'
    tmp.write_text(''.join(f"{r['sha256']} {latest[r['sha256']]['status']}\n"
                           for r in manifest if r['sha256'] in latest))
    tmp.replace(ROOT/'resolved.txt')
    if current is None:
        report = ROOT/'RESULTS.md'
        marker = '\n<!-- RESTART_PROGRESS -->\n'
        before = report.read_text().split(marker)[0]
        snapshot = (
            f"\nRestart progress at {data['updated']}:\n\n"
            f"- Assigned: {data['assigned']}.\n"
            f"- Attempted: {data['attempted']}.\n"
            f"- NONE: {counts['NONE']}.\n"
            f"- LIMIT (unknown): {counts['LIMIT']}.\n"
            f"- FOUND with both strict judges passed: {counts['FOUND']}.\n"
            f"- Not attempted: {data['remaining']}.\n"
            f"- Saved attempts, including retries: {data['attempts']}.\n\n"
            "The restart began with 4,963 attempted skeletons. It skips every\n"
            "saved attempt in the first pass. LIMIT cases run last with a larger\n"
            "time limit. NONE and FOUND cases are never repeated.\n\n"
            "`audit_state.py` checks source copies, the assigned list, attempt\n"
            "order, and solver logs. `audit.json` records its latest snapshot.\n"
        )
        tmp = ROOT/'RESULTS.md.tmp'
        tmp.write_text(before + marker + snapshot)
        tmp.replace(report)


def check_found(row, log, attempt):
    """A solver witness is not FOUND until the strict reference judge passes."""
    text = log.read_text()
    block = re.search(r'^SOLUTION .*\n(.*?)^END$', text, re.M|re.S)
    if not block:
        raise RuntimeError('FOUND without program')
    folder = ROOT/'candidates'; folder.mkdir(exist_ok=True)
    stem = Path(row['local']).stem + f'_a{attempt}'
    out = folder/(stem+'_out.s')
    lines = block[1].splitlines()
    out.write_text('# n=5 iset=I1 model=out source=w14-dagx\n'+'\n'.join(lines)+'\n')
    # Five loads. Rename input registers to S0..S4 and scratch to S5+.
    def reg(m):
        return 'S'+str(int(m[2])+(0 if m[1]=='P' else 5))
    memlines = [f'mov S{i}, P{i}' for i in range(5)]
    for line in lines:
        line = re.sub(r'\b([PS])(\d+)\b', reg, line)
        match = re.fullmatch(r'out (\d+), (S\d+)', line)
        memlines.append(f'mov P{match[1]}, {match[2]}' if match else line)
    mem = folder/(stem+'_mem.s')
    mem.write_text('# n=5 iset=I1 model=mem source=w14-dagx\n'+'\n'.join(memlines)+'\n')
    checks = []
    for model, path in [('out',out),('mem',mem)]:
        proc = subprocess.run(['python3', str(JUDGE), str(path), '--strict', '--model', model],
                              stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True,
                              preexec_fn=limits)
        checklog=folder/(stem+'_'+model+'.judge.txt')
        checklog.write_text(proc.stdout)
        ok=proc.returncode==0 and re.search(r'\bPASS\b',proc.stdout) is not None
        checks.append(dict(model=model,path=str(path),log=str(checklog),pass_strict=ok))
    return checks


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--timeout',type=float,default=2.0)
    ap.add_argument('--retry',action='store_true')
    args=ap.parse_args()
    os.chdir(ROOT)
    limits()
    # Clear split/node-pruning controls: every completed run covers the full tree.
    env=os.environ.copy()
    for key in ['SPLIT','CPLSLACK']:
        env.pop(key,None)
    manifest=json.loads((ROOT/'manifest.json').read_text())
    latest=history()
    start=time.monotonic(); n=0
    for row in manifest:
        old=latest.get(row['sha256'])
        if old and (old['status'] in ('NONE','FOUND') or not args.retry):
            continue
        attempt=1+(old['attempt'] if old else 0)
        name=Path(row['local']).stem
        log=ROOT/'logs'/f'{name}_a{attempt}.out'
        write_status(manifest,latest,dict(index=row['index'],local=row['local'],timeout=args.timeout))
        # Check the copied bytes before every attempt.
        assert hashlib.sha256((ROOT/row['local']).read_bytes()).hexdigest()==row['file_sha256']
        t0=time.monotonic()
        timed_out=False
        with log.open('w') as stream:
            proc=subprocess.Popen([str(ROOT/'dagx'),str(ROOT/row['local']),'31','1'],
                                  stdout=stream,stderr=subprocess.STDOUT,env=env)
            try:
                proc.wait(timeout=args.timeout if args.timeout>0 else None)
            except subprocess.TimeoutExpired:
                timed_out=True; proc.kill(); proc.wait()
        elapsed=time.monotonic()-t0
        data=log.read_text()
        match=RESULT.search(data)
        status=match[1] if match and proc.returncode==0 and not timed_out else 'LIMIT'
        record=dict(index=row['index'],sha256=row['sha256'],local=row['local'],source=row['source'],
                    comparisons=row['comparisons'],attempt=attempt,status=status,log=str(log.relative_to(ROOT)),
                    elapsed=elapsed,wall_limit=args.timeout,returncode=proc.returncode,timed_out=timed_out,
                    calls=int(match[2]) if match else None,leaves=int(match[3]) if match else None,
                    solver_result=match[0] if match else None)
        if status=='FOUND':
            checks=check_found(row,log,attempt)
            record['judge_checks']=checks
            if not all(x['pass_strict'] for x in checks):
                record['status']='LIMIT'
                record['reason']='Solver witness did not pass both strict judges; unknown.'
        if timed_out:
            with log.open('a') as stream:
                stream.write(f'\nW14 LIMIT wall_limit={args.timeout}s; unknown, not exhaustive.\n')
        with (ROOT/'runs.jsonl').open('a') as stream:
            stream.write(json.dumps(record)+'\n'); stream.flush()
        latest[row['sha256']]=record
        n+=1
        if n%100==0 or status=='FOUND':
            counts=collections.Counter(x['status'] for x in latest.values())
            print(f'processed_this_pass={n} attempted={len(latest)} counts={dict(counts)} elapsed={time.monotonic()-start:.1f}s',flush=True)
            write_status(manifest,latest)
        if status=='FOUND':
            print(json.dumps(record),flush=True)
            break
    write_status(manifest,latest)
    print('PASS COMPLETE '+json.dumps(json.loads((ROOT/'status.json').read_text())),flush=True)


if __name__=='__main__':
    main()
