"""Collect new conditional-swap sources, strict-judge them, add one repeat."""
import collections
import hashlib
import json
import os
from pathlib import Path
import resource
import subprocess
import time
import numpy as np
import generate as g
from expand import opkey

resource.setrlimit(resource.RLIMIT_AS,(2800*1024*1024,)*2)
os.environ.update(OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1')
out=Path('round10/invented');out.mkdir(exist_ok=True)
cmd=['round10/bin/collect_macros',str(out),'120','2610731','0.35','round10/artifacts/macro_seed.csv']
before=resource.getrusage(resource.RUSAGE_CHILDREN);t=time.monotonic()
with Path('round10/logs/invention.log').open('w') as f:
    p=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,timeout=300)
after=resource.getrusage(resource.RUSAGE_CHILDREN)
run=dict(command=cmd,exit_code=p.returncode,cpu_seconds=after.ru_utime+after.ru_stime-before.ru_utime-before.ru_stime,wall_seconds=time.monotonic()-t,max_rss_kib=after.ru_maxrss,
         binary_sha256=hashlib.sha256(Path(cmd[0]).read_bytes()).hexdigest(),seed_sha256=hashlib.sha256(Path(cmd[-1]).read_bytes()).hexdigest())
Path('round10/artifacts/invention_run.json').write_text(json.dumps(run,indent=2))
assert p.returncode==0

oldflag=set();old_operand=set();exclusion_counts={};unreadable=0
for folder in [g.ROOT/'agents/team/codex-fleet/w2/sk',g.ROOT/'agents/team/d1-skeleton/sk']:
    parsed=0
    for fn in sorted(folder.rglob('*.txt')):
        try:sk=g.readsk(fn)
        except (ValueError,IndexError,UnicodeDecodeError):unreadable+=1;continue
        if sk is not None:oldflag.add(g.key(sk));parsed+=1
    exclusion_counts[str(folder)]=parsed
for name in ['manifest','expanded_manifest','singleton_inventory']:
    for row in json.loads(Path(f'round10/artifacts/{name}.json').read_text()):
        sk=g.readsk(Path(row['file']))
        if sk is not None:
            old_operand.add(opkey(sk))
            # Seek flag histories outside this round's old source structures.
            oldflag.add(g.key(sk))
sources=[];queries=[];byseed=collections.defaultdict(list);seen=set();excluded=0
skdir=Path('round10/sk_invented');skdir.mkdir(exist_ok=True)
for fn in sorted(out.glob('*.s')):
    jl=Path('round10/logs')/(fn.stem+'_invented_out_judge.log')
    with jl.open('w') as f:j=subprocess.run(['python3',str(g.ROOT/'shared/judge.py'),str(fn),'--strict','--model','out'],stdout=f,stderr=subprocess.STDOUT)
    passed=j.returncode==0 and jl.read_text().startswith('PASS ')
    code,names=g.load(fn);trace=g.trace(code,names)
    row=dict(file=str(fn),sha256=hashlib.sha256(fn.read_bytes()).hexdigest(),strict_out='PASS' if passed else 'FAIL',judge_log=str(jl))
    sources.append(row)
    if not passed or trace is None:continue
    sk=trace[0];base=len(sources)-1
    for repeat in range(8):
        for pos in range(repeat+2,10):
            ext=np.insert(sk,pos,sk[repeat],axis=0);fk=g.key(ext);ok=opkey(ext)
            if fk in oldflag or ok in old_operand:excluded+=1;continue
            if ok in seen:continue
            seen.add(ok);dest=skdir/f'i{len(queries):05d}.txt'
            dest.write_text(f'# invented source={fn} repeat={repeat} insert={pos}\n'+''.join('='+''.join(map(str,a))+':='+''.join(map(str,b))+'\n' for a,b in ext))
            q=dict(file=str(dest),seed=str(fn),base=base,repeat=repeat,insert=pos,kind='invented_macro_repeat',sha256=hashlib.sha256(dest.read_bytes()).hexdigest())
            queries.append(q);byseed[base].append(q)
    print('invention source',fn.name,row['strict_out'],'queries',len(queries),flush=True)
    Path('round10/artifacts/invented_sources.json').write_text(json.dumps(sources,indent=2))
    Path('round10/artifacts/invented_all_manifest.json').write_text(json.dumps(queries,indent=2))
plan=[]
for items in byseed.values():
    items.sort(key=lambda x:(x['insert']-x['repeat'],abs(x['repeat']-4),x['repeat']))
for rank in range(36):
    for base in sorted(byseed):
        if rank<len(byseed[base]):plan.append(byseed[base][rank])
# At most 360 new scopes. The full generated inventory remains available.
plan=plan[:360]
Path('round10/artifacts/invented_manifest.json').write_text(json.dumps(plan,indent=2))
Path('round10/artifacts/invention_generation.json').write_text(json.dumps(dict(sources=len(sources),strict_out=dict(collections.Counter(x['strict_out'] for x in sources)),generated=len(queries),selected=len(plan),oldflag_classes=len(oldflag),excluded=excluded,exclusion_files=exclusion_counts,unreadable_files=unreadable),indent=2))
print('INVENTION',len(sources),'samples',len(queries),'new scopes',len(plan),'selected',flush=True)
