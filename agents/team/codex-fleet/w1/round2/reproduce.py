#!/usr/bin/env python3
# Run from w1. Sequential CPU jobs. Each child runs at nice 19.
from pathlib import Path
import subprocess,sys
HERE=Path(__file__).resolve().parent
BASE=HERE.parent
JUDGE='/path/to/repo/shared/judge.py'
def run(args,log=None):
 print('+',' '.join(args),flush=True)
 if log:
  with open(BASE/log,'w') as out,open(BASE/(log+'.err'),'w') as err:
   subprocess.run(['nice','-n','19',*args],cwd=BASE,stdout=out,stderr=err,check=True)
 else:subprocess.run(['nice','-n','19',*args],cwd=BASE,check=True)
for src,out,flags in [('omit.cpp','omit',[]),('extend.cpp','extend',[]),('route.cpp','route',[]),('route.cpp','route_strict',['-DPERMS']),('extra.cpp','extra_fast',[])]:
 run(['g++','-O3','-std=c++17',*flags,'round2/'+src,'-o','round2/'+out])
run(['./round2/omit','6'],'round2/omit6.log')
run(['./round2/omit','7'],'round2/omit7.log')
run(['./round2/omit','8'],'round2/omit8.log')
run(['./round2/extend','8','0','14904','1'],'round2/extend1.log')
run(['./round2/extend','8','0','14904','2'],'round2/extend2.log')
run(['./round2/extend','7','0','14904','1'],'round2/extend7.log')
run(['python3','round2/prepare.py'],'round2/prepare.log')
run(['./round2/route','23'],'round2/route_fast23.log')
run(['./round2/route','27'],'round2/route_fast27.log')
run(['./round2/route_strict','23'],'round2/route_perms23.log')
run(['python3','round2/exact_check.py'],'round2/exact_check.log')
run(['python3','round2/crossroute.py'],'round2/crossroute.log')
run(['python3','round2/compare_extensions.py'],'round2/compare_extensions.log')
run(['python3','round2/check_class_targets.py'],'round2/check_class_targets.log')
run(['./round2/extra_fast','0','33'],'round2/extra_fast.log')
run(['./round2/route','27','57','56'],'round2/emit33.log')
run(['python3','round2/audit.py','round2/witness_out.s'],'round2/audit33.log')
run(['python3',JUDGE,'round2/witness_out.s','--strict','--model','out'],'round2/judge33_out.log')
run(['python3',JUDGE,'round2/witness_mem.s','--strict','--model','mem'],'round2/judge33_mem.log')
print('Round 2 reproduction complete.',flush=True)
