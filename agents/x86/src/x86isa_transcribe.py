#!/usr/bin/env python3
"""x86 agent: executable transcription of the ACL2 x86isa clauses (books/projects/x86isa, git HEAD 2026-10-24)
for the opcodes we use, run on (input, hardware output) vectors dumped by driver.c (env DUMP=...).
Not the certified model itself (ACL2 build was not allowed here); each function cites its clause.

Usage: x86isa_transcribe.py DUMPFILE
"""
import sys

M32, M64 = (1 << 32) - 1, (1 << 64) - 1
CF, PF, AF, ZF, SF, OF = 0, 2, 4, 6, 7, 11          # rflags bit positions
FLM = sum(1 << b for b in (CF, PF, AF, ZF, SF, OF))

def n32_to_i32(x):                                    # n32-to-i32
    return x - (1 << 32) if x >> 31 else x

def gpr_sub_spec_4(dst, src, rflags):                 # instructions/sub-spec.lisp gpr-sub-spec-gen-fn, size 4
    signed_raw = n32_to_i32(dst) - n32_to_i32(src)
    result = signed_raw & M32                         # n-size 32
    cf = int(dst < src)                               # (< dst src) on unsigned operands
    pf = int(bin(result & 0xFF).count('1') % 2 == 0)  # pf-spec32: not logbitp 0 (logcount low byte)
    af = int((dst & 0xF) - (src & 0xF) < 0)           # sub-af-spec32
    zf = int(result == 0)                             # zf-spec
    sf = result >> 31                                 # sf-spec32: bit 31
    of = int(not (-(1 << 31) <= signed_raw < (1 << 31)))  # of-spec32: not signed-byte-p 32
    out = rflags & ~FLM
    for b, v in ((CF, cf), (PF, pf), (AF, af), (ZF, zf), (SF, sf), (OF, of)):
        out |= v << b
    return result, out

def flgi(rflags, b):
    return (rflags >> b) & 1

def jcc_cmovcc_setcc_spec(low_nibble, rflags):        # instructions/conditional.lisp jcc/cmovcc/setcc-spec
    zf, sf, of = flgi(rflags, ZF), flgi(rflags, SF), flgi(rflags, OF)
    return {0xC: sf != of, 0xD: sf == of, 0xE: zf == 1 or sf != of, 0xF: zf == 0 and sf == of}[low_nibble]

def wr32(regs, i, val):                               # register-readers-and-writers.lisp wr32: (!rgfi reg (n32 val))
    regs[i] = val & M32

def rgfi_size4(regs, i):                              # rgfi-size 4 = rr32 = low 32 bits
    return regs[i] & M32

# opcode codes from gen_harness.py: 0 mov, 1 cmp, 2 cmovl(0F 4C), 3 cmovg(0F 4F), 4 cmovle(0F 4E), 5 cmovge(0F 4D), 6 out
NIB = {2: 0xC, 3: 0xF, 4: 0xE, 5: 0xD}
import os
if os.environ.get('XBUG'):                            # negative control: cmovle decoded as cmovl
    NIB[4] = 0xC

def run(code, n, R, regs, rflags):
    regs = list(regs)
    slots = [M64] * n
    for op, d, s in code:
        if op == 0:                                   # x86-mov-Op/En-MR, mod=3: x86-operand-to-reg/mem -> !rgfi-size 4 -> wr32
            wr32(regs, d, rgfi_size4(regs, s))
        elif op == 1:                                 # x86-add/adc/sub/sbb/or/and/xor/cmp/test-E-G, OP-CMP: flags only
            _, rflags = gpr_sub_spec_4(rgfi_size4(regs, d), rgfi_size4(regs, s), rflags)
        elif op == 6:                                 # mov m32, r32 (wml32 of rr32): low 32 bits stored
            slots[d] = rgfi_size4(regs, s)            # (driver marks the slot written: high half 0)
        else:                                         # x86-cmovcc, 64-bit mode
            if jcc_cmovcc_setcc_spec(NIB[op], rflags):
                wr32(regs, d, rgfi_size4(regs, s))    # !rgfi-size 4 reg reg/mem
            else:
                wr32(regs, d, rgfi_size4(regs, d) & M32)  # (loghead 32 (rgfi-size 4 reg)): zero-extends
    return regs, rflags, slots

def main():
    prog = None; total = bad = progs = 0
    for line in open(sys.argv[1]):
        f = line.split()
        if f[0] == 'PROG':
            name, mode, n, R = f[1], f[2], int(f[3]), int(f[4])
            code = [tuple(map(int, c.split('.'))) for c in f[5:]]
            progs += 1
            continue
        vals = [int(x, 16) for x in f[1:] if x != '|']
        regs, fl = vals[:R], vals[R]
        hw_regs, hw_fl, hw_slots = vals[R + 1:2 * R + 1], vals[2 * R + 1], vals[2 * R + 2:2 * R + 2 + n]
        r, rf, sl = run(code, n, R, regs, fl)
        total += 1
        if r != hw_regs or (rf ^ hw_fl) & FLM or sl != hw_slots:
            bad += 1
            if bad <= 3:
                print('MISMATCH', name, mode, regs, hex(fl), 'hw', hw_regs, hex(hw_fl), 'model', r, hex(rf))
    print('x86isa-transcription vs hardware: programs=%d vectors=%d mismatches=%d' % (progs, total, bad))
    sys.exit(1 if bad else 0)

if __name__ == '__main__':
    main()
