"""Attach a verified sort2/sort3 preparation to a sorted-input merge."""
import argparse,re,subprocess,json
from pathlib import Path
ROOT=Path('/path/to/repo')
PREFIX='''cmp P0, P1
mov S0, P0
cmovg P0, P1
cmovg P1, S0
mov S3, P4
cmp P4, P3
cmovge S3, P3
cmovl P4, P3
mov S4, P4
cmp S4, P2
cmovge S4, P2
cmovl P4, P2
cmp P2, S3
cmovle S4, S3
cmovg P2, S3
'''
def main():
    ap=argparse.ArgumentParser();ap.add_argument('fragment');ap.add_argument('stem');ap.add_argument('--dup',type=int,default=0);ap.add_argument('--residual',action='store_true');ap.add_argument('--copymin',action='store_true');a=ap.parse_args()
    mapping={f'P{i}':f'P{i}' for i in range(5)};mapping['P3']='S4'
    mapping.update({f'S{i}':f'S{i+5}' for i in range(20)})
    if a.residual:
        mapping.update({'S0':'P3','S1':'S0','S2':'S3'})
    body=PREFIX
    if a.copymin:body+='cmovle S3, P2\n'
    if a.dup:body+=f'mov S5, {mapping["P"+str(a.dup-1)]}\n'
    for line in Path(a.fragment).read_text().splitlines():
        if line.startswith('#'):continue
        body+=re.sub(r'[PS]\d+',lambda m:mapping[m[0]],line)+'\n'
    out=Path('candidates/'+a.stem+'_out.s');out.write_text('# n=5 model=out iset=I1 source=w9-merge\n'+body)
    # In the memory form, each virtual register gets a distinct physical register.
    names={f'P{i}':f'S{i}' for i in range(5)}
    for token in re.findall(r'[PS]\d+',body):
        if token not in names:names[token]='S'+str(len(names))
    mem=['# n=5 model=mem iset=I1 source=w9-merge']+[f'mov S{i}, P{i}' for i in range(5)]
    for line in body.splitlines():
        tokens=line.replace(',',' ').split()
        if not tokens:continue
        if tokens[0]=='out':mem.append(f'mov P{tokens[1]}, {names[tokens[2]]}')
        else:mem.append(f'{tokens[0]} {names[tokens[1]]}, {names[tokens[2]]}')
    mpath=Path('candidates/'+a.stem+'_mem.s');mpath.write_text('\n'.join(mem)+'\n')
    records=[]
    for model,path in [('out',out),('mem',mpath)]:
        p=subprocess.run(['nice','-n','10','python3',str(ROOT/'shared/judge.py'),str(path),'--strict','--model',model],capture_output=True,text=True)
        log=Path('logs/'+a.stem+'_'+model+'_judge.log');log.write_text(p.stdout+p.stderr);print(p.stdout,p.stderr,flush=True)
        record={'path':str(path.resolve()),'model':model,'log':str(log),'pass':'PASS' in p.stdout,'returncode':p.returncode};records.append(record)
        if record['pass']:Path('verified/'+path.name).write_bytes(path.read_bytes())
    Path('artifacts/'+a.stem+'_judges.json').write_text(json.dumps(records,indent=2)+'\n')
if __name__=='__main__':main()
