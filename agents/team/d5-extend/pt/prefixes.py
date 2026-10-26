import glob, sys, itertools, collections
sys.path.insert(0, '../gx')
exec(open('../gx/canontpl.py').read().split('cnt = collections')[0])  # maps, tr, canon
pre = collections.OrderedDict(); n8 = 0
for f in sorted(glob.glob('../../d4-evolve/runs/skel/d4_*.txt')):
    L = open(f).read().split('\n')
    if 'c=8' not in L[0]: continue
    n8 += 1
    ws = [l.strip() for l in L if l.strip() and not l.startswith('#')]
    if len(ws) != 8 or not all(w.startswith('=') for w in ws): continue
    k = canon(ws[:6]); pre.setdefault(k, f)
print('c=8 files', n8, 'distinct 6-prefixes', len(pre))
with open('prefixes6.txt', 'w') as fo:
    for k, f in pre.items(): fo.write(f + '\t' + k + '\n')
