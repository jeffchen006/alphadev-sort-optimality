"""Independent bounded SAT route search for one fixed operand skeleton.

SAT is Boolean satisfiability. The base encoding uses one value node per data
instruction and tracks destructive register writes. This wrapper fixes the
comparison columns and requires every produced column to be fully defined.
Negative results apply only to this initialized-value representation.
"""
import argparse,gc,hashlib,itertools,json,os,resource,subprocess,time
from pathlib import Path
from column_sat_base import Encoding,PROJECT
from audit import recipe
from run import verify

def main():
    ap=argparse.ArgumentParser();ap.add_argument('file');ap.add_argument('--k',type=int,default=31);ap.add_argument('--seconds',type=int,default=60);ap.add_argument('--cases',type=int,default=24);ap.add_argument('--seed',type=int,default=13);ap.add_argument('--tag',required=True);ap.add_argument('--fixed');a=ap.parse_args()
    if os.nice(0)<10:os.nice(10-os.nice(0))
    resource.setrlimit(resource.RLIMIT_AS,(4*1024**3,4*1024**3))
    from random import Random
    types=list(itertools.permutations(range(5)));indices=list(range(120))
    Random(a.seed).shuffle(indices);indices=sorted(indices[:a.cases]);types=[types[t] for t in indices]
    _,columns=recipe(a.file);c=len(columns)//2
    cols=[[row[t] for t in indices] for row in columns]
    flags=[[(u>v)-(u<v) for u,v in zip(cols[2*j],cols[2*j+1])] for j in range(c)]
    start=time.monotonic();enc=Encoding(5,a.k,c,types,'full',flags=flags,first_pair=True,origin=True)
    for g in range(enc.m):
        for t in range(len(types)):enc.cl(*enc.unequal_guard(enc.val[5+g][t],5))
    for j in range(c):
        for side in range(2):
            for x,pick in enumerate(enc.cmp[j][side]):
                for t,p in enumerate(types):enc.equal_value(enc.val[x][t],p.index(cols[2*j+side][t]),-pick)
    if a.fixed:enc.fix_program(Path(a.fixed).read_text())
    tag=Path('logs')/a.tag;cnf=tag.with_suffix('.cnf');enc.dimacs(cnf)
    record=dict(file=a.file,k=a.k,c=c,cases=len(types),case_indices=indices,variables=enc.nv,clauses=len(enc.cs),build_seconds=time.monotonic()-start,cnf_sha256=hashlib.sha256(cnf.read_bytes()).hexdigest())
    print(json.dumps(dict(step='built',**record)),flush=True)
    enc.cs.clear();gc.collect()
    solver=tag.with_suffix('.solver')
    with solver.open('w') as f:
        try:r=subprocess.run([str(PROJECT/'bin/kissat'),'--time='+str(a.seconds),str(cnf)],stdout=f,stderr=subprocess.STDOUT,timeout=a.seconds+10);record['returncode']=r.returncode
        except subprocess.TimeoutExpired:record['returncode']=124
    text=solver.read_text();record['status']='UNKNOWN';model=[]
    for line in text.splitlines():
        if line.startswith('s '):record['status']=line[2:].strip()
        if line.startswith('v '):model.extend(int(x) for x in line[2:].split() if int(x))
    if record['status']=='SATISFIABLE':
        yes={x for x in model if x>0}
        with cnf.open() as f:
            next(f)
            for line in f:
                cl=map(int,line.split()[:-1]);assert any((x in yes) if x>0 else (-x not in yes) for x in cl)
        record['assignment_checked']=True
        lines=[l for l in enc.decode(model).splitlines() if l and not l.startswith('#')]
        record['verification']=verify(lines,a.tag)
    record['elapsed_seconds']=time.monotonic()-start
    tag.with_suffix('.json').write_text(json.dumps(record,indent=2)+'\n');print(json.dumps(record),flush=True)

if __name__=='__main__':main()
