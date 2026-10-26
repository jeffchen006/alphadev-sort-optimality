"""Bounded full-cone probes, followed by sequential validation."""
import json,os,re,resource,subprocess,sys,time
from pathlib import Path
HERE=Path(__file__).resolve().parent;os.chdir(HERE.parent)
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
for i in [0,10,15]:
 stem=f'all_r2_allcases_b{i}_{i+1}';cmd=[sys.executable,'round7/batch.py','--mode','all','--start',str(i),'--end',str(i+1),'--all-cases','--cpu','120']
 print('RUN',stem,flush=True);started=time.time()
 with (HERE/(stem+'.log')).open('w') as f:p=subprocess.run(['/usr/bin/time','-v','-o',str(HERE/(stem+'.resources'))]+cmd,stdout=f,stderr=subprocess.STDOUT)
 if p.returncode:
  path=HERE/(stem+'.json')
  resources=(HERE/(stem+'.resources')).read_text()
  cpu=sum(float(re.search(label+r':\s*([0-9.]+)',resources).group(1)) for label in [r'User time \(seconds\)',r'System time \(seconds\)'])
  rss=int(re.search(r'Maximum resident set size \(kbytes\):\s*(\d+)',resources).group(1))
  reason='std::bad_alloc under the 2800 MiB address-space limit; no final solver result' if 'std::bad_alloc' in (HERE/(stem+'.log')).read_text() else 'Probe exited without a solver result'
  path.write_text(json.dumps([dict(base=i,status='UNKNOWN',cpu=cpu,wall=time.time()-started,exit_code=p.returncode,reason=reason,maxrss_kib=rss)],indent=2)+'\n')
 print('DONE',stem,'exit',p.returncode,flush=True)
print('RUN VALIDATION',flush=True)
subprocess.run([sys.executable,'round7/validate.py'],check=True)
