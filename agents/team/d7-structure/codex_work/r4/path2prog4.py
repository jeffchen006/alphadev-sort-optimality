#!/usr/bin/env python3
# d7: path2prog.py POOL PATHFILE OUT : turn a pool_bfs FOUND path (state sequence) into an M_out program
import sys, itertools
pool = [tuple(map(int, l.split())) for l in open(sys.argv[1])]
lines = open(sys.argv[2]).read().split('FOUND')[1].split('\n')[1:]
states = []
for l in lines:
    l = l.strip()
    if not l.startswith('regs'): 
        if states: break
        continue
    parts = l.split('flag')
    regs = sorted(map(int, parts[0].split()[1:]))
    fl = tuple(map(int, parts[1].split(':'))) if len(parts) > 1 else None
    states.append((regs, fl))
outs = []
for j in range(4):
    v = tuple(sorted(pool[i][t] for i in range(4))[j] for t in range(75))
    outs.append(pool.index(v))
names = ['P%d' % i for i in range(4)] + ['S%d' % i for i in range(10)]
reg = {names[i]: i for i in range(4)}  # name -> pool idx
flag = None; prog = []; emitted = set()
def emit():
    for n, t in reg.items():
        for j in range(4):
            if t == outs[j] and j not in emitted: emitted.add(j); prog.append('out %d, %s' % (j, n))
CS = {'cmovl': (-1,), 'cmovle': (-1, 0), 'cmovg': (1,), 'cmovge': (1, 0)}
for (r0, f0), (r1, f1) in zip(states, states[1:]):
    done = False
    cand = []
    live = list(reg)
    free = [n for n in names if n not in reg][:1]
    for d in live + free:
        for s in live:
            if d != s: cand.append(('mov', d, s))
    for a, b in itertools.combinations(live, 2): cand.append(('cmp', a, b))
    for d in live:
        for s in live:
            if d != s:
                for c in CS: cand.append((c, d, s))
    for op, d, s in cand:
        nr = dict(reg); nf = flag
        if op == 'mov': nr[d] = reg[s]
        elif op == 'cmp': nf = (reg[d], reg[s])
        else:
            if flag is None: continue
            P, Q = pool[flag[0]], pool[flag[1]]; D, S = pool[reg[d]], pool[reg[s]]
            v = tuple(S[k] if ((P[k] > Q[k]) - (P[k] < Q[k])) in CS[op] else D[k] for k in range(75))
            if v not in pool: continue
            nr[d] = pool.index(v)
        nfs = tuple(sorted(nf)) if nf else None
        if sorted(nr.values()) == r1 and nfs == (tuple(f1) if f1 else None):
            reg, flag = nr, nf; prog.append('%s %s, %s' % (op, d, s)); emit(); done = True; break
    if not done: sys.exit('no transition found')
with open(sys.argv[3], 'w') as f:
    f.write('# n=4 iset=I1 model=out source=d7 pool_bfs k=%d\n' % sum(1 for p in prog if not p.startswith('out')) + '\n'.join(prog) + '\n')
print(open(sys.argv[3]).read())
