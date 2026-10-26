from pathlib import Path
import sys

p=Path(sys.argv[1]);dest=Path(sys.argv[2])
regs={f'P{i}':i for i in range(5)};ins=[]
for line in p.read_text().splitlines():
    line=line.split('#')[0].strip()
    if not line or line.startswith('out '):continue
    op,a,b=line.replace(',','').split()
    for r in a,b:
        if r not in regs:regs[r]=len(regs)
    ins.append((op,regs[a],regs[b]))
dest.write_text(f'{len(regs)} {len(ins)}\n'+''.join(f'{op} {a} {b}\n' for op,a,b in ins))
print(f'{p}: k={len(ins)} registers={len(regs)} -> {dest}')
