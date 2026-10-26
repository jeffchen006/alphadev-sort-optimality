"""Independent full-case scoring and output snapshots for failing search states."""
import argparse,itertools,json,re,sys,subprocess
from pathlib import Path
from compose import PREFIX,ROOT
CASES=[w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(max(w)+1))]
GOALS=list(zip(*(sorted(w) for w in CASES)))
def evaluate(body,stem):
    p=[];registers={f'P{i}' for i in range(5)}
    for line in body.splitlines():
        line=line.split('#')[0].replace(',',' ').split()
        if not line or line[0]=='out':continue
        op,d,s=line;p.append((op,d,s));registers|={d,s}
    r={reg:tuple(w[int(reg[1:])] if reg[0]=='P' else None for w in CASES) for reg in registers}
    flag=(None,)*541;best=[(9999,None,None,None) for j in range(5)]
    def consider(t,reg):
        for j,goal in enumerate(GOALS):
            error=sum(a!=b for a,b in zip(r[reg],goal))
            if error<best[j][0]:best[j]=(error,t,reg,r[reg])
    for reg in sorted(registers):consider(-1,reg)
    for t,(op,d,s) in enumerate(p):
        a,b=r[d],r[s]
        if op=='cmp':flag=tuple(0 if d==s else None if x is None or y is None else (x>y)-(x<y) for x,y in zip(a,b))
        elif op=='mov':r[d]=b
        else:
            def choose(x,y,f):
                if f is None:return x if x==y else None
                yes=f<0 if op=='cmovl' else f<=0 if op=='cmovle' else f>0 if op=='cmovg' else f>=0
                return y if yes else x
            r[d]=tuple(choose(x,y,f) for x,y,f in zip(a,b,flag))
        if op!='cmp':consider(t,d)
    failed=[w for i,w in enumerate(CASES) if any(best[j][3][i]!=GOALS[j][i] for j in range(5))]
    lines=['# n=5 model=out iset=I1 source=w9-near weak_fail='+str(len(failed))]
    for t in range(-1,len(p)):
        if t>=0:op,d,s=p[t];lines.append(f'{op} {d}, {s}')
        lines.extend(f'out {j}, {b[2]}' for j,b in enumerate(best) if b[1]==t)
    path=Path('candidates/'+stem+'_out.s');path.write_text('\n'.join(lines)+'\n')
    result={'path':str(path),'core':len(p),'cmp':sum(op=='cmp' for op,d,s in p),'errors':[b[0] for b in best],'failed_weak_orders':len(failed),'failed_cases':failed}
    proc=subprocess.run(['nice','-n','10','python3',str(ROOT/'shared/judge.py'),str(path),'--strict','--model','out'],capture_output=True,text=True)
    log=Path('logs/'+stem+'_judge.log');log.write_text(proc.stdout+proc.stderr);result['judge']=proc.stdout;result['log']=str(log)
    Path('artifacts/'+stem+'.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)
    return result
def main():
    for tag in sys.argv[1:]:
        near=Path('candidates/'+tag+'_near.txt')
        if not near.exists():continue
        if tag.startswith('residual'):
            mapping={f'P{i}':f'P{i}' for i in range(5)};mapping['P3']='S4';mapping.update({f'S{i}':f'S{i+5}' for i in range(20)});mapping.update({'S0':'P3','S1':'S0','S2':'S3'})
            suffix=re.sub(r'[PS]\d+',lambda m:mapping[m[0]],near.read_text());body=PREFIX+suffix
        elif tag.startswith('m16'):
            mapping={f'P{i}':f'P{i}' for i in range(5)};mapping['P3']='S4';mapping.update({f'S{i}':f'S{i+5}' for i in range(20)})
            suffix=re.sub(r'[PS]\d+',lambda m:mapping[m[0]],near.read_text());body=PREFIX+suffix
        else:body=Path('candidates/'+tag+'_prefix.s').read_text()+near.read_text()
        evaluate(body,tag+'_near31')
if __name__=='__main__':main()
