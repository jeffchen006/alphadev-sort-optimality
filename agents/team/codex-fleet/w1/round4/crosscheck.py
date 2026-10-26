"""Independent scalar edit simulator; compare complete candidate-mask hashes.

The C++ search shares suffix executions across actions. This check executes
individual candidate programs. It does not use that sharing or prefix caches.
"""
import itertools
import json
import os
from pathlib import Path
import subprocess
import time

HERE=Path(__file__).resolve().parent
WORK=HERE.parent
MASK=(1<<64)-1
rows=json.loads((HERE/'manifest.json').read_text())
cases=[tuple(map(int,s.split())) for s in (HERE/'cases.txt').read_text().splitlines()]
expected={w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(max(w)+1))}
assert set(cases)==expected and len(cases)==541
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})

def condition(flag,op):
    if op==2: return flag<0
    if op==3: return flag<=0
    if op==4: return flag>0
    return flag>=0

def simulate(q,gap,ins,case,nr):
    regs=list(case)+[5]*(nr-5)
    goals=sorted(case)
    flag=0
    matches=[0]*5
    def record(slot,register):
        value=regs[register]
        for j in range(5):
            if value==goals[j]: matches[j]|=1<<slot
    for r in range(5): record(r,r)
    for i in range(len(q)+1):
        events=[]
        if i==gap: events.append((ins,5))
        if i<len(q): events.append((q[i],6+i))
        for (op,d,s),slot in events:
            if op==1: flag=(regs[d]>regs[s])-(regs[d]<regs[s])
            elif op==0 or condition(flag,op): regs[d]=regs[s]
            if op!=1: record(slot,d)
    return matches

def digest(candidates):
    h=1469598103934665603
    for ins,have in candidates:
        for v in (*ins,*have): h=((h^v)*1099511628211)&MASK
    return h

start=time.process_time()
count_slots=count_candidates=count_audits=0
selections=[(0,0),(0,31),(0,244),(0,495),(55,31),(120,244),
            (143,0),(143,495),(144,31),(151,244),(169,0),(169,495)]
for index,pair in selections:
    row=rows[index]
    a,b=list(itertools.combinations(range(32),2))[pair]
    q=[ins for i,ins in enumerate(z for z in row['code'] if z[0]!=6) if i not in (a,b)]
    log=HERE/f'cross_cpp_{index}_{pair}.log'
    with log.open('w') as out:
        subprocess.run([str(HERE/'edit'),str(HERE/'bases.txt'),str(index),str(index+1),
                        '1',str(pair),str(pair+1),str(HERE/'cross_unused'),'0','8'],
                       check=True,stdout=out)
    actual=[line.split()[1:] for line in log.read_text().splitlines() if line.startswith('AUDIT ')]
    independent=[]
    nr=len(row['registers'])+1
    for gap in range(len(q)+1):
        count_slots+=1
        candidates=[((op,d,s),[MASK]*5) for op in range(6) for d in range(nr) for s in range(nr)]
        count_candidates+=len(candidates)
        for t,case in enumerate(cases[:8]):
            if not candidates: break
            retained=[]
            for ins,have in candidates:
                got=simulate(q,gap,ins,case,nr)
                have=[x&y for x,y in zip(have,got)]
                if all(have): retained.append((ins,have))
            candidates=retained
            independent.append(list(map(str,(row['name'],pair,gap,t,len(candidates),digest(candidates)))))
    assert independent==actual,(index,pair,next((x,y) for x,y in itertools.zip_longest(independent,actual) if x!=y))
    count_audits+=len(actual)
    print('MATCH',index,pair,'slots',len(q)+1,'audits',len(actual),flush=True)
print('PASS independent candidate-mask audit',count_slots,'slots',count_candidates,
      'candidate programs',count_audits,'case-boundary hashes',
      'cpu',round(time.process_time()-start,3),flush=True)
