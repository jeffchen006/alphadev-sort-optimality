import sys, gzip
from multiprocessing import Pool
sys.path.insert(0, '.')
from d5lib import read_progs, canon
def f(p): return canon(p)
if __name__ == '__main__':
    progs = list(read_progs(sys.argv[1]))
    print('read', len(progs), flush=True)
    with Pool(14) as pool:
        keys = pool.map(f, progs, chunksize=2000)
    from collections import Counter
    c = Counter(keys)
    print('distinct canon', len(c), flush=True)
    with gzip.open(sys.argv[2], 'wt') as fo:
        for k, v in c.most_common(): fo.write(f'{v}\t{k}\n')
