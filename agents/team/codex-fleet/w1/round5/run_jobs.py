"""Run round 5 jobs sequentially with resource and verification records."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import resource
import subprocess
import time

HERE=Path(__file__).resolve().parent
WORK=HERE.parent
ROOT=HERE.parents[4]
JUDGE=ROOT/'shared/judge.py'


def run(command,stem):
    command=list(map(str,command))
    start=time.monotonic()
    with (HERE/(stem+'.log')).open('w') as out,(HERE/(stem+'.resources')).open('w') as err:
        result=subprocess.run(['/usr/bin/time','-v']+command,stdout=out,stderr=err)
    row={'command':command,'stem':stem,'exit':result.returncode,
         'wall_seconds':time.monotonic()-start,
         'source_hashes':{p.name:hashlib.sha256(p.read_bytes()).hexdigest()
                          for p in HERE.iterdir() if p.suffix in ['.py','.cpp']}}
    ledger=HERE/'jobs.json'
    rows=json.loads(ledger.read_text()) if ledger.exists() else []
    rows.append(row)
    ledger.write_text(json.dumps(rows,indent=2)+'\n')
    print('JOB',stem,'exit',result.returncode,'wall',round(row['wall_seconds'],3),flush=True)
    assert result.returncode==0,(stem,(HERE/(stem+'.resources')).read_text()[-2500:])
    return (HERE/(stem+'.log')).read_text()


def verify(path):
    path=Path(path)
    log=run(['python3',JUDGE,path,'--strict','--model','out'],path.stem+'_judge_out')
    assert log.startswith('PASS '),log
    mem=path.with_name(path.stem+'_mem.s')
    run(['python3','round3/lower.py',path,mem],path.stem+'_lower')
    log=run(['python3',JUDGE,mem,'--strict','--model','mem'],path.stem+'_judge_mem')
    assert log.startswith('PASS '),log
    k=sum(bool(line.split('#')[0].strip()) and not line.strip().startswith('out ')
          for line in path.read_text().splitlines())
    ledger=HERE/'passes.json'
    rows=json.loads(ledger.read_text()) if ledger.exists() else []
    rows.append({'out':str(path.relative_to(WORK)),'mem':str(mem.relative_to(WORK)),
                 'k':k,'length_mem':k+10,
                 'out_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
                 'mem_sha256':hashlib.sha256(mem.read_bytes()).hexdigest()})
    ledger.write_text(json.dumps(rows,indent=2)+'\n')
    if k<=31:
        report=WORK/'RESULTS.md'
        report.write_text(f'FOUND k={k} total={k+10} strict out+mem PASS: {path}, {mem}\n\n'+report.read_text())
        raise SystemExit(0)


def merge(stem,k,cmps,regs=8,prefix='pair',cpu=300,fixed='binary',order='0,2,1,3'):
    run(['python3','round5/merge_sat.py','--k',k,'--cmps',cmps,'--regs',regs,
         '--prefix',prefix,'--fixed',fixed,'--creation-outputs','--cpu',cpu,
         '--predicate-order',order,
         '--conflicts',2000,'--stem',stem],stem)
    record=json.loads((HERE/(stem+'.json')).read_text())
    if record['status']=='CANDIDATE':
        verify(record['path'])


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('phase',choices=['finite','binary','triple','rankfixed','rankbatch','shapes','rankunits'])
    args=ap.parse_args()
    os.chdir(WORK)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    os.nice(max(0,19-os.getpriority(os.PRIO_PROCESS,0)))
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    if args.phase=='finite':
        run(['python3','round5/check_encoding.py'],'check_encoding')
        for suffix,flags in [('sorted',[]),('unsorted',['--unsorted-pair']),
                             ('sorted_distinct',['--strict']),
                             ('unsorted_distinct',['--unsorted-pair','--strict'])]:
            run(['python3','round5/rank_chains.py']+flags,'raw_'+suffix)
        run(['g++','-O3','-std=c++17','round5/forward_chains.cpp','-o','round5/forward_chains'],'forward_build')
        run(['./round5/forward_chains'],'forward_chains')
        python=(HERE/'raw_sorted_distinct.tsv').read_text()
        cpp=(HERE/'forward_distinct.tsv').read_text()
        assert python==cpp,'independent forward/backward cost tables differ'
        (HERE/'forward_check.log').write_text('PASS exact match: 720 orders x 5 output costs\n')
        verify(HERE/'control34.s')
    elif args.phase=='binary':
        merge('binary17_c4',17,4,cpu=300,order='0,1,2,3')
        merge('binary16_c4',16,4,cpu=600)
    elif args.phase=='triple':
        merge('triple20_c5',20,5,regs=8,prefix='triple',cpu=180)
    elif args.phase=='rankfixed':
        run(['python3','round5/rank_dag.py','--gates',10,'--cpu',180,
             '--order','0,1,2,5,4,3','--stem','rank_dag10_fixed'],'rank_dag10_fixed')
    elif args.phase=='rankbatch':
        run(['python3','round5/rank_batch.py','--cpu',600],'rank_dag10_batch')
    elif args.phase=='rankunits':
        run(['python3','round5/rank_units.py','--cpu',300],'rank_dag10_units')
    else:
        run(['python3','round5/merge_shapes.py','--cpu',180],'binary16_shapes')
        row=json.loads((HERE/'binary16_shapes.json').read_text())
        if row['status']=='CANDIDATE':
            verify(row['path'])


if __name__=='__main__':
    main()
