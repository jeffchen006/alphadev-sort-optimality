#!/usr/bin/env python3
"""Replace the last six sort4 instructions and add eleven insertion slots.

The prefix contains exactly fourteen register instructions. Suffix comparisons
and data instructions have free operands and a free phase schedule. No physical
register cap applies. A conditional move consumes its default value node.
This search excludes new reads of untouched scratch registers.
"""
import argparse
import itertools
import json
import os
from pathlib import Path
import random
import resource
import subprocess
import sys
import time
from pysat.card import CardEnc, EncType

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT/'round4/src'))
from insertion_sat import OPS, PERMS, PROJECT, parse, run, solve
from encoding import Enc


def prefix_groups(prefix, types):
    rows=[run(prefix,t) for t in types]
    names=sorted(set().union(*(row[0] for row in rows)))
    groups={}
    for i,(ty,row) in enumerate(zip(types,rows)):
        origins=tuple(ty.index(row[0][n]) if row[0][n]<5 else 5 for n in names)
        groups.setdefault((origins,row[1]),[]).append(i)
    return list(groups.values())


def add_history(enc):
    """Necessary origin/history equalities for each initial prefix state."""
    assert enc.origin
    groups=prefix_groups(enc.prefix,enc.types)
    pairs=[pair for group in groups for pair in itertools.combinations(group,2)]
    history={pair:True for pair in pairs}
    for phase in range(1,enc.c+1):
        now={}
        for a,b in pairs:
            same=enc.new()
            for fa in range(3):
                for fb in range(3):
                    enc.cl(enc.neg(enc.flags[phase][a][fa]),
                           enc.neg(enc.flags[phase][b][fb]),same if fa==fb else -same)
            h=enc.new();prev=history[a,b]
            enc.cl(-h,prev);enc.cl(-h,same);enc.cl(h,enc.neg(prev),-same)
            now[a,b]=h
            for g in range(enc.m):
                for bit in range(3):
                    enc.eq(enc.val[enc.B+g][a][bit],enc.val[enc.B+g][b][bit],
                           -h,-enc.blk[g][phase])
            if phase==enc.c:
                enc.cl(-h)
        if phase==enc.c-1:
            for group in groups:
                for a,b,c in itertools.combinations(group,3):
                    enc.cl(-now[a,b],-now[a,c])
        history=now


def normalize(enc):
    # Reversing one comparison and complementing its phase predicates gives
    # the same circuit. Canonical operand order preserves physical routing.
    for pair in enc.cmps:
        for d in range(enc.B+enc.m):
            for s in range(d+1):
                enc.cl(-pair[0][d],-pair[1][s])
    for g in range(enc.m):
        # A data node with no consumer can be removed. A program shorter than
        # the budget can instead pad an output with a chain of useful copies.
        consumers=[out[enc.B+g] for out in enc.out]
        consumers += [pair[side][enc.B+g] for pair in enc.cmps for side in range(2)]
        for h in range(g+1,enc.m):
            consumers.append(enc.src[h][enc.B+g])
            used_as_default=enc.new()
            enc.cl(-used_as_default,-enc.mov[h])
            enc.cl(-used_as_default,enc.dst[h][enc.B+g])
            enc.cl(used_as_default,enc.mov[h],-enc.dst[h][enc.B+g])
            consumers.append(used_as_default)
        enc.cl(*consumers)
        # A self-conditional-move can be replaced by a same-cost copy into a
        # fresh register. This preserves or increases future availability.
        for x in range(enc.B+g):
            enc.cl(enc.mov[g],-enc.dst[g][x],-enc.src[g][x])
    # No paired-copy or fixed-register restriction is imposed here.


def add_preservation(enc):
    """Keep each needed input value live until its output is recorded.

    A compare/move program cannot create a lost input value. Live value nodes
    represent physical registers. Historical output nodes can retain a value
    after its register is overwritten. These clauses only state that necessary
    condition; they do not restrict the program's comparison or data schedule.
    """
    assert not enc.free_copies
    alive=[True]*enc.B
    for stage in range(1,enc.m):
        g=stage-1
        next_alive=[]
        for x,previous in enumerate(alive):
            if x==enc.sentinel:
                next_alive.append(True)
                continue
            new=enc.new()
            enc.cl(-new,previous)
            enc.cl(-new,enc.mov[g],-enc.dst[g][x])
            enc.cl(new,enc.neg(previous),-enc.mov[g])
            enc.cl(new,enc.neg(previous),enc.dst[g][x])
            next_alive.append(new)
        alive=next_alive+[True]
        assert len(alive)==enc.B+stage
        for j in range(5):
            done=enc.out[j][:enc.B+stage]
            for t,ty in enumerate(enc.types):
                origin=ty.index(j) if enc.origin else sorted(ty)[j]
                witnesses=[]
                for x,live in enumerate(alive):
                    bits=enc.val[x][t]
                    literals=[bit if (origin>>b)&1 else enc.neg(bit) for b,bit in enumerate(bits)]
                    if any(bit is False for bit in literals):continue
                    literals=[bit for bit in literals if bit is not True]
                    if not literals:
                        witnesses.append(live)
                        continue
                    w=enc.new()
                    enc.cl(-w,live)
                    for literal in literals:enc.cl(-w,literal)
                    witnesses.append(w)
                enc.cl(*done,*witnesses)


def judge(path):
    result=subprocess.run(['python3',str(PROJECT/'shared/judge.py'),str(path),
                           '--strict','--model','out'],text=True,stdout=subprocess.PIPE,
                          stderr=subprocess.STDOUT)
    Path(str(path)+'.judge.txt').write_text(result.stdout)
    print('JUDGE',result.stdout.strip(),flush=True)
    return 'PASS' in result.stdout and result.returncode==0


def main():
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    ap=argparse.ArgumentParser()
    ap.add_argument('prefix')
    ap.add_argument('--tag',required=True)
    ap.add_argument('--comparisons',type=int,default=4)
    ap.add_argument('--slots',type=int,default=17)
    ap.add_argument('--timeout',type=int,default=120)
    ap.add_argument('--all',action='store_true')
    ap.add_argument('--tests',type=int,default=20)
    ap.add_argument('--seed',type=int,default=1)
    ap.add_argument('--fix')
    ap.add_argument('--solver',default='cadical')
    ap.add_argument('--free-copies',action='store_true')
    ap.add_argument('--history',action='store_true')
    ap.add_argument('--proof',action='store_true')
    ap.add_argument('--iterations',type=int,default=20)
    ap.add_argument('--start-group',action='store_true')
    ap.add_argument('--preserve',action='store_true')
    ap.add_argument('--scratch',action='store_true')
    ap.add_argument('--ordered-seed',action='store_true')
    ap.add_argument('--profile',help='comma-separated data counts before/between/after comparisons')
    ap.add_argument('--copies',type=int,help='exact suffix mov count')
    ap.add_argument('--minimum-gates',type=int,default=8,
                    help='necessary suffix cmov bound from round4 select_bound7 certificate')
    ap.add_argument('--weak',action='store_true')
    args=ap.parse_args()
    prefix=[row for row in parse(args.prefix) if row[0]!='out']
    assert len(prefix)==14
    weaktypes=[p for p in itertools.product(range(5),repeat=5)
               if set(p)==set(range(max(p)+1))]
    alltypes=weaktypes if args.weak else PERMS
    rng=random.Random(args.seed)
    current=list(alltypes) if args.all else sorted(rng.sample(alltypes,min(args.tests,len(alltypes))))
    if args.start_group and not args.all:
        groups=prefix_groups(prefix,alltypes)
        group=max(groups,key=len)
        current=[alltypes[i] for i in group]
    if args.ordered_seed and not args.all:
        current=[p for p in alltypes if list(p[:4])==sorted(p[:4])]
    fixed=parse(args.fix) if args.fix else None
    for iteration in range(args.iterations):
        start=time.monotonic()
        tag=ROOT/'round5/logs'/f'{args.tag}_i{iteration}'
        enc=Enc(prefix,current,args.comparisons,args.slots-args.comparisons,
                fixed=fixed,free_copies=args.free_copies,origin=not args.weak,scratch=args.scratch)
        if not fixed:normalize(enc)
        if args.history and enc.origin:add_history(enc)
        if args.preserve:add_preservation(enc)
        if args.profile:
            profile=list(map(int,args.profile.split(',')))
            assert len(profile)==enc.c+1 and sum(profile)==enc.m
            g=0
            for phase,count in enumerate(profile):
                for _ in range(count):
                    enc.cl(enc.blk[g][phase]);g+=1
        if args.copies is not None:
            ca=CardEnc.equals(enc.mov,bound=args.copies,top_id=enc.nv,encoding=EncType.seqcounter)
            enc.nv=max(enc.nv,ca.nv);enc.cs+=ca.clauses
        if args.minimum_gates:
            # Fixing any one order of the first four values leaves five P4
            # positions. The round4 seven-selector relaxation already contains
            # every possible initial origin, with free copies and predicates.
            # Its checked UNSAT certificate therefore applies to this prefix.
            if enc.m<args.minimum_gates:enc.cl()
            else:
                ca=CardEnc.atmost(enc.mov,bound=enc.m-args.minimum_gates,
                                 top_id=enc.nv,encoding=EncType.seqcounter)
                enc.nv=max(enc.nv,ca.nv);enc.cs+=ca.clauses
        print(json.dumps(dict(event='ENC',tag=args.tag,iteration=iteration,types=len(current),
              prefix=str(args.prefix),slots=args.slots,comparisons=args.comparisons,
              data=enc.m,base=enc.B,free_copies=args.free_copies,history=args.history and enc.origin,
              weak=args.weak,
              preservation=args.preserve,
              scratch=args.scratch,
              profile=args.profile,
              copies=args.copies,
              minimum_gates=args.minimum_gates,
              variables=enc.nv,clauses=len(enc.cs),
              encode_seconds=round(time.monotonic()-start,3))),flush=True)
        status,model,elapsed=solve(enc,tag,args.timeout,args.seed,args.solver,args.proof)
        print(json.dumps(dict(event='RESULT',tag=args.tag,iteration=iteration,
              result=status,solve_seconds=elapsed,
              peak_self_rss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
              peak_child_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss)),flush=True)
        if status!='SATISFIABLE':return
        candidate=ROOT/'round5/programs'/f'{args.tag}_i{iteration}.s'
        candidate.write_text(enc.decode(model))
        prog=parse(candidate)
        bad=[]
        for ty in alltypes:
            outs=run(prog,ty)[2]
            if [outs[j] for j in range(5)]!=sorted(ty):bad.append(ty)
        passed=judge(candidate)
        if passed:
            k=sum(op!='out' for op,d,s in prog)
            print('STRICT_PASS',k,candidate,flush=True)
            if k<=31:
                memory=candidate.with_name(candidate.stem+'_mem.s')
                subprocess.run([sys.executable,str(ROOT/'src/to_mem.py'),str(candidate),str(memory)],check=True)
                memjudge=subprocess.run([sys.executable,str(PROJECT/'shared/judge.py'),str(memory),
                                        '--strict','--model','mem'],text=True,stdout=subprocess.PIPE,
                                       stderr=subprocess.STDOUT)
                Path(str(memory)+'.judge.txt').write_text(memjudge.stdout)
                print('MEM_JUDGE',memjudge.stdout.strip(),flush=True)
                results=ROOT/'RESULTS.md'
                line=f'FOUND k={k}: `{candidate.relative_to(ROOT)}`. Strict out judge PASS; see matching `.judge.txt`.\n'
                results.write_text(line+'\n'+results.read_text())
                if memjudge.returncode or not memjudge.stdout.startswith('PASS '):
                    raise RuntimeError('out PASS needs memory-conversion repair: '+str(memory))
                with open(ROOT/'round5/FOUND','w') as f:f.write(str(candidate)+'\n')
            return
        if not bad:
            if not args.weak:
                weakbad=[]
                for ty in weaktypes:
                    outs=run(prog,ty)[2]
                    if [outs[j] for j in range(5)]!=sorted(ty):weakbad.append(ty)
                if weakbad:
                    args.weak=True;alltypes=weaktypes
                    current=sorted(set(current+rng.sample(weakbad,min(12,len(weakbad)))))
                    print('ADD_WEAK_COUNTEREXAMPLES',len(weakbad),'NEXT_TYPES',len(current),flush=True)
                    del enc
                    continue
            print('STRICT_GARBAGE_FAILURE_AFTER_ALL_VALUE_ORDERS',candidate,flush=True)
            return
        current=sorted(set(current+rng.sample(bad,min(12,len(bad)))))
        print('COUNTEREXAMPLES',len(bad),'NEXT_TYPES',len(current),flush=True)
        del enc


if __name__=='__main__':main()
