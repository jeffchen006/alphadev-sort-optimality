#!/usr/bin/env python3
import pathlib,re,sys
src=pathlib.Path(sys.argv[1]);dest=pathlib.Path(sys.argv[2]);mapping={'P'+str(i):'S'+str(i) for i in range(5)}
lines=['# n=5 model=mem iset=I1 source=w4-out-to-mem']+[f'mov S{i}, P{i}' for i in range(5)]
for line in src.read_text().splitlines():
 line=line.split('#')[0].strip()
 if not line:continue
 op,ab=line.split(None,1);a,b=map(str.strip,ab.split(','))
 def reg(r):
  if r not in mapping:mapping[r]='S'+str(len(mapping))
  return mapping[r]
 if op=='out':lines.append(f'mov P{a}, {reg(b)}')
 else:lines.append(f'{op} {reg(a)}, {reg(b)}')
dest.write_text('\n'.join(lines)+'\n')
