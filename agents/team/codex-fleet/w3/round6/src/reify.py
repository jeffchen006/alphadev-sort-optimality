#!/usr/bin/env python3
"""Try actual comparisons for one fixed relaxed data circuit.

The data order, data operands, value columns, and output nodes are fixed.
The solver selects comparison operands, their schedule, and all cmov conditions.
UNSAT only excludes this data circuit. Every assembly candidate is strict-judged.
"""
import argparse
import itertools
import json
import os
from pathlib import Path
import resource
import random
import subprocess
import sys
import time
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'round4/src'))
from insertion_sat import parse
from encoding import Enc
from interleave_sat import normalize,add_history,add_preservation,judge
from solver import solve

def main():
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    ap=argparse.ArgumentParser();ap.add_argument('prefix');ap.add_argument('graph')
    ap.add_argument('--comparisons',type=int,default=4);ap.add_argument('--tag',required=True)
    ap.add_argument('--timeout',type=int,default=1200);ap.add_argument('--fix')
    ap.add_argument('--free-data-order',action='store_true')
    ap.add_argument('--weak',action='store_true')
    ap.add_argument('--weak-subset',type=int,default=0)
    ap.add_argument('--no-scratch-comparisons',action='store_true');args=ap.parse_args()
    saved=json.loads(Path(args.graph).read_text());savedtypes=[tuple(t) for t in saved['types']]
    savedindex={ty:i for i,ty in enumerate(savedtypes)}
    types=[ty for ty in itertools.product(range(5),repeat=5)
           if set(ty)==set(range(max(ty)+1))] if args.weak else savedtypes
    if args.weak and args.weak_subset:
        ties=[ty for ty in types if len(set(ty))<5]
        types=sorted(savedtypes+random.Random(1).sample(ties,min(args.weak_subset,len(ties))))
    graph=saved['graph'];prefix=parse(args.prefix);start=time.monotonic()
    enc=Enc(prefix,types,args.comparisons,len(graph),origin=not args.weak,scratch=True,
            fixed=parse(args.fix) if args.fix else None)
    assert enc.names==saved['names']
    if not args.fix:normalize(enc)
    if enc.origin:add_history(enc,True)
    add_preservation(enc)
    if args.no_scratch_comparisons:
        for pair in enc.cmps:
            for side in pair:enc.cl(-side[enc.sentinel])
    if args.free_data_order:
        assignment=[enc.vec(len(graph)) for _ in graph]
        for xs in assignment:enc.eo(xs)
        for task in range(len(graph)):enc.eo([xs[task] for xs in assignment])
        if args.fix:
            for g in range(len(graph)):enc.cl(assignment[g][g])
    else:assignment=None
    for g in range(len(graph)):
        for task,gate in enumerate(graph):
            if not assignment and task!=g:continue
            guard=[-assignment[g][task]] if assignment else []
            enc.cl(*guard,enc.mov[g] if gate['mov'] else -enc.mov[g])
            for side in ('source','default'):
                if side=='default' and gate['mov']:continue
                vector=enc.src[g] if side=='source' else enc.dst[g]
                x=gate[side]
                if x<enc.B:enc.cl(*guard,vector[x])
                elif assignment:
                    parent=x-enc.B
                    enc.cl(*guard,*[assignment[earlier][parent] for earlier in range(g)])
                    for earlier in range(g):
                        enc.cl(*guard,-assignment[earlier][parent],vector[enc.B+earlier])
                else:enc.cl(vector[x])
            for t,ty in enumerate(types):
                if ty not in savedindex:continue
                rank=gate['column'][savedindex[ty]]
                origin=rank if args.weak else ty.index(rank) if rank<5 else 5
                for bit in range(3):
                    enc.cl(*guard,enc.val[enc.B+g][t][bit] if (origin>>bit)&1 else -enc.val[enc.B+g][t][bit])
    for j,x in enumerate(saved['outputs']):
        if not assignment or x<enc.B:enc.cl(enc.out[j][x])
        else:
            for g in range(len(graph)):enc.cl(-assignment[g][x-enc.B],enc.out[j][enc.B+g])
    print(json.dumps(dict(event='ENC',prefix=args.prefix,graph=args.graph,comparisons=args.comparisons,
                         data=len(graph),copies=sum(g['mov'] for g in graph),variables=enc.nv,
                         free_data_order=args.free_data_order,
                         weak=args.weak,types=len(types),no_scratch_comparisons=args.no_scratch_comparisons,
                         weak_subset=args.weak_subset,
                         clauses=len(enc.cs),encode_seconds=round(time.monotonic()-start,3))),flush=True)
    tag=ROOT/'round6/logs'/args.tag
    status,model,elapsed=solve(enc,tag,args.timeout,1,'kissat',True)
    print(json.dumps(dict(event='RESULT',result=status,solve_seconds=elapsed,
                         peak_self_rss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
                         peak_child_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss)),flush=True)
    if status!='SATISFIABLE':return
    candidate=ROOT/f'round6/programs/{args.tag}.s';candidate.write_text(enc.decode(model))
    if not judge(candidate):return
    k=sum(op!='out' for op,d,s in parse(candidate))
    print('STRICT_PASS',k,candidate,flush=True)
    program=parse(candidate)
    counts=(sum(op=='cmp' for op,d,s in program),sum(op.startswith('cmov') for op,d,s in program),
            sum(op=='mov' for op,d,s in program))
    print('BUDGET',counts,flush=True)
    if k==32 and counts not in ((9,18,5),(8,20,4)):
        line=(f'ASSUMPTION CHALLENGED: A3 — strict k=32 program `{candidate.relative_to(ROOT)}` '
              f'has {counts[0]} comparisons, {counts[1]} conditional moves, and {counts[2]} copies. '
              'The matching `.s.judge.txt` records its PASS.\n')
        with (ROOT/'RESULTS.md').open('a') as stream:stream.write('\n'+line)
        (ROOT/'round6/NEW_BUDGET').write_text(str(candidate)+'\n')
    if k<=31:
        memory=candidate.with_name(candidate.stem+'_mem.s')
        subprocess.run([sys.executable,str(ROOT/'src/to_mem.py'),str(candidate),str(memory)],check=True)
        project=ROOT.parents[3]
        result=subprocess.run([sys.executable,str(project/'shared/judge.py'),str(memory),'--strict','--model','mem'],
                              text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
        Path(str(memory)+'.judge.txt').write_text(result.stdout)
        print('MEM_JUDGE',result.stdout.strip(),flush=True)
        results=ROOT/'RESULTS.md'
        results.write_text(f'FOUND k={k}: `{candidate.relative_to(ROOT)}`. Strict out judge PASS.\n\n'+results.read_text())
        if result.returncode or not result.stdout.startswith('PASS '):raise RuntimeError('Memory conversion failed.')
        (ROOT/'round6/FOUND').write_text(str(candidate)+'\n')

if __name__=='__main__':main()
