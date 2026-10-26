#!/usr/bin/env python3
"""Collect the retained logs without rerunning completed searches or judges."""
import collections
import hashlib
import json
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[2]
LOGS=ROOT/'round5/logs'

def main():
    queries=[]
    for path in sorted(LOGS.glob('*.log')):
        enc=None;results=[]
        for line in path.read_text().splitlines():
            if not line.startswith('{'):continue
            try:row=json.loads(line)
            except json.JSONDecodeError:continue
            if row.get('event')=='ENC':enc=row
            if row.get('event')=='RESULT':
                results.append(dict(encoding=enc,result=row))
        if results:
            invalid=[]
            for solverlog in LOGS.glob(path.stem+'*.solver'):
                if 'error:' in solverlog.read_text():invalid.append(str(solverlog.relative_to(ROOT)))
            queries.append(dict(log=str(path.relative_to(ROOT)),attempts=results,
                                invalid_solver_files=invalid))
    registry=[]
    for path in sorted((ROOT/'round5/programs').glob('*.s')):
        if not path.read_text().startswith('# n=5'):continue
        judge=Path(str(path)+'.judge.txt')
        assert judge.exists(),'complete assembly file lacks judge log: '+str(path)
        text=judge.read_text();first=text.splitlines()[0]
        assert first.startswith(('PASS ','FAIL ')),first
        length=int(re.search(r'\bL=(\d+)',first).group(1))
        registry.append(dict(file=str(path.relative_to(ROOT)),judge=str(judge.relative_to(ROOT)),
                             status=first.split()[0],length=length,line=first))
    counts=collections.Counter(r['result']['result'] for q in queries for r in q['attempts'])
    invalid=sum(len(q['invalid_solver_files']) for q in queries)
    rss=0;rss_sum=0
    for q in queries:
        for attempt in q['attempts']:
            result=attempt['result']
            a=result.get('peak_self_rss_kib',0);b=result.get('peak_child_rss_kib',0)
            rss=max(rss,a,b);rss_sum=max(rss_sum,a+b)
    for journal in LOGS.glob('*.jsonl'):
        for line in journal.read_text().splitlines():
            row=json.loads(line)
            rss=max(rss,row.get('peak_child_rss_kib',0),row.get('observed_child_peak_rss_kib',0))
    summary=dict(query_logs=len(queries),solver_status_counts=dict(counts),invalid_attempts=invalid,
                 complete_assembly_files=len(registry),judge_counts=dict(collections.Counter(r['status'] for r in registry)),
                 target_pass_files=[r['file'] for r in registry if r['status']=='PASS' and r['length']<=31],
                 observed_peak_process_rss_kib=rss,
                 observed_parent_plus_child_peak_bound_kib=rss_sum,
                 source_sha256={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest()
                                for p in sorted((ROOT/'round5/src').glob('*')) if p.is_file()})
    for name,obj in [('query_registry.json',queries),('judge_registry.json',registry),('summary.json',summary)]:
        (LOGS/name).write_text(json.dumps(obj,indent=2)+'\n')
    print(json.dumps(summary,indent=2))

if __name__=='__main__':main()
