#!/usr/bin/env python3
"""Convert AlphaDev AT&T inline asm (repo .cc or supplement Appendix G text) to programs/*.s format.

Map: memory 4*i(%0) -> P<i>; x86 registers -> S<j> in order of first appearance.
AT&T "op src, dst" -> Intel "op dst, src". AT&T "cmp X, Y" sets flags from Y - X -> our "cmp Y, X".
"""
import re
import sys

LINE = re.compile(r'"\s*([a-z]+)\s+([^,]+?)\s*,\s*([^\\"]+?)\s*\\n"')


def operand(tok, regmap):
    tok = tok.strip()
    m = re.fullmatch(r'(0x[0-9a-f]+|\d*)\(%0\)', tok)
    if m:
        off = int(m.group(1), 16) if m.group(1).startswith('0x') else int(m.group(1) or 0)
        assert off % 4 == 0
        return 'P%d' % (off // 4)
    m = re.fullmatch(r'%%([a-z0-9]+)', tok)
    assert m, tok
    r = m.group(1)
    if r not in regmap:
        regmap[r] = 'S%d' % len(regmap)
    return regmap[r]


def functions(text):
    """Yield (name, [raw asm lines]) for each 'void Name(int* buffer)' with asm volatile."""
    for m in re.finditer(r'void (\w+)\(int\* buffer\) \{\s*asm volatile\((.*?)\: "\+r"\(buffer\)', text, re.S):
        body = m.group(2)
        lines = [l for l in re.findall(r'"[^"]*\\n"', body)]
        yield m.group(1), lines


def convert(lines):
    regmap = {}
    out = []
    for raw in lines:
        m = LINE.fullmatch(raw.strip())
        assert m, raw
        op, a, b = m.groups()
        if op == 'movl':
            op = 'mov'
        if op == 'cmovgel':
            op = 'cmovge'
        src, dst = operand(a, regmap), operand(b, regmap)
        if op == 'cmp':
            out.append('cmp %s, %s' % (dst, src))
        else:
            out.append('%s %s, %s' % (op, dst, src))
    return out, regmap


if __name__ == '__main__':
    path, outdir, tag = sys.argv[1], sys.argv[2], sys.argv[3]
    text = open(path).read()
    for name, lines in functions(text):
        m = re.fullmatch(r'Sort(\d)(?:AlphaDev|_(\d+))', name)
        if not m:
            continue
        n = int(m.group(1))
        prog, regmap = convert(lines)
        R = n + len(regmap)
        fname = '%s/alphadev_sort%d_%d_%s.s' % (outdir, n, len(prog), tag)
        with open(fname, 'w') as f:
            f.write('# n=%d R=%d iset=I1 model=mem source=%s:%s\n' % (n, R, tag, name))
            f.write('# L=%d (every instruction counts). regs: %s\n' % (
                len(prog), ' '.join('%s=%s' % (v, k) for k, v in regmap.items())))
            for p, raw in zip(prog, lines):
                f.write('%-16s # %s\n' % (p, raw.strip()[1:-3].strip()))
        print(fname)
