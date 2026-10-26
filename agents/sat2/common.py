"""sat2: order types, program parser/writer, and an own simulator (relaxed model of shared/MODEL.md v0).

Value-level semantics: for a weak order type e (rank vector, ranks 0..m-1), input x_i := rank_i.
Scratch registers start as T (= n, larger than every rank). Flags start as eq (lt = gt = False).
"""
import itertools

OPS_I0 = ["mov", "cmp", "cmovl", "cmovg"]
OPS_I1 = OPS_I0 + ["cmovle", "cmovge"]
ISETS = {"I0": OPS_I0, "I1": OPS_I1}


def weak_orders(n):
    """All weak order types of n elements as rank tuples (ranks are 0..m-1, all used)."""
    out = []
    for r in itertools.product(range(n), repeat=n):
        m = max(r) + 1
        if set(r) == set(range(m)):
            out.append(r)
    return out


def reg_name(r, n):
    return f"P{r}" if r < n else f"S{r - n}"


def reg_index(name, n):
    name = name.strip()
    if name[0] == "P":
        i = int(name[1:])
        assert 0 <= i < n, name
        return i
    if name[0] == "S":
        return n + int(name[1:])
    raise ValueError(name)


def parse_program(text, n):
    prog = []
    for line in text.splitlines():
        line = line.split("#", 1)[0].strip()
        if not line:
            continue
        op, rest = line.split(None, 1)
        d, s = [x.strip() for x in rest.split(",")]
        prog.append((op.lower(), reg_index(d, n), reg_index(s, n)))
    return prog


def format_program(prog, n, header="", outs=None):
    """outs: as in norm_outs; non-default outputs are written as judge 'out j, R' pseudo-instructions."""
    lines = []
    if header:
        lines.append(header)
    no = norm_outs(outs, n, len(prog))
    def outs_at(t):
        return [f"out {j}, {reg_name(r, n)}" for j, (tt, r) in enumerate(no) if tt == t and outs is not None]
    lines += outs_at(0)
    for t, (op, d, s) in enumerate(prog):
        lines.append(f"{op} {reg_name(d, n)}, {reg_name(s, n)}")
        lines += outs_at(t + 1)
    return "\n".join(lines) + "\n"


def step(op, d, s, regs, lt, gt):
    """One instruction; regs is a list (mutated). Returns new (lt, gt)."""
    if op == "cmp":
        a, b = regs[d], regs[s]
        return a < b, a > b
    if op == "mov":
        w = True
    elif op == "cmovl":
        w = lt
    elif op == "cmovg":
        w = gt
    elif op == "cmovle":
        w = not gt
    elif op == "cmovge":
        w = not lt
    else:
        raise ValueError(op)
    if w:
        regs[d] = regs[s]
    return lt, gt


def run(prog, n, R, ranks, lt=False, gt=False, scratch=None, history=False):
    T = n
    regs = list(ranks) + ([T] * (R - n) if scratch is None else list(scratch))
    hist = [list(regs)]
    for op, d, s in prog:
        lt, gt = step(op, d, s, regs, lt, gt)
        hist.append(list(regs))
    return hist if history else regs


def norm_outs(outs, n, k):
    """outs: None (final P0..), list of registers (final), or list of (t, r) snapshots (state after t steps)."""
    if outs is None:
        return [(k, j) for j in range(n)]
    return [o if isinstance(o, (tuple, list)) else (k, o) for o in outs]


def failures(prog, n, R, outs=None, types=None):
    """Order types on which prog (relaxed model) does not sort. outs[j] = register holding output j."""
    outs = norm_outs(outs, n, len(prog))
    bad = []
    for e in (types if types is not None else weak_orders(n)):
        hist = run(prog, n, R, e, history=True)
        want = sorted(e)
        if [hist[t][r] for t, r in outs] != want:
            bad.append(e)
    return bad


def strict_failures(prog, n, R, outs=None, limit_scratch=4):
    """Strict model check: every initial scratch value (all weak order types of inputs+used scratch) and
    every initial flag state (eq, lt, gt). Only scratch registers the program mentions are varied."""
    outs = norm_outs(outs, n, len(prog))
    used = sorted({r for _, d, s in prog for r in (d, s) if r >= n})
    if len(used) > limit_scratch:
        raise ValueError("too many scratch registers for strict check")
    m = n + len(used)
    bad = []
    for e in weak_orders(m):
        for lt0, gt0 in ((False, False), (True, False), (False, True)):
            lt, gt = lt0, gt0
            regs = list(e[:n]) + [0] * (R - n)
            for j, r in enumerate(used):
                regs[r] = e[n + j]
            hist = [list(regs)]
            for op, d, s in prog:
                lt, gt = step(op, d, s, regs, lt, gt)
                hist.append(list(regs))
            if [hist[t][r] for t, r in outs] != sorted(e[:n]):
                bad.append((e, lt0, gt0))
                break
    return bad
