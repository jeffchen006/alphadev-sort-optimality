#!/usr/bin/env python3
"""x86 agent: timing kernels. gen_bench.py OUT_PREFIX file.s ...
Each memory-model program (P = int32 cells of buf, S = registers; mem or MM+ form) becomes
    void bench_<k>(int *buf)        (buf in rdi, AlphaDev calling form: sorts buf[0..n-1] in place)
with exactly the program's instructions (P<i> -> dword ptr [rdi+4i]) plus push/pop of the callee-saved
registers it uses and ret. bench_empty = ret only (baseline). Writes OUT_PREFIX.S and OUT_PREFIX.h.
"""
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from gen_harness import parse, POOL64, r32, mem_legal

CALLEE = ('rbx', 'rbp', 'r12', 'r13', 'r14', 'r15')


def main():
    pre, files = sys.argv[1], sys.argv[2:]
    S = ['.intel_syntax noprefix', '.text', '.globl bench_empty', 'bench_empty:', '  ret']
    rows = []
    for k, f in enumerate(files):
        n, R, ins = parse(f)
        if any(op == 'out' for op, _, _ in ins) or not mem_legal(n, R, ins):
            print('skip (not a memory-model program):', f)
            continue
        sregs = POOL64[:R - n]
        def o(r):
            return 'dword ptr [rdi+%d]' % (4 * int(r[1:])) if r[0] == 'P' else r32(sregs[int(r[1:])])
        saved = [r for r in sregs if r in CALLEE]
        a = ['.globl bench_%d' % k, 'bench_%d:' % k] + ['  push %s' % r for r in saved]
        a += ['  %s %s, %s' % (op, o(d), o(s)) for op, d, s in ins]
        a += ['  pop %s' % r for r in reversed(saved)] + ['  ret']
        S += a
        rows.append('{"%s", %d, %d, %d, bench_%d}' % (os.path.basename(f), n, len(ins), len(saved), k))
    H = ['#include <stdint.h>', 'void bench_empty(int *);']
    H += ['void bench_%s(int *);' % r.split('bench_')[1].rstrip('}') for r in rows]
    H.append('typedef struct { const char *name; int n, L, saves; void (*fn)(int *); } bench_t;')
    H.append('static const bench_t BENCH[] = {\n  ' + ',\n  '.join(rows) + '\n};')
    H.append('#define NBENCH %d' % len(rows))
    open(pre + '.S', 'w').write('\n'.join(S) + '\n.section .note.GNU-stack,"",@progbits\n')
    open(pre + '.h', 'w').write('\n'.join(H) + '\n')


if __name__ == '__main__':
    main()
