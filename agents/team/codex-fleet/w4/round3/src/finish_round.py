#!/usr/bin/env python3
"""After the retry batch ends, run new-seed windows and write an audit."""
import collections
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time

BASE = Path(__file__).resolve().parents[1]
ROOT = BASE.parent
JUDGE = '/path/to/repo/shared/judge.py'


def emit(value):
    print(json.dumps(value),flush=True)


def audit():
    batches = {}
    all_queries = []
    for name in ['retry','variants_fixed','variants_freeout','variants_broad']:
        path = BASE/'logs'/f'{name}_summary.json'
        queries = json.loads(path.read_text()) if path.exists() else []
        counts = dict(collections.Counter(q['status'] for q in queries))
        seconds = sum(q['seconds'] for q in queries)
        batches[name] = dict(queries=len(queries),status_counts=counts,wall_seconds=round(seconds,3))
        all_queries.extend(queries)
    max_rss = max((r.get('peak_job_rss_kib',0) for q in all_queries
                   for r in q['records'] if r.get('phase')=='kissat_result'),default=0)
    cpu = sum(next((r.get('child_cpu_seconds',0) for r in reversed(q['records'])
                    if r.get('phase')=='kissat_result'),0) for q in all_queries)
    conflicts = 0
    for log in (BASE/'logs').glob('*_kissat_*.log'):
        last = 0
        for line in log.read_text().splitlines():
            fields=line.split()
            if len(fields)==23 and fields[0]=='c':
                try: last=int(fields[9])
                except ValueError: pass
        conflicts += last
    passes = []
    for log in (BASE/'logs').glob('*.judge'):
        text = log.read_text()
        if text.startswith('PASS '):
            passes.append(dict(log=str(log.relative_to(ROOT)),output=text))
    result = dict(batches=batches,total_queries=len(all_queries),
                  maximum_measured_job_rss_kib=max_rss,kissat_cpu_seconds=round(cpu,3),
                  reported_conflicts=conflicts,passes=passes,
                  source_hashes={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest()
                                 for p in (BASE/'src').glob('*.py')})
    (BASE/'logs/final_audit.json').write_text(json.dumps(result,indent=2)+'\n')
    lines=['\n### Round-3 completed search results\n',
           '| Batch | Queries | Solver UNSAT | Unknown | Candidate | Wall seconds |',
           '|---|---:|---:|---:|---:|---:|']
    for name,b in batches.items():
        counts=b['status_counts']
        lines.append(f'| {name} | {b["queries"]} | {counts.get("False",0)} | '
                     f'{counts.get("None",0)+counts.get("UNKNOWN",0)} | '
                     f'{counts.get("CANDIDATE",0)} | {b["wall_seconds"]} |')
    lines.extend(['',f'The largest measured combined Python/Kissat resident set was {max_rss:,} KiB. '
                  f'Kissat used {cpu:.3f} recorded CPU seconds across these queries.',
                  '', 'The retry batch used the original formulas and longer limits. '
                  'The new-seed batches used optional literal complementation to map seed phase hints '
                  'to Kissat initial phases. This is a reversible change of Boolean variable signs. '
                  'It does not add constraints. SAT models were mapped back and checked against the '
                  'original emitted clauses before decoding.',
                  '', 'The fixed batch retains instruction classes, write destinations, and output locations. '
                  'Its windows cross preparation and merge. Each has a 15-second limit and 24 initial strict cases. '
                  'The freeout batch rebuilds the full suffix with fixed instruction classes and destinations. '
                  'Its output snapshots are free, with a 60-second limit and 16 initial strict cases. '
                  'The broad batch keeps only comparison positions. Every non-comparison slot can be mov or '
                  'any supported conditional move. Write destinations and output snapshots are free. '
                  'It adds one scratch register, starts from all 31 binary weak orders, and uses a 90-second '
                  'limit. All three new-seed batches leave both comparison operands free.',
                  '', 'Every UNSAT result concerns only its encoded finite register set and template. '
                  'A time or resource limit is unknown. The conservative rules for undefined data and '
                  'flags remain as stated in round 2. No global lower bound follows.',
                  '', 'Machine-readable results: `round3/logs/final_audit.json`. '
                  'Query definitions and full solver records are in the corresponding task and summary JSON files.',
                  '', 'Every round-3 strict PASS is listed below. The known controls have k=32.', ''])
    for item in passes:
        lines.append(f'- `{item["log"]}`: `{item["output"].splitlines()[0]}`')
    lines.extend(['', 'All scheduled round-3 jobs have ended. '
                  + ('A target PASS is recorded at the top of this file.' if (ROOT/'RESULTS.md').read_text().startswith('FOUND')
                     else 'No k<=31 program passed the strict judge.'), ''])
    path=ROOT/'RESULTS.md'
    path.write_text(path.read_text()+'\n'.join(lines))
    emit({'phase':'audit',**result})


def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    # This process remains idle while the existing serial retry runner works.
    while True:
        path=BASE/'logs/retry_batch.log'
        records=[]
        for line in path.read_text().splitlines() if path.exists() else []:
            try: records.append(json.loads(line))
            except ValueError: pass
        if any(r.get('phase')=='complete' for r in records): break
        time.sleep(5)
    if not (ROOT/'RESULTS.md').read_text().startswith('FOUND'):
        env=dict(os.environ,W4_KISSAT_PHASES='1')
        command=[sys.executable,str(BASE/'src/kissat_window.py'),str(ROOT/'round2/seeds/palette_c8_k32.s'),
                 '--a','8','--b','32','--delta','0','--all-cases','--seconds','60','--random-seed','4200',
                 '--mode','dest','--outputs','seed','--prefer-seed',
                 '--out',str(BASE/'candidates/control_phased.s')]
        with (BASE/'logs/control_phased.log').open('w') as stream:
            subprocess.run(command,stdout=stream,stderr=subprocess.STDOUT,env=env,timeout=100,check=True)
        control=BASE/'candidates/control_phased.s'
        if control.exists():
            checked=subprocess.run([sys.executable,JUDGE,str(control),'--strict','--model','out'],
                                   capture_output=True,text=True,check=True)
            (BASE/'logs/control_phased.judge').write_text(checked.stdout+checked.stderr)
            emit({'phase':'phased_control','output':checked.stdout})
        else:
            raise RuntimeError('Phase-renaming control did not produce a candidate')
        for name in ['variants_fixed','variants_freeout','variants_broad']:
            with (BASE/'logs'/f'{name}_batch.log').open('w') as stream:
                subprocess.run([sys.executable,str(BASE/'src/run_serial.py'),
                                str(BASE/'logs'/f'{name}_tasks.json')],
                               stdout=stream,stderr=subprocess.STDOUT,env=env,check=True)
            emit({'phase':'batch_complete','batch':name})
            if (ROOT/'RESULTS.md').read_text().startswith('FOUND'): break
    audit()


if __name__=='__main__':
    if '--audit-only' in sys.argv: audit()
    else: main()
