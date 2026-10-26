import sys, random
sys.path.insert(0, 'src')
import winsat as W
class Rec:
    def __init__(self): self.cls = []
    def add_clause(self, c): self.cls.append(list(c))
    def delete(self): pass
prog, names = W.parse_regs(W.read_prog(sys.argv[1]))
i, w, nt = int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4])
used = sorted(set(r for _, d, s in prog for r in (d, s)) | set(range(W.N)))
fr = list(range(max(used) + 1, max(used) + 3))
W.Cadical195 = Rec
enc = W.WinEnc(prog, max(fr) + 1, used, i, w, w - 1, fr)
for k in random.Random(1).sample(range(W.NT), nt): enc.add_test(k)
cls = enc.solver.cls
with open(sys.argv[5], 'w') as f:
    f.write('p cnf %d %d\n' % (enc.C.nv, len(cls)))
    for c in cls: f.write(' '.join(map(str, c)) + ' 0\n')
