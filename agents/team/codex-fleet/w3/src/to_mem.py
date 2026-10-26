from pathlib import Path
import re,sys
src=Path(sys.argv[1]);dst=Path(sys.argv[2])
lines=['# n=5 R=200 iset=I1 model=mem source=w3_out_conversion']+[f'mov S{i}, P{i}' for i in range(5)]
def reg(r):return 'S'+str(int(r[1:])+(0 if r[0]=='P' else 5))
for line in src.read_text().splitlines():
 if not line.strip() or line.startswith('#'):continue
 op,rest=line.split(None,1);a,b=[s.strip() for s in rest.split(',')]
 if op=='out':lines.append(f'mov P{a}, {reg(b)}')
 else:lines.append(f'{op} {reg(a)}, {reg(b)}')
dst.write_text('\n'.join(lines)+'\n')
