#!/usr/bin/env python3
"""One CPU job at a time. Preserve each query and its resource record."""
import argparse
import json
import os
from pathlib import Path
import resource
import signal
import subprocess
import sys
import time

ROOT=Path(__file__).resolve().parents[2]

def main():
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    ap=argparse.ArgumentParser()
    ap.add_argument('--timeout',type=int,default=1200)
    ap.add_argument('--family',choices=('retry','seven','repeat'),required=True)
    ap.add_argument('--classes',type=int,nargs='*')
    args=ap.parse_args()
    if args.family=='retry':
        data_control=ROOT/'round6/logs/data_output_control19.log'
        if not data_control.exists():
            with data_control.open('w') as stream:
                p=subprocess.run([sys.executable,str(ROOT/'round6/src/data_output_control.py')],
                                 stdout=stream,stderr=subprocess.STDOUT)
            if p.returncode or 'INDEPENDENT_DATA_OUTPUT_CONTROL PASS' not in data_control.read_text():
                raise SystemExit('Data output control failed.')
        strengthened=ROOT/'round6/logs/class21_data13_no_output_reads.log'
        if not strengthened.exists():
            print('START class21_data13_no_output_reads',flush=True)
            with strengthened.open('w') as stream:
                p=subprocess.run([sys.executable,str(ROOT/'round6/src/data_bound.py'),
                    str(ROOT/'round5/classes/p37.s'),'--slots','13','--minimum-gates','11',
                    '--no-output-reads','--tag','class21_data13_no_output_reads',
                    '--timeout',str(args.timeout),'--proof'],stdout=stream,stderr=subprocess.STDOUT)
            print('END class21_data13_no_output_reads',p.returncode,flush=True)
            if p.returncode:raise SystemExit('Data follow-up failed.')
        control=ROOT/'round6/logs/sink_control12.log'
        if not control.exists():
            with control.open('w') as stream:
                p=subprocess.run([sys.executable,str(ROOT/'round6/src/sink_control.py')],
                                 stdout=stream,stderr=subprocess.STDOUT)
            if p.returncode or 'INDEPENDENT_SINK_CONTROL PASS' not in control.read_text():
                raise SystemExit('Output-selector control failed.')
        reference_control=ROOT/'round6/logs/sink_reference12.log'
        if not reference_control.exists():
            with reference_control.open('w') as stream:
                p=subprocess.run([sys.executable,str(ROOT/'round6/src/sink_control.py'),'--reference'],
                                 stdout=stream,stderr=subprocess.STDOUT)
            if p.returncode or 'INDEPENDENT_SINK_CONTROL PASS' not in reference_control.read_text():
                raise SystemExit('Reference selector control failed.')
        capacity_control=ROOT/'round6/logs/repeat_capacity37.log'
        if not capacity_control.exists():
            with capacity_control.open('w') as stream:
                p=subprocess.run([sys.executable,str(ROOT/'round6/src/interleave_sat.py'),
                    str(ROOT/'round5/classes/p0.s'),'--slots','23','--comparisons','7',
                    '--fix',str(ROOT/'round6/programs/repeat_control_suffix23.s'),
                    '--repeat-flag','--tag','repeat_capacity37','--all','--history',
                    '--capacity','--preserve','--scratch','--timeout','60'],
                    stdout=stream,stderr=subprocess.STDOUT)
            if p.returncode or 'STRICT_PASS 37' not in capacity_control.read_text():
                raise SystemExit('History-capacity control failed.')
        checked=ROOT/'round6/logs/class21_gate10_sinks.drat_check'
        followup=ROOT/'round6/logs/class21_gate11_sinks.log'
        if checked.exists() and 's VERIFIED' in checked.read_text() and not followup.exists():
            print('START class21_gate11_sinks',flush=True)
            with followup.open('w') as stream:
                p=subprocess.run([sys.executable,str(ROOT/'round6/src/gate_bound.py'),
                    str(ROOT/'round5/classes/p37.s'),'--gates','11','--tag','class21_gate11_sinks',
                    '--solver','kissat','--timeout',str(args.timeout),'--proof','--sink-outputs'],
                    stdout=stream,stderr=subprocess.STDOUT)
            print('END class21_gate11_sinks',p.returncode,flush=True)
            if p.returncode:raise SystemExit('Selector follow-up failed.')
        subprocess.run([sys.executable,str(ROOT/'round6/src/extend_bounds.py')],check=True)
    classes=json.loads((ROOT/'round5/logs/classes.json').read_text())
    old=json.loads((ROOT/'round5/logs/query_registry.json').read_text())
    bounds=json.loads((ROOT/'round5/logs/checked_gate_bounds.json').read_text())
    new_bounds=ROOT/'round6/logs/checked_gate_bounds.json'
    if new_bounds.exists():bounds.update(json.loads(new_bounds.read_text()))
    prior={}
    for q in old:
        for a in q['attempts']:
            enc=a['encoding'] or {}
            if a['result']['result']=='TIMEOUT' and 'prefix' in enc:
                key=(Path(enc['prefix']).name,enc['comparisons'])
                prior.setdefault(key,[]).append(q['log'])
    configurations=[]
    if args.family=='retry':
        for cl in sorted(classes,key=lambda c:(-c['programs'],c['id'])):
            if args.classes and cl['id'] not in args.classes:continue
            pending=sorted({c for name,c in prior if name==f'p{cl["representative"]}.s'})
            for c in pending:
                key=(f'p{cl["representative"]}.s',c)
                if key in prior:configurations.append((cl,c,prior[key]))
    elif args.family in ('seven','repeat'):
        kept={r['class_id'] for r in json.loads((ROOT/'round5/logs/preflight.json').read_text()) if not r['missing_input']}
        for cl in sorted(classes,key=lambda c:(-c['programs'],c['id'])):
            if cl['prefix_comparisons']!=3 or cl['id'] not in kept:continue
            if args.classes and cl['id'] not in args.classes:continue
            configurations.append((cl,5 if args.family=='repeat' else 4,[]))
    journal=ROOT/f'round6/logs/{args.family}.jsonl'
    old_records=[json.loads(l) for l in journal.read_text().splitlines()] if journal.exists() else []
    done={r['tag'] for r in old_records if r.get('returncode')==0 and r.get('results')}
    plan=[]
    for cl,c,previous in configurations:
        tag=f'{args.family}_cl{cl["id"]}_p{cl["representative"]}_c{c}'
        plan.append(dict(tag=tag,class_id=cl['id'],comparisons=c,previous=previous))
    (ROOT/f'round6/logs/{args.family}_plan.json').write_text(json.dumps(plan,indent=2)+'\n')
    for cl,c,previous in configurations:
        tag=f'{args.family}_cl{cl["id"]}_p{cl["representative"]}_c{c}'
        if tag in done:continue
        if (ROOT/'round6/FOUND').exists():return
        log=ROOT/f'round6/logs/{tag}.log'
        if log.exists():
            count=1
            while log.with_name(log.stem+f'.failed{count}.log').exists():count+=1
            log.rename(log.with_name(log.stem+f'.failed{count}.log'))
        cmd=['/usr/bin/time','-v',sys.executable,str(ROOT/'round6/src/interleave_sat.py'),
             str(ROOT/f'round5/classes/p{cl["representative"]}.s'), '--tag',tag,
             '--comparisons',str(c),'--timeout',str(args.timeout),'--solver','kissat',
             '--all','--history','--capacity','--preserve','--scratch','--iterations','20',
             '--minimum-gates',str(bounds.get(str(cl['id']),8))]
        if args.family=='repeat':cmd.append('--repeat-flag')
        print('START',tag,flush=True)
        started=time.monotonic()
        with log.open('w') as f:
            child=subprocess.Popen(cmd,stdout=f,stderr=subprocess.STDOUT,start_new_session=True)
            while child.poll() is None:
                time.sleep(1)
        text=log.read_text();results=[];enc=[]
        for line in text.splitlines():
            if line.startswith('{'):
                row=json.loads(line)
                if row.get('event')=='RESULT':results.append(row)
                if row.get('event')=='ENC':enc.append(row)
        rss=[int(l.split(':',1)[1]) for l in text.splitlines() if 'Maximum resident set size (kbytes):' in l]
        row=dict(tag=tag,class_id=cl['id'],representative=cl['representative'],
                 prefix_comparisons=cl['prefix_comparisons'],comparisons=c,
                 total_comparisons=cl['prefix_comparisons']+c,
                 previous_logs=previous,seconds=round(time.monotonic()-started,3),
                 returncode=child.returncode,results=results,encodings=enc,
                 peak_process_rss_kib=max(rss,default=0),log=str(log.relative_to(ROOT)))
        with journal.open('a') as f:f.write(json.dumps(row)+'\n')
        print('END',tag,results[-1]['result'] if results else 'ERROR',row['seconds'],flush=True)
        if child.returncode:raise SystemExit('Query process failed; inspect '+str(log))
    print('QUEUE_COMPLETE',args.family,flush=True)

if __name__=='__main__':main()
