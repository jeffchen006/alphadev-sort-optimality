"""Replay queries with subset SAT models and judge every decoded program."""
import argparse
import json
from pathlib import Path
from prefix_batch import tasks
from order_sat import HERE,solve

def phase_for(task,n):
    p=task['source_program'];starts=[t for t,x in enumerate(p) if x[0]=='cmp']+[len(p)]
    blocks={j:p[starts[i]:starts[i+1]] for i,j in enumerate(task['source_order'])}
    q=[x for j in task['order'] for x in blocks[j]];rename={i:i for i in range(5)};result=[]
    for op,d,s in q:
        for r in (d,s):
            if r not in rename:rename[r]=len(rename)
        result.append((op,rename[d],rename[s]))
    if len(result)==32:
        choices=[t for t,x in enumerate(result) if t>=n and x[0]!='cmp']
        deleted=next((t for t in choices if result[t][0]=='mov'),choices[-1])
        result=result[:deleted]+result[deleted+1:]
    return result

def main():
    todo=tasks();old=[]
    for name in ('prefix_all','polarity_all'):
        old.extend((name,r) for r in map(json.loads,(HERE/'artifacts'/f'{name}.jsonl').read_text().splitlines()) if r['iterations'])
    with (HERE/'artifacts/replay.jsonl').open('w') as stream:
        for name,previous in old:
            task=todo[previous['index']];n=previous['prefix_length'];polarity=previous.get('polarity',False)
            a=argparse.Namespace(k=31,regs=previous['regs'],seconds=12,types=12 if polarity else 8,add=5,
                                 solver='cadical195',polarity=polarity,save_models=True,
                                 tag=f'replay_{previous["index"]}')
            row=solve(task['row'],task['order'],a,task['source_program'][:n],task['row']['source'],previous.get('positions'),phase_for(task,n) if polarity else None)
            row.update(index=previous['index'],replayed_batch=name)
            text=json.dumps(row);stream.write(text+'\n');stream.flush();print(text,flush=True)
            if row.get('strict_pass'):return

if __name__=='__main__':main()
