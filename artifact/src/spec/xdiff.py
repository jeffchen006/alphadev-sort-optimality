#!/usr/bin/env python3
"""Real-x86 differential test of shared/judge.py semantics (model=mem programs).

  python3 agents/spec/x86/xdiff.py programs/alphadev_sort3.s [--tests N]
  python3 agents/spec/x86/xdiff.py --edge          # cmov/cmp edge cases on this CPU vs judge

P<i> -> 4*i(%rdi) (memory), S<j> -> x86 32-bit registers. Before the program: scratch registers get garbage, flags
get one of the 4 states (ZF, SF!=OF) by popfq. After it: memory and all scratch registers are dumped and compared
with judge.run_concrete on the same state. Tests: every weak order type (several value realizations, incl.
INT_MIN/INT_MAX) and random 32-bit inputs with duplicates.
"""
import os
import random
import subprocess
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'shared'))
import judge  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
X86 = ['eax', 'ecx', 'edx', 'ebx', 'esi', 'r8d', 'r9d', 'r10d', 'r11d', 'r12d', 'r13d', 'r14d', 'r15d']
CLOB = ['rax', 'rcx', 'rdx', 'rbx', 'rsi', 'r8', 'r9', 'r10', 'r11', 'r12', 'r13', 'r14', 'r15']
# struct layout (int32 units): buf[0..15], g[16..31], out[32..47], then uint64 flags at byte 192
G, O, FL = 16, 32, 192
# popfq images for (zf, lt); lt = SF != OF. bit1 always 1. ZF=0x40 SF=0x80 OF=0x800
FLAGS = {(1, 0): [0x042, 0x8C2], (0, 1): [0x082, 0x802], (0, 0): [0x002, 0x882], (1, 1): [0x0C2, 0x842]}
INT_MIN, INT_MAX = -2 ** 31, 2 ** 31 - 1


def asm_operand(r):
    return '%d(%%%%rdi)' % (4 * int(r[1:])) if r[0] == 'P' else '%%' + X86[int(r[1:])]


def att(op, a, b):
    if op == 'cmp':  # ours: cmp A, B sets lt = A < B ; AT&T "cmp X, Y" computes Y - X
        return '"cmp %s, %s\\n"' % (asm_operand(b), asm_operand(a))
    return '"%s %s, %s\\n"' % (op, asm_operand(b), asm_operand(a))


def c_source(prog, nS):
    pre = ['"mov %d(%%%%rdi), %%%%%s\\n"' % (4 * (G + j), X86[j]) for j in range(nS)]
    pre += ['"pushq %d(%%%%rdi)\\n"' % FL, '"popfq\\n"']
    body = [att(op, a, b) for op, a, b, _ in prog]
    post = ['"mov %%%%%s, %d(%%%%rdi)\\n"' % (X86[j], 4 * (O + j)) for j in range(nS)]
    clob = ', '.join('"%s"' % c for c in CLOB) + ', "memory", "cc"'
    return r'''#include <stdio.h>
#include <stdint.h>
#include <string.h>
struct st { int32_t w[48]; uint64_t fl; } __attribute__((aligned(16)));
static void run(struct st *s) {
  __asm__ volatile(
%s
    : : "D"(s) : %s);
}
int main(void) {
  struct st s; long long v; int i;
  for (;;) {
    memset(&s, 0, sizeof s);
    for (i = 0; i < 32; i++) { if (scanf("%%lld", &v) != 1) return 0; s.w[i] = (int32_t)v; }
    if (scanf("%%lld", &v) != 1) return 0; s.fl = (uint64_t)v;
    run(&s);
    for (i = 0; i < 16; i++) printf("%%d ", s.w[i]);
    for (i = 32; i < 48; i++) printf("%%d ", s.w[i]);
    printf("\n");
  }
}
''' % ('\n'.join('    ' + l for l in pre + body + post), clob)


def build(prog, nS, tag):
    src = os.path.join(HERE, 'build', tag + '.c')
    exe = src[:-2]
    os.makedirs(os.path.dirname(src), exist_ok=True)
    open(src, 'w').write(c_source(prog, nS))
    subprocess.run(['gcc', '-O1', '-mno-red-zone', '-o', exe, src], check=True)
    return exe


def cases(n, nS, tests, rng):
    out = []
    specials = [INT_MIN, INT_MIN + 1, -1, 0, 1, INT_MAX - 1, INT_MAX]
    for v in judge.weak_orders(n):
        m = max(v) + 1
        reals = [list(range(m)), sorted(rng.sample(range(INT_MIN, INT_MAX), m))]
        if m <= 2:
            reals.append([INT_MIN, INT_MAX][:m])
        reals.append([INT_MIN] + sorted(rng.sample(range(INT_MIN + 1, INT_MAX), m - 2)) + [INT_MAX] if m >= 2 else [INT_MAX])
        for r in reals:
            out.append([r[i] for i in v])
    while len(out) < tests:
        k = rng.randint(1, n)
        pool = [rng.choice(specials) if rng.random() < 0.4 else rng.randint(INT_MIN, INT_MAX) for _ in range(k)]
        out.append([rng.choice(pool) for _ in range(n)])
    res = []
    for x in out:
        g = [rng.choice([rng.randint(INT_MIN, INT_MAX), rng.choice(specials), rng.choice(x)]) for _ in range(nS)]
        f = rng.choice(list(FLAGS))
        res.append((x, g, f, rng.choice(FLAGS[f])))
    return res


def diff(prog, n, nS, tag, tests, rng, check_sorted=True):
    if nS > len(X86):
        raise SystemExit('too many scratch registers: %d' % nS)
    exe = build(prog, nS, tag)
    cs = cases(n, nS, tests, rng)
    lines = []
    for x, g, f, img in cs:
        w = x + [0] * (16 - n) + g + [0] * (16 - nS)
        lines.append(' '.join(map(str, w)) + ' %d' % img)
    r = subprocess.run([exe], input='\n'.join(lines) + '\n', capture_output=True, text=True, check=True)
    got = [list(map(int, l.split())) for l in r.stdout.splitlines()]
    assert len(got) == len(cs)
    bad = 0
    for (x, g, f, img), hw in zip(cs, got):
        st = {'P%d' % i: x[i] for i in range(n)}
        st.update({'S%d' % j: g[j] for j in range(nS)})
        sim = judge.run_concrete(prog, st, f)
        exp = [sim['P%d' % i] for i in range(n)] + [sim['S%d' % j] for j in range(nS)]
        hwv = hw[:n] + hw[16:16 + nS]
        if exp != hwv or (check_sorted and hw[:n] != sorted(x)):
            bad += 1
            if bad <= 3:
                kind = 'SEMANTICS MISMATCH' if exp != hwv else 'NOT SORTED (x86 == judge)'
                print('  %s input %s garbage %s flags %s(popf %#x): x86 %s judge %s' % (kind, x, g, f, img, hwv, exp))
    return len(cs), bad


def edge(rng):
    """Single-cmp kernels: cmp A,B ; cmovX D,S for all opcodes on edge values (no sort check)."""
    tot = bad = 0
    vals = [INT_MIN, INT_MIN + 1, -1, 0, 1, INT_MAX - 1, INT_MAX]
    for op in ['cmovl', 'cmovle', 'cmovg', 'cmovge']:
        # P0 = A, P1 = B, S0 = D (garbage slot), S1 = S
        prog = [('mov', 'S0', 'P0', 0), ('mov', 'S1', 'P1', 0), ('cmp', 'S0', 'S1', 0), (op, 'S0', 'S1', 0),
                ('mov', 'P0', 'S0', 0)]
        exe = build(prog, 2, 'edge_' + op)
        lines, cs = [], []
        for a in vals:
            for b in vals:
                for f, imgs in FLAGS.items():
                    for img in imgs:
                        cs.append(([a, b], [rng.randint(INT_MIN, INT_MAX), 7], f))
                        lines.append(' '.join(map(str, [a, b] + [0] * 14 + cs[-1][1] + [0] * 14)) + ' %d' % img)
        r = subprocess.run([exe], input='\n'.join(lines) + '\n', capture_output=True, text=True, check=True)
        for (x, g, f), l in zip(cs, r.stdout.splitlines()):
            hw = list(map(int, l.split()))
            sim = judge.run_concrete(prog, {'P0': x[0], 'P1': x[1], 'S0': g[0], 'S1': g[1]}, f)
            tot += 1
            if [sim['P0'], sim['S0'], sim['S1']] != [hw[0], hw[16], hw[17]]:
                bad += 1
                print('  EDGE MISMATCH', op, x, f, hw[:2], hw[16:18], sim)
        # initial-flag test: cmov BEFORE any cmp reads the popf state
        prog2 = [('mov', 'S1', 'P1', 0), (op, 'S0', 'S1', 0), ('mov', 'P0', 'S0', 0)]
        exe = build(prog2, 2, 'edgeflag_' + op)
        lines, cs = [], []
        for f, imgs in FLAGS.items():
            for img in imgs:
                cs.append(f)
                lines.append(' '.join(map(str, [5, 9] + [0] * 14 + [3, 0] + [0] * 14)) + ' %d' % img)
        r = subprocess.run([exe], input='\n'.join(lines) + '\n', capture_output=True, text=True, check=True)
        for f, l in zip(cs, r.stdout.splitlines()):
            hw = list(map(int, l.split()))
            sim = judge.run_concrete(prog2, {'P0': 5, 'P1': 9, 'S0': 3, 'S1': 0}, f)
            tot += 1
            if sim['P0'] != hw[0]:
                bad += 1
                print('  FLAG MISMATCH', op, f, hw[0], sim['P0'])
    print('EDGE %s: %d cases, %d mismatches' % ('PASS' if bad == 0 else 'FAIL', tot, bad))
    return bad


def main(argv):
    rng = random.Random(12345)
    if '--edge' in argv:
        return 1 if edge(rng) else 0
    tests = int(argv[argv.index('--tests') + 1]) if '--tests' in argv else 20000
    rc = 0
    for path in [a for a in argv[1:] if a.endswith('.s')]:
        hdr, prog = judge.parse(open(path).read())
        if hdr.get('model', 'reg') != 'mem':
            print('SKIP %s (model=%s; x86 harness runs model=mem only)' % (path, hdr.get('model', 'reg')))
            continue
        n = int(hdr['n'])
        nS = len([r for r in judge.regs(n, prog) if r[0] == 'S'])
        tag = os.path.basename(path)[:-2]
        tot, bad = diff(prog, n, nS, tag, tests, rng)
        print('%s %s: %d tests on this CPU, %d mismatches (x86 vs judge, memory + all registers)' % (
            'PASS' if bad == 0 else 'FAIL', path, tot, bad))
        rc |= bad > 0
    return rc


if __name__ == '__main__':
    sys.exit(main(sys.argv))
