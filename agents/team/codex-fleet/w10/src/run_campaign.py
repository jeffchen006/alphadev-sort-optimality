#!/usr/bin/env python3
"""Run at most six CPU-bound search workers, all at nice level 10."""
import concurrent.futures
import json
import os
from pathlib import Path
import subprocess
import sys
import time

sys.path.insert(0, str(Path(__file__).resolve().parent))
from analyze import collection, dump, parse, trace, PERMS, CONDS

ROOT = Path(__file__).resolve().parent.parent

def snapshot_error(prog):
    garbage = (None,)*120
    regs = {f'P{i}': tuple(p[i] for p in PERMS) for i in range(5)}
    flags = (0,)*120
    best = [120]*5
    for op,a,b in prog:
        if op == 'out':
            continue
        x,y = regs.get(a,garbage),regs.get(b,garbage)
        if op == 'cmp':
            flags = tuple(None if u is None or v is None else (u>v)-(u<v) for u,v in zip(x,y))
            continue
        if op == 'mov':
            col=y
        else:
            col=tuple((v if CONDS[op](f) else u) if f is not None else (u if u==v else None)
                      for u,v,f in zip(x,y,flags))
        regs[a]=col
        for j in range(5):
            best[j]=min(best[j],sum(v!=j for v in col))
    return sum(best)

def make_seeds():
    records=[]
    for s in range(4):
        p=parse((ROOT/f'programs/exception_{s}_original.s').read_text())
        p=[x for x in p if x[0]!='out']
        variants=[]
        for i in range(len(p)):
            q=p[:i]+p[i+1:]
            variants.append((snapshot_error(q),i,q))
        variants.sort(key=lambda v:v[:2])
        for j,(e,i,q) in enumerate(variants[:4]):
            f=ROOT/f'programs/delete_{s}_{j}.s'
            dump(q,f,source=f'w10_deleted_{i}_strict120_error_{e}')
            records.append({'seed':str(f.relative_to(ROOT)),'deleted_core_index':i,'error_120':e})
    (ROOT/'analysis/deletion_seeds.json').write_text(json.dumps(records,indent=2)+'\n')

def run_one(config):
    ident=config['id']
    log=ROOT/'logs'/f'{ident}.log'
    cmd=['nice','-n','10',str(ROOT/config.get('binary','gap_mcmc')),'-n','5','-m','out','-i','I1',
         '-L',str(config['L']),'-S',str(config['S']),'-seed',str(config['rng']),
         '-time',str(config['cpu']),'-T',str(config['temp']),'-gap',str(config['gap']),
         '-lam',str(config['lam']),'-restart',str(config.get('restart',0)),
         '-start',str(ROOT/config['seed']),'-out',str(ROOT/'programs'/ident)]
    if config.get('collect'):
        cmd += ['-collect',str(config['collect'])]
    if config.get('delete'):
        cmd += ['-del',str(config['delete'])]
    if config.get('iters'):
        cmd += ['-iters',str(config['iters'])]
    start=time.monotonic()
    with log.open('w') as f:
        f.write('# command: '+' '.join(cmd)+'\n');f.flush()
        try:
            p=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,cwd=ROOT,timeout=config.get('wall',900))
            code=p.returncode
        except subprocess.TimeoutExpired:
            code=124
    record=dict(config,returncode=code,wall_seconds=round(time.monotonic()-start,2))
    (ROOT/'logs'/f'{ident}.json').write_text(json.dumps(record,indent=2)+'\n')
    print(json.dumps(record),flush=True)
    return record

if __name__=='__main__':
    os.chdir(ROOT)
    make_seeds()
    wave=int(sys.argv[1]) if len(sys.argv)>1 else 0
    configs=[]
    for i in range(6):
        configs.append(dict(id=f'wave{wave}_{i}', L=31 if i<4 else 32,
                            S=[6,10,16,24,10,16][i],rng=100000+wave*100+i,
                            cpu=240,wall=900,temp=[0.25,0.6,1.0,1.6,0.3,0.7][i],
                            gap=[2,5,10,5,5,10][i],lam=1.25,
                            seed=f'programs/delete_{i%4}_{wave%4}.s' if i<4 else f'programs/exception_{i%4}_original.s',
                            restart=0.000002 if i<4 else 0,collect=0))
    if wave==1:
        seeds=sorted(ROOT.glob('programs/c8_guard_[01]_[0-9].s'))
        assert seeds,'run guard_seeds.py before campaign 1'
        configs=[]
        for i in range(6):
            seed=seeds[i%len(seeds)]
            deletion=seed.with_name(seed.stem+f'_delete_{i%3}.s')
            configs.append(dict(id=f'wave1_{i}',L=31,S=[6,10,16,24,10,16][i],
                                rng=110000+i,cpu=60,wall=600,iters=500000,
                                temp=[0.2,0.4,0.7,1.0,1.5,2.0][i],gap=6,lam=1.25,
                                seed=str(deletion.relative_to(ROOT)),restart=0.000002,
                                binary='gap_mcmc_next'))
    (ROOT/'logs'/f'wave{wave}_config.json').write_text(json.dumps(configs,indent=2)+'\n')
    with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:
        results=list(pool.map(run_one,configs))
    print('COMPLETE',len(results),flush=True)
