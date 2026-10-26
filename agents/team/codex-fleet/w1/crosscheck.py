#!/usr/bin/env python3
"""Independent Python enumeration and copy search on the 120 strict input orders.

The negative four-copy result on this subset is sufficient for a lower bound.
This file does not import or parse search tables from either C++ program.
"""
import itertools
import time
from collections import Counter
from functools import lru_cache

start = time.monotonic()
inputs = tuple(tuple((s >> i) & 1 for s in range(32)) for i in range(5))
target = tuple(sorted(tuple(int(s.bit_count() >= 5-j) for s in range(32)) for j in range(5)))
layers = [{tuple(sorted(inputs)): []}]
for depth in range(9):
    nxt = {}
    for ch, edges in layers[-1].items():
        for i, j in itertools.combinations(range(5), 2):
            a, b = ch[i], ch[j]
            if depth == 0 and {a, b} != {inputs[0], inputs[1]}:
                continue
            mn = tuple(min(x,y) for x,y in zip(a,b))
            mx = tuple(max(x,y) for x,y in zip(a,b))
            if mn in (a,b):
                continue
            following = tuple(sorted([c for k,c in enumerate(ch) if k not in (i,j)] + [mn,mx]))
            nxt.setdefault(following, [])
            edges.append((following, a, b))
    layers.append(nxt)
    assert depth == 8 or target not in nxt
    print('independent depth', depth+1, 'states', len(nxt), flush=True)

good = [None]*10
good[9] = {target}
for depth in reversed(range(9)):
    good[depth] = {ch for ch,edges in layers[depth].items() if any(n in good[depth+1] for n,_,_ in edges)}

def truth_integer(col):
    return sum(v << s for s,v in enumerate(col))

sequences = []
def walk(depth, ch, path):
    if depth == 9:
        sequences.append(tuple(path))
        return
    for following,a,b in layers[depth][ch]:
        if following in good[depth+1]:
            walk(depth+1, following, path + [tuple(sorted((truth_integer(a),truth_integer(b))))])
walk(0, tuple(sorted(inputs)), [])
saved = [tuple(tuple(int(x,16) for x in p.split(':')) for p in line.split()) for line in open('networks.txt')]
assert len(sequences) == 14904
assert len(set(sequences)) == len(sequences)
assert set(sequences) == set(saved)
print('independent sequence set matches all', len(sequences), 'entries', flush=True)

terms = sorted({t for sq in sequences for a,b in sq for t in (a,b,a&b,a|b)})
index = {t:i for i,t in enumerate(terms)}
orders = list(itertools.permutations(range(5)))
universe = (1 << len(orders)) - 1
columns = []
for term in terms:
    col = []
    for w in orders:
        value = 0
        for level in range(1,5):
            mask = sum(1 << i for i,x in enumerate(w) if x >= level)
            if term >> mask & 1:
                value = level
        col.append(value)
    columns.append(tuple(col))

thresholds = [tuple(sum(1 << p for p,x in enumerate(col) if x >= v) for v in range(1,5)) for col in columns]
differences = [[(a[0]^b[0]) | (a[1]^b[1]) | (a[2]^b[2]) | (a[3]^b[3]) for b in thresholds] for a in thresholds]
term_bits = [1 << i for i in range(len(terms))]
initial = tuple(sorted(index[truth_integer(t)] for t in inputs))

@lru_cache(None)
def rules(a,b,t):
    ta,tb = thresholds[a],thresholds[b]
    lt = gt = 0
    for x,y in zip(ta,tb):
        lt |= (universe ^ x) & y
        gt |= x & (universe ^ y)
    result = []
    for condition in (lt, universe ^ gt, gt, universe ^ lt):
        destinations = sources = 0
        for d,bit in enumerate(term_bits):
            mismatch = differences[t][d]
            if not (mismatch & (universe ^ condition)):
                destinations |= bit
            if not (mismatch & condition):
                sources |= bit
        result.append((destinations,sources))
    return tuple(result)

total_states = 0
def gate(layer, rs, t, needed):
    global total_states
    result = set()
    for registers in layer:
        have = 0
        for r in registers:
            have |= term_bits[r]
        dest = 0
        for d,s in rs:
            if have & s:
                dest |= have & d
        if not dest:
            continue
        if len(registers) < 9:
            result.add(tuple(sorted(registers+(t,))))
        while dest:
            bit = dest & -dest
            dest -= bit
            d = bit.bit_length()-1
            if needed & bit and registers.count(d) == 1:
                continue
            new = list(registers)
            new.remove(d)
            new.append(t)
            result.add(tuple(sorted(new)))
    total_states += len(result)
    return result

for number,sq in enumerate(sequences):
    sq = [(index[a],index[b],index[a&b],index[a|b]) for a,b in sq]
    need = [set() for _ in range(9)]
    following = set()
    for j in reversed(range(9)):
        need[j] = following.copy()
        following.update(sq[j][:2])
    made = set(initial)
    layer = {initial}
    for j,(a,b,mn,mx) in enumerate(sq):
        needed = sum(term_bits[t] for t in need[j] & made)
        next_layer = set()
        for t,u in ((mn,mx),(mx,mn)):
            mid = gate(layer, rules(a,b,t), t, needed)
            nxt = gate(mid, rules(a,b,u), u, needed | (term_bits[t] if t in need[j] else 0))
            next_layer.update(nxt)
        layer = next_layer
        made.update((mn,mx))
        if not layer:
            break
    assert not layer, ('four-copy candidate on strict orders',number,sq)
    if (number+1)%500 == 0:
        print('independent copy checks',number+1,'states',total_states,'seconds',round(time.monotonic()-start,2),flush=True)
print('INDEPENDENT CHECK: no four-copy plan for all 14904 sequences on all 120 strict orders',flush=True)
print('states',total_states,'cached gates',rules.cache_info(),'seconds',round(time.monotonic()-start,3),flush=True)
