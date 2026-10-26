"""d5-extend pair-tracking skeletons: 5 wires; step = compare wires (a,b), then on a>b swap a set of wire pairs:
mode 0 {ab}, mode 1 {ab, cd}, mode 2 {cd} (cd disjoint from ab). Operand columns = wire values (input index per perm).
Prune: after step j every flag class has size <= 2^(C-j) (perms: each cmp of 2 distinct inputs is binary).
Output: distinct operand-column skeletons (dagx explicit format: one cmp per line as =<120 values>:=<120 values>)."""
import itertools, sys
import numpy as np
C = int(sys.argv[1]); out = sys.argv[2]
P = np.array(list(itertools.permutations(range(5))), dtype=np.int8)  # P[t][i] = value (rank) of input i
pairs = [(a, b) for a in range(5) for b in range(a + 1, 5)]
moves = []
for a, b in pairs:
    rest = [w for w in range(5) if w not in (a, b)]
    moves.append((a, b, [(a, b)]))
    for c, d in itertools.combinations(rest, 2):
        moves.append((a, b, [(a, b), (c, d)])); moves.append((a, b, [(c, d)]))
seen = set(); cnt = [0] * (C + 1)
def rec(j, W, lab, ops):
    # W: (120,5) wire contents as VALUES (ranks); lab: class id per perm
    if j == C:
        if len(set(lab.tolist())) == 120:
            key = tuple(ops)
            if key not in seen: seen.add(key)
        return
    bound = 2 ** (C - j - 1)
    for a, b, sw in moves:
        if j == 0 and (a, b) != (0, 1): continue
        f = (W[:, a] > W[:, b])
        nl = lab * 2 + f
        _, c = np.unique(nl, return_counts=True)
        if c.max() > bound: continue
        W2 = W.copy()
        for c1, d1 in sw:
            x = W2[f, c1].copy(); W2[f, c1] = W2[f, d1]; W2[f, d1] = x
        u, inv = np.unique(nl, return_inverse=True)
        cnt[j + 1] += 1
        rec(j + 1, W2, inv.astype(np.int64), ops + [(W[:, a].tobytes(), W[:, b].tobytes())])
rec(0, P.copy(), np.zeros(120, dtype=np.int64), [])
print('C', C, 'nodes per level', cnt, 'skeletons', len(seen))
with open(out, 'w') as fo:
    for sk in seen:
        fo.write(' '.join('=%s:=%s' % (''.join(map(str, np.frombuffer(a, np.int8))), ''.join(map(str, np.frombuffer(b, np.int8)))) for a, b in sk) + '\n')
