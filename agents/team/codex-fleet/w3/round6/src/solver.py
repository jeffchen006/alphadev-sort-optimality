"""Local single-process solver wrapper with a child address-space limit."""
import json
import gc
import ctypes
import os
from pathlib import Path
import resource
import subprocess
import time
PROJECT=Path(__file__).resolve().parents[6]
# This worker folder is PROJECT/agents/team/codex-fleet/w3.
PROJECT=Path(__file__).resolve().parents[2].parents[3]

def child_limits():
    resource.setrlimit(resource.RLIMIT_AS,(2400*1024**2,)*2)

def solve(enc,tag,timeout,seed,solver,proof=False):
    if getattr(enc,'_clauses_released',False):raise RuntimeError('Solver encoding has already been consumed.')
    cnf=str(tag)+'.cnf';log=str(tag)+'.solver';enc.dimacs(cnf)
    enc.cs.clear();enc._clauses_released=True
    gc.collect()
    try:ctypes.CDLL(None).malloc_trim(0)
    except AttributeError:pass
    cmd=['timeout','--kill-after=5',str(timeout),str(PROJECT/'bin'/solver),'-q']
    if solver=='kissat':cmd.append(f'--seed={seed}')
    cmd.append(cnf)
    if proof:cmd.append(str(tag)+'.drat')
    start=time.monotonic()
    with open(log,'w') as stream:
        p=subprocess.run(cmd,stdout=stream,stderr=subprocess.STDOUT,preexec_fn=child_limits)
    status='TIMEOUT' if p.returncode in (124,137) else 'UNKNOWN';model=[]
    for line in Path(log).read_text().splitlines():
        if line.startswith('s '):status=line[2:]
        elif line.startswith('v '):model.extend(int(x) for x in line[2:].split() if int(x))
    if proof and status=='UNSATISFIABLE':
        checklog=str(tag)+'.drat_check'
        with open(checklog,'w') as stream:
            p=subprocess.run(['timeout','--kill-after=5','600',str(PROJECT/'bin/drat-trim'),cnf,
                              str(tag)+'.drat','-t','590'],stdout=stream,stderr=subprocess.STDOUT,
                             preexec_fn=child_limits)
        checked=not p.returncode and 's VERIFIED' in Path(checklog).read_text()
        print('CNF_CERTIFICATE_'+('VERIFIED' if checked else 'UNCHECKED'),checklog,flush=True)
    if not proof:os.unlink(cnf)
    return status,model,round(time.monotonic()-start,3)
