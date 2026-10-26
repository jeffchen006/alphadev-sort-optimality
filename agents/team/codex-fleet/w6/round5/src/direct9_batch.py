from pathlib import Path
import subprocess,json
commands=[("macro9one31",["./dagx","round5/artifacts/macro9one.skel","31","1"])]
subprocess.run(["nice","-n","19","python3","-B","round5/src/skeleton.py"],check=True)
for name,cmd in commands:
 subprocess.run(["nice","-n","19","python3","-B","round5/src/run.py","300",name,*cmd],check=True)
