#!/usr/bin/env python3
"""Extract AlphaDev Sort{3,4,5}AlphaDev asm (AT&T) from sort_functions_test.cc and
write it in MODEL.md section-5 format (Intel order).
Translation (x86 agent, independent of spec):
  memory cell buffer[i]  ->  P<i>        (inputs at start, sorted outputs at end)
  real register r        ->  S<j>        (j = order of first appearance)
So every AlphaDev instruction maps to exactly one model instruction: k = L.
"""
import re, sys
src = open(sys.argv[1]).read()
outdir = sys.argv[2]
for n in (3, 4, 5):
    m = re.search(r'void Sort%dAlphaDev\(int\* buffer\) \{\s*asm volatile\((.*?)\s*:\s*"\+r"' % n, src, re.S)
    lines = re.findall(r'"([^"]*?)\s*\\n"', m.group(1))
    regs = {}
    def opnd(t):
        t = t.strip()
        mm = re.fullmatch(r'(0x[0-9a-f]+)?\(%0\)', t)
        if mm:
            off = int(mm.group(1), 16) if mm.group(1) else 0
            assert off % 4 == 0 and off // 4 < n
            return 'P%d' % (off // 4)
        mm = re.fullmatch(r'%%(\w+)', t)
        assert mm, t
        r = mm.group(1)
        regs.setdefault(r, 'S%d' % len(regs))
        return regs[r]
    body = []
    for ln in lines:
        op, rest = ln.split(None, 1)
        a, b = [x for x in re.split(r',\s*(?![^()]*\))', rest)]
        src_o, dst_o = opnd(a), opnd(b)          # AT&T: op src, dst
        body.append('%s %s, %s' % (op, dst_o, src_o))  # Intel: op dst, src
    iset = 'I1' if any(l.split()[0] in ('cmovle', 'cmovge') for l in body) else 'I0'
    hdr = '# n=%d R=%d iset=%s source=AlphaDev sort_functions_test.cc Sort%dAlphaDev (converted by agents/x86/src/extract_alphadev.py)\n' % (n, n + len(regs), iset, n)
    hdr += '# L=%d ; S map: %s\n' % (len(body), ' '.join('%s=%s' % (v, k) for k, v in regs.items()))
    open('%s/alphadev_sort%d.s' % (outdir, n), 'w').write(hdr + '\n'.join(body) + '\n')
    print(n, len(body), iset, regs)
