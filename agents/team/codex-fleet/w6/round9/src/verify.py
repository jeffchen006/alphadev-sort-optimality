"""Retain only candidates that pass both strict judges."""
from pathlib import Path
import hashlib,json,subprocess,sys
HERE=Path(__file__).resolve().parents[2];ROOT=HERE.parents[3]
source=Path(sys.argv[1]);name=sys.argv[2] if len(sys.argv)>2 else source.stem
registers={f'P{i}':f'S{i}' for i in range(5)};p=[];k=0
for line in source.read_text().splitlines():
    s=line.split('#')[0].strip()
    if not s:continue
    op,d,v=s.replace(',',' ').split()
    if op=='out':p.append(f'mov P{int(d)}, {registers[v]}');continue
    k+=1
    for r in (d,v):
        if r not in registers:registers[r]=f'S{len(registers)}'
    p.append(f'{op} {registers[d]}, {registers[v]}')
row={'source':str(source),'k':k,'sha256':hashlib.sha256(source.read_bytes()).hexdigest()}
for model,path in [('out',source),('mem',Path('round9/verified_mem',name+'.s'))]:
    if model=='mem':path.write_text(f'# n=5 iset=I1 model=mem source=w6-round9 k={k}\n'+'\n'.join([f'mov S{i}, P{i}' for i in range(5)]+p)+'\n')
    log=Path('round9/logs',name+'_'+model+'_judge.log')
    with log.open('w') as f:r=subprocess.run(['nice','-n','19','python3','-B',str(ROOT/'shared/judge.py'),str(path),'--strict','--model',model],stdout=f,stderr=subprocess.STDOUT)
    ok=r.returncode==0 and 'PASS ' in log.read_text()
    row[model]={'pass':ok,'file':str(path),'log':str(log)}
    print(log.read_text(),end='',flush=True)
    if not ok:break
    if model=='out':Path('round9/verified',name+'.s').write_bytes(source.read_bytes())
Path('round9/artifacts',name+'_judge.json').write_text(json.dumps(row,indent=2))
if row.get('out',{}).get('pass') and row.get('mem',{}).get('pass') and k<=31:
    results=Path('RESULTS.md');old=results.read_text();line=f'FOUND k={k} out=round9/verified/{name}.s mem=round9/verified_mem/{name}.s strict out+mem PASS\n'
    results.write_text(line+old);Path('round9/artifacts/FOUND').write_text(line)
