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
from solver import solve
from insertion_sat import OPS, PERMS, PROJECT, parse, run
from encoding import Enc
from cmp_escape import add_escape


def prefix_groups(prefix, types):
    rows=[run(prefix,t) for t in types]
    names=sorted(set().union(*(row[0] for row in rows)))
    groups={}
    for i,(ty,row) in enumerate(zip(types,rows)):
        origins=tuple(ty.index(row[0][n]) if row[0][n]<5 else 5 for n in names)
        groups.setdefault((origins,row[1]),[]).append(i)
    return list(groups.values())


def add_history(enc,capacity=False):
    """Necessary origin/history equalities for each initial prefix state."""
    assert enc.origin
    groups=prefix_groups(enc.prefix,enc.types)
    minimum=(max(map(len,groups),default=1)-1).bit_length()
    enc.minimum_useful_comparisons=minimum
    used_phases=[]
    for phase in range(1,enc.c+1):
        used=enc.new();used_phases.append(used);witnesses=[]
        for g in range(enc.m):
            witness=enc.new();witnesses.append(witness)
            enc.cl(-witness,-enc.mov[g]);enc.cl(-witness,enc.blk[g][phase])
            enc.cl(witness,enc.mov[g],-enc.blk[g][phase])
            enc.cl(-witness,used)
        enc.cl(-used,*witnesses)
    if minimum>enc.c:enc.cl()
    elif minimum:
        ca=CardEnc.atleast(used_phases,bound=minimum,top_id=enc.nv,encoding=EncType.seqcounter)
        enc.nv=max(enc.nv,ca.nv);enc.cs+=ca.clauses
    pairs=[pair for group in groups for pair in itertools.combinations(group,2)]
    for group in groups:
        anchor=group[0]
        for other in group[1:]:
            for bit in range(3):
                for g in range(enc.m):
                    enc.eq(enc.val[enc.B+g][anchor][bit],enc.val[enc.B+g][other][bit],-enc.blk[g][0])
                for side in range(2):
                    enc.eq(enc.cmpval[0][side][anchor][bit],enc.cmpval[0][side][other][bit])
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
            if phase<enc.c:
                for side in range(2):
                    for bit in range(3):
                        enc.eq(enc.cmpval[phase][side][a][bit],enc.cmpval[phase][side][b][bit],-h)
            if phase==enc.c:
                enc.cl(-h)
        if phase==enc.c-1:
            for group in groups:
                for a,b,c in itertools.combinations(group,3):
                    enc.cl(-now[a,b],-now[a,c])
        if capacity and phase<enc.c:
            cap=2**(enc.c-phase)
            for group in groups:
                if len(group)<=cap:continue
                for anchor in group:
                    peers=[now[tuple(sorted((anchor,other)))] for other in group if other!=anchor]
                    ca=CardEnc.atmost(peers,bound=cap-1,top_id=enc.nv,encoding=EncType.seqcounter)
                    enc.nv=max(enc.nv,ca.nv);enc.cs+=ca.clauses
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


def add_repeated_flag(enc,mode='state'):
    """At least one suffix comparison restores an earlier flag function.

    The match covers strict test orders. State mode permits any global
    permutation of less/equal/greater. This includes recovery through equality,
    such as comparing max(a,b) with a. Sign mode permits only reversal.
    Thus the family includes exact comparison recomputation and other operands
    that restore the same predicate. It does not require a fixed value pool.
    """
    earlier=[]
    for i,(op,d,s) in enumerate(enc.prefix):
        if op=='cmp':earlier.append([run(enc.prefix[:i+1],t)[1] for t in enc.types])
    choices=[]
    permutations=list(itertools.permutations(range(3))) if mode=='state' else [(0,1,2),(2,1,0)]
    strict=[t for t,ty in enumerate(enc.types) if len(set(ty))==5]
    for j in range(1,enc.c+1):
        for old in earlier+list(range(1,j)):
            for permutation in permutations:
                match=enc.new();choices.append(match)
                for t in strict:
                    if isinstance(old,list):
                        expected=permutation[old[t]+1]
                        enc.cl(-match,enc.flags[j][t][expected])
                    else:
                        for f in range(3):
                            enc.eq(enc.flags[j][t][permutation[f]],enc.flags[old][t][f],-match)
    enc.cl(*choices)


def search_preflight():
    """Run each control and fixed-data query once, before broad search."""
    prefix0=str(ROOT/'round5/classes/p0.s')
    prefix21=str(ROOT/'round5/classes/p37.s')
    suffix=str(ROOT/'round6/programs/repeat_control_suffix23.s')
    control_graph=str(ROOT/'round6/logs/data_control16.graph.json')
    relaxed=ROOT/'round6/logs/class21_data13_no_output_reads.graph.json'
    specifications=[
        ('cmp_escape_audit','cmp_escape.py',[],'"status": "PASS"'),
        ('repeat_state_control37','repeat_state_control.py',[],'STRICT_PASS 37'),
        ('repeat_useful37','interleave_sat.py',[prefix0,'--slots','23','--comparisons','7',
          '--fix',suffix,'--repeat-flag','--tag','repeat_useful37','--all','--history',
          '--capacity','--preserve','--scratch','--timeout','60'],'STRICT_PASS 37'),
        ('sink_reference12','sink_control.py',['--reference'],'INDEPENDENT_SINK_CONTROL PASS'),
    ]
    if relaxed.exists():
        control=[prefix0,control_graph,'--comparisons','6','--timeout','60',
                 '--fix',str(ROOT/'round5/programs/control_suffix22.s')]
        specifications += [
            ('reify_control36','reify.py',control+['--tag','reify_control36'],'STRICT_PASS 36'),
            ('reify_class21_data13','reify.py',[prefix21,str(relaxed),'--comparisons','4',
              '--tag','reify_class21_data13','--timeout','1200'],None),
            ('reify_order_control36','reify.py',control+['--free-data-order',
              '--tag','reify_order_control36'],'STRICT_PASS 36'),
            ('reify_class21_free_order','reify.py',[prefix21,str(relaxed),'--comparisons','4',
              '--free-data-order','--tag','reify_class21_free_order','--timeout','1200'],None),
            ('reify_weak_control36','reify.py',control+['--free-data-order','--weak',
              '--weak-subset','20','--no-scratch-comparisons','--tag','reify_weak_control36'],
              'STRICT_PASS 36'),
            ('reify_release_control36','reify.py',control+['--free-data-order','--weak',
              '--weak-subset','20','--no-scratch-comparisons','--tag','reify_release_control36'],
              'STRICT_PASS 36'),
            ('reify_class21_c5_seed32','reify.py',[prefix21,str(relaxed),'--comparisons','5',
              '--free-data-order','--weak','--weak-subset','20','--no-scratch-comparisons',
              '--tag','reify_class21_c5_seed32','--timeout','1200'],None),
            ('class21_data12_no_output_reads','data_bound.py',[prefix21,'--slots','12',
              '--minimum-gates','11','--no-output-reads','--tag','class21_data12_no_output_reads',
              '--timeout','1200','--proof'],None),
            ('dag_control16','physical_dag.py',[prefix0,'--gates','12','--copies','4',
              '--fix-graph',control_graph,'--tag','dag_control16','--timeout','60'],
              'INDEPENDENT_PHYSICAL_DAG_CHECK PASS'),
            ('dag_control13','physical_dag.py',[prefix21,'--gates','13','--copies','0',
              '--fix-graph',str(relaxed),'--tag','dag_control13','--timeout','60'],
              'INDEPENDENT_PHYSICAL_DAG_CHECK PASS'),
            ('dag_scratch_control17','physical_dag.py',[prefix0,'--gates','14','--copies','3',
              '--fix-graph',str(ROOT/'round6/logs/data_scratch_control17.graph.json'),
              '--tag','dag_scratch_control17','--timeout','60'],
              'INDEPENDENT_PHYSICAL_DAG_CHECK PASS'),
            ('dag_consume_conflict','physical_dag.py',[prefix21,'--gates','13','--copies','0',
              '--fix-graph',str(relaxed),'--force-double-consume','--tag','dag_consume_conflict',
              '--timeout','60','--proof'],'CNF_CERTIFICATE_VERIFIED'),
            ('class21_dag12_copy0','physical_dag.py',[prefix21,'--gates','12','--copies','0',
              '--tag','class21_dag12_copy0','--timeout','1200','--proof'],None),
            ('class21_dag11_copy1','physical_dag.py',[prefix21,'--gates','11','--copies','1',
              '--tag','class21_dag11_copy1','--timeout','1200','--proof'],None),
        ]
    for source in ('class21_dag12_copy0','class21_dag11_copy1'):
        graph=ROOT/f'round6/logs/{source}.graph.json'
        if graph.exists():
            count=len(json.loads(graph.read_text())['graph'])
            tag=source+'_reify31'
            specifications.append((tag,'reify.py',[prefix21,str(graph),
                '--comparisons',str(31-14-count),'--free-data-order','--tag',tag,
                '--timeout','1200'],None))
    for tag,script,arguments,required in specifications:
        if (ROOT/'round6/FOUND').exists():return
        log=ROOT/f'round6/logs/{tag}.log'
        old=log.read_text() if log.exists() else ''
        valid=required in old if required else any(
            line.startswith('{') and '"event": "RESULT"' in line for line in old.splitlines())
        if valid:continue
        if log.exists():
            count=1
            while log.with_name(log.stem+f'.failed{count}.log').exists():count+=1
            log.rename(log.with_name(log.stem+f'.failed{count}.log'))
        with log.open('w') as stream:
            result=subprocess.run([sys.executable,str(ROOT/'round6/src'/script)]+arguments,
                                  stdout=stream,stderr=subprocess.STDOUT)
        output=log.read_text()
        valid=required in output if required else any(
            line.startswith('{') and '"event": "RESULT"' in line for line in output.splitlines())
        if result.returncode or not valid:raise RuntimeError('Preflight failed: '+str(log))
    with (ROOT/'round6/logs/checkpoint.log').open('w') as stream:
        result=subprocess.run([sys.executable,str(ROOT/'round6/src/finalize.py')],
                              stdout=stream,stderr=subprocess.STDOUT)
    if result.returncode:raise RuntimeError('Checkpoint collection failed.')


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
    ap.add_argument('--repeat-flag',action='store_true')
    ap.add_argument('--repeat-mode',choices=('sign','state'),default='state')
    ap.add_argument('--capacity',action=argparse.BooleanOptionalAction,default=True)
    ap.add_argument('--cmp-escape',action=argparse.BooleanOptionalAction,default=True)
    args=ap.parse_args()
    if args.history and args.capacity and args.fix is None:
        search_preflight()
        if (ROOT/'round6/FOUND').exists():return
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
        tag=ROOT/'round6/logs'/f'{args.tag}_i{iteration}'
        enc=Enc(prefix,current,args.comparisons,args.slots-args.comparisons,
                fixed=fixed,free_copies=args.free_copies,origin=not args.weak,scratch=args.scratch)
        if not fixed:normalize(enc)
        if args.history and enc.origin:add_history(enc,args.capacity)
        if args.preserve:add_preservation(enc)
        if args.repeat_flag:add_repeated_flag(enc,args.repeat_mode)
        escape=None
        if args.cmp_escape and sum(op=='cmp' for op,d,s in prefix)+args.comparisons<=8:
            escape=add_escape(enc)
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
              repeated_flag=args.repeat_flag,
              repeat_mode=args.repeat_mode if args.repeat_flag else None,
              history_capacity=args.capacity and args.history and enc.origin,
              minimum_useful_comparisons=getattr(enc,'minimum_useful_comparisons',None),
              comparison_escape=escape,
              variables=enc.nv,clauses=len(enc.cs),
              encode_seconds=round(time.monotonic()-start,3))),flush=True)
        status,model,elapsed=solve(enc,tag,args.timeout,args.seed,args.solver,args.proof)
        print(json.dumps(dict(event='RESULT',tag=args.tag,iteration=iteration,
              result=status,solve_seconds=elapsed,
              peak_self_rss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
              peak_child_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss)),flush=True)
        if status!='SATISFIABLE':return
        candidate=ROOT/'round6/programs'/f'{args.tag}_i{iteration}.s'
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
                with open(ROOT/'round6/FOUND','w') as f:f.write(str(candidate)+'\n')
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
