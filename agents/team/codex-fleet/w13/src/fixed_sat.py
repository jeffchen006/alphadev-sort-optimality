"""Direct SAT routing with fixed strict comparison columns.

Every data instruction writes a fully defined input selection. A conditional
move destroys its old destination. A move allocates a fresh register. Output
snapshots are free. The formula leaves all intermediate selections free.
"""
import argparse,gc,hashlib,itertools,json,os,resource,subprocess,time
from pathlib import Path
from column_sat_base import Encoding,PROJECT
from audit import recipe
from run import verify

class FixedEncoding(Encoding):
    def __init__(self,k,types,cols,history=True):
        self.nv=0;self.cs=[]
        n=5;c=len(cols)//2;m=k-c;nt=len(types);nb=3
        self.n,self.k,self.c,self.types=n,k,c,types
        self.m,self.nb,self.origin=m,nb,True
        self.mode='full';self.partial=[]
        self.mov=self.vec(m)
        self.dst=[self.vec(n+g+1) for g in range(m)]
        self.src=[self.vec(n+g+1) for g in range(m)]
        self.blk=[self.vec(c) for _ in range(m)]
        self.high=self.vec(m);self.inclusive=self.vec(m)
        self.cmp=[[self.vec(n+m) for _ in range(2)] for _ in range(c)]
        self.out=[self.vec(n+m) for _ in range(n)]
        self.val=[[[bool(x>>b&1) for b in range(nb)] for _ in types] for x in range(n)]
        self.val += [[self.vec(nb) for _ in types] for _ in range(m)]
        self.top=[bool(n>>b&1) for b in range(nb)]
        flags=[[(a>b)-(a<b) for a,b in zip(cols[2*j],cols[2*j+1])] for j in range(c)]
        assert all(f for row in flags for f in row),'This encoder uses strict non-equal comparisons.'
        self.fl=[[[f==ff for ff in (-1,0,1)] for f in row] for row in flags]
        for g in range(m):
            for picks in (self.dst[g],self.src[g],self.blk[g]):self.eo(picks)
            self.cl(-self.inclusive[g]);self.cl(-self.src[g][-1])
            # A fresh destination occurs exactly for a copy.
            self.eq(self.mov[g],self.dst[g][-1])
            if g:
                for b in range(c):
                    for earlier in range(b):self.cl(-self.blk[g-1][b],-self.blk[g][earlier])
            for x,d in enumerate(self.dst[g][:-1]):
                for h in range(g+1,m):
                    self.cl(self.mov[g],-d,-self.src[h][x])
                    self.cl(self.mov[g],-d,self.mov[h],-self.dst[h][x])
                for j in range(c):
                    for b in range(j):
                        for side in range(2):self.cl(self.mov[g],-d,-self.blk[g][b],-self.cmp[j][side][x])
        for j in range(c):
            for side in range(2):
                self.eo(self.cmp[j][side])
                for x,pick in enumerate(self.cmp[j][side]):
                    if x>=n:self.cl(-pick,*self.blk[x-n][:j])
                    for t,ty in enumerate(types):self.equal_value(self.val[x][t],ty.index(cols[2*j+side][t]),-pick)
        for g in range(m):
            dv=[self.vec(nb) for _ in types];sv=[self.vec(nb) for _ in types]
            for x in range(n+g):
                for t in range(nt):
                    for b in range(nb):
                        self.eq(dv[t][b],self.val[x][t][b],-self.dst[g][x])
                        self.eq(sv[t][b],self.val[x][t][b],-self.src[g][x])
            for t in range(nt):
                take=self.new()
                self.cl(-self.mov[g],take)
                for j in range(c):
                    positive=flags[j][t]>0
                    # Unless this is a copy, take agrees with the selected flag.
                    self.eq(take,self.high[g] if positive else -self.high[g],self.mov[g],-self.blk[g][j])
                for b in range(nb):
                    self.eq(self.val[n+g][t][b],sv[t][b],-take)
                    self.eq(self.val[n+g][t][b],dv[t][b],take)
            if history:
                for j in range(c):
                    groups={}
                    for t in range(nt):
                        key=tuple(flags[q][t] for q in range(j+1))
                        if key not in groups:groups[key]=t
                        else:
                            for b in range(nb):self.eq(self.val[n+g][t][b],self.val[n+g][groups[key]][b],-self.blk[g][j])
        for rank in range(n):
            self.eo(self.out[rank])
            for x,pick in enumerate(self.out[rank]):
                for t,ty in enumerate(types):self.equal_value(self.val[x][t],ty.index(rank),-pick)

def main():
    ap=argparse.ArgumentParser();ap.add_argument('file');ap.add_argument('--k',type=int,default=31);ap.add_argument('--cases',type=int,default=120);ap.add_argument('--seed',type=int,default=13);ap.add_argument('--seconds',type=int,default=60);ap.add_argument('--tag',required=True);ap.add_argument('--fixed');ap.add_argument('--no-history',action='store_true');a=ap.parse_args()
    if os.nice(0)<10:os.nice(10-os.nice(0))
    resource.setrlimit(resource.RLIMIT_AS,(4*1024**3,4*1024**3))
    from random import Random
    types=list(itertools.permutations(range(5)));indices=list(range(120));Random(a.seed).shuffle(indices);indices=sorted(indices[:a.cases]);types=[types[t] for t in indices]
    _,columns=recipe(a.file);cols=[[row[t] for t in indices] for row in columns]
    start=time.monotonic();enc=FixedEncoding(a.k,types,cols,not a.no_history)
    if a.fixed:enc.fix_program(Path(a.fixed).read_text())
    tag=Path('logs',a.tag);cnf=tag.with_suffix('.cnf');enc.dimacs(cnf)
    record=dict(file=a.file,k=a.k,c=len(cols)//2,cases=len(types),case_indices=indices,variables=enc.nv,clauses=len(enc.cs),build_seconds=time.monotonic()-start,cnf_sha256=hashlib.sha256(cnf.read_bytes()).hexdigest())
    print(json.dumps(dict(step='built',**record)),flush=True);enc.cs.clear();gc.collect()
    with tag.with_suffix('.solver').open('w') as out:
        try:p=subprocess.run([str(PROJECT/'bin/kissat'),'--time='+str(a.seconds),str(cnf)],stdout=out,stderr=subprocess.STDOUT,timeout=a.seconds+10);record['returncode']=p.returncode
        except subprocess.TimeoutExpired:record['returncode']=124
    model=[];record['status']='UNKNOWN'
    for line in tag.with_suffix('.solver').read_text().splitlines():
        if line.startswith('s '):record['status']=line[2:].strip()
        if line.startswith('v '):model.extend(int(x) for x in line[2:].split() if int(x))
    if record['status']=='SATISFIABLE':
        yes={x for x in model if x>0}
        with cnf.open() as inp:
            next(inp)
            for line in inp:
                cl=map(int,line.split()[:-1]);assert any((x in yes) if x>0 else (-x not in yes) for x in cl)
        record['assignment_checked']=True
        lines=[l for l in enc.decode(model).splitlines() if l and not l.startswith('#')]
        record['verification']=verify(lines,a.tag)
    record['elapsed_seconds']=time.monotonic()-start;tag.with_suffix('.json').write_text(json.dumps(record,indent=2)+'\n');print(json.dumps(record),flush=True)

if __name__=='__main__':main()
