import sys, gzip; sys.path.insert(0, '.')
from d5lib import read_progs
from collections import Counter
recs = {}
for f in range(4):
    for line in open(f'rev3_out.{f}'):
        parts = line.rstrip('\n').split(' | ')
        if len(parts) < 4 or parts[1].strip() != '20' or parts[3].count(';') != 19: continue
        loc = int(parts[0].split()[0]); keep = [int(x) for x in parts[2].split('keep')[1].split()]
        recs[loc * 4 + f] = (parts[2].split()[0], keep)
mx = max(recs)
prof = Counter(); nblk = Counter(); shared = Counter(); combo = Counter()
for g, p in enumerate(read_progs('../../upper/runs/r4/s5k32_coll.txt.gz')):
    if g > mx: break
    if g not in recs: continue
    m, keep = recs[g]; ks = set(keep)
    ext = [i for i in range(len(p)) if i not in ks]
    ncmp = sum(p[i][0] == 'cmp' for i in ext)
    prof[ncmp] += 1
    blocks = sum(1 for j, i in enumerate(ext) if j == 0 or ext[j - 1] != i - 1)
    nblk[blocks] += 1
    # core cmovs reading flags of an extension cmp
    last = None; sh = 0
    for i, ins in enumerate(p):
        if ins[0] == 'cmp': last = i
        elif ins[0] != 'mov' and i in ks and last is not None and last not in ks: sh += 1
    shared[sh] += 1
    combo[(ncmp, 12 - ncmp, sh)] += 1
print('programs', sum(prof.values()))
print('#cmp in extension:', sorted(prof.items()))
print('#blocks of extension:', sorted(nblk.items()))
print('#core cmovs reading extension flags:', sorted(shared.items()))
print('(ext cmp, ext write, shared):', combo.most_common(8))
