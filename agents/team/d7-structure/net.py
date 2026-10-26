#!/usr/bin/env python3
# d7: lattice-term level analysis of ana.txt. fam = 32-bit monotone Boolean fn (bit S = f(1_S)); min = AND, max = OR.
import sys, itertools, collections as C
f = sys.argv[1] if len(sys.argv) > 1 else 'ana.txt'
LIM = int(sys.argv[2]) if len(sys.argv) > 2 else 10**9
PERMS = list(itertools.permutations(range(5)))
def smap(p):
    return [sum(1 << p[i] for i in range(5) if S >> i & 1) for S in range(32)]
SM = [smap(p) for p in PERMS]
def act(fam, g, rev):
    if rev:
        fam = sum(1 << S for S in range(32) if not (fam >> (31 & ~S) & 1))
    sm = SM[g]
    return sum(1 << sm[S] for S in range(32) if fam >> S & 1)
X = [sum(1 << S for S in range(32) if S >> i & 1) for i in range(5)]
def canon_seq(pairs):
    # canonical sequence of unordered pairs (comparator sequence) under S5 x rev
    best = None
    for rev in (0, 1):
        for g in range(120):
            k = tuple(tuple(sorted((act(a, g, rev), act(b, g, rev)))) for a, b in pairs)
            if best is None or k < best: best = k
    return best
st = C.Counter(); nets = C.Counter(); netsets = C.Counter(); otag = C.Counter(); tagc = C.Counter()
operand_src = C.Counter(); termsets = C.Counter(); cache = {}
N = 0
for line in open(f):
    p = line.split(); N += 1
    if N > LIM: break
    lat = p[14].split(','); tags = p[15]
    pairs = [tuple(int(x, 16) for x in q.split(':')) for q in p[16].split(',')]
    terms = set(int(x, 16) for x in lat if x not in 'TN')
    mm = set()
    for a, b in pairs: mm.add(a & b); mm.add(a | b)
    st['terms==minmax(cmp pairs)' if terms == mm else 'terms!=minmax'] += 1
    st['minmax subset terms' if mm <= terms else 'minmax not subset'] += 1
    # operands available: inputs or created before the cmp (network property)
    avail = set(X); ok = True
    # need order: cmp i operands must be in X or in terms created by earlier cmovs; approximate with min/max closure
    for a, b in pairs:
        if a not in avail or b not in avail: ok = False
        avail.add(a & b); avail.add(a | b)
    st['network (operands from earlier comparators)' if ok else 'not network-order'] += 1
    key = tuple(pairs)
    if key not in cache: cache[key] = canon_seq(pairs)
    nets[cache[key]] += 1
    for t in tags: tagc[t] += 1
print('programs', N)
for k, v in st.items(): print(k, v)
print('distinct comparator sequences (semantic, raw):', len(cache), ' mod S5 x rev:', len(nets))
print('class sizes:', [v for _, v in nets.most_common(40)])
print('cmov tags (m/M = min/max of current cmp new, a/A repeat, o/p other new/repeat, T garbage-partial, N non-lattice):', tagc.most_common())
import pickle; pickle.dump(nets, open('nets.pkl', 'wb'))
