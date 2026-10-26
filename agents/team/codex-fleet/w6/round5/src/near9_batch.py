from pathlib import Path
import subprocess,json,sys
base=["python3","-B","round3/src/satrep.py","round5/candidates/fresh31_near.s"]
jobs=[("near9_typed6",180,["--rank","--typed","--fixed-dest","--changes","6","--maxcmp","9","--fresh","1","--change-cmp","--random-seed","5231961"]),
("near9_full4",180,["--rank","--changes","4","--maxcmp","10","--fresh","1","--change-cmp","--random-seed","5231941"]),
("near9_suffix15",180,["--rank","--typed","--changes","0","--prefix","16","--maxcmp","9","--fresh","1","--random-seed","5231915"])]
for name,limit,options in jobs:
 output="round5/candidates/"+name+".s"
 subprocess.run(["nice","-n","19","python3","-B","round5/src/run.py",str(limit),name,*base,output,*options],check=True)
 p=Path(output)
 if p.exists():
  subprocess.run(["nice","-n","19","python3","-B","round5/src/verify.py",str(p)],check=True)
  if Path("round5/artifacts/FOUND").exists():break
