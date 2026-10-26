"""Pinned controls for the comparison-origin constraints."""
import argparse
import json
import os
from pathlib import Path
import resource
import sys

sys.dont_write_bytecode=True
HERE=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(HERE.parent/'round2/src'))
from control import transformed
from order_kissat import solve


def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    families=json.loads((HERE.parent/'round2/artifacts/orders.json').read_text())['families']
    records=[]
    for index in (0,2,5):
        family=families[index];p,R,order=transformed(family)
        for polarity in (False,True):
            # Reverse a late comparison and all conditional moves that read its
            # flags. This forces a nontrivial orientation in the polarity test.
            q=list(p)
            if polarity:
                positions=[t for t,x in enumerate(q) if x[0]=='cmp']+[len(q)]
                t=positions[6];op,d,s=q[t];q[t]=(op,s,d)
                reverse={'cmovl':'cmovg','cmovg':'cmovl','cmovle':'cmovge','cmovge':'cmovle'}
                for t in range(t+1,positions[7]):
                    op,d,s=q[t]
                    if op in reverse:q[t]=(reverse[op],d,s)
            a=argparse.Namespace(k=32,regs=R,seconds=30,types=12,add=5,
                                 polarity=polarity,save_models=True,origin_cuts=True,
                                 pin_program=q,tag=f'origin_control_{index}_{int(polarity)}')
            row=solve(family,order,a)
            assert row.get('strict_pass'),row
            row['origin_cuts']=True;records.append(row)
    (HERE/'artifacts/origin_controls.json').write_text(json.dumps(records,indent=2)+'\n')


if __name__=='__main__':main()
