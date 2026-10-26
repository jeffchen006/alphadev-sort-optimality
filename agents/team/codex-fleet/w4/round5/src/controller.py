"""Serial, restartable 600-second window batch with strict verification."""
from collections import Counter
import fcntl
import hashlib
import json
import os
from pathlib import Path
import resource
import signal
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT/'round5'
JUDGE = ROOT.parents[3]/'shared/judge.py'
CHECKER = ROOT.parents[3]/'agents/proofs/tools/bin/drat-trim'


def digest(path):
    h=hashlib.sha256()
    with Path(path).open('rb') as f:
        while block:=f.read(1024**2):h.update(block)
    return h.hexdigest()


def save(path,data):
    p=Path(path);tmp=p.with_suffix(p.suffix+'.tmp')
    tmp.write_text(json.dumps(data,indent=2)+'\n');tmp.replace(p)


def launch(command,log,seconds,env=None):
    started=time.monotonic()
    with Path(log).open('w') as stream:
        p=subprocess.Popen(command,stdout=stream,stderr=subprocess.STDOUT,
                           start_new_session=True,env=env,cwd=BASE)
        try:p.wait(timeout=seconds);limited=False
        except subprocess.TimeoutExpired:
            limited=True;os.killpg(p.pid,signal.SIGTERM)
            try:p.wait(timeout=2)
            except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
    rows=[]
    for line in Path(log).read_text().splitlines():
        try:
            row=json.loads(line)
            if isinstance(row,dict):rows.append(row)
        except ValueError:pass
    return dict(command=command,returncode=p.returncode,external_limit=limited,
                seconds=round(time.monotonic()-started,3),records=rows)


def judge(path,model='out'):
    checked=subprocess.run([sys.executable,'-B',str(JUDGE),str(path),'--strict','--model',model],
                           capture_output=True,text=True)
    output=checked.stdout+checked.stderr
    log=BASE/'logs'/f'{Path(path).stem}_{model}.judge';log.write_text(output)
    return dict(path=str(path),returncode=checked.returncode,output=output,
                log=str(log),sha256=digest(path))


def run_task(task):
    assert digest(task['seed'])==task['seed_sha256']
    tag=task['tag'];stem=BASE/'cnf'/tag;output=BASE/'candidates'/f'{tag}.s'
    env=os.environ.copy();env['W4_QUERY_STEM']=str(stem)
    env['W4_QUERY_DEADLINE']=str(time.monotonic()+task['seconds'])
    command=[sys.executable,'-B',str(BASE/'src/search.py'),task['seed'],str(output),
             '--changes','0','--registers',str(task['registers']),'--initial','16']
    command+=['--free',','.join(map(str,task['window']))] if task['window'] else ['--prefix','32']
    if task.get('all_cases'):command+=['--all-cases']
    save(BASE/'logs/active.json',dict(tag=tag,started_unix=time.time(),limit_seconds=task['seconds']))
    print(json.dumps(dict(phase='start',tag=tag,seconds=task['seconds'])),flush=True)
    row=launch(command,BASE/'logs'/f'{tag}.log',task['seconds']+8,env)
    row.update(tag=tag,task=task,judges=[])
    final=next((r for r in reversed(row['records']) if r.get('status') in ['PASS','UNSAT','UNKNOWN']),{})
    row['status']=final.get('status','UNKNOWN' if row['external_limit'] or row['returncode'] in [-9,-15] else 'ERROR')
    if row['status']=='UNSAT':
        cnf=stem.with_suffix('.cnf');proof=stem.with_suffix('.drat')
        check_log=BASE/'logs'/f'{tag}.verify.log'
        check=launch([str(CHECKER),str(cnf),str(proof)],check_log,120)
        verified=check['returncode']==0 and 's VERIFIED' in check_log.read_text()
        row['certificate']=dict(returncode=check['returncode'],seconds=check['seconds'],verified=verified,
                                cnf=str(cnf),cnf_sha256=digest(cnf),proof_sha256=digest(proof))
        if not verified:row['status']='UNSAT_UNCHECKED'
    if row['status']=='PASS':
        checked=judge(output);row['judges'].append(checked)
        if checked['returncode'] or not checked['output'].startswith('PASS '):row['status']='REJECTED'
        else:
            core=sum(bool(line.partition('#')[0].strip()) and not line.startswith('out')
                     for line in output.read_text().splitlines())
            row['k']=core
            if core<=31:
                target=BASE/'verified'/output.name;target.write_bytes(output.read_bytes())
                memory=target.with_name(target.stem+'_mem.s')
                subprocess.run([sys.executable,'-B',str(ROOT/'src/to_mem.py'),str(target),str(memory)],check=True)
                row['judges'].append(judge(memory,'mem'))
                results=ROOT/'RESULTS.md'
                results.write_text(f'FOUND k={core} strict out PASS: {target}\n\n'+results.read_text())
    row['maximum_measured_job_rss_kib']=max((r.get('peak_job_rss_kib',0) for r in row['records']),default=0)
    save(BASE/'logs'/f'{tag}.json',row)
    print(json.dumps(dict(phase='end',tag=tag,status=row['status'],seconds=row['seconds'])),flush=True)
    return row


def report(rows,finished=False):
    tasks=json.loads((BASE/'logs/tasks.json').read_text())
    data=dict(finished=finished,planned=len(tasks),completed=len(rows),pending=len(tasks)-len(rows),
              statuses=dict(Counter(r['status'] for r in rows)),
              groups={g:dict(Counter(r['status'] for r in rows if r['task']['group']==g)) for g in ['recovered','w6']},
              query_wall_seconds=round(sum(r['seconds'] for r in rows),3),
              maximum_measured_job_rss_kib=max((r['maximum_measured_job_rss_kib'] for r in rows),default=0),
              verified_unsat=sum(r.get('certificate',{}).get('verified',False) for r in rows),
              model_judges=sum(sum(e.get('step')=='model_judge' for e in r['records']) for r in rows),
              assumptions=['G1','G2','G3','G4','A2','A11'],
              strict_passes=[j for r in rows for j in r['judges'] if not j['returncode'] and j['output'].startswith('PASS ')],
              source_sha256={str(p.relative_to(ROOT)):digest(p) for p in (BASE/'src').glob('*.py')})
    save(BASE/'logs/progress.json',data)
    text=(f"Round 5: {len(rows)}/{len(tasks)} windows complete. Statuses: {data['statuses']}.\n\n"
          f"Checked UNSAT certificates: {data['verified_unsat']}. Strict model judges: {data['model_judges']}.\n\n"
          f"Query wall seconds: {data['query_wall_seconds']}. Largest sampled job RSS: {data['maximum_measured_job_rss_kib']} KiB.\n\n"
          "Assumptions [G1,G2,G3,G4,A2,A11]. Each exclusion concerns four free instruction positions, "
          "free output snapshots, and the stated finite register set. The scratch value above all inputs "
          "and equal initial flags define a necessary test state. Candidates require the strict judge. "
          "Time and resource limits remain UNKNOWN. No global lower bound follows.\n")
    (BASE/'STATUS.md').write_text(text)
    if finished:
        save(BASE/'logs/final_audit.json',data)
        marker=BASE/'logs/report_appended'
        if not marker.exists():
            with (ROOT/'RESULTS.md').open('a') as f:f.write('\n### Round-5 completed windows\n\n'+text)
            marker.write_text(str(time.time())+'\n')
    return data


def controls():
    marker=BASE/'logs/controls.json'
    if marker.exists():return
    positive=ROOT/'round3/candidates/control32.s'
    negative=BASE/'seeds/variants_broad_v17_model01.s'
    rows=[]
    for tag,seed in [('positive32',positive),('negative31',negative)]:
        from reference_window import read
        p,nr=read(seed)
        task=dict(tag=tag,seed=str(seed),seed_sha256=digest(seed),registers=nr,
                  window=[],seconds=120,group='control',all_cases=True)
        row=run_task(task);rows.append(row)
        assert row['status']==('PASS' if tag=='positive32' else 'UNSAT'),row
    save(marker,rows)


def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    lock=(BASE/'logs/controller.lock').open('w');fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
    save(BASE/'logs/controller.json',dict(pid=os.getpid(),affinity=sorted(os.sched_getaffinity(0)),
                                      nice=os.getpriority(os.PRIO_PROCESS,0),started_unix=time.time()))
    controls()
    path=BASE/'logs/summary.json';rows=json.loads(path.read_text()) if path.exists() else []
    done={r['tag'] for r in rows}
    report(rows)
    for task in json.loads((BASE/'logs/tasks.json').read_text()):
        if task['tag'] in done:continue
        row=run_task(task);rows.append(row);save(path,rows);report(rows)
        if row['status']=='PASS':break
        if row['status']=='ERROR':raise RuntimeError(f"Query error: {row['tag']}")
    report(rows,True)


if __name__=='__main__':
    main()
