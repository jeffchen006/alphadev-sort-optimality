"""dedupe templates under S5 x reversal (input relabeling, order reversal). Output tplc.txt: count, L4, gi, canon tpl"""
import itertools, collections
P = list(itertools.permutations(range(5))); PI = {p: i for i, p in enumerate(P)}
maps = []
for s in itertools.permutations(range(5)):
    for rev in (0, 1):
        m = []
        for t in P:
            tt = tuple(t[s[i]] for i in range(5))
            if rev: tt = tuple(4 - v for v in tt)
            m.append(PI[tt])
        maps.append((m, rev))
def tr(col, m, rev):
    return ''.join(str(4 - int(col[m[t]])) if rev else col[m[t]] for t in range(120))
def canon(slots):
    best = None
    for m, rev in maps:
        out = []
        for s in slots:
            if s == '*': out.append(s); continue
            a, b = s.split(':'); a, b = tr(a[1:], m, rev), tr(b[1:], m, rev)
            a, b = min(a, b), max(a, b); out.append('=%s:=%s' % (a, b))
        k = ' '.join(out)
        if best is None or k < best: best = k
    return best
cnt = collections.Counter(); info = {}
for line in open('tpls.txt'):
    n, L4, gi, t = line.rstrip('\n').split('\t')
    k = (int(L4), canon(t.split()))
    cnt[k] += int(n); info.setdefault(k, gi)
with open('tplc.txt', 'w') as fo:
    for (L4, t), n in cnt.most_common(): fo.write(f'{n}\t{L4}\t{info[(L4, t)]}\t{t}\n')
print('canon templates', len(cnt), 'L4=20', sum(1 for k in cnt if k[0] == 20), 'top', [(n, k[0]) for k, n in cnt.most_common(12)])
