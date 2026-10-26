"""One routing process at a time; save node counts and strict verification."""
import argparse
import collections
import json
import os
from pathlib import Path
import re
import resource
import subprocess
import time

from round2_prepare import required

def limits():
    resource.setrlimit(resource.RLIMIT_AS, (3*1024**3, 3*1024**3))

def verify(text, identity):
    body = text.split('\nSOLUTION ',1)[1].split('\n',1)[1].split('\nEND')[0]
    prog = Path('programs')/('round2_'+identity+'.s')
    prog.write_text('# n=5 iset=I1 model=out source=w8_round2\n'+body+'\n')
    cmd = ['python3','src/verify_log.py',str(prog),prog.stem]
    check = subprocess.run(cmd,capture_output=True,text=True,preexec_fn=limits)
    result = check.stdout+check.stderr
    passed = check.returncode==0 and result.count('PASS ')==2
    if not passed:
        repaired = prog.with_name(prog.stem+'_repaired.s')
        try:
            fix = subprocess.run(['python3','src/repair_ties.py',str(prog),str(repaired)],
                                 capture_output=True,text=True,timeout=120,preexec_fn=limits)
            result += fix.stdout+fix.stderr
            if repaired.exists():
                check = subprocess.run(['python3','src/verify_log.py',str(repaired),repaired.stem],
                                       capture_output=True,text=True,preexec_fn=limits)
                result += check.stdout+check.stderr
                passed = check.returncode==0 and check.stdout.count('PASS ')==2
                if passed: prog = repaired
        except subprocess.TimeoutExpired:
            result += '\nTIE_REPAIR TIMEOUT\n'
    Path('logs',prog.stem+'.verification.log').write_text(result)
    return dict(program=str(prog),verified=passed,judge=result)

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--manifest',default='sk/round2_rerun.json')
    parser.add_argument('--tag',default='round2_rerun')
    args=parser.parse_args()
    if os.nice(0)<19: os.nice(19-os.nice(0))
    limits()
    manifest=json.loads(Path(args.manifest).read_text())
    folder=Path('logs')/args.tag;folder.mkdir(exist_ok=True)
    dst=folder/'results.jsonl'
    completed={}
    if dst.exists():
        for line in dst.read_text().splitlines():
            row=json.loads(line);completed[row['file']]=row
    manifest.sort(key=lambda r:(r['required_gates'],r['node_limit'],r['file']))
    def snapshot():
        counts=collections.Counter(r['status'] for r in completed.values())
        groups={}
        for gates in sorted({r['required_gates'] for r in manifest}):
            rows=[completed[r['file']] for r in manifest if r['file'] in completed and r['required_gates']==gates]
            groups[str(gates)]=dict(total=sum(r['required_gates']==gates for r in manifest),completed=len(rows),
                                   states=sum(r.get('calls',0) for r in rows),
                                   status=dict(collections.Counter(r['status'] for r in rows)))
        value=dict(total=len(manifest),completed=len(completed),status=dict(counts),
                   states=sum(r.get('calls',0) for r in completed.values()),
                   seconds=sum(r.get('seconds',0) for r in completed.values()),gates=groups)
        (folder/'summary.json').write_text(json.dumps(value,indent=2)+'\n')
        return value
    print(json.dumps(dict(start=args.tag,**snapshot())),flush=True)
    with dst.open('a') as stream:
        for source in manifest:
            if source['file'] in completed: continue
            identity=source['file'].replace('/','_').replace('.txt','')
            log=folder/(identity+'.log')
            (folder/'active.json').write_text(json.dumps(source,indent=2)+'\n')
            start=time.monotonic()
            # No wall-time cutoff: the stated node limit controls each rerun.
            proc=subprocess.run(['./dagx_round2',source['file'],'31','1',str(source['node_limit'])],
                                capture_output=True,text=True,preexec_fn=limits)
            text=proc.stdout+proc.stderr;log.write_text(text)
            found=re.findall(r'^RESULT (\w+).*$',text,re.M)
            row=dict(source,log=str(log),status=found[-1] if found else 'ERROR',cost=31,
                     seconds=round(time.monotonic()-start,3),returncode=proc.returncode)
            calls=re.findall(r'calls=(\d+)',text)
            if calls:row['calls']=int(calls[-1])
            if row['status']=='FOUND':
                actual_cost=int(re.search(r'SOLUTION cost=(\d+)',text)[1])
                row.update(verify(text,identity))
                row['actual_cost']=actual_cost
                if not row['verified']:row['status']='REJECTED'
                else:
                    # The strict judge has accepted both forms before this marker is written.
                    result=Path('RESULTS.md')
                    result.write_text('FOUND k='+str(actual_cost)+' '+row['program']+'; strict out and mem PASS\n'+row['judge']+'\n'+result.read_text())
            stream.write(json.dumps(row)+'\n');stream.flush()
            completed[row['file']]=row
            info=snapshot()
            print(json.dumps(dict(done=len(completed),file=row['file'],gates=row['required_gates'],
                                  status=row['status'],calls=row.get('calls'),seconds=row['seconds'],
                                  counts=info['status'],states=info['states'])),flush=True)
    (folder/'active.json').unlink(missing_ok=True)
    print(json.dumps(dict(finished=args.tag,**snapshot())),flush=True)

if __name__=='__main__':main()
