"""Run one bounded single-threaded job, with a 2800 MiB address-space limit."""
import json
import os
from pathlib import Path
import resource
import subprocess
import sys
import time

seconds, name, *command = sys.argv[1:]
resource.setrlimit(resource.RLIMIT_AS,(2800*1024*1024,2800*1024*1024))
os.environ.update(OMP_NUM_THREADS='1',OPENBLAS_NUM_THREADS='1',PYTHONDONTWRITEBYTECODE='1')
start=time.monotonic()
log=Path('round4/logs',name+'.log')
with log.open('w') as f:
    p=subprocess.run(['timeout','--signal=TERM','--kill-after=3s',seconds+'s',
                      'nice','-n','19',*command],stdout=f,stderr=subprocess.STDOUT)
row={'name':name,'command':command,'wall_limit':float(seconds),'exit':p.returncode,
     'seconds':time.monotonic()-start,'log':str(log),'affinity':sorted(os.sched_getaffinity(0))}
Path('round4/artifacts',name+'.json').write_text(json.dumps(row,indent=2))
print(json.dumps(row),flush=True)
