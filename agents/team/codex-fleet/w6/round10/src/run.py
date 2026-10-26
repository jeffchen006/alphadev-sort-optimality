"""Sequential exhaustive-with-timeout routing. A timeout is UNKNOWN."""
import argparse
import collections
import hashlib
import json
import os
from pathlib import Path
import re
import resource
import subprocess
import time

ROOT=Path('/path/to/repo')
ROUND=Path('round10')

def save(path,value):
    tmp=path.with_suffix('.tmp');tmp.write_text(json.dumps(value,indent=2)+'\n');tmp.replace(path)

def verify(log,stem):
    txt=log.read_text();pieces=re.findall(r'SOLUTION[^\n]*\n(.*?)\nEND',txt,re.S)
    found=[]
    for i,body in enumerate(pieces):
        source=ROUND/'candidates'/f'{stem}_{i}_source.s'
        source.write_text('# n=5 model=out iset=I1\n'+body+'\n')
        pre=ROUND/'candidates'/f'{stem}_{i}'
        subprocess.run(['python3','src/lower.py',str(source),str(pre)],check=True,capture_output=True)
        row={'source':str(source),'models':{}}
        for model in ['out','mem']:
            fn=Path(str(pre)+f'_{model}.s');jl=ROUND/'logs'/f'{stem}_{i}_{model}_judge.log'
            cmd=['python3',str(ROOT/'shared/judge.py'),str(fn),'--strict','--model',model]
            with jl.open('w') as f:r=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT)
            row['models'][model]={'file':str(fn),'log':str(jl),'exit_code':r.returncode,'pass':r.returncode==0 and 'PASS' in jl.read_text()}
        found.append(row)
        if all(x['pass'] for x in row['models'].values()):
            core=sum(1 for l in body.splitlines() if l.strip() and not l.startswith('out'))
            if core<=31:
                result=Path('RESULTS.md');old=result.read_text()
                result.write_text(f'FOUND k={core} {pre}_out.s; strict out and mem PASS.\n'+old)
                print('FOUND',core,row,flush=True)
    return found

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--seconds',type=int,default=120)
    ap.add_argument('--manifest',default='round10/artifacts/manifest.json')
    ap.add_argument('--ledger',default='round10/artifacts/ledger.json')
    ap.add_argument('--limit',type=int,default=0)
    ap.add_argument('--root-order',type=int,default=0)
    ap.add_argument('--log-suffix',default='');args=ap.parse_args()
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024*1024,)*2)
    os.environ.update(OMP_NUM_THREADS='1',OPENBLAS_NUM_THREADS='1')
    if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
    ledgerpath=Path(args.ledger);rows=json.loads(ledgerpath.read_text()) if ledgerpath.exists() else []
    if not ledgerpath.exists():save(ledgerpath,rows)
    done={x['file'] for x in rows};plan=json.loads(Path(args.manifest).read_text())
    # The manifest supplies the priority order.
    engine=ROUND/'bin/dagx_flags_fast';enginehash=hashlib.sha256(engine.read_bytes()).hexdigest()
    os.environ['ROOTORDER']=str(args.root_order)
    for x in plan:
        if x['file'] in done:continue
        if (ROUND/'artifacts/PAUSE_DISPATCHER').exists():break
        if args.limit and len(rows)>=args.limit:break
        log=ROUND/'logs'/(Path(x['file']).stem+'_fast_k31'+args.log_suffix+'.log')
        cmd=[str(engine),x['file'],'31','1']
        before=resource.getrusage(resource.RUSAGE_CHILDREN);t=time.monotonic()
        status='ERROR';code=None
        with log.open('w') as f:
            f.write('# '+json.dumps({'command':cmd,'wall_limit':args.seconds,'node_limit':None,'engine_sha256':enginehash})+'\n');f.flush()
            try:
                p=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,timeout=args.seconds)
                code=p.returncode
                m=re.search(r'RESULT (\w+).*',log.read_text())
                status=m[1] if m and code==0 else 'ERROR'
            except subprocess.TimeoutExpired:status='UNKNOWN_TIMEOUT'
        after=resource.getrusage(resource.RUSAGE_CHILDREN)
        txt=log.read_text();m=re.search(r'RESULT (.*)',txt)
        row=dict(x,status=status,exit_code=code,log=str(log),command=cmd,wall_limit=args.seconds,node_limit=None,
                 wall_seconds=time.monotonic()-t,cpu_seconds=(after.ru_utime+after.ru_stime-before.ru_utime-before.ru_stime),max_rss_kib=after.ru_maxrss,
                 result=m[1] if m else None,engine_sha256=enginehash,root_order=args.root_order,assumptions=['A4','A6'])
        if status=='FOUND':
            row['judges']=verify(log,Path(x['file']).stem)
            if not any(all(m['pass'] for m in q['models'].values()) for q in row['judges']):
                row['status']='CANDIDATE_STRICT_FAIL'
        rows.append(row);save(ledgerpath,rows)
        print(len(rows),Path(x['file']).name,status,row['result'],'wall',round(row['wall_seconds'],2),flush=True)
        save(ledgerpath.with_name(ledgerpath.stem+'_summary.json'),dict(total=len(rows),statuses=dict(collections.Counter(r['status'] for r in rows)),cpu_seconds=sum(r['cpu_seconds'] for r in rows),wall_seconds=sum(r['wall_seconds'] for r in rows),max_rss_kib=max(r['max_rss_kib'] for r in rows),planned=len(plan)))

if __name__=='__main__':main()
