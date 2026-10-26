"""Pinned positive controls and independent enumeration checks."""
import argparse
import itertools
import json
import sys
import time
from pathlib import Path
from order_sat import OrderEnc,HERE,ROOT,CASES,family_data,evaluate,emit
from orders import read,compare_columns,canonical,CASES as STRICT,enumerate_orders
from pysat.solvers import Solver
import subprocess

def transformed(row):
    p,R=read(Path(row['source']));_,(qi,data)=canonical(compare_columns(p,R))
    perm=STRICT[qi];q=[];flip=False;ci=0;order=[]
    for op,d,s in p:
        d=perm[d] if d<5 else d;s=perm[s] if s<5 else s
        if op=='cmp':
            j=next(k for k,item in enumerate(data) if item[1]==ci)
            flip=data[j][2];order.append(j);ci+=1
            if flip:d,s=s,d
        elif op.startswith('cmov') and flip:
            op={'cmovl':'cmovg','cmovg':'cmovl','cmovle':'cmovge','cmovge':'cmovle'}[op]
        q.append((op,d,s))
    # Delay leading copies until after the first comparison. Read each copied
    # input directly in that comparison. Copies do not change flags.
    first=next(t for t,x in enumerate(q) if x[0]=='cmp')
    aliases=list(range(R))
    for op,d,s in q[:first]:
        assert op=='mov';aliases[d]=aliases[s]
    op,d,s=q[first]
    q=[(op,aliases[d],aliases[s])]+q[:first]+q[first+1:]
    return q,R,order

def main():
    rows=json.loads((HERE/'artifacts/orders.json').read_text())['families'];records=[]
    for row in (rows[0],rows[2],rows[5]):
        start=time.process_time();p,R,order=transformed(row)
        e=OrderEnc(len(p),R,family_data(row,order))
        for t,(op,d,s) in enumerate(p):
            e.cl(e.op[t][op]);e.cl(e.d[t][d]);e.cl(e.s[t][s])
        encoded=CASES[::27]+[w for w in CASES if len(set(w))==5][::11]
        for w in encoded:e.add_type(w)
        with Solver(name='cadical195',bootstrap_with=e.clauses) as sat:
            assert sat.solve(), 'Pinned correct program rejected by encoder'
            p,out=e.decode(sat.get_model());cols,flags=evaluate(p,R)
            assert all(cols[when-1][t]==sorted(w)[j] for t,w in enumerate(CASES) for j,(when,r) in enumerate(out))
        path=HERE/'candidates'/f"control_{row['id']}_k{len(p)}.s";emit(p,out,path)
        log=HERE/'logs'/f"control_{row['id']}_judge.log"
        with log.open('w') as stream:
            judge=subprocess.run(['nice','-n','19','python3','-B',str(ROOT/'shared/judge.py'),str(path),'--strict','--model','out'],stdout=stream,stderr=subprocess.STDOUT)
        record={'family':row['id'],'status':'SAT','cases':len(encoded),'length':len(p),'path':str(path),
                'judge_returncode':judge.returncode,'judge_log':str(log),'cpu':time.process_time()-start}
        assert judge.returncode==0 and 'PASS' in log.read_text()
        records.append(record);print(json.dumps(record),flush=True)
    (HERE/'artifacts/controls.json').write_text(json.dumps(records,indent=2)+'\n')

if __name__=='__main__':main()
