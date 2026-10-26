"""Apply w7-style non-contiguous four-position repairs to all seven models."""
import atexit
from collections import Counter
import json
from pathlib import Path
import subprocess
import sys

from controller import BASE, ROOT, accept, digest, judge, launch, report, save

CHECKER = ROOT.parents[3]/'agents/proofs/tools/bin/drat-trim'


def controls():
    marker = BASE/'repair/controls.json'
    if marker.exists():
        return
    seed = ROOT/'round3/candidates/control32.s'
    output = BASE/'candidates/repair_positive32.s'
    command = [sys.executable,'-B',str(BASE/'src/search.py'),str(seed),str(output),
               '--changes','0','--prefix','32','--registers','11','--initial','16']
    result = launch(command,BASE/'repair/control_positive32.log',120,cwd=BASE)
    assert any(r.get('status')=='PASS' for r in result['records']),result
    checked = judge(output)
    assert checked['returncode']==0 and checked['output'].startswith('PASS '),checked
    result['judges'] = [checked]
    save(marker,result)
    with (ROOT/'RESULTS.md').open('a') as stream:
        stream.write(f'\nRound-4 copied-encoder control: `{output}` passed the strict out judge at k=32. '
                     f'Judge log: `{checked["judge_log"]}`. This control does not meet the target.\n')


def run():
    # The controller can have started before the repair module was finalized.
    # Rebuild the final machine-readable report with this imported reporter.
    if not (BASE/'handoff/analysis.json').exists():
        subprocess.run([sys.executable,'-B',str(BASE/'src/analyze_failures.py')],check=True)
    controls()
    tasks = json.loads((BASE/'repair/tasks.json').read_text())
    summary = BASE/'repair/summary.json'
    rows = json.loads(summary.read_text()) if summary.exists() else []
    done = {r['tag'] for r in rows}
    for task in tasks:
        if task['tag'] in done:
            continue
        stem = BASE/'repair'/task['tag']
        output = stem.with_suffix('.s')
        command = [sys.executable,'-B',str(BASE/'src/search.py'),task['seed'],str(output),
                   '--changes','0','--registers',str(task['registers']),
                   '--free',','.join(map(str,task['window'])),'--proof','--initial','16']
        save(BASE/'logs/active.json',dict(tag=task['tag'],stage='repair',limit_seconds=task['seconds']))
        row = launch(command,stem.with_suffix('.log'),task['seconds'],cwd=BASE)
        row.update(tag=task['tag'],task=task,command=command,judges=[])
        final = next((r for r in reversed(row['records']) if 'status' in r),{})
        row['status'] = final.get('status','UNKNOWN' if row['external_limit'] else 'ERROR')
        found = False
        if row['status']=='PASS':
            checked = judge(output)
            row['judges'].append(checked)
            found = accept(checked,31)
            if not found:
                row['status']='REJECTED'
        elif row['status']=='UNSAT':
            cnf,proof = str(output)+'.cnf',str(output)+'.drat'
            check_log = stem.with_suffix('.verify.log')
            checked = launch([str(CHECKER),cnf,proof],check_log,120,cwd=BASE)
            row['certificate'] = dict(returncode=checked['returncode'],seconds=checked['seconds'],
                                     cnf_sha256=digest(cnf),drat_sha256=digest(proof),
                                     verified=checked['returncode']==0 and 's VERIFIED' in check_log.read_text())
            if not row['certificate']['verified']:
                row['status']='UNSAT_UNCHECKED'
        save(stem.with_suffix('.json'),row)
        rows.append(row)
        save(summary,rows)
        report()
        print(json.dumps({'phase':'repair_end','tag':task['tag'],'status':row['status'],
                          'seconds':row['seconds']}),flush=True)
        if found:
            break
    counts = dict(Counter(r['status'] for r in rows))
    print(json.dumps({'phase':'repair_complete','queries':len(rows),'statuses':counts}),flush=True)
    from audit_round4 import audit
    atexit.register(audit)
    atexit.register(report, True)


if __name__=='__main__':
    run()
