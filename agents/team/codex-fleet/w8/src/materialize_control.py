#!/usr/bin/env python3
from pathlib import Path
import re, subprocess
log=Path('logs/router_control32.log').read_text()
body=log.split('\nSOLUTION ',1)[1].split('\n',1)[1].split('\nEND')[0]
out=Path('programs/router_control32.s')
out.write_text('# n=5 R=40 iset=I1 model=out source=w8_router_control\n'+body+'\n')
def rename(m):
    t=m.group();return 'S'+str(int(t[1:])+(5 if t[0]=='S' else 0))
lines=['# n=5 R=40 iset=I1 model=mem source=w8_router_control']
lines += [f'mov S{i}, P{i}' for i in range(5)]
for line in body.splitlines():
    if line.startswith('out '):
        j,r=line[4:].split(', ');lines.append('mov P'+j+', '+rename(re.match(r'[PS]\d+',r)))
    else:lines.append(re.sub(r'[PS]\d+',rename,line))
mem=Path('programs/router_control32_mem.s');mem.write_text('\n'.join(lines)+'\n')
for file,model in [(Path('programs/known32.s'),'out'),(out,'out'),(mem,'mem')]:
    r=subprocess.run(['nice','-n','10','python3','/path/to/repo/shared/judge.py',str(file),'--strict','--model',model],capture_output=True,text=True)
    Path('logs',file.stem+'.judge.log').write_text(r.stdout+r.stderr)
    print(r.stdout+r.stderr,end='',flush=True)
