import sys, gzip; sys.path.insert(0, '.')
from d5lib import canon, parse_key, check_out
from collections import Counter
from multiprocessing import Pool
L = [l.strip() for l in open(sys.argv[1]) if l.count(';') == 19]
def f(k): return canon(parse_key(k))
if __name__ == '__main__':
    with Pool(4) as p: ks = p.map(f, L, chunksize=500)
    c = Counter(ks); top = c.most_common()
    print('cores', len(L), 'distinct', len(c), 'top counts', [n for _, n in top[:15]])
    s4 = set()
    with gzip.open('s4_canon.txt.gz', 'rt') as fi:
        for line in fi: s4.add(line.split('\t')[1].strip())
    print('in s4k20 collection:', sum(1 for k in c if k in s4), 'of', len(c))
    print('check top', all(check_out(parse_key(k), 4) for k, _ in top[:50]))
    with open('cores_top.txt', 'w') as fo:
        for k, n in top: fo.write(f'{n}\t{k}\n')
