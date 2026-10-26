#!/usr/bin/env python3
"""Independent simulator and lattice completion check. No judge imports."""
import argparse
import gzip
import itertools
import json
from functools import lru_cache
from pathlib import Path

PERMS = tuple(itertools.permutations(range(5)))
CONDS = {"cmovl": lambda f: f < 0, "cmovle": lambda f: f <= 0,
         "cmovg": lambda f: f > 0, "cmovge": lambda f: f >= 0}

def parse(text):
    ans = []
    for line in text.splitlines():
        line = line.split("#", 1)[0].strip()
        if line:
            op, args = line.split(None, 1)
            a, b = (s.strip() for s in args.split(","))
            ans.append((op, a, b))
    return ans

def dump(prog, path, source="w10"):
    Path(path).write_text("# n=5 model=out iset=I1 source=" + source + "\n" +
                          "\n".join(f"{o} {a}, {b}" for o,a,b in prog) + "\n")

def collection(path):
    opener = gzip.open if str(path).endswith(".gz") else open
    with opener(path, "rt") as f:
        cur = []
        for line in f:
            if line.startswith("#"):
                if cur:
                    yield cur
                cur = []
            elif line.strip():
                cur += parse(line)
        if cur:
            yield cur

@lru_cache(maxsize=50000)
def lattice_completion(col):
    """All non-garbage entries must agree with one monotone Boolean function.

    For each upper set B of a permutation, output >= threshold iff the
    selected input is in B. A min/max expression defines one monotone
    Boolean function on these B. Conflicting requirements refute completion.
    Unspecified entries impose no constraints. This criterion is exact on
    strict permutations. Returns (possible, witness).
    """
    fixed = {0: (False, None), 31: (True, None)}
    for p, value in zip(PERMS, col):
        if value is None:
            continue
        selected = p.index(value)
        mask = 0
        for k in range(6):
            bit = bool(mask & (1 << selected))
            origin = {"input": p, "value": value, "upper_set": mask}
            if mask in fixed and fixed[mask][0] != bit:
                return False, {"kind": "same_set", "first": fixed[mask][1], "second": origin}
            fixed[mask] = (bit, origin)
            if k < 5:
                mask |= 1 << p.index(4-k)
    for a, (va, oa) in fixed.items():
        if not va:
            continue
        for b, (vb, ob) in fixed.items():
            if (a & b) == a and not vb:
                return False, {"kind": "monotonicity", "first": oa, "second": ob}
    return True, None

def trace(prog):
    scratch = (None,) * len(PERMS)
    state = {f"P{i}": tuple(p[i] for p in PERMS) for i in range(5)}
    flags = (0,) * len(PERMS)
    outs = {}
    rows = []
    for step, (op, a, b) in enumerate(prog):
        x, y = state.get(a, scratch), state.get(b, scratch)
        if op == "out":
            outs[int(a)] = y
            continue
        if op == "cmp":
            # Strict conservative semantics. Unknown comparison is not given
            # a sentinel order. Equal unknowns are also treated as unknown.
            flags = tuple(None if u is None or v is None else (u > v)-(u < v)
                          for u,v in zip(x,y))
            continue
        if op == "mov":
            col = y
        else:
            col = tuple((v if CONDS[op](f) else u) if f is not None else
                        (u if u == v else None) for u,v,f in zip(x,y,flags))
        state[a] = col
        possible, witness = lattice_completion(col)
        rows.append({"step": step+1, "instruction": f"{op} {a}, {b}",
                     "garbage_entries": col.count(None), "lattice_completion": possible,
                     "witness": witness, "column": col})
    for j in range(5):
        outs.setdefault(j, state[f"P{j}"])
    correct = all(outs[j] == (j,) * 120 for j in range(5))
    return rows, correct

def first_access_eliminate(prog):
    """First-access rewrite for one fresh and one known operand.

    This implements only the cases used by the seed programs. It does not
    claim to implement the garbage-class theorem.
    """
    prog = list(prog)
    while True:
        seen = {f"P{i}" for i in range(5)}
        changed = False
        for t, (op, a, b) in enumerate(prog):
            reads = [b] if op in ("mov", "out") else [a,b]
            fresh = [r for r in reads if r not in seen]
            if fresh:
                if len(set(fresh)) != 1 or op in ("out", "cmp"):
                    raise ValueError((t, op, a, b, "unsupported first access"))
                s = fresh[0]
                other = b if s == a else a
                if other not in seen:
                    raise ValueError("both operands fresh")
                prog[t] = ("mov", s, other)
                changed = True
                break
            if op != "cmp" and op != "out":
                seen.add(a)
        if not changed:
            return prog

def summary(prog):
    rows, correct = trace(prog)
    return {"k": sum(o != "out" for o,_,_ in prog), "correct_120": correct,
            "partial_columns": sum(0 < r["garbage_entries"] < 120 for r in rows),
            "noncompletable_partial": sum(0 < r["garbage_entries"] < 120 and not r["lattice_completion"] for r in rows),
            "nonlattice_full": sum(not r["garbage_entries"] and not r["lattice_completion"] for r in rows)}

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("file")
    ap.add_argument("--trace", action="store_true")
    args = ap.parse_args()
    prog = parse(Path(args.file).read_text())
    print(json.dumps(summary(prog), indent=2))
    if args.trace:
        rows, _ = trace(prog)
        print(json.dumps([{k:v for k,v in r.items() if k != "column"} for r in rows], indent=2))
