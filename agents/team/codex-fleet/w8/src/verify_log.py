#!/usr/bin/env python3
"""Extract every route, convert out to mem, and run the strict judge."""
from pathlib import Path
import re
import subprocess
import sys

judge='/path/to/repo/shared/judge.py'
log=Path(sys.argv[1])
prefix=sys.argv[2]
if log.suffix=='.s':
    solutions=['\n'.join(l for l in log.read_text().splitlines()
                         if l.strip() and not l.lstrip().startswith('#'))]
else:
    solutions=re.findall(r'SOLUTION[^\n]*\n(.*?)\nEND',log.read_text(),re.S)
for ix,solution in enumerate(solutions):
    suffix='' if len(solutions)==1 else '_%d'%ix
    stem=prefix+suffix
    outf=Path('programs/'+stem+'.s')
    outf.write_text('# n=5 iset=I1 model=out source=w2_verification origin='+str(log)+'\n'+solution+'\n')
    def reg(r):
        return 'S'+str(int(r[1:])+(0 if r[0]=='P' else 5))
    mem=['# n=5 iset=I1 model=mem source=w2_verification origin='+str(log),
         *['mov S%d, P%d'%(j,j) for j in range(5)]]
    for line in solution.splitlines():
        op,args=line.split(None,1)
        a,b=[s.strip() for s in args.split(',')]
        if op=='out':
            mem.append('mov P%s, %s'%(a,reg(b)))
        else:
            mem.append('%s %s, %s'%(op,reg(a),reg(b)))
    memf=Path('programs/'+stem+'_mem.s')
    memf.write_text('\n'.join(mem)+'\n')
    for path,model in ((outf,'out'),(memf,'mem')):
        result=subprocess.run(['python3',judge,str(path),'--strict','--model',model],
                              capture_output=True,text=True)
        dst=Path('logs/'+path.stem+'.judge.log')
        dst.write_text(result.stdout+result.stderr)
        print(result.stdout+result.stderr,end='',flush=True)
        if result.returncode:
            print('REJECTED',path,flush=True)
