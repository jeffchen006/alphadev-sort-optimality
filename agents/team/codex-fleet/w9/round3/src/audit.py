"""Audit all emitted programs and build a current, resumable result ledger."""
from collections import Counter
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import resource
import sys

sys.dont_write_bytecode=True
HERE=Path(__file__).resolve().parents[1]
OLD=HERE.parent/'round2'
sys.path.insert(0,str(OLD/'src'))
from orders import ROOT


def read_rows(name):
    path=HERE/'artifacts'/name
    return [json.loads(line) for line in path.read_text().splitlines() if line.strip()] if path.exists() else []


def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    spec=importlib.util.spec_from_file_location('old_audit',OLD/'src/audit.py')
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    module.HERE=HERE
    ledger=[]
    for path in sorted((HERE/'candidates').glob('*.s')):
        if path.stem.endswith('_mem'):continue
        row=module.judge(path,'out');ledger.append(row)
        if row['pass']:ledger.append(module.judge(module.memory(path),'mem'))
    (HERE/'artifacts/strict_ledger.json').write_text(json.dumps(ledger,indent=2)+'\n')
    unknown=read_rows('kissat_unknown.jsonl');median=read_rows('median_all.jsonl')
    assert len({row['queue_index'] for row in unknown})==len(unknown)
    assert len({row['index'] for row in median})==len(median)
    groups=[]
    for name,rows,total in [('unknown_rerun',unknown,701),('median_repair',median,653)]:
        groups.append({'name':name,'queries_completed':len(rows),'queries_planned':total,
                       'status':dict(Counter(r['status'] for r in rows)),
                       'cpu_parent':sum(r['cpu'] for r in rows),
                       'cpu_child':sum(r['stats']['child_cpu_seconds'] for r in rows),
                       'wall':sum(r['wall'] for r in rows),
                       'solver_calls':sum(len(r['stats']['solver_calls']) for r in rows),
                       'queries_without_solver_call':sum(not r['stats']['solver_calls'] and r['status']!='FILTER_REJECTED' for r in rows),
                       'subset_sat_models':sum(r['iterations'] for r in rows),
                       'peak_job_rss_kib':max((r['stats']['peak_job_rss_kib'] for r in rows),default=0)})
    resolved=sum(r['status']=='UNSAT' for r in unknown)
    summary={'groups':groups,'round2_queries_total':795,
             'round2_latest_unsat':94+resolved,'round2_latest_unknown':701-resolved,
             'strict_counts':dict(Counter('PASS' if r['pass'] else 'FAIL' for r in ledger)),
             'pass_paths':[r for r in ledger if r['pass']],
             'best_strict_pass_out_k':min((r['length'] for r in ledger if r['pass'] and r['model']=='out'),default=None),
             'hashes':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted((HERE/'src').glob('*.py'))},
             'resources':{'cpu_jobs':1,'cpu_affinity':sorted(os.sched_getaffinity(0)),
                          'nice':19,'address_space_mib':2800,'combined_rss_kib_limit':2800000},
             'limits':['Finite register bounds','Fixed comparison-flag partitions',
                       'Input-derived comparison operands','Fixed retained data or prefixes',
                       'Timeouts are UNKNOWN','No independently checked UNSAT certificate']}
    (HERE/'artifacts/summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps(summary),flush=True)


if __name__=='__main__':main()
