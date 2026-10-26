#!/usr/bin/env python3
"""Lemma L5 translation (agents/theory/lemmas.md, paper/appendix_proofs.tex), independent of spec's ad2out.py.

usage: l5map.py MEM.s > OUT.s     (MEM.s: model=mem, P<i> = memory cells; loads 'mov S,P', stores 'mov P,S')
Writes a model=out program (out j, R lines) and reports k vs L-2n on stderr.
"""
import sys, re
sys.path.insert(0, __file__.rsplit('/', 1)[0])
import check  # noqa: E402


def translate(prog, n):
    is_load = lambda i: i[0] == 'mov' and i[2][0] == 'P'
    is_store = lambda i: i[0] == 'mov' and i[1][0] == 'P'
    for op, d, s in prog:
        assert not (op != 'mov' and (d[0] == 'P' or s[0] == 'P')), 'MM-1 violated'
        assert not (op == 'mov' and d[0] == 'P' and s[0] == 'P'), 'mem-to-mem mov'
    # segment of each cell at each time; loads per segment
    seg, cur = [], {f'P{i}': 0 for i in range(n)}
    loads = {}  # (cell, seg) -> list of times
    nseg = dict(cur)
    for t, ins in enumerate(prog):
        if is_store(ins):
            cur[ins[1]] += 1
            nseg[ins[1]] = cur[ins[1]]
        seg.append(dict(cur))
        if is_load(ins):
            loads.setdefault((ins[2], cur[ins[2]]), []).append(t)
    fresh = iter(f'S{j}' for j in range(10 ** 6))
    G = {}
    def g(cell, s):
        if s == 0:
            return cell
        if (cell, s) not in G:
            G[(cell, s)] = next(fresh)
        return G[(cell, s)]
    nu = {}
    name = lambda r: nu.setdefault(r, next(fresh))
    out, outs = [], {}
    for t, ins in enumerate(prog):
        op, d, s = ins
        if is_load(ins):
            cell, sg = s, seg[t][s]
            if t == loads[(cell, sg)][-1]:
                nu[d] = g(cell, sg)
            else:
                nu[d] = next(fresh)
                out.append(('mov', nu[d], g(cell, sg)))
        elif is_store(ins):
            cell, sg = d, seg[t][d]
            src = name(s)
            if (cell, sg) in loads:
                out.append(('mov', g(cell, sg), src))
            if sg == nseg[cell]:
                outs[int(cell[1:])] = (src, len(out))
        elif op == 'mov':
            src = name(s)
            nu[d] = next(fresh)
            out.append(('mov', nu[d], src))
        else:
            out.append((op, name(d), name(s)))
    return out, outs


def main():
    prog, meta, _ = check.parse(sys.argv[1])
    n = int(meta['n'])
    out, outs = translate(prog, n)
    lines = [f"# n={n} iset={meta.get('iset', 'I1')} model=out source=l5map({sys.argv[1].split('/')[-1]}) k={len(out)}"]
    pos = 0
    byp = {}
    for j, (r, t) in outs.items():
        byp.setdefault(t, []).append((j, r))
    for t in range(len(out) + 1):
        for j, r in byp.get(t, []):
            lines.append(f'out {j}, {r}')
        if t < len(out):
            lines.append('%s %s, %s' % out[t])
    print('\n'.join(lines))
    L = len(prog)
    sys.stderr.write(f'L={L} n={n} k={len(out)} L-2n={L - 2 * n} {"OK" if len(out) <= L - 2 * n else "VIOLATES"}\n')


if __name__ == '__main__':
    main()
