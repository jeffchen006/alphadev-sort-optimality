#!/usr/bin/env python3
# d7: statistics over ana.txt
import sys, collections as C
f = sys.argv[1] if len(sys.argv) > 1 else 'ana.txt'
k240 = C.Counter(); k120 = C.Counter(); kraw = C.Counter()
cnt = {n: C.Counter() for n in ['mv', 'blocks', 'nNL', 'nT', 'nodup', 'maxlive', 'nregs', 'roles', 'rolecnt', 'lastout', 'outorder', 'ndistinctlat', 'Tpos']}
N = 0
for line in open(f):
    p = line.split()
    N += 1
    k240[p[1]] += 1; k120[p[2]] += 1; kraw[p[3]] += 1
    cnt['mv'][(int(p[4]), int(p[5]))] += 1
    cnt['blocks'][p[6]] += 1
    cnt['nNL'][p[7]] += 1; cnt['nT'][p[8]] += 1; cnt['nodup'][p[9]] += 1
    cnt['maxlive'][p[10]] += 1; cnt['nregs'][p[11]] += 1
    ot = list(map(int, p[12].split(',')))
    cnt['lastout'][max(ot)] += 1
    cnt['outorder'][''.join(str(j) for j in sorted(range(5), key=lambda j: ot[j]))] += 1
    cnt['roles'][''.join(sorted(p[13]))] += 1
    for ch in p[13]:
        cnt['rolecnt'][ch] += 1
    lat = p[14].split(',')
    cnt['ndistinctlat'][len(set(x for x in lat if x not in 'TN'))] += 1
    cnt['Tpos'][tuple(i for i, x in enumerate(lat) if x == 'T')] += 1
print('programs', N)
print('distinct DAG keys: raw', len(kraw), ' mod S5', len(k120), ' mod S5 x rev', len(k240))
print('top k240 class sizes', [c for _, c in k240.most_common(10)])
for n, c in cnt.items():
    print(n, c.most_common(12))
