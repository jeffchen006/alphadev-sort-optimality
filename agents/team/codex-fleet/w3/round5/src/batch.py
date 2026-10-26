#!/usr/bin/env python3
"""Single-job, resumable class queue. Each limit remains UNKNOWN."""
import argparse
import json
import os
from pathlib import Path
import resource
import subprocess
import sys
import time

ROOT=Path(__file__).resolve().parents[2]

def main():
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    ap=argparse.ArgumentParser()
    ap.add_argument('--limit',type=int,default=20)
    ap.add_argument('--timeout',type=int,default=30)
    ap.add_argument('--comparisons',type=int,nargs='+',default=[4,5])
    ap.add_argument('--all',action='store_true')
    ap.add_argument('--tests',type=int,default=20)
    ap.add_argument('--free-copies',action='store_true')
    ap.add_argument('--history',action='store_true')
    ap.add_argument('--solver',default='cadical')
    ap.add_argument('--queue',default='batch')
    ap.add_argument('--classes',type=int,nargs='+')
    ap.add_argument('--start-group',action='store_true')
    ap.add_argument('--preserve',action='store_true')
    ap.add_argument('--scratch',action='store_true')
    ap.add_argument('--ordered-seed',action='store_true')
    ap.add_argument('--minimum-gates',type=int)
    args=ap.parse_args()
    classes=json.loads((ROOT/'round5/logs/classes.json').read_text())
    bounds_path=ROOT/'round5/logs/checked_gate_bounds.json'
    bounds=json.loads(bounds_path.read_text()) if bounds_path.exists() else {}
    preflight=ROOT/'round5/logs/preflight.json'
    if preflight.exists():
        alive={r['class_id'] for r in json.loads(preflight.read_text()) if not r['missing_input']}
        classes=[c for c in classes if c['id'] in alive]
    if args.classes is not None:classes=[c for c in classes if c['id'] in args.classes]
    else:classes=sorted(classes,key=lambda c:(-c['programs'],c['id']))[:args.limit]
    journal=ROOT/'round5/logs'/f'{args.queue}.jsonl'
    done={}
    if journal.exists():
        for line in journal.read_text().splitlines():
            row=json.loads(line);done[row['tag']]=row
    for cl in classes:
        for comparisons in args.comparisons:
            tag=f'{args.queue}_cl{cl["id"]}_p{cl["representative"]}_c{comparisons}'
            if tag in done:continue
            prefix=ROOT/f'round5/classes/p{cl["representative"]}.s'
            log=ROOT/f'round5/logs/{tag}.log'
            cmd=[sys.executable,str(ROOT/'round5/src/interleave_sat.py'),str(prefix),
                 '--tag',tag,'--comparisons',str(comparisons),'--timeout',str(args.timeout),
                 '--solver',args.solver,'--tests',str(args.tests)]
            minimum=args.minimum_gates if args.minimum_gates is not None else bounds.get(str(cl['id']),8)
            cmd+=['--minimum-gates',str(minimum)]
            for name in ('all','free_copies','history','start_group','preserve','scratch','ordered_seed'):
                if getattr(args,name):cmd.append('--'+name.replace('_','-'))
            print('START',tag,flush=True)
            start=time.monotonic()
            with open(log,'w') as f:
                p=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT)
            results=[];enc=[];judges=[]
            for line in log.read_text().splitlines():
                if line.startswith('{'):
                    row=json.loads(line)
                    if row['event']=='RESULT':results.append(row)
                    if row['event']=='ENC':enc.append(row)
                elif line.startswith('JUDGE'):judges.append(line)
            record=dict(tag=tag,class_id=cl['id'],representative=cl['representative'],
                        programs=cl['programs'],comparisons=comparisons,prefix_comparisons=cl['prefix_comparisons'],
                        log=str(log.relative_to(ROOT)),results=results,encodings=enc,judges=judges,
                        returncode=p.returncode,seconds=round(time.monotonic()-start,3),
                        observed_child_peak_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss)
            with open(journal,'a') as f:f.write(json.dumps(record)+'\n')
            print('END',tag,results[-1]['result'] if results else 'ERROR',record['seconds'],flush=True)
            if (ROOT/'round5/FOUND').exists():return

if __name__=='__main__':main()
