#!/usr/bin/env python3
"""exact window sweep: for each seed program and window size w, test every window [i,i+w) -> w-1 slots.
Usage: sweep.py seeds.s W[,W..] NPROC out.txt [first:last seed]"""
import sys, os, time, random
from multiprocessing import Pool
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import winsat as W
DELTA = int(os.environ.get('DELTA', '1'))
FRESH = int(os.environ.get('FRESH', '2'))

def load(fn):
    progs, cur, tag = [], None, None
    for line in open(fn):
        if line.startswith('# prog'):
            if cur: progs.append((tag, cur))
            cur, tag = [], line.split('idx=')[1].strip() if 'idx=' in line else str(len(progs))
            continue
        line = line.split('#')[0].strip()
        if not line or line.startswith('out'): continue
        op, rest = line.split(None, 1)
        d, s = [x.strip() for x in rest.split(',')]
        cur.append((op, d, s))
    if cur: progs.append((tag, cur))
    return progs

def job(a):
    tag, lines, w, i = a
    prog, names = W.parse_regs(lines)
    R = max(max(d, s) for _, d, s in prog) + 1
    t0 = time.time()
    r = W.window_test(prog, R, i, w, w - DELTA, fresh=FRESH, ninit=6, rng=random.Random(hash((tag, i, w)) & 0xffff))
    dt = time.time() - t0
    if r[0] == 'HIT':
        txt = W.fmt_prog(r[1], names)
        return '%s w=%d i=%d HIT %.1fs\n%s\n' % (tag, w, i, dt, txt)
    return '%s w=%d i=%d %s tests=%d %.1fs\n' % (tag, w, i, r[0], r[1], dt)

if __name__ == '__main__':
    fn, ws, npr, out = sys.argv[1], [int(x) for x in sys.argv[2].split(',')], int(sys.argv[3]), sys.argv[4]
    progs = load(fn)
    if len(sys.argv) > 5:
        a, b = map(int, sys.argv[5].split(':')); progs = progs[a:b]
    done = set()
    if os.path.exists(out):
        for line in open(out):
            p = line.split()
            if len(p) >= 4 and p[1].startswith('w='): done.add((p[0], p[1], p[2]))
    CONTAINS = int(os.environ.get('CONTAINS', '-1'))   # only windows containing this index
    MINSCR = int(os.environ.get('MINSCR', '0'))   # rerun mode: only windows with > MINSCR removed scratch regs
    def nscratch(lines, i, w):
        prog, _ = W.parse_regs(lines)
        used = sorted(set(r for _, d, s in prog for r in (d, s)) | set(range(W.N)))
        st = W.sim_states(prog[:i], max(used) + 1)[-1][0]
        def dead_after(r):
            for op, d, s in prog[i + w:]:
                if s == r or (op != 'mov' and d == r): return False
                if op == 'mov' and d == r: return True
            return True
        return sum(1 for r in used if r >= W.N and (st[r] == W.U).all() and dead_after(r))
    jobs = [(tag, lines, w, i) for w in ws for tag, lines in progs for i in range(len(lines) - w + 1)
            if (tag, 'w=%d' % w, 'i=%d' % i) not in done and (CONTAINS < 0 or i <= CONTAINS < i + w) and (MINSCR == 0 or nscratch(lines, i, w) > MINSCR)]
    print(len(jobs), 'jobs', flush=True)
    with Pool(npr) as pool, open(out, 'a') as fo:
        for res in pool.imap_unordered(job, jobs, chunksize=1):
            fo.write(res); fo.flush()
            if 'HIT' in res.split('\n')[0]:
                print(res, flush=True)
