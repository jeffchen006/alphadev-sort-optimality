#!/usr/bin/env python3
import json,os,re,resource,subprocess,time
from pathlib import Path
resource.setrlimit(resource.RLIMIT_AS,(2800000000,2800000000))
folder=Path('logs/recompute9_priority/priority_deeper');folder.mkdir(exist_ok=True)
env=dict(os.environ,ROOTORDER='1',FASTCPL='1',CACHECPL='1',LEGACYFILL='1',FASTLB='1')
env.pop('SPLIT',None)
records=[]
for case in ['r000111','r000037']:
 log=folder/(case+'.log');start=time.monotonic()
 with log.open('w') as f:
  f.write(f'RUN skeleton=sk/recompute9_wide/{case}.txt node_limit=120000000 seconds=1800 nice=19 address_space=2800000000 ROOTORDER=1\n');f.flush()
  try:subprocess.run(['nice','-n','19','./dagx_lb',f'sk/recompute9_wide/{case}.txt','31','1','120000000'],env=env,stdout=f,stderr=subprocess.STDOUT,timeout=1800,check=True)
  except subprocess.TimeoutExpired:f.write('RESULT TIMEOUT seconds=1800 (unknown; not exhaustive)\n')
  except subprocess.CalledProcessError as e:f.write(f'RESULT ERROR returncode={e.returncode} (unknown)\n')
  f.write(f'RUN_END elapsed={time.monotonic()-start:.3f}\n')
 text=log.read_text();status=re.findall(r'^RESULT (\w+)',text,re.M)[-1]
 if status=='FOUND':
  verify=subprocess.run(['nice','-n','19','python3','src/verify_log.py',str(log),'recompute9_deeper_'+case],capture_output=True,text=True)
  with log.open('a') as f:f.write(verify.stdout+verify.stderr)
  print(verify.stdout+verify.stderr,flush=True)
 records.append(dict(case=case,status=status,log=str(log),elapsed=round(time.monotonic()-start,2)))
 (folder/'summary.json').write_text(json.dumps(dict(records=records,child_peak_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss),indent=2)+'\n')
 print(json.dumps(records[-1]),flush=True)
 if status=='FOUND':break
print('DEEPER PASS COMPLETE',flush=True)
