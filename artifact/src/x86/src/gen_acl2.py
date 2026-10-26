#!/usr/bin/env python3
"""x86 agent: run the hardware test vectors in the CERTIFIED ACL2 x86isa model.

  gen_acl2.py gen  DUMP OUTDIR [MAXVEC]  -> OUTDIR/run.lisp (+ OUTDIR/meta.txt)
  gen_acl2.py cmp  DUMP OUTDIR ACL2_OUTPUT

DUMP = vectors written by driver.c (env DUMP=...): per program its code, per vector the initial
state and the HARDWARE final state. Only 'reg' mode programs are used: the body is assembled with
GNU as exactly as gen_harness.py does it (same register map), the machine code is loaded into the
x86isa state (64-bit mode, app-view), registers + RFLAGS are set from the vector, and x86-run
executes the body. The final GPRs, RFLAGS and output slots are compared with the hardware.
"""
import os, subprocess, sys, tempfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from gen_harness import POOL64, r32

GPR = {'rax': 0, 'rcx': 1, 'rdx': 2, 'rbx': 3, 'rsp': 4, 'rbp': 5, 'rsi': 6, 'rdi': 7}
GPR.update({'r%d' % i: i for i in range(8, 16)})
OPN = ['mov', 'cmp', 'cmovl', 'cmovg', 'cmovle', 'cmovge', 'out']
CODE, BASE = 0x400000, 0x600000
FLM = 0x8D5


def read_dump(path):
    progs = []
    for line in open(path):
        f = line.split()
        if f[0] == 'PROG':
            progs.append({'file': f[1], 'mode': f[2], 'n': int(f[3]), 'R': int(f[4]),
                          'code': [tuple(map(int, c.split('.'))) for c in f[5:]], 'vec': []})
        else:
            v = [int(x, 16) for x in f[1:] if x != '|']
            progs[-1]['vec'].append(v)
    return [p for p in progs if p['mode'] in ('reg', 'mem')]


def body_bytes(p):
    R, n, mem = p['R'], p['n'], p['mode'] == 'mem'
    regs = POOL64[:R - n] if mem else POOL64[:R]
    def o(i):                                   # model register index -> operand text
        if mem and i < n:
            return 'dword ptr [rdi+%d]' % (8 * (R + 1 + i))
        return r32(regs[i - n] if mem else regs[i])
    a = ['.intel_syntax noprefix', '.text']
    steps = 0
    for op, d, s in p['code']:
        if OPN[op] == 'out':
            slot = 8 * (2 * R + 2 + d)
            a += ['mov dword ptr [rdi+%d], %s' % (slot, o(s)), 'mov dword ptr [rdi+%d], 0' % (slot + 4)]
            steps += 2
        else:
            a.append('%s %s, %s' % (OPN[op], o(d), o(s)))
            steps += 1
    with tempfile.TemporaryDirectory() as t:
        open(t + '/b.S', 'w').write('\n'.join(a) + '\n')
        subprocess.check_call(['as', '-o', t + '/b.o', t + '/b.S'])
        subprocess.check_call(['objcopy', '-O', 'binary', '-j', '.text', t + '/b.o', t + '/b.bin'])
        return list(open(t + '/b.bin', 'rb').read()), steps


def gen(dump, out, maxvec):
    progs = read_dump(dump)
    os.makedirs(out, exist_ok=True)
    L = ['(include-book "projects/x86isa/tools/execution/top" :dir :system)',
         '(in-package "X86ISA")',
         '(set-fmt-soft-right-margin 1000000 state)', '(set-fmt-hard-right-margin 1000000 state)',
         '(set-guard-checking :none)', '(program)',
         # read 8 bytes little-endian from memi (app-view: linear address = memi index)
         '(defun rd64 (a i acc x86) (declare (xargs :stobjs x86))'
         ' (if (zp i) acc (rd64 a (1- i) (+ (* acc 256) (memi (+ a (1- i)) x86)) x86)))',
         '(defun rd-slots (a k acc x86) (declare (xargs :stobjs x86))'
         ' (if (zp k) (reverse acc) (rd-slots (+ a 8) (1- k) (cons (rd64 a 8 0 x86) acc) x86)))',
         '(defun rd-gprs (l x86) (declare (xargs :stobjs x86)) (if (endp l) nil (cons (rgfi (car l) x86) (rd-gprs (cdr l) x86))))',
         '(defun run-vecs (pid vid mem gidx nsteps slot-addr nslots pc-addr npc vecs x86)'
         ' (declare (xargs :stobjs x86))'
         ' (if (endp vecs) x86'
         '  (mv-let (flg x86)'
         '   (init-x86-state-64 nil %d (car (car vecs)) nil nil nil nil nil nil (cadr (car vecs)) mem x86)'
         '   (let* ((x86 (x86-run nsteps x86)))'
         '    (prog2$ (cw "RES ~x0 ~x1 ~x2 ~x3 ~x4 ~x5 ~x6 ~x7 ~x8~%%" pid vid flg (ms x86) (fault x86) (rip x86)'
         '                (rd-gprs gidx x86) (cons (rflags x86) (rd-slots slot-addr nslots nil x86))'
         '                (rd-slots pc-addr npc nil x86))'
         '            (run-vecs pid (1+ vid) mem gidx nsteps slot-addr nslots pc-addr npc (cdr vecs) x86))))))' % CODE]
    meta = []
    for k, p in enumerate(progs):
        R, n = p['R'], p['n']
        code, steps = body_bytes(p)
        if os.environ.get('ACL2BUG'):           # negative control: stop one instruction early
            steps -= 1
        ismem = p['mode'] == 'mem'
        first = n if ismem else 0                 # model registers held in GPRs: S only (mem) or all (reg)
        gidx = [GPR[r] for r in POOL64[:R - first]]
        slot_addr = BASE + 8 * (2 * R + 2)
        pc_addr, npc = BASE + 8 * (R + 1), (n if ismem else 0)
        mem0 = [(CODE + i, b) for i, b in enumerate(code)] + [(slot_addr + i, 0xFF) for i in range(8 * n)]
        vecs = []
        for v in p['vec'][:maxvec]:
            gprs = [(gidx[i - first], v[i]) for i in range(first, R)] + [(7, BASE)]
            cells = [(pc_addr + 8 * i + b, (v[i] >> (8 * b)) & 0xFF) for i in range(npc) for b in range(8)]
            vecs.append((gprs, v[R] & 0xFFFFFFFF, cells))
        # P cells differ per vector, so a mem-mode program gets one run-vecs call per vector
        groups = [(0, vecs)] if not ismem else [(j, [x]) for j, x in enumerate(vecs)]
        for vid0, g in groups:
            mem = mem0 + (g[0][2] if ismem else [])
            L.append('(run-vecs %d %d \'(%s) \'(%s) %d %d %d %d %d \'(%s) x86)' % (
                k, vid0,
                ' '.join('(%d . %d)' % m for m in mem), ' '.join(map(str, gidx)), steps, slot_addr, n, pc_addr, npc,
                ' '.join('(%s %d)' % ('(' + ' '.join('(%d . %d)' % x for x in gp) + ')', fl) for gp, fl, _ in g)))
        meta.append('%d %s %d %d %d %d %s' % (k, p['file'], R, n, steps, CODE + len(code), p['mode']))
    open(out + '/run.lisp', 'w').write('\n'.join(L) + '\n')
    open(out + '/meta.txt', 'w').write('\n'.join(meta) + '\n')
    print('programs=%d vectors=%d' % (len(progs), sum(min(len(p['vec']), maxvec) for p in progs)))


def cmp(dump, out, acl2out):
    progs = read_dump(dump)
    meta = {int(l.split()[0]): l.split() for l in open(out + '/meta.txt')}
    total = bad = 0
    seen = set()
    for line in open(acl2out):
        i = line.find('RES ')          # the first result follows the ACL2 prompt on the same line
        if i < 0:
            continue
        t = line[i + 4:].replace('(', ' ').replace(')', ' ').split()
        pid, vid, flg, ms, fault, rip = int(t[0]), int(t[1]), t[2], t[3], t[4], int(t[5])
        p = progs[pid]; R, n = p['R'], p['n']
        nums = [int(x) for x in t[6:] if x != 'NIL']   # NIL = empty list (no P cells in reg mode)
        ismem = p['mode'] == 'mem'
        ng = R - n if ismem else R
        g = [x & (2 ** 64 - 1) for x in nums[:ng]]       # rgfi returns signed-byte 64
        fl, slots, cells = nums[ng], nums[ng + 1:ng + 1 + n], nums[ng + 1 + n:]
        v = p['vec'][vid]
        hw_regs, hw_fl, hw_slots = v[R + 1:2 * R + 1], v[2 * R + 1], v[2 * R + 2:2 * R + 2 + n]
        if ismem:   # P cells: dwords in 8-byte slots (a 32-bit store keeps the high half) -> compare low 32
            regs = [c & 0xFFFFFFFF for c in cells] + g
            hw_regs = [x & 0xFFFFFFFF for x in hw_regs[:n]] + hw_regs[n:]
        else:
            regs = g
        endrip = int(meta[pid][5])
        ok = (flg == 'NIL' and ms == 'NIL' and fault == 'NIL' and rip == endrip and regs == hw_regs
              and (fl ^ hw_fl) & FLM == 0 and slots == hw_slots)
        total += 1
        seen.add(pid)
        if not ok:
            bad += 1
            if bad <= 5:
                print('MISMATCH', p['file'], vid, 'flg/ms/fault/rip', flg, ms, fault, hex(rip), hex(endrip),
                      'acl2', [hex(x) for x in regs], hex(fl), 'hw', [hex(x) for x in hw_regs], hex(hw_fl))
    print('ACL2 x86isa (certified model, x86-run) vs hardware: programs=%d vectors=%d mismatches=%d'
          % (len(seen), total, bad))
    return bad if total else 1


if __name__ == '__main__':
    if sys.argv[1] == 'gen':
        gen(sys.argv[2], sys.argv[3], int(sys.argv[4]) if len(sys.argv) > 4 else 10 ** 9)
    else:
        sys.exit(1 if cmp(sys.argv[2], sys.argv[3], sys.argv[4]) else 0)
