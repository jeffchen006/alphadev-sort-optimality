"""latency agent: program parser, strict simulator, dependency-depth calculator.

Internal form: list of (op, dst, src), Intel operand order.
  op in {mov, cmp, cmovl, cmovg, cmovle, cmovge, load, store}
  cmp A,B      : lt := A<B, gt := A>B
  load r, i    : r := x_i   (memory load; depth model: see LAT tables)
  store i, r   : out_i := r (memory store)
A register program in the team format (shared/MODEL.md sec. 5) has no load/store:
inputs start in P0..P{n-1}, output j is in Pj at the end.
"""
import itertools, random, re, sys

CC = {'cmovl': lambda lt, gt: lt, 'cmovg': lambda lt, gt: gt,
      'cmovle': lambda lt, gt: not gt, 'cmovge': lambda lt, gt: not lt}


def parse_att_function(path, fname):
    """Extract the asm of `void <fname>(int* buffer)` in AT&T syntax."""
    src = open(path).read()
    body = src[src.index('void %s(' % fname):]
    body = body[:body.index('\n}')]
    prog = []
    for line in re.findall(r'"([^"]*)\\n"', body):
        line = line.strip()
        op, args = line.split(None, 1)
        a, b = [s.strip() for s in re.split(r',(?![^()]*\))', args)]
        def mem(s):
            m = re.fullmatch(r'(0x[0-9a-f]+)?\(%0\)', s)
            return None if m is None else int(m.group(1) or '0', 16) // 4
        reg = lambda s: s.replace('%%', '')
        if op == 'mov' and mem(a) is not None:
            prog.append(('load', reg(b), mem(a)))
        elif op == 'mov' and mem(b) is not None:
            prog.append(('store', mem(b), reg(a)))
        else:  # AT&T "op src, dst" -> Intel "op dst, src"
            prog.append((op, reg(b), reg(a)))
    return prog


def parse_s(path):
    """Team .s format -> (n, prog). Inputs: load Pi,i prepended; stores Pj appended."""
    n = None
    prog = []
    for line in open(path):
        if line.startswith('#') and n is None:
            m = re.search(r'n=(\d+)', line)
            if m:
                n = int(m.group(1))
        line = line.split('#')[0].strip()
        if not line:
            continue
        op, args = line.split(None, 1)
        d, s = [x.strip() for x in args.split(',')]
        prog.append((op, d, s))
    return n, [('load', 'P%d' % i, i) for i in range(n)] + prog + \
        [('store', j, 'P%d' % j) for j in range(n)]


def parse_team(path):
    """Team .s file, any model (reg | mem | out, shared/MODEL.md sec. 4-5) -> (n, internal prog).
    mem: P = memory cells; mov S,P = load, mov P,S = store (last store wins).
    out: 'out j, S' = snapshot store (last wins); missing outputs = final Pj.
    reg: inputs P0..P{n-1}, outputs final Pj."""
    n = None; model = 'reg'
    body = []
    for line in open(path):
        if line.startswith('#'):
            m = re.search(r'\bn=(\d+)', line)
            if m and n is None:
                n = int(m.group(1))
            m = re.search(r'model=(\w+)', line)
            if m:
                model = m.group(1)
        line = line.split('#')[0].strip()
        if not line:
            continue
        op, args = line.split(None, 1)
        d, s = [x.strip() for x in args.split(',')]
        body.append((op, d, s))
    prog = []
    if model == 'mem':
        stored = set()
        for op, d, s in body:
            if op == 'mov' and s.startswith('P'):
                assert s not in stored, 'reload after store: not supported'
                prog.append(('load', d, int(s[1:])))
            elif op == 'mov' and d.startswith('P'):
                stored.add(d); prog.append(('store', int(d[1:]), s))
            else:
                prog.append((op, d, s))
        return n, prog, model
    prog = [('load', 'P%d' % i, i) for i in range(n)]
    outs = set()
    for op, d, s in body:
        if op == 'out':
            prog.append(('store', int(d), s)); outs.add(int(d))
        else:
            prog.append((op, d, s))
    prog += [('store', j, 'P%d' % j) for j in range(n) if j not in outs]
    return n, prog, model


def weak_orders(n):
    """All weak order types of n items as rank tuples (Fubini number many)."""
    seen = set()
    for r in itertools.product(range(n), repeat=n):
        vals = sorted(set(r))
        t = tuple(vals.index(v) for v in r)
        seen.add(t)
    return sorted(seen)


def run(prog, xs, garbage, flags0):
    regs = dict(garbage)
    lt, gt = flags0
    out = {}
    for op, d, s in prog:
        if op == 'load':
            regs[d] = xs[s]
        elif op == 'store':
            out[d] = regs[s]
        elif op == 'mov':
            regs[d] = regs[s]
        elif op == 'cmp':
            lt, gt = regs[d] < regs[s], regs[d] > regs[s]
        else:
            if CC[op](lt, gt):
                regs[d] = regs[s]
    return out


def check(prog, n, trials=20):
    """Strict check: all weak orders x several garbage/flag choices."""
    regs = {r for p in prog for r in (p[1], p[2]) if isinstance(r, str)}
    rnd = random.Random(1)
    for w in weak_orders(n):
        for t in range(trials):
            g = {r: rnd.choice([-10**9, 10**9, rnd.randint(-5, 10)]) for r in regs}
            f = rnd.choice([(False, False), (True, False), (False, True)])
            out = run(prog, list(w), g, f)
            if [out[j] for j in range(n)] != sorted(w):
                return False, (w, g, f, out)
    return True, None


# Latency tables (cycles). 'load' = 0: inputs are available at time 0
# (a real load adds the same constant to every input, so it shifts all depths equally).
LAT = {
    'U': dict(mov=1, cmp=1, cmovl=1, cmovg=1, cmovle=1, cmovge=1, load=0),  # unit, no mov elim
    'E': dict(mov=0, cmp=1, cmovl=1, cmovg=1, cmovle=1, cmovge=1, load=0),  # mov eliminated
    # Zen 2: cmov flags->dst 2, data->dst 1; flags feed only cmovs, so = cmp latency 2
    'Z2': dict(mov=0, cmp=2, cmovl=1, cmovg=1, cmovle=1, cmovge=1, load=0),
}


def depth(prog, lat):
    """Critical path (data + flags, RAW only) to the stored outputs.
    Returns (max over outputs, per-output depth list, per-instruction depth)."""
    t = {}          # register -> ready time; unset register = 0 (garbage, never on a real path)
    tf = 0          # flags ready time
    out = {}
    per = []
    for op, d, s in prog:
        if op == 'load':
            t[d] = lat['load']; per.append(t[d])
        elif op == 'store':
            out[d] = t.get(s, 0); per.append(None)
        elif op == 'mov':
            t[d] = t.get(s, 0) + lat['mov']; per.append(t[d])
        elif op == 'cmp':
            tf = max(t.get(d, 0), t.get(s, 0)) + lat['cmp']; per.append(tf)
        else:
            t[d] = max(t.get(d, 0), t.get(s, 0), tf) + lat[op]; per.append(t[d])
    o = [out[j] for j in sorted(out)]
    return max(o), o, per


def counts(prog):
    c = {}
    for p in prog:
        c[p[0]] = c.get(p[0], 0) + 1
    return c

