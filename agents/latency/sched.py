"""Resource-constrained latency model (latency agent): cycle-level list scheduling of one call.

Machine (per uarch): in-order dispatch of W instructions per cycle (rename); an instruction can
issue when its RAW inputs are ready and a port of its class is free (oldest first);
mov r,r eliminated at rename (latency 0, no port) where the uarch does it; loads have latency LD and
use load ports; stores use store ports and end the program when their data is ready.
Result = cycle when the last store has its data (all inputs available at cycle 0 + load latency).
This is a model for ONE isolated call (latency), not measured hardware.

usage: python3 sched.py [--uarch zen4|skl|icl|zen2] files...
"""
import sys, os, argparse
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from prog import parse_team, depth, LAT

UARCH = {
    # W: dispatch width; alu: #ALU ports; cmovp: #ports that run cmov; movelim; lat cmov flags->dst; LD: load latency
    'zen4': dict(W=6, alu=4, cmovp=2, movelim=True, cmovf=1, LD=4, ldp=3, stp=2),
    'zen2': dict(W=5, alu=4, cmovp=4, movelim=True, cmovf=2, LD=4, ldp=2, stp=1),
    'skl':  dict(W=4, alu=4, cmovp=2, movelim=True, cmovf=1, LD=5, ldp=2, stp=1),
    'icl':  dict(W=5, alu=4, cmovp=2, movelim=False, cmovf=1, LD=5, ldp=2, stp=2),
}


def schedule(prog, u):
    ready = {}          # register -> cycle its value is ready
    fready = 0
    n = len(prog)
    # rename: resolve RAW sources in program order (renaming: WAR/WAW free)
    srcs = []
    for op, d, s in prog:
        if op == 'load':
            srcs.append(('ld', [], d)); continue
        if op == 'store':
            srcs.append(('st', [s], None)); continue
        if op == 'mov':
            srcs.append(('mov', [s], d)); continue
        if op == 'cmp':
            srcs.append(('cmp', [d, s], 'FLAGS')); continue
        srcs.append(('cmov', [d, s, 'FLAGS'], d))
    # map each source to the producing instruction index (last writer before it)
    last = {}
    deps = []
    for i, (cls, ss, dst) in enumerate(srcs):
        deps.append([last.get(x) for x in ss])
        if dst is not None:
            last[dst] = i
    done = [None] * n     # cycle result ready
    issued = [False] * n
    disp = [None] * n
    cyc = 0
    nd = 0
    remaining = n
    while remaining:
        # dispatch
        k = 0
        while nd < n and k < u['W']:
            disp[nd] = cyc; nd += 1; k += 1
        # issue (oldest first)
        ports = {'alu': u['alu'], 'cmov': u['cmovp'], 'ld': u['ldp'], 'st': u['stp']}
        for i in range(nd):
            if issued[i]:
                continue
            cls = srcs[i][0]
            # operand readiness at this cycle
            def rdy(j, flagsrc=False):
                if j is None:
                    return 0
                return done[j] if done[j] is not None else 10 ** 9
            t_in = 0
            for pos, j in enumerate(deps[i]):
                r = rdy(j)
                if cls == 'cmov' and pos == 2 and j is not None and done[j] is not None:
                    r = done[j] + (u['cmovf'] - 1)
                t_in = max(t_in, r)
            if t_in > cyc:
                continue
            if cls == 'mov' and u['movelim']:
                issued[i] = True; done[i] = max(t_in, disp[i]); remaining -= 1; continue
            if cls == 'ld':
                if ports['ld'] == 0: continue
                ports['ld'] -= 1; issued[i] = True; done[i] = cyc + u['LD']; remaining -= 1; continue
            if cls == 'st':
                if ports['st'] == 0: continue
                ports['st'] -= 1; issued[i] = True; done[i] = cyc; remaining -= 1; continue
            if cls == 'cmov':
                if ports['cmov'] == 0 or ports['alu'] == 0: continue
                ports['cmov'] -= 1; ports['alu'] -= 1
            else:
                if ports['alu'] == 0: continue
                ports['alu'] -= 1
            issued[i] = True; done[i] = cyc + 1; remaining -= 1
        cyc += 1
        if cyc > 10000:
            raise RuntimeError('no progress')
    stores = [done[i] for i in range(n) if srcs[i][0] == 'st']
    return max(stores) if stores else max(done)


def as_memory_form(prog):
    """team .s internal form already has load/store; nothing to do"""
    return prog


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--uarch', default='zen4')
    ap.add_argument('files', nargs='+')
    a = ap.parse_args()
    u = UARCH[a.uarch]
    print('%-50s %4s %4s %4s  %s' % ('file', 'L', 'dU', 'dE', 'sched(%s)' % a.uarch))
    for f in a.files:
        n, p, model = parse_team(f)
        print('%-50s %4d %4d %4d  %d' % (os.path.relpath(f), len(p), depth(p, LAT['U'])[0], depth(p, LAT['E'])[0], schedule(p, u)))
