import sys
p, h = int(sys.argv[1]), int(sys.argv[2])
v = lambda i, j: i * h + j + 1
cl = [[v(i, j) for j in range(h)] for i in range(p)]
cl += [[-v(i, j), -v(k, j)] for j in range(h) for i in range(p) for k in range(i + 1, p)]
print(f"p cnf {p*h} {len(cl)}")
for c in cl: print(" ".join(map(str, c)), 0)
