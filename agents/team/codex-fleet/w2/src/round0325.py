#!/usr/bin/env python3
"""One-job retry driver. Completed logs are retained, never overwritten."""
import csv, hashlib, json, os, re, resource, subprocess, time
from collections import Counter
from pathlib import Path

resource.setrlimit(resource.RLIMIT_AS, (2800000000, 2800000000))
base = Path('logs/round0325')
base.mkdir(exist_ok=True)
env = dict(os.environ, ROOTORDER='1', FASTCPL='1', CACHECPL='1',
           LEGACYFILL='1', FASTLB='1')
for name in ['SPLIT', 'MAXGATES', 'CPLSLACK']:
    env.pop(name, None)
rows = list(csv.DictReader(Path('logs/recompute9_priority/unknown_priority.tsv').open(), delimiter='\t'))
records = []
for row in rows:
    previous = Path(row['log'])
    reuse = int(row['node_limit']) >= 120000000
    log = previous if reuse else base / (Path(row['file']).stem + '.log')
    if not log.exists() or not re.search(r'^RESULT ', log.read_text(), re.M):
        with log.open('w') as f:
            f.write(f'RUN skeleton=sk/recompute9_wide/{row["file"]} node_limit=120000000 seconds=1800 nice=19 address_space=2800000000 ROOTORDER=1 assumptions=A4,A6\n')
            f.flush()
            start = time.monotonic()
            try:
                subprocess.run(['nice','-n','19','./dagx_lb',
                                'sk/recompute9_wide/'+row['file'],'31','1','120000000'],
                               env=env, stdout=f, stderr=subprocess.STDOUT,
                               timeout=1800, check=True)
            except subprocess.TimeoutExpired:
                f.write('RESULT TIMEOUT (unknown)\n')
            except subprocess.CalledProcessError as e:
                f.write(f'RESULT ERROR returncode={e.returncode} (unknown)\n')
            f.write(f'RUN_END elapsed={time.monotonic()-start:.3f}\n')
    txt = log.read_text()
    status = re.findall(r'^RESULT (\w+)', txt, re.M)[-1]
    m = re.search(r'^RESULT .*calls=(\d+).*time=([\d.]+)s', txt, re.M)
    records.append(dict(file=row['file'], status=status, log=str(log), reused=reuse,
                        calls=int(m[1]) if m else None, seconds=float(m[2]) if m else None))
    summary = dict(done=len(records), total=len(rows), counts=dict(Counter(r['status'] for r in records)),
                   newly_exhausted=sum(r['status']=='NONE' and not r['reused'] for r in records),
                   child_peak_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss,
                   engine_sha256=hashlib.sha256(Path('dagx_lb').read_bytes()).hexdigest(), records=records)
    (base/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps(records[-1]), flush=True)
    if status == 'FOUND':
        subprocess.run(['nice','-n','19','python3','src/verify_log.py',str(log),
                        'round0325_'+Path(row['file']).stem], check=True)
        raise SystemExit('Candidate produced; inspect strict judge logs.')
print('RETRY COMPLETE', flush=True)
