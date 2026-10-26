#!/usr/bin/env python3
"""Budget and schedule subfamilies of one interleaving class at a time."""
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
    ap.add_argument('--classes',type=int,nargs='+',default=[21])
    ap.add_argument('--timeout',type=int,default=30)
    ap.add_argument('--queue',default='profiles')
    ap.add_argument('--solver',default='cadical')
    ap.add_argument('--max-copies',type=int,default=5)
    ap.add_argument('--no-scratch',action='store_true')
    ap.add_argument('--tests',type=int,default=120)
    args=ap.parse_args()
    classes=json.loads((ROOT/'round5/logs/classes.json').read_text())
    classes=[cl for cl in classes if cl['id'] in args.classes]
    configs=[]
    for c in (4,5):
        for copies in range(args.max_copies+1):configs.append((c,copies,None))
    profiles={4:['2,3,3,3,2','1,3,3,3,3','3,3,2,3,2','2,2,3,3,3','0,4,3,3,3'],
              5:['2,2,2,2,2,2','1,2,3,2,2,2','0,3,3,2,2,2']}
    for c,ps in profiles.items():
        for p in ps:configs.append((c,None,p))
    journal=ROOT/f'round5/logs/{args.queue}.jsonl'
    done=set()
    if journal.exists():done={json.loads(line)['tag'] for line in journal.read_text().splitlines()}
    for cl in classes:
        for comparisons,copies,profile in configs:
            postfix=f'mv{copies}' if copies is not None else 'pr'+profile.replace(',','')
            tag=f'{args.queue}_cl{cl["id"]}_c{comparisons}_{postfix}'
            if tag in done:continue
            log=ROOT/f'round5/logs/{tag}.log'
            cmd=[sys.executable,str(ROOT/'round5/src/interleave_sat.py'),
                 str(ROOT/f'round5/classes/p{cl["representative"]}.s'),
                 '--tag',tag,'--comparisons',str(comparisons),'--timeout',str(args.timeout),
                 '--solver',args.solver,'--history','--preserve']
            if not args.no_scratch:cmd.append('--scratch')
            if args.tests==120:cmd.append('--all')
            else:cmd+=['--tests',str(args.tests)]
            if copies is not None:cmd+=['--copies',str(copies)]
            if profile:cmd+=['--profile',profile]
            print('START',tag,flush=True);start=time.monotonic()
            with open(log,'w') as f:p=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT)
            results=[];enc=[];judges=[]
            for line in log.read_text().splitlines():
                if line.startswith('{'):
                    row=json.loads(line)
                    if row['event']=='RESULT':results.append(row)
                    if row['event']=='ENC':enc.append(row)
                elif line.startswith('JUDGE'):judges.append(line)
            row=dict(tag=tag,class_id=cl['id'],representative=cl['representative'],
                     comparisons=comparisons,copies=copies,profile=profile,
                     results=results,encodings=enc,judges=judges,returncode=p.returncode,
                     seconds=round(time.monotonic()-start,3),
                     peak_child_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss,
                     log=str(log.relative_to(ROOT)))
            with open(journal,'a') as f:f.write(json.dumps(row)+'\n')
            print('END',tag,results[-1]['result'] if results else 'ERROR',row['seconds'],flush=True)
            if (ROOT/'round5/FOUND').exists():return

if __name__=='__main__':main()
