#!/usr/bin/env python3
"""Read-only audit of completed query records, formulas, and strict judge logs."""
import collections
import datetime
import hashlib
import json
import os
from pathlib import Path
import re

BASE=Path(__file__).resolve().parents[1]
ROOT=BASE.parent


def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    batches={}
    queries=[]
    errors=[]
    frontier_checks=[]
    for name in ['retry','frontier','variants_fixed','variants_freeout','variants_broad']:
        tasks=json.loads((BASE/'logs'/f'{name}_tasks.json').read_text())
        path=BASE/'logs'/f'{name}_summary.json'
        records=json.loads(path.read_text()) if path.exists() else []
        counts=dict(collections.Counter(q['status'] for q in records))
        batches[name]={'planned':len(tasks),'completed':len(records),'statuses':counts,
                       'wall_seconds':round(sum(q['seconds'] for q in records),3)}
        queries.extend(records)
        assert len({q['tag'] for q in records})==len(records)
        for q in records:
            if name=='frontier':
                prior_tag=q['tag'].removeprefix('frontier_')
                prior=[json.loads(line) for line in (ROOT/'round2/logs'/f'{prior_tag}.log').read_text().splitlines()
                       if line.startswith('{')]
                old_built=[r for r in prior if r.get('phase')=='built'][-1]
                new_built=next(r for r in q['records'] if r.get('phase')=='built')
                for key in ['cases','variables','clauses']:
                    assert old_built[key]==new_built[key],(q['tag'],key)
                frontier_checks.append({'tag':q['tag'],'cases':new_built['cases'],
                                        'variables':new_built['variables'],'clauses':new_built['clauses'],
                                        'matches_prior_final_counts':True})
            if q['returncode']!=0:
                errors.append({'tag':q['tag'],'returncode':q['returncode']})
            solver=[r for r in q['records'] if r.get('phase')=='kissat_result']
            if not solver:
                continue
            final=solver[-1]
            formula=BASE/'cnf'/f'{q["tag"]}.cnf'
            assert hashlib.sha256(formula.read_bytes()).hexdigest()==final['cnf_sha256'],q['tag']
            if q['status']=='False':
                assert final['status']=='False' and final['returncode']==20,q['tag']
                assert 's UNSATISFIABLE' in Path(final['raw_log']).read_text(),q['tag']
    conflicts=0
    for log in (BASE/'logs').glob('*_kissat_*.log'):
        last=0
        content=log.read_text()
        for line in content.splitlines():
            fields=line.split()
            if len(fields)>=20 and fields[0]=='c' and len(fields[1])==1:
                try:
                    float(fields[2])
                    last=int(fields[9])
                except ValueError:
                    pass
        exact=re.search(r'^c conflicts:\s+(\d+)',content,re.MULTILINE)
        if exact:last=int(exact.group(1))
        conflicts+=last
    passes=[]
    failures=[]
    for log in sorted((BASE/'logs').glob('*.judge')):
        output=log.read_text()
        entry={'log':str(log.relative_to(ROOT)),'output':output}
        if output.startswith('PASS '):
            source=Path(output.split(' [relaxed')[0][5:])
            if not source.is_absolute():
                source=ROOT/source
            entry['path']=str(source.relative_to(ROOT))
            entry['sha256']=hashlib.sha256(source.read_bytes()).hexdigest()
            entry['length']=int(re.search(r' L=(\d+)',output).group(1))
            passes.append(entry)
        elif output.startswith('FAIL '):
            failures.append(entry)
    cpu=0.0
    peak=0
    for q in queries:
        solved=[r for r in q['records'] if r.get('phase')=='kissat_result']
        if solved:
            cpu+=solved[-1]['child_cpu_seconds']
            peak=max(peak,max(r['peak_job_rss_kib'] for r in solved))
    result={'audited_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
            'batches':batches,'total_queries':len(queries),
            'complete':all(b['completed']==b['planned'] for b in batches.values()),
            'query_errors':errors,'kissat_cpu_seconds':round(cpu,3),
            'resumed_frontier_checks':frontier_checks,
            'maximum_measured_job_rss_kib':peak,'reported_solver_conflicts':conflicts,
            'passes':passes,'failures':failures,
            'target_pass':any(p['length']<=31 and 'model=out' in p['output'] for p in passes),
            'encoder_sha256':hashlib.sha256((ROOT/'round2/src/window_cnf.py').read_bytes()).hexdigest(),
            'kissat_sha256':hashlib.sha256(Path('/path/to/workspace/schur6/bin/kissat').read_bytes()).hexdigest(),
            'auditor_affinity':sorted(os.sched_getaffinity(0)),
            'source_hashes':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest()
                             for p in sorted((BASE/'src').glob('*.py'))}}
    recovered_file=BASE/'logs/recovered_models.json'
    if recovered_file.exists():
        recovered=json.loads(recovered_file.read_text())
        expected={}
        assignments=[]
        for query in queries:
            iteration=None
            failures={}
            for record in query['records']:
                if record.get('phase')=='solve' and record['status']=='True':iteration=record['iteration']
                elif record.get('phase')=='refine':failures[iteration]=record['failures']
                elif record.get('status')=='CANDIDATE':failures[iteration]=0
            for record in query['records']:
                if record.get('phase')=='kissat_result' and record['status']=='True':
                    assignments.append(record['raw_log'])
                    expected[record['raw_log']]=failures[record['iteration']]
        assert len(recovered)==len(assignments)
        for record in recovered:
            assert record['failing_weak_orders']==expected[record['raw_assignment']],record['tag']
        result['recovered_models']=recovered
        result['recovered_failure_counts_match_original']=True
    (BASE/'logs/independent_audit.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ['passes','failures','source_hashes']},indent=2))


if __name__=='__main__':main()
