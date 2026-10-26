#!/usr/bin/env python3
"""Decode every saved SAT assignment and submit its program to the strict judge.

This performs no synthesis. Instruction and output selector variables are
allocated before case clauses, so decoding needs no case-CNF reconstruction.
"""
import argparse
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys

BASE=Path(__file__).resolve().parents[1]
ROOT=BASE.parent
JUDGE='/path/to/repo/shared/judge.py'
spec=importlib.util.spec_from_file_location('window_cnf',ROOT/'round2/src/window_cnf.py')
w=importlib.util.module_from_spec(spec)
spec.loader.exec_module(w)


class Capture:
    def __init__(self):
        self.phases={}
        self.model=[]
    def add_clause(self,clause):pass
    def set_phases(self,phases):self.phases.update({abs(x):x>0 for x in phases})
    def get_model(self):return self.model


def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    directory=BASE/'recovered'
    directory.mkdir(exist_ok=True)
    ledger=[]
    for batch in ['retry','frontier','variants_fixed','variants_freeout','variants_broad']:
        path=BASE/'logs'/f'{batch}_summary.json'
        if not path.exists():continue
        for query in json.loads(path.read_text()):
            sats=[r for r in query['records'] if r.get('phase')=='kissat_result' and r['status']=='True']
            if not sats:continue
            task=query['task'].copy()
            seed=Path(task['seed'])
            if not seed.is_absolute():seed=ROOT/seed
            assert hashlib.sha256(seed.read_bytes()).hexdigest()==query['seed_sha256']
            core,names=w.read(seed)
            for i in range(task.get('extra',0)):names.append(f'S{100+i}')
            defaults=dict(delta=1,mode='free',outputs='free',control=False,cmp_order=False,
                          no_self_write=False,prefer_seed=False,comparisons=-1,solver='capture')
            defaults.update(task)
            defaults['seed']=str(seed)
            delete=defaults.get('delete',[])
            if isinstance(delete,int):delete=[delete]
            if not delete:delete=list(range(task['b']-task['a']-defaults['delta'],task['b']-task['a']))
            defaults['delete']=delete
            capture=Capture()
            w.Solver=lambda name:capture
            window=w.Window(core,names,argparse.Namespace(**defaults))
            for record in sats:
                raw=Path(record['raw_log']).read_text()
                assert 's SATISFIABLE' in raw
                model=[int(x) for line in raw.splitlines() if line.startswith('v ')
                       for x in line[2:].split() if int(x)]
                if record.get('phase_renaming'):
                    model=[-x if capture.phases.get(abs(x)) is False else x for x in model]
                capture.model=model
                candidate,outs=window.decode()
                tag=f'{query["tag"]}_model{record["iteration"]:02d}'
                target=directory/f'{tag}.s'
                w.write(target,candidate,names,outs)
                failing=[]
                for ix,case in enumerate(w.CASES):
                    states,_=w.concrete(candidate,case,len(names))
                    if any(states[t][0][r]!=sorted(case)[j] for j,(t,r) in outs.items()):failing.append(ix)
                checked=subprocess.run([sys.executable,JUDGE,str(target),'--strict','--model','out'],
                                       capture_output=True,text=True)
                log=BASE/'logs'/f'{tag}.judge'
                log.write_text(checked.stdout+checked.stderr)
                result=dict(tag=tag,path=str(target),k=len(candidate),failing_weak_orders=len(failing),
                            binary_failures=sum(max(w.CASES[ix])<=1 for ix in failing),
                            returncode=checked.returncode,judge=checked.stdout+checked.stderr,
                            sha256=hashlib.sha256(target.read_bytes()).hexdigest(),
                            raw_assignment=record['raw_log'])
                ledger.append(result)
                print(json.dumps(result),flush=True)
                if checked.returncode==0 and len(candidate)<=31 and checked.stdout.startswith('PASS '):
                    memory=BASE/'verified'/f'{tag}_mem.s'
                    subprocess.run([sys.executable,str(ROOT/'src/to_mem.py'),str(target),str(memory)],check=True)
                    mem=subprocess.run([sys.executable,JUDGE,str(memory),'--strict','--model','mem'],
                                       capture_output=True,text=True)
                    (BASE/'logs'/f'{tag}_mem.judge').write_text(mem.stdout+mem.stderr)
                    result['memory_judge']=mem.stdout+mem.stderr
                    result['memory_returncode']=mem.returncode
                    results=ROOT/'RESULTS.md'
                    results.write_text(f'FOUND k={len(candidate)} strict out PASS: {target}\n\n'+results.read_text())
    (BASE/'logs/recovered_models.json').write_text(json.dumps(ledger,indent=2)+'\n')
    print(json.dumps({'phase':'replay_complete','models':len(ledger),
                      'strict_passes':sum(x['returncode']==0 for x in ledger)}),flush=True)


if __name__=='__main__':main()
