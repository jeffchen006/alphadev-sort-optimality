#!/usr/bin/env python3
"""Collect the actual round-6 results. Never treat a timeout as exclusion."""
import argparse
import collections
import hashlib
import json
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[2]
LOGS=ROOT/'round6/logs'

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--append',action='store_true');args=ap.parse_args()
    registry=[]
    for path in sorted(LOGS.glob('*.log')):
        enc=None;attempts=[]
        for line in path.read_text(errors='replace').splitlines():
            if not line.startswith('{'):continue
            try:row=json.loads(line)
            except json.JSONDecodeError:continue
            if row.get('event')=='ENC':enc=row
            if row.get('event')=='RESULT':attempts.append(dict(encoding=enc,result=row))
        if attempts:registry.append(dict(log=str(path.relative_to(ROOT)),attempts=attempts))
    judges=[]
    for path in sorted((ROOT/'round6/programs').glob('*.s.judge.txt')):
        text=path.read_text();line=text.splitlines()[0]
        length=re.search(r'\bL=(\d+)',line)
        model=re.search(r'\bmodel=(\w+)',line)
        model=model.group(1) if model else 'unknown'
        value=int(length.group(1)) if length else None
        judges.append(dict(file=str(path.relative_to(ROOT)).removesuffix('.judge.txt'),
                           judge=str(path.relative_to(ROOT)),line=line,status=line.split()[0],
                           model=model,length=value,core=value-10 if model=='mem' and value is not None else value))
    checks=[]
    for path in sorted(LOGS.glob('*.drat_check')):
        text=path.read_text(errors='replace')
        checks.append(dict(check=str(path.relative_to(ROOT)),verified='s VERIFIED' in text))
    counts=collections.Counter(a['result']['result'] for r in registry for a in r['attempts'])
    rss=0;sumrss=0
    for r in registry:
        for a in r['attempts']:
            result=a['result'];one=result.get('peak_self_rss_kib',0);two=result.get('peak_child_rss_kib',0)
            rss=max(rss,one,two);sumrss=max(sumrss,one+two)
    queues={}
    for path in sorted(LOGS.glob('*_plan.json')):
        family=path.name.removesuffix('_plan.json')
        planned=json.loads(path.read_text());journal=LOGS/f'{family}.jsonl'
        completed=[json.loads(l) for l in journal.read_text().splitlines()] if journal.exists() else []
        done={r['tag'] for r in completed if r.get('returncode')==0 and r.get('results')}
        queues[family]=dict(planned=len(planned),completed=len(done),attempts=len(completed),
                            pending=[r['tag'] for r in planned if r['tag'] not in done])
    findings=[line for line in (ROOT/'RESULTS.md').read_text().splitlines()
              if line.startswith('ASSUMPTION CHALLENGED:')]
    summary=dict(queries=len(registry),solver_status_counts=dict(counts),proof_checks=checks,
                 assumption_findings=findings,
                 judge_counts=dict(collections.Counter(j['status'] for j in judges)),
                 target_pass_files=[j['file'] for j in judges if j['status']=='PASS' and j['core']<=31],
                 observed_peak_process_rss_kib=rss,observed_parent_plus_child_rss_bound_kib=sumrss,
                 queues=queues,source_sha256={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest()
                 for p in sorted((ROOT/'round6/src').glob('*')) if p.is_file()})
    for name,obj in [('query_registry.json',registry),('judge_registry.json',judges),('summary.json',summary)]:
        (LOGS/name).write_text(json.dumps(obj,indent=2)+'\n')
    print(json.dumps(summary,indent=2),flush=True)
    if args.append:
        lines=['','## Round 6 recorded results','']
        if summary['target_pass_files']:
            lines.append('Target PASS files: '+', '.join('`'+p+'`' for p in summary['target_pass_files'])+'.')
        else:lines.append('No program with core k <= 31 passed the strict judge in these runs.')
        lines+=['','| Query | Result | Recorded solve seconds |','| --- | --- | ---: |']
        for r in registry:
            for a in r['attempts']:
                lines.append(f'| `{Path(r["log"]).stem}` | {a["result"]["result"]} | {a["result"]["solve_seconds"]:.3f} |')
        lines+=['','The solver status counts are `'+json.dumps(dict(counts),sort_keys=True)+'`.',
                 'A timeout supplies no negative bound. Separate completed results can resolve a related model.',
                 'A SAT circuit with free predicates is not an assembly PASS.',
                 'The model definitions and the output-selector transformation are in `round6/METHOD.md`.',
                 'The exact query, judge, and certificate records are under `round6/logs/`.']
        if judges:
            lines+=['','Every new strict-judge file:','',
                    '| File | Status | Model | Length |','| --- | --- | --- | ---: |']
            for j in judges:lines.append(f'| `{j["file"]}` | {j["status"]} | {j["model"]} | {j["length"]} |')
        lines+=['',f'The observed maximum process RSS was {rss:,} KiB. The observed parent-plus-child RSS bound was {sumrss:,} KiB.',
                 'These are recorded maxima. A zero value means that a field was not recorded.',
                 'Assumption tags: G1-G4 and the fixed-prefix restriction related to A11.',
                 'No fixed suffix comparison skeleton (A4), network term pool (A8), or physical register cap (A2/A7) is used.',
                 'The common-high scratch assignment is a relaxation and does not require A15 scratch elimination.']
        lines+=findings if findings else ['No ASSUMPTION CHALLENGED finding was established by this record.']
        if any(q['pending'] for q in queues.values()):lines+=['','Some planned queries are pending. See `round6/logs/summary.json`.']
        with (ROOT/'RESULTS.md').open('a') as f:f.write('\n'.join(lines)+'\n')

if __name__=='__main__':main()
