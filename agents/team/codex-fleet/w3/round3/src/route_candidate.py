#!/usr/bin/env python3
"""Minimize copies for the fixed conditional-move DAG of an out program."""
import argparse,json,subprocess,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'src'))
from dag_reference import Search

def optimize(path,dest=None):
    path=Path(path)
    cur={f'P{i}':i for i in range(5)}
    nodes=[[None,0,'in',None,None,None] for i in range(5)]
    comparisons={};outputs={};phase=0
    for line in path.read_text().splitlines():
        line=line.strip()
        if not line or line.startswith('#'):continue
        op,rest=line.split(None,1);d,s=[q.strip() for q in rest.split(',')]
        if op=='mov':cur[d]=cur[s]
        elif op=='out':outputs[int(d)]=cur[s]
        elif op=='cmp':phase+=1;comparisons[phase]=(cur[d],cur[s])
        else:
            assert op in ('cmovl','cmovle','cmovg','cmovge') and phase
            nodes.append([None,phase,'gate',cur[d],cur[s],op]);cur[d]=len(nodes)-1
    assert set(outputs)==set(range(5))
    allocator=Search.__new__(Search);allocator.nodes=nodes;allocator.cmpuse=comparisons;allocator.c=phase
    inplace=[];order=[]
    for b in range(1,phase+1):
        res=allocator.max_inplace([g for g in range(5,len(nodes)) if nodes[g][1]==b],0)
        if res is None:raise RuntimeError('Fixed DAG has no schedule')
        inplace+=res[0];order+=res[1]
    inplace=set(inplace);register={i:f'P{i}' for i in range(5)};next_scratch=0
    lines=['# n=5 R=100 iset=I1 model=out source=w3_round3_fixed_dag_routing']
    for out,node in outputs.items():
        if node<5:lines.append(f'out {out}, {register[node]}')
    for b in range(1,phase+1):
        a,s=comparisons[b];lines.append(f'cmp {register[a]}, {register[s]}')
        for g in order:
            if nodes[g][1]!=b:continue
            _,_,_,d,s,op=nodes[g]
            if g in inplace:destreg=register[d]
            else:
                destreg=f'S{next_scratch}';next_scratch+=1
                lines.append(f'mov {destreg}, {register[d]}')
            lines.append(f'{op} {destreg}, {register[s]}');register[g]=destreg
            for out,node in outputs.items():
                if node==g:lines.append(f'out {out}, {destreg}')
    result=Path(dest) if dest else path.with_name(path.stem+'_routed.s')
    result.write_text('\n'.join(lines)+'\n')
    k=sum(not s.startswith(('#','out ')) for s in lines)
    print('FIXED_DAG_ROUTING',json.dumps(dict(file=str(result),k=k,comparisons=phase,
          conditional_moves=len(nodes)-5,copies=len(nodes)-5-len(inplace))),flush=True)
    return result

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--tag',required=True);ap.add_argument('--timeout',type=int,default=60)
    args=ap.parse_args()
    path=optimize(ROOT/'programs/construct_fj_k53.s',ROOT/'round3/programs'/f'{args.tag}.s')
    q=subprocess.run(['nice','-n','19','python3',str(ROOT.parents[3]/'shared/judge.py'),str(path),
                      '--strict','--model','out'],capture_output=True,text=True,timeout=args.timeout)
    result=q.stdout+q.stderr;print('JUDGE',result,flush=True)
    path.with_suffix('.judge.txt').write_text(result)
    print(json.dumps(dict(event='RESULT',tag=args.tag,status='JUDGE_PASS' if 'PASS ' in result else 'JUDGE_FAIL')),flush=True)
    if 'PASS ' not in result:raise SystemExit(1)
if __name__=='__main__':main()
