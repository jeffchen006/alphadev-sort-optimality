"""group completions of one prefix by normalized flag vectors of the completion cmps -> dagx alternatives files."""
import sys, collections, os
src, P, outdir = sys.argv[1], int(sys.argv[2]), sys.argv[3]
os.makedirs(outdir, exist_ok=True)
def flag(w):
    a, b = w.split(':'); a, b = a[1:], b[1:]
    f = ''.join('l' if x < y else 'g' if x > y else 'e' for x, y in zip(a, b))
    r = f.translate(str.maketrans('lg', 'gl'))
    return min(f, r)
G = collections.OrderedDict()
for l in open(src):
    ws = l.split()
    k = tuple(flag(w) for w in ws[P:])
    g = G.setdefault(k, {'pre': ws[:P], 'alt': [collections.OrderedDict() for _ in ws[P:]]})
    for q, w in enumerate(ws[P:]): g['alt'][q][w] = 1
for n, (k, g) in enumerate(G.items()):
    with open(f'{outdir}/g{n:05d}.txt', 'w') as fo:
        for w in g['pre']: fo.write(w + '\n')
        for alt in g['alt']: fo.write(';'.join(alt) + '\n')
sizes = [1 for _ in G]
print('groups', len(G), 'from', sum(1 for _ in open(src)))
