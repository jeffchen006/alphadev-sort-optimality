"""all templates from rev3 outputs (L4 in {20,21}): core cmp slots fixed (columns over 120 perms), ext '*'.
Dedupe; count. Output tpls.txt: count \t L4 \t first global idx \t template (slots ' '-separated)"""
import sys, itertools, collections; sys.path.insert(0, '..')
from d5lib import read_progs
recs = {}
for f in range(4):
    for line in open(f'../rev3_out.{f}'):
        parts = line.rstrip('\n').split(' | ')
        if len(parts) < 4 or parts[3].count(';') < 19: continue
        L4 = int(parts[1]); loc = int(parts[0].split()[0])
        if L4 > 21: continue
        recs[loc * 4 + f] = (L4, set(int(x) for x in parts[2].split('keep')[1].split()))
P = list(itertools.permutations(range(5)))
cnt = collections.Counter(); first = {}
mx = max(recs)
for gi, p in enumerate(read_progs('/path/to/repo/agents/upper/runs/r4/s5k32_coll.txt.gz')):
    if gi > mx: break
    if gi not in recs: continue
    L4, keep = recs[gi]
    cidx = [i for i, x in enumerate(p) if x[0] == 'cmp']
    cols = [([], []) for _ in cidx]
    for t in P:
        r = {'P%d' % i: t[i] for i in range(5)}; fl = None; k = 0
        for o, d, s in p:
            if o == 'cmp':
                cols[k][0].append(r.get(d, 9)); cols[k][1].append(r.get(s, 9)); k += 1
                fl = 'l' if r[d] < r[s] else 'g' if r[d] > r[s] else 'e'
            elif o == 'mov': r[d] = r[s]
            else:
                c = o[4:]
                if (fl == 'l' and 'l' in c) or (fl == 'g' and 'g' in c) or (fl == 'e' and c.endswith('e')): r[d] = r[s]
    slots = []
    for k, ci in enumerate(cidx):
        if ci in keep:
            a, b = ''.join(map(str, cols[k][0])), ''.join(map(str, cols[k][1]))
            a, b = min(a, b), max(a, b)
            slots.append('=%s:=%s' % (a, b))
        else: slots.append('*')
    key = (L4, ' '.join(slots)); cnt[key] += 1; first.setdefault(key, gi)
with open('tpls.txt', 'w') as fo:
    for (L4, t), n in cnt.most_common(): fo.write(f'{n}\t{L4}\t{first[(L4, t)]}\t{t}\n')
print('programs', len(recs), 'templates', len(cnt), 'L4=20:', sum(1 for k in cnt if k[0] == 20), 'top', [n for _, n in cnt.most_common(10)])
print('free-slot patterns', collections.Counter(''.join('*' if s == '*' else 'C' for s in k[1].split()) for k in cnt).most_common(8))
