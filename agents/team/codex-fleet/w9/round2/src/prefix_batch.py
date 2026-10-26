"""Repair changed comparator orders after their longest common source prefix."""
import argparse
import json
import time
from pathlib import Path
from order_sat import HERE,solve
from control import transformed

def tasks():
    families=json.loads((HERE/'artifacts/orders.json').read_text())['families']
    result=[]
    for row in families:
        sources=[]
        for path in row['sources']:
            source=dict(row,source=path);p,R,old=transformed(source)
            if len(p)>32:continue
            sources.append((source,p,R,old))
        for order in row['new_flag_orders']:
            def shared(item):
                _,p,R,old=item
                n=next((j for j,(a,b) in enumerate(zip(order,old)) if a!=b),8)
                positions=[t for t,x in enumerate(p) if x[0]=='cmp']
                # A new order always diverges before comparison eight.
                return n,positions[n]
            if not sources:continue
            source,p,R,old=max(sources,key=shared);n,prefix=shared((source,p,R,old))
            result.append({'row':source,'order':order,'source_program':p,
                           'source_regs':R,'source_order':old,'common_comparisons':n,'prefix':prefix})
    result.sort(key=lambda x:(-x['common_comparisons'],-x['prefix'],x['row']['id'],x['order']))
    return result

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--seconds',type=float,default=3)
    ap.add_argument('--regs',type=int,default=9);ap.add_argument('--k',type=int,default=31)
    ap.add_argument('--types',type=int,default=8);ap.add_argument('--add',type=int,default=5)
    ap.add_argument('--solver',default='cadical195');ap.add_argument('--first',type=int,default=0)
    ap.add_argument('--count',type=int,default=653);ap.add_argument('--tag',default='prefix_batch')
    ap.add_argument('--backtrack',type=int,default=0);ap.add_argument('--minimum-prefix',type=int,default=0)
    ap.add_argument('--polarity',action='store_true')
    ap.add_argument('--placements',action='store_true')
    ap.add_argument('--phase-source',action='store_true')
    a=ap.parse_args();todo=tasks();summary={}
    for t in todo:summary[t['common_comparisons']]=summary.get(t['common_comparisons'],0)+1
    print(json.dumps({'tasks':len(todo),'common_prefix_counts':summary,'args':vars(a)}),flush=True)
    with (HERE/'artifacts'/f'{a.tag}.jsonl').open('a') as stream:
        for ti,task in enumerate(todo[a.first:a.first+a.count],a.first):
            n=max(0,task['prefix']-a.backtrack)
            if n<a.minimum_prefix:continue
            prefix=task['source_program'][:n]
            local=argparse.Namespace(**vars(a))
            local.regs=max(a.regs,task['source_regs'])
            reordered=task['source_program']
            if a.phase_source:
                starts=[t for t,x in enumerate(reordered) if x[0]=='cmp']+[len(reordered)]
                blocks={j:reordered[starts[i]:starts[i+1]] for i,j in enumerate(task['source_order'])}
                reordered=[instruction for j in task['order'] for instruction in blocks[j]]
                renamed={i:i for i in range(5)}
                canon=[]
                for op,d,s in reordered:
                    for r in (d,s):
                        if r not in renamed:renamed[r]=len(renamed)
                    canon.append((op,renamed[d],renamed[s]))
                reordered=canon
            phase=None
            if len(reordered)==a.k+1:
                choices=[t for t,x in enumerate(reordered) if t>=n and x[0]!='cmp']
                if choices:
                    deleted=next((t for t in choices if reordered[t][0]=='mov'),choices[-1])
                    phase=reordered[:deleted]+reordered[deleted+1:]
            elif len(reordered)==a.k:phase=reordered
            positions=[None]
            if a.placements and len(task['source_program'])==a.k+1:
                original=[t for t,x in enumerate(reordered) if x[0]=='cmp']
                positions=sorted({tuple(t-(t>deleted) for t in original)
                                  for deleted in range(n,len(reordered))
                                  if reordered[deleted][0]!='cmp'})
            for pos in positions:
                row=solve(task['row'],task['order'],local,prefix,task['row']['source'],pos,phase if a.phase_source else None)
                row['index']=ti;row['common_comparisons']=task['common_comparisons']
                text=json.dumps(row);print(text,flush=True);stream.write(text+'\n');stream.flush()
                if row['status']=='SAT_CANDIDATE':return

if __name__=='__main__':main()
