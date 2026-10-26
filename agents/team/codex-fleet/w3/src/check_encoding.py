import sys,itertools,time
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent))
from ssa_sat import *
src=Path('/path/to/repo/programs/found/upper_sort5_I0_L42_mem.s').read_text().splitlines()
regs={f'S{4+i}':f'P{i}' for i in range(5)}
prog=[]
for line in src:
 if line.startswith('#'):continue
 op,rest=line.split(None,1);d,s=[x.strip() for x in rest.split(',')]
 if op=='mov' and d in regs and s.startswith('P'):continue
 if d.startswith('P'):
  prog.append(f'out {d[1:]}, {regs.get(s,s)}');continue
 prog.append(f'{op} {regs.get(d,d)}, {regs.get(s,s)}')
assert prog[0]=='mov S3, P4'
assert prog[1]=='cmp P3, S3'
prog[:2]=['cmp P3, P4','mov S3, P4']
Path('programs/known32.s').write_text('# n=5 R=20 iset=I0 model=out source=upper_encoding_control\n'+'\n'.join(prog)+'\n')
assert all(simulate(prog,ty)[0] for ty in P)
F=list(map(list,zip(*(simulate(prog,ty)[1] for ty in P))))
e=Enc(F,P,23,fixed=prog)
print('validation vars',e.nv,'clauses',len(e.cs),flush=True)
st,model=solve(e,'logs/encoding_control',60)
print('validation',st,flush=True)
if st=='SATISFIABLE':
 out=e.decode(model);Path('programs/control_decoded.s').write_text('\n'.join(out)+'\n');assert all(simulate(out,ty)[0] for ty in P)
