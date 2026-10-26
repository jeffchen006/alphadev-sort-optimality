#!/usr/bin/env python3
"""Wait for the retry, then generate and route 200 new lost-value cases."""
import hashlib, json, os, re, resource, subprocess, time
from collections import Counter
from pathlib import Path

resource.setrlimit(resource.RLIMIT_AS,(2800000000,2800000000))
base=Path('logs/round0325_new');base.mkdir(exist_ok=True)
while 'RETRY COMPLETE' not in Path('logs/round0325_batch.log').read_text():
    if Path('logs/round0325/summary.json').exists():
        s=json.loads(Path('logs/round0325/summary.json').read_text())
        if s['counts'].get('FOUND'):raise SystemExit('Retry candidate needs review.')
    time.sleep(10)

root=Path('/path/to/repo')
seeds=root/'agents/team/d7-structure/fam32'
with (base/'generation.log').open('w') as out:
    subprocess.run(['nice','-n','19','g++','-O3','-std=c++17','src/recompute9_two.cpp','-o','recompute9_two'],stdout=out,stderr=subprocess.STDOUT,check=True)
    subprocess.run(['nice','-n','19','./recompute9_two',str(seeds),
                    'sk/recompute9_wide_classified/all_viable_recipes.tsv','sk/recompute9_two',
                    str(root/'agents/team/d1-skeleton/sk'),'sk/recompute9_wide','sk/recompute9'],
                   stdout=out,stderr=subprocess.STDOUT,check=True)
files=sorted(Path('sk/recompute9_two').glob('t*.txt'))
assert len(files)==200
env=dict(os.environ,ROOTORDER='1',FASTCPL='1',CACHECPL='1',LEGACYFILL='1',FASTLB='1')
for name in ['SPLIT','MAXGATES','CPLSLACK']:env.pop(name,None)
records=[]
for fn in files:
    log=base/(fn.stem+'.log')
    if not log.exists() or not re.search(r'^RESULT ',log.read_text(),re.M):
        with log.open('w') as out:
            out.write(f'RUN skeleton={fn} K=31 node_limit=0 seconds=1800 nice=19 address_space=2800000000 ROOTORDER=1 assumptions=A4,A6\n');out.flush()
            start=time.monotonic()
            try:
                subprocess.run(['nice','-n','19','./dagx_lb',str(fn),'31','1','0'],
                               env=env,stdout=out,stderr=subprocess.STDOUT,timeout=1800,check=True)
            except subprocess.TimeoutExpired:out.write('RESULT TIMEOUT seconds=1800 (unknown; not exhaustive)\n')
            except subprocess.CalledProcessError as e:out.write(f'RESULT ERROR returncode={e.returncode} (unknown)\n')
            out.write(f'RUN_END elapsed={time.monotonic()-start:.3f}\n')
    txt=log.read_text();status=re.findall(r'^RESULT (\w+)',txt,re.M)[-1]
    m=re.search(r'^RESULT .*calls=(\d+).*time=([\d.]+)s',txt,re.M)
    records.append(dict(file=str(fn),status=status,log=str(log),calls=int(m[1]) if m else None,seconds=float(m[2]) if m else None))
    summary=dict(done=len(records),total=len(files),counts=dict(Counter(r['status'] for r in records)),
                 engine_sha256=hashlib.sha256(Path('dagx_lb').read_bytes()).hexdigest(),
                 child_peak_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss,records=records)
    (base/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps(records[-1]),flush=True)
    if status=='FOUND':
        subprocess.run(['nice','-n','19','python3','src/verify_log.py',str(log),'round0325_new_'+fn.stem],check=True)
        raise SystemExit('Candidate produced; inspect strict judge logs.')
print('NEW PASS COMPLETE',flush=True)
