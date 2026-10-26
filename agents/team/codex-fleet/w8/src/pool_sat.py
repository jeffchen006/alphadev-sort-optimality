#!/usr/bin/env python3
"""SAT routing in a finite value pool with at most two copies per value.

Each action costs one instruction. Comparisons follow the input skeleton.
An output can be recorded when its value first appears. Negative results
apply only to the supplied pool and the two-copy state restriction.
"""
import argparse
import itertools
from pathlib import Path
import time
import subprocess
import re
from pysat.card import CardEnc, EncType
from pysat.formula import CNF, IDPool
from pysat.solvers import Solver

p=argparse.ArgumentParser()
p.add_argument('skeleton')
p.add_argument('cost',type=int)
p.add_argument('output')
p.add_argument('--conflicts',type=int,default=1000000)
p.add_argument('--hint')
p.add_argument('--prefix',type=int,default=0,
               help='Fix this many initial instructions from the hint')
p.add_argument('--verify',action='store_true')
p.add_argument('--solver')
a=p.parse_args()
if a.solver is None: a.solver='g4'
t0=time.monotonic()
P=list(itertools.permutations(range(5)))
CODES=['cmovl','cmovg','cmovle','cmovge']
def col(f):
    if f.startswith('='):
        return tuple(map(int,f[1:]))
    return tuple(max(min(x[int(ch)] for ch in term) for term in f.split('|')) for x in P)
def conds(x,y):
    f=[(u>v)-(u<v) for u,v in zip(x,y)]
    return [tuple(q<0 for q in f),tuple(q>0 for q in f),
            tuple(q<=0 for q in f),tuple(q>=0 for q in f)]
sk=[]
for line in Path(a.skeleton).read_text().splitlines():
    line=line.split('#',1)[0].strip()
    if line:
        sk.append([tuple(col(f) for f in part.split(':')) for part in line.split(';')])
C=len(sk)
inputs=[tuple(x[i] for x in P) for i in range(5)]
targets=[tuple([i]*120) for i in range(5)]
pool=set(inputs+targets)
for alts in sk:
    for x,y in alts:
        pool.update((x,y,tuple(map(min,x,y)),tuple(map(max,x,y))))
if a.hint:
    r={'P%d'%i:x for i,x in enumerate(inputs)}
    for line in Path(a.hint).read_text().splitlines():
        line=line.split('#',1)[0].strip()
        if not line or line.startswith('out'):
            continue
        op,args=line.split(None,1)
        d,s=map(str.strip,args.split(','))
        if op=='cmp':
            hf=conds(r[d],r[s])
        elif op=='mov':
            r[d]=r[s]
            pool.add(r[d])
        else:
            r[d]=tuple(y if b else x for x,y,b in zip(r[d],r[s],hf[CODES.index(op)]))
            pool.add(r[d])
pool=inputs+sorted(pool-set(inputs))
ix={x:i for i,x in enumerate(pool)}
M=len(pool)
goal=[ix[x] for x in targets]
maps=[]
flags=[]
for alts in sk:
    reference=conds(*alts[0])
    flags.append(reference)
    this=[]
    for pair in alts:
        ac=conds(*pair)
        mp=[]
        for cd,mask in enumerate(reference):
            if not any(mask) or all(mask):
                mp.append(0)
            else:
                assert mask in ac,'alternative masks differ'
                mp.append(cd if ac[cd]==mask else ac.index(mask))
        this.append(mp)
    maps.append(this)

# Action: kind, phase, destination term, source term, produced term, detail.
actions=[('nop',-1,-1,-1,-1,-1)]
for z in range(M):
    actions.append(('mov',-1,-1,z,z,-1))
for phase,alts in enumerate(sk):
    for ai,(x,y) in enumerate(alts):
        actions.append(('cmp',phase,ix[x],ix[y],-1,ai))
for phase,reference in enumerate(flags,1):
    seen=set()
    for d,x in enumerate(pool):
        for s,y in enumerate(pool):
            if d==s:
                continue
            for cd,mask in enumerate(reference):
                if not any(mask) or all(mask):
                    continue
                zcol=tuple(v if take else u for u,v,take in zip(x,y,mask))
                z=ix.get(zcol)
                # A full copy can use mov into a fresh register instead.
                semantic_key=(d,s,z,cd) if a.prefix else (d,s,z)
                if z is None or z in (d,s) or semantic_key in seen:
                    continue
                seen.add(semantic_key)
                actions.append(('cmov',phase,d,s,z,cd))

ids=IDPool()
cnf=CNF()
def var(*key):
    return ids.id(key)
def clause(*lits):
    cnf.append(list(lits))
def equivalent_or(v,support):
    clause(-v,*support)
    for u in support:
        clause(-u,v)
def mux(out,c,yes,no):
    clause(-c,-yes,out)
    clause(-c,yes,-out)
    clause(c,-no,out)
    clause(c,no,-out)
F=var('false')
clause(-F)
K=a.cost
input_set=set(inputs)
required=set(inputs)
prefix_need=[0]
for alts in sk:
    common=set(alts[0])
    for pair in alts[1:]:
        common.intersection_update(pair)
    required.update(common)
    prefix_need.append(len(required-input_set))
all_need=len((required|set(targets))-input_set)
# Compute a lower bound with free copies and monotone availability.
# A selected non-input column costs one conditional move to create.
mandatory={ix[x] for x in required|set(targets) if x not in input_set}
optional=[i for i in range(5,M) if i not in mandatory]
initial=(1<<5)-1
mandatory_mask=initial|sum(1<<i for i in mandatory)
target_mask=sum(1<<i for i in goal)
cmp_masks=[[(1<<ix[x])|(1<<ix[y]) for x,y in alts] for alts in sk]
gate_masks=[set() for _ in range(C+1)]
for kind,phase,d,s,z,detail in actions:
    if kind=='cmov':
        gate_masks[phase].add(((1<<d)|(1<<s),1<<z))
gate_masks=[list(s) for s in gate_masks]
def free_reachable(selected):
    available=initial
    for phase in range(1,C+1):
        if not any((available&mask)==mask for mask in cmp_masks[phase-1]):
            return False
        changed=True
        while changed:
            changed=False
            for before,after in gate_masks[phase]:
                if selected&after and not available&after and (available&before)==before:
                    available|=after
                    changed=True
    return (available&target_mask)==target_mask
gate_lb=len(mandatory)
subset_calls=0
stopped=False
for size in range(len(mandatory),min(17,M-5)+1):
    reached=False
    for extra in itertools.combinations(optional,size-len(mandatory)):
        subset_calls+=1
        if subset_calls>2000:
            stopped=True
            break
        if free_reachable(mandatory_mask|sum(1<<i for i in extra)):
            reached=True
            break
    if stopped or reached:
        break
    gate_lb=size+1
print('FREE_COPY_GATE_LB',gate_lb,'subsets=',subset_calls,flush=True)
allowed=[]
for t in range(K):
    ks=[]
    for k,(kind,phase,d,s,z,detail) in enumerate(actions):
        if kind=='cmp' and not (phase+prefix_need[phase+1]<=t<=K-C+phase):
            continue
        if kind=='cmov' and not (phase+prefix_need[phase]<=t<=K-C+phase-1):
            continue
        if kind=='nop' and t<C+all_need:
            continue
        ks.append(k)
    allowed.append(ks)
for t in range(K+1):
    phases=[var('phase',t,j) for j in range(C+1)]
    cnf.extend(CardEnc.equals(phases,1,vpool=ids,encoding=EncType.seqcounter).clauses)
    for j in range(C+1):
        if t<j+prefix_need[j] or t>K-C+j:
            clause(-var('phase',t,j))
for i in range(M):
    clause(var('one',0,i) if i<5 else -var('one',0,i))
    clause(-var('two',0,i))
clause(var('phase',0,0))
for j in range(5):
    clause(-var('out',0,j))
# Each original value must remain in a live register until its output has
# been recorded. Copy-only instructions cannot recover a value after loss.
coverage={(rank,tuple(i for i,x in enumerate(pool) if x[case]==rank))
          for case in range(120) for rank in range(5)}
for t in range(1,K):
    for rank,columns in coverage:
        clause(var('out',t,rank),*[var('one',t,i) for i in columns])
for t in range(K):
    choices={k:var('action',t,k) for k in allowed[t]}
    cnf.extend(CardEnc.equals(list(choices.values()),1,vpool=ids,encoding=EncType.seqcounter).clauses)
    adds=[[] for _ in pool]
    deletes=[[] for _ in pool]
    comparisons=[]
    for k in allowed[t]:
        kind,phase,d,s,z,detail=actions[k]
        q=choices[k]
        if kind=='nop':
            clause(-q,var('phase',t,C))
            for j in range(5):
                clause(-q,var('out',t,j))
        elif kind=='mov':
            clause(-q,var('one',t,s))
            clause(-q,-var('two',t,z))
            adds[z].append(q)
        elif kind=='cmp':
            clause(-q,var('phase',t,phase))
            clause(-q,var('one',t,d))
            clause(-q,var('one',t,s))
            comparisons.append(q)
        else:
            clause(-q,var('phase',t,phase))
            clause(-q,var('one',t,d))
            clause(-q,var('one',t,s))
            clause(-q,-var('two',t,z))
            adds[z].append(q)
            deletes[d].append(q)
    cmp=var('cmp',t)
    equivalent_or(cmp,comparisons)
    equivalent_or(var('move_or_pad',t),[choices[k] for k in allowed[t]
                                      if actions[k][0] in ('mov','nop')])
    for j in range(C+1):
        mux(var('phase',t+1,j),cmp,
            var('phase',t,j-1) if j else F,var('phase',t,j))
    for i in range(M):
        add=var('add',t,i)
        delete=var('delete',t,i)
        equivalent_or(add,adds[i])
        equivalent_or(delete,deletes[i])
        one,two=var('one',t,i),var('two',t,i)
        on,tn=var('one',t+1,i),var('two',t+1,i)
        clause(-add,on)
        clause(-delete,-on,two)
        clause(-delete,on,-two)
        clause(add,delete,-on,one)
        clause(add,delete,on,-one)
        clause(-delete,-tn)
        clause(-add,-tn,one)
        clause(-add,tn,-one)
        clause(delete,add,-tn,two)
        clause(delete,add,tn,-two)
    for j,g in enumerate(goal):
        equivalent_or(var('out',t+1,j),[var('out',t,j),var('add',t,g)])
clause(var('phase',K,C))
for j in range(5):
    clause(var('out',K,j))
if K-C-gate_lb<0:
    clause(F)
else:
    cnf.extend(CardEnc.atmost([var('move_or_pad',t) for t in range(K)],
                             K-C-gate_lb,vpool=ids,encoding=EncType.seqcounter).clauses)
hint=[]
if a.hint:
    r={'P%d'%i:x for i,x in enumerate(inputs)}
    phase=0
    hint_alt={}
    actual_flags=None
    step=0
    for line in Path(a.hint).read_text().splitlines():
        line=line.split('#',1)[0].strip()
        if not line or line.startswith('out'):
            continue
        if step>=K:
            break
        op,args=line.split(None,1)
        d,s=map(str.strip,args.split(','))
        D,S=r.get(d),r[s]
        matching=[]
        if op=='cmp':
            for k,act in enumerate(actions):
                kind,ph,dd,ss,z,detail=act
                if kind=='cmp' and ph==phase and pool[dd]==D and pool[ss]==S:
                    matching.append(k)
            actual_flags=conds(D,S)
            phase+=1
            if matching:
                hint_alt[phase]=actions[matching[0]][5]
        elif op=='mov':
            matching=[k for k,act in enumerate(actions)
                      if act[0]=='mov' and pool[act[3]]==S]
            r[d]=S
        else:
            cd=CODES.index(op)
            Z=tuple(y if b else x for x,y,b in zip(D,S,actual_flags[cd]))
            matching=[k for k,act in enumerate(actions)
                      if act[0]=='cmov' and act[1]==phase and
                      pool[act[2]]==D and pool[act[3]]==S and pool[act[4]]==Z and
                      (phase not in hint_alt or maps[phase-1][hint_alt[phase]][act[5]]==cd)]
            r[d]=Z
        matching=[k for k in matching if k in allowed[step]]
        if matching:
            h=var('action',step,matching[0])
            hint.append(h)
            if step<a.prefix:
                clause(h)
        elif step<a.prefix:
            raise ValueError('hint instruction outside pool: '+line)
        step+=1
    print('HINT mapped=%d fixed_prefix=%d'%(len(hint),a.prefix),flush=True)
print('ENCODED pool=%d actions=%d vars=%d clauses=%d seconds=%.2f'%
      (M,len(actions),ids.top,len(cnf.clauses),time.monotonic()-t0),flush=True)
print('SOLVER',a.solver,flush=True)
with Solver(name=a.solver,bootstrap_with=cnf) as solver:
    if hint:
        solver.set_phases(hint)
    solver.conf_budget(a.conflicts)
    result=solver.solve_limited()
    print('RESULT', 'SAT' if result else 'UNSAT' if result is False else 'LIMIT',
          'seconds=%.2f'%(time.monotonic()-t0),'stats=',solver.accum_stats(),flush=True)
    if result is not True:
        raise SystemExit(0)
    model=set(solver.get_model())

regs={i:['P%d'%i] for i in range(5)}
lines=['# n=5 iset=I1 model=out source=w8_pool_sat']
done=set()
fresh=0
selected_alt={}
for t in range(K):
    k=next(k for k in allowed[t] if var('action',t,k) in model)
    kind,phase,d,s,z,detail=actions[k]
    if kind=='nop':
        continue
    if kind=='cmp':
        lines.append('cmp %s, %s'%(regs[d][0],regs[s][0]))
        selected_alt[phase+1]=detail
        continue
    if kind=='mov':
        dest='S%d'%fresh
        fresh+=1
        lines.append('mov %s, %s'%(dest,regs[s][0]))
    else:
        dest=regs[d].pop()
        op=CODES[maps[phase-1][selected_alt[phase]][detail]]
        lines.append('%s %s, %s'%(op,dest,regs[s][0]))
    regs.setdefault(z,[]).append(dest)
    for j,g in enumerate(goal):
        if z==g and j not in done:
            lines.append('out %d, %s'%(j,dest))
            done.add(j)
Path(a.output).write_text('\n'.join(lines)+'\n')
print('CANDIDATE',a.output,'core=',sum(not l.startswith(('#','out')) for l in lines),flush=True)
if a.verify:
    candidate=Path(a.output)
    check=subprocess.run(['nice','-n','10','python3','src/verify_log.py',str(candidate),
                          candidate.stem],capture_output=True,text=True)
    print(check.stdout+check.stderr,end='',flush=True)
    passed=check.stdout.count('PASS ')==2
    if not passed:
        repaired=candidate.with_name(candidate.stem+'_repaired.s')
        try:
            fix=subprocess.run(['nice','-n','10','python3','src/repair_ties.py',
                                str(candidate),str(repaired)],capture_output=True,text=True,timeout=30)
            print(fix.stdout+fix.stderr,end='',flush=True)
            if repaired.exists():
                check=subprocess.run(['nice','-n','10','python3','src/verify_log.py',
                                      str(repaired),repaired.stem],capture_output=True,text=True)
                print(check.stdout+check.stderr,end='',flush=True)
                passed=check.stdout.count('PASS ')==2
        except subprocess.TimeoutExpired:
            print('TIE_REPAIR TIMEOUT',flush=True)
    print('RESULT','FOUND' if passed else 'REJECTED',flush=True)
