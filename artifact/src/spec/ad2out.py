#!/usr/bin/env python3
"""Map an AlphaDev memory-model program (model=mem, length L) to model=out (cost k), as in the proof of
L_AD = 2n + k_out (MODEL.md §4). Prints the new program; k <= L - 2n is the claim.

  python3 agents/spec/tools/ad2out.py programs/orig/X.s > Y.s
"""
import re
import sys

sys.path.insert(0, __file__.rsplit('/agents/', 1)[0] + '/shared')
import judge  # noqa: E402


def convert(text):
    hdr, prog = judge.parse(text)
    n = int(hdr['n'])
    fresh = [0]

    def new():
        fresh[0] += 1
        return 'S%d' % (fresh[0] - 1)

    # pristine loads of cell i = loads before the first store to cell i
    first_store = {}
    for t, (op, a, b, _) in enumerate(prog):
        if op == 'mov' and a[0] == 'P':
            first_store.setdefault(a, t)
    last_pristine = {}
    for t, (op, a, b, _) in enumerate(prog):
        if op == 'mov' and b[0] == 'P' and t < first_store.get(b, len(prog)):
            last_pristine[b] = t
    # is cell j reloaded after store t (before the next store to j)?
    def reloaded(t, cell):
        for op, a, b, _ in prog[t + 1:]:
            if op == 'mov' and a == cell:
                return False
            if op == 'mov' and b == cell:
                return True
        return False

    def last_reload(t, c):
        for op, x, y, _ in prog[t + 1:]:
            if op == 'mov' and x == c:
                return True
            if op == 'mov' and y == c:
                return False
        return True

    m, out, cell = {}, [], {}
    reg = lambda r: m.setdefault(r, new()) if r[0] == 'S' else r  # unseen S = garbage register
    for t, (op, a, b, _) in enumerate(prog):
        if op == 'mov' and b[0] == 'P':                       # load
            if t < first_store.get(b, len(prog)):
                if last_pristine[b] == t:
                    m[a] = b                                  # rename live range to P_i, no instruction
                else:
                    m[a] = new()
                    out.append('mov %s, %s' % (m[a], b))
            elif last_reload(t, b):
                m[a] = cell[b]                                # last reload: rename, no instruction
            else:
                m[a] = new()
                out.append('mov %s, %s' % (m[a], cell[b]))
        elif op == 'mov' and a[0] == 'P':                     # store
            j = int(a[1:])
            out.append('out %d, %s' % (j, reg(b)))
            if reloaded(t, a):
                cell[a] = new()
                out.append('mov %s, %s' % (cell[a], reg(b)))
        elif op == 'mov':
            src = reg(b)
            m[a] = new()
            out.append('mov %s, %s' % (m[a], src))
        else:
            out.append('%s %s, %s' % (op, reg(a), reg(b)))
    k = sum(not l.startswith('out') for l in out)
    L = len(prog)
    head = '# n=%d iset=%s model=out source=ad2out(%s) k=%d L_AD=%d L-2n=%d' % (
        n, hdr.get('iset', 'I1'), hdr.get('source', '?'), k, L, L - 2 * n)
    return '\n'.join([head] + out) + '\n', k, L, n


if __name__ == '__main__':
    text, k, L, n = convert(open(sys.argv[1]).read())
    sys.stdout.write(text)
    sys.stderr.write('k=%d L=%d L-2n=%d %s\n' % (k, L, L - 2 * n, 'OK' if k <= L - 2 * n else 'VIOLATES k<=L-2n'))
