#!/usr/bin/env python3
"""Use the existing c<=8 exclusion for all-lattice comparison columns.

For conservative columns on strict permutations, a min/max term has one
threshold bit for each subset of input origins. Threshold disagreement, or a
scratch value, witnesses an operand outside this family. This is a necessary
condition based on the user-supplied completed lattice-comparison exclusion.
"""
import itertools
from pathlib import Path
import random
import sys
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'round4/src'))
from insertion_sat import CNF,PERMS,parse,run


def is_lattice(column,types=PERMS):
    table={}
    for ty,value in zip(types,column):
        if value not in ty:return False
        for q in range(1,5):
            mask=sum(1<<i for i,v in enumerate(ty) if v>=q)
            high=value>=q
            if mask in table and table[mask]!=high:return False
            table[mask]=high
    return True


def add_escape(enc):
    strict=[i for i,ty in enumerate(enc.types) if len(set(ty))==5]
    if len(strict)!=120 or {tuple(enc.types[i]) for i in strict}!={tuple(t) for t in PERMS}:
        return 'not-full-strict-set'
    types=[enc.types[i] for i in strict]
    if enc.prefix:
        rows=[run(enc.prefix,ty,True)[3] for ty in types]
        for i,(op,d,s) in enumerate(enc.prefix):
            if op!='cmp':continue
            for name in (d,s):
                column=[row[i][0].get(name,5) for row in rows]
                if not is_lattice(column,types):return 'prefix-already-outside'
    witnesses=[]
    for pair in enc.cmpval:
        for side in pair:
            highs={};groups={}
            for t in strict:
                bits=side[t]
                garbage=enc.new();witnesses.append(garbage)
                for b in range(3):enc.cl(-garbage,bits[b] if (5>>b)&1 else enc.neg(bits[b]))
                ty=enc.types[t]
                for q in range(1,5):
                    high=enc.new();highs[t,q]=high
                    mask=sum(1<<i for i,v in enumerate(ty) if v>=q)
                    groups.setdefault(mask,[]).append((t,q))
                    for value in range(6):
                        guard=[enc.neg(bits[b]) if (value>>b)&1 else bits[b] for b in range(3)]
                        rank=ty[value] if enc.origin and value<5 else value
                        enc.cl(*guard,high if rank>=q else -high)
            for group in groups.values():
                anchor=highs[group[0]]
                for key in group[1:]:
                    other=highs[key];different=enc.new();witnesses.append(different)
                    enc.cl(-different,anchor,other)
                    enc.cl(-different,-anchor,-other)
    enc.cl(*witnesses)
    return 'suffix-witness'


def column_pairs(program):
    parsed=parse(program);rows=[run(parsed,ty,True)[3] for ty in PERMS]
    result=[]
    for i,(op,d,s) in enumerate(parsed):
        if op=='cmp':result.append([[row[i][0].get(n,5) for row in rows] for n in (d,s)])
    return result


def static_query(columns,origin):
    from pysat.solvers import Solver
    enc=CNF();enc.types=PERMS;enc.origin=origin;enc.prefix=[]
    enc.cmpval=[]
    for pair in columns:
        encoded=[]
        for col in pair:
            side=[]
            for ty,value in zip(PERMS,col):
                code=ty.index(value) if origin and value<5 else value
                side.append([bool((code>>b)&1) for b in range(3)])
            encoded.append(side)
        enc.cmpval.append(encoded)
    assert add_escape(enc)=='suffix-witness'
    with Solver(bootstrap_with=enc.cs) as solver:return solver.solve()


def main():
    import json
    import os
    import resource
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    initial=[tuple(t[i] for t in PERMS) for i in range(5)]
    rng=random.Random(1);pool=list(initial)
    for _ in range(500):
        a,b=rng.sample(pool,2);op=min if rng.randrange(2) else max
        col=tuple(op(x,y) for x,y in zip(a,b));assert is_lattice(col);pool.append(col)
    partner=tuple(min(ty[:2]) if max(ty[:2])>max(ty[2:4]) else min(ty[2:4]) for ty in PERMS)
    assert not is_lattice(partner)
    reference=column_pairs(ROOT/'programs/construct_fj_k53.s')
    assert len(reference)==7
    assert any(not is_lattice(col) for pair in reference for col in pair)
    fixtures=[('input',[[initial[0],initial[1]]],False),
              ('random_terms',[[pool[-1],pool[-2]]],False),
              ('partner',[[partner,initial[4]]],True),
              ('garbage',[[(5,)*120,initial[4]]],True),
              ('reference53',reference,True)]
    results=[]
    for origin in (False,True):
        for name,columns,expected in fixtures:
            actual=static_query(columns,origin)
            assert actual==expected,(name,origin,actual,expected)
            results.append(dict(name=name,origin=origin,satisfiable=actual))
    output=dict(status='PASS',random_lattice_columns=500,fixtures=results,
                reference=str((ROOT/'programs/construct_fj_k53.s').relative_to(ROOT)),
                note='Property-encoding controls; no new assembly candidate or judge PASS.')
    (ROOT/'round6/logs/cmp_escape_audit.json').write_text(json.dumps(output,indent=2)+'\n')
    print(json.dumps(output),flush=True)

if __name__=='__main__':main()
