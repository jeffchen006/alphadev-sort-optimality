#!/usr/bin/env python3
"""x86 agent: turn model programs (MODEL.md section 5 format) into real x86-64 code.

Usage: gen_harness.py OUT_PREFIX file.s [file.s ...]
Writes OUT_PREFIX.S (GNU as, Intel syntax) and OUT_PREFIX.h (program table for driver.c).

Each program becomes   void prog_<i>(uint64_t *st)   with st layout (64-bit slots):
  st[0..R-1]     initial value of model register r (P0..P{n-1}, then S0..), full 64 bits
  st[R]          initial RFLAGS (driver sets CF/PF/AF/ZF/SF/OF at random)
  st[R+1..2R]    final value of each model register (full 64 bits)
  st[2R+1]       final RFLAGS
  st[2R+2+j]     output slot j for 'out j, S' (model=out): driver sets it to all ones; the code writes
                 the low 32 bits = S and the high 32 bits = 0 (a real 32-bit store, like AlphaDev's mov m32, r32)
Model register index: P<i> -> i, S<j> -> n + j.

Two code modes:
  reg   : every model register is a real 64-bit GPR (pool of 14, rdi = state pointer);
          the body is the program text with registers renamed, 32-bit forms (eax, r8d, ...).
  mem   : P<i> is a real memory cell (dword at st[R+1+i]), S<j> a real GPR; P operands are emitted as
          memory operands (mov r32,m32 / mov m32,r32 / cmp m32,r32 / cmp r32,m32 / cmovcc r32,m32), i.e.
          the AlphaDev memory model and its x86-legal variant with memory sources. Only if x86-legal
          (no mov P,P, no cmp P,P, no cmov into P, no out from P) and the S count <= 14.
  spill : every model register lives in st[R+1+r]; each instruction loads to eax/edx,
          runs the SAME opcode on registers, and stores back with a 64-bit store
          (so the zero-extension behaviour of the real 32-bit op is kept).
"""
import re, sys

OPS = {'mov': 0, 'cmp': 1, 'cmovl': 2, 'cmovg': 3, 'cmovle': 4, 'cmovge': 5, 'out': 6}
POOL64 = ['rax', 'rcx', 'rdx', 'rsi', 'r8', 'r9', 'r10', 'r11', 'rbx', 'rbp', 'r12', 'r13', 'r14', 'r15']
R32 = {'rax': 'eax', 'rcx': 'ecx', 'rdx': 'edx', 'rsi': 'esi', 'rbx': 'ebx', 'rbp': 'ebp'}
def r32(r): return R32.get(r, r + 'd')


def parse(path):
    n = None; ins = []
    for raw in open(path):
        m = re.search(r'\bn=(\d+)', raw)
        if n is None and raw.lstrip().startswith('#') and m:
            n = int(m.group(1))
        line = raw.split('#', 1)[0].strip()
        if not line:
            continue
        m = re.fullmatch(r'([a-z]+)\s+([PS]\d+|\d+)\s*,\s*([PS]\d+)', line)
        if not m or m.group(1) not in OPS or (m.group(1) == 'out') != m.group(2).isdigit():
            raise SystemExit('%s: cannot parse line: %r' % (path, raw))
        ins.append((m.group(1), m.group(2), m.group(3)))
    if n is None:
        raise SystemExit('%s: no "# n=" header' % path)
    # rename S registers densely in order of first use (a pure renaming: semantics unchanged)
    smap = {}
    for i in ins:
        for r in i[1:]:
            if r[0] == 'S':
                smap.setdefault(r, 'S%d' % len(smap))
    ins = [(o, smap.get(d, d), smap.get(s, s)) for o, d, s in ins]
    nS = len(smap)
    for i in ins:
        if i[0] == 'out' and int(i[1]) >= n:
            raise SystemExit('%s: out %s out of range n=%d' % (path, i[1], n))
        for r in i[1:]:
            if r.isdigit():
                continue
            if r[0] == 'P' and int(r[1:]) >= n:
                raise SystemExit('%s: %s out of range n=%d' % (path, r, n))
    return n, n + nS, ins


def ridx(n, r):
    if r.isdigit():
        return int(r)
    return int(r[1:]) if r[0] == 'P' else n + int(r[1:])


def mem_legal(n, R, ins):
    if R - n > len(POOL64):
        return False
    for op, d, s in ins:
        if op == 'out':
            if s[0] == 'P':
                return False
        elif d[0] == 'P' and (s[0] == 'P' or op.startswith('cmov')):
            return False
    return True


def emit(fn, n, R, ins, mode):
    a = ['.globl %s' % fn, '.type %s, @function' % fn, '%s:' % fn]
    for r in ('rbx', 'rbp', 'r12', 'r13', 'r14', 'r15'):
        a.append('  push %s' % r)
    IN = lambda i: 'qword ptr [rdi+%d]' % (8 * i)
    OUT = lambda i: 'qword ptr [rdi+%d]' % (8 * (R + 1 + i))
    SLOT = lambda j: 8 * (2 * R + 2 + j)
    if mode == 'reg':
        regs = POOL64[:R]
        for i in range(R):
            a.append('  mov %s, %s' % (regs[i], IN(i)))
        a.append('  push %s' % IN(R)); a.append('  popfq')
        for op, d, s in ins:
            if op == 'out':
                a += ['  mov dword ptr [rdi+%d], %s' % (SLOT(int(d)), r32(regs[ridx(n, s)])),
                      '  mov dword ptr [rdi+%d], 0' % (SLOT(int(d)) + 4)]
                continue
            a.append('  %s %s, %s' % (op, r32(regs[ridx(n, d)]), r32(regs[ridx(n, s)])))
        for i in range(R):
            a.append('  mov %s, %s' % (OUT(i), regs[i]))
    elif mode == 'mem':
        sregs = POOL64[:R - n]
        def o(r):
            i = ridx(n, r)
            return 'dword ptr [rdi+%d]' % (8 * (R + 1 + i)) if r[0] == 'P' else r32(sregs[i - n])
        for i in range(n):
            a.append('  mov rax, %s' % IN(i)); a.append('  mov %s, rax' % OUT(i))
        for i in range(n, R):
            a.append('  mov %s, %s' % (sregs[i - n], IN(i)))
        a.append('  push %s' % IN(R)); a.append('  popfq')
        for op, d, s in ins:
            if op == 'out':
                a += ['  mov dword ptr [rdi+%d], %s' % (SLOT(int(d)), o(s)), '  mov dword ptr [rdi+%d], 0' % (SLOT(int(d)) + 4)]
            else:
                a.append('  %s %s, %s' % (op, o(d), o(s)))
        for i in range(n, R):
            a.append('  mov %s, %s' % (OUT(i), sregs[i - n]))
    else:
        for i in range(R):
            a.append('  mov rax, %s' % IN(i)); a.append('  mov %s, rax' % OUT(i))
        a.append('  push %s' % IN(R)); a.append('  popfq')
        for op, d, s in ins:
            D, S = ridx(n, d), ridx(n, s)
            if op == 'out':
                a += ['  mov eax, dword ptr [rdi+%d]' % (8 * (R + 1 + S)), '  mov dword ptr [rdi+%d], eax' % SLOT(D),
                      '  mov dword ptr [rdi+%d], 0' % (SLOT(D) + 4)]
            elif op == 'mov':
                a += ['  mov eax, dword ptr [rdi+%d]' % (8 * (R + 1 + S)), '  mov %s, rax' % OUT(D)]
            elif op == 'cmp':
                a += ['  mov eax, dword ptr [rdi+%d]' % (8 * (R + 1 + D)),
                      '  mov edx, dword ptr [rdi+%d]' % (8 * (R + 1 + S)), '  cmp eax, edx']
            else:
                a += ['  mov rax, %s' % OUT(D), '  mov edx, dword ptr [rdi+%d]' % (8 * (R + 1 + S)),
                      '  %s eax, edx' % op, '  mov %s, rax' % OUT(D)]
    a.append('  pushfq'); a.append('  pop qword ptr [rdi+%d]' % (8 * (2 * R + 1)))
    for r in reversed(('rbx', 'rbp', 'r12', 'r13', 'r14', 'r15')):
        a.append('  pop %s' % r)
    a.append('  ret')
    return '\n'.join(a) + '\n'


def main():
    pre, files = sys.argv[1], sys.argv[2:]
    S = ['.intel_syntax noprefix', '.text']
    H = ['/* generated by gen_harness.py */', '#include <stdint.h>']
    rows = []
    for k, f in enumerate(files):
        n, R, ins = parse(f)
        modes = (['reg'] if R <= len(POOL64) else []) + (['mem'] if mem_legal(n, R, ins) else []) + ['spill']
        for mode in modes:
            fn = 'prog_%d_%s' % (k, mode)
            S.append(emit(fn, n, R, ins, mode))
            H.append('void %s(uint64_t *st);' % fn)
            code = ','.join('{%d,%d,%d}' % (OPS[o], ridx(n, d), ridx(n, s)) for o, d, s in ins)
            H.append('static const uint8_t code_%d_%s[][3] = {%s};' % (k, mode, code or '{0,0,0}'))
            L = sum(1 for i in ins if i[0] != 'out')
            rows.append('{"%s", "%s", %d, %d, %d, %d, code_%d_%s, %s}' % (f, mode, n, R, len(ins), L, k, mode, fn))
    H.append('typedef struct { const char *file, *mode; int n, R, len, L; const uint8_t (*code)[3]; void (*fn)(uint64_t*); } prog_t;')
    H.append('static const prog_t PROGS[] = {\n  ' + ',\n  '.join(rows) + '\n};')
    H.append('#define NPROGS %d' % len(rows))
    open(pre + '.S', 'w').write('\n'.join(S) + '\n.section .note.GNU-stack,"",@progbits\n')
    open(pre + '.h', 'w').write('\n'.join(H) + '\n')


if __name__ == '__main__':
    main()
