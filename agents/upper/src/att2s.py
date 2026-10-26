#!/usr/bin/env python3
"""Convert AlphaDev AT&T inline asm (sort_functions_test.cc) into upper's .s formats.
  mem  : exact AlphaDev counting. M<i> = buffer[i]; loads/stores are mov. Length = L.
  free : registers only; loads/stores removed by renaming. Length = L - 2n (if no extra copies needed).
Usage: att2s.py <cc file> <FuncName> <n> <mem|free>
"""
import re, sys

def extract(fn, name):
    src = open(fn).read()
    m = re.search(r'void %s\(int\* buffer\) \{\s*asm volatile\((.*?)\);' % name, src, re.S)
    lines = re.findall(r'"([^"]*)\\n"', m.group(1))
    out = []
    for l in lines:
        l = l.strip()
        op, args = l.split(None, 1)
        a = [x.strip() for x in re.split(r',(?![^()]*\))', args)]
        out.append((op, a))
    return out

def opnd(x):
    x = x.strip()
    m = re.match(r'(0x[0-9a-f]+|\d*)\(%0\)', x)
    if m:
        off = int(m.group(1), 16) if m.group(1).startswith('0x') else int(m.group(1) or 0)
        return ('M', off // 4)
    return ('R', x.replace('%', ''))

def main():
    fn, name, n, mode = sys.argv[1], sys.argv[2], int(sys.argv[3]), sys.argv[4]
    ins = extract(fn, name)
    res = []
    if mode == 'mem':
        rmap = {}
        def r(x):
            k, v = x
            if k == 'M':
                return 'M%d' % v
            if v not in rmap:
                rmap[v] = 'S%d' % len(rmap)
            return rmap[v]
        for op, (src, dst) in ins:
            res.append('%s %s, %s' % (op, r(opnd(dst)), r(opnd(src))))   # AT&T src,dst -> Intel dst,src
        print('# n=%d iset=I1 model=mem source=AlphaDev %s (sort_functions_test.cc), L=%d' % (n, name, len(res)))
    else:
        phys = {}          # asm reg -> physical name
        loaded = set()
        nfresh = [0]
        stored = {}        # j -> phys
        frozen = set()     # phys regs that hold an output already
        def fresh():
            nfresh[0] += 1
            return 'S%d' % (nfresh[0] - 1)
        for op, (src, dst) in ins:
            s, d = opnd(src), opnd(dst)
            if op == 'mov' and s[0] == 'M':          # load
                i = s[1]
                if i not in loaded:
                    loaded.add(i); phys[d[1]] = 'P%d' % i
                else:
                    t = fresh(); res.append('mov %s, P%d' % (t, i)); phys[d[1]] = t
                continue
            if op == 'mov' and d[0] == 'M':          # store
                stored[d[1]] = phys[s[1]]; frozen.add(phys[s[1]])
                continue
            sp = phys[s[1]]
            if op == 'mov':
                dp = fresh() if d[1] not in phys or phys[d[1]] in frozen or True else phys[d[1]]
                # full overwrite: always give a new name (unbounded registers), avoids clobbering outputs
                phys[d[1]] = dp
                res.append('mov %s, %s' % (dp, sp))
            else:
                dp = phys[d[1]]
                if dp in frozen:
                    raise SystemExit('cmov into stored register: needs copy')
                res.append('%s %s, %s' % (op, dp, sp))
        print('# n=%d iset=I1 model=free source=AlphaDev %s, k=%d (= L - 2n), outputs: %s' % (
            n, name, len(res), ' '.join('O%d=%s' % (j, stored[j]) for j in range(n))))
    print('\n'.join(res))

main()
