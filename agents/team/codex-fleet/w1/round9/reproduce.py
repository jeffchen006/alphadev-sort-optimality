"""Reproduce this round only. Earlier ledgers supply immutable inputs."""
import os,resource,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
os.chdir(HERE.parent);os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
jobs=[
 ('prepare',[sys.executable,'round9/prepare.py']),
 ('c9_exclusive',[sys.executable,'round9/batch.py','--kind','c9','--mode','exclusive','--unbounded','--cpu','30','--stem','c9_exclusive']),
 ('c9_control',[sys.executable,'round9/batch.py','--kind','c9','--mode','exclusive','--unbounded','--control','--cpu','10','--stem','c9_control']),
 ('c8_control',[sys.executable,'round9/batch.py','--kind','c8','--mode','schedule','--tail','6','--control','--end','8','--cpu','10','--stem','c8_control']),
 ('c9_tail6',[sys.executable,'round9/batch.py','--kind','c9','--mode','tail','--tail','6','--unbounded','--cpu','15','--stem','c9_tail6']),
 ('c8_schedule6',[sys.executable,'round9/batch.py','--kind','c8','--mode','schedule','--tail','6','--cpu','10','--stem','c8_schedule6']),
 ('post',[sys.executable,'round9/post.py']),
 ('finish',[sys.executable,'round9/finish.py']),
]
for stem,cmd in jobs:
 print('RUN',stem,flush=True)
 with (HERE/(stem+'_reproduce.log')).open('w') as f:
  subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,check=True)
print('DONE',flush=True)
