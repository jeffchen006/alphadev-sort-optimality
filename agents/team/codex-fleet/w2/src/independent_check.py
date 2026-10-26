#!/usr/bin/env python3
"""Independent concrete simulator. This check does not replace the judge."""
import itertools
from pathlib import Path
import sys

def parse(path):
    result=[]
    for line in Path(path).read_text().splitlines():
        line=line.split('#',1)[0].strip()
        if not line:
            continue
        op,args=line.split(None,1)
        result.append((op,*[x.strip() for x in args.split(',')]))
    return result

def orders():
    for p in itertools.product(range(5),repeat=5):
        if set(p)==set(range(max(p)+1)):
            yield p

for fn in sys.argv[1:]:
    code=parse(fn)
    scratches={r for op,a,b in code for r in (a,b) if r.startswith('S')}
    count=0
    for values in orders():
        expected=tuple(sorted(values))
        for garbage in (-2147483648,0,2147483647):
            for initial_flags in (-1,0,1):
                regs={r:garbage for r in scratches}
                regs.update({'P%d'%i:x for i,x in enumerate(values)})
                flags=initial_flags
                outputs={}
                for op,a,b in code:
                    if op=='out':
                        outputs[int(a)]=regs[b]
                    elif op=='mov':
                        regs[a]=regs[b]
                    elif op=='cmp':
                        flags=(regs[a]>regs[b])-(regs[a]<regs[b])
                    elif op in ('cmovl','cmovle','cmovg','cmovge'):
                        take={'cmovl':flags<0,'cmovle':flags<=0,
                              'cmovg':flags>0,'cmovge':flags>=0}[op]
                        if take:
                            regs[a]=regs[b]
                    else:
                        raise ValueError(op)
                got=tuple(outputs.get(i,regs['P%d'%i]) for i in range(5))
                if got!=expected:
                    raise SystemExit('FAIL %s input=%r garbage=%r flags=%r got=%r'%
                                     (fn,values,garbage,initial_flags,got))
                count+=1
    print('Concrete check OK',fn,'cases=',count,flush=True)
