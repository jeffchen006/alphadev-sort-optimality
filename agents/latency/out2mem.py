"""model=out program -> model=mem program (Lemma 4.1 (<=) direction): n loads first (P_i -> fresh S),
body with P_i renamed, each `out j, R` -> store `mov P_j, R` at the same place.  L = k + 2n.
usage: python3 out2mem.py in.s > out.s"""
import sys, re
lines = open(sys.argv[1]).read().splitlines()
head = lines[0]
n = int(re.search(r'\bn=(\d+)', head).group(1))
body = [l.split('#')[0].strip() for l in lines[1:]]
body = [l for l in body if l]
used = set(int(x) for l in body for x in re.findall(r'\bS(\d+)', l))
base = max(used) + 1 if used else 0
ren = {'P%d' % i: 'S%d' % (base + i) for i in range(n)}
sub = lambda r: ren.get(r, r)
out = [re.sub(r'R=\d+', 'R=%d' % (n + base + n), re.sub(r'model=out', 'model=mem', head)) + ' (out2mem)']
out += ['mov %s, P%d' % (ren['P%d' % i], i) for i in range(n)]
for l in body:
    op, args = l.split(None, 1)
    a, b = [x.strip() for x in args.split(',')]
    if op == 'out':
        out.append('mov P%s, %s' % (a, sub(b)))
    else:
        out.append('%s %s, %s' % (op, sub(a), sub(b)))
print('\n'.join(out))
