"""Resynthesize a short instruction window with packed Z3 bit vectors.

The independent concrete evaluator uses all 541 weak orders. The solver starts
with 16 cases. A failed candidate adds cases that exclude its output witnesses.
UNKNOWN and time limits do not establish any exclusion.
"""
import argparse
import itertools
import json
from pathlib import Path
import time
import z3

OPS = ["mov", "cmp", "cmovl", "cmovle", "cmovg", "cmovge"]
CASES = [x for x in itertools.product(range(5), repeat=5)
         if set(x) == set(range(max(x) + 1))]
GOALS = list(zip(*(sorted(x) for x in CASES)))


def read(path):
    registers = {f"P{i}": i for i in range(5)}
    program = []
    for line in Path(path).read_text().splitlines():
        line = line.split("#")[0].strip()
        if not line or line.startswith("out"):
            continue
        op, d, s = line.replace(",", " ").split()
        for r in (d, s):
            if r not in registers:
                registers[r] = len(registers)
        program.append((OPS.index(op), registers[d], registers[s]))
    return program, len(registers) + 1


def concrete(program, nr):
    registers = [tuple(x[r] for x in CASES) if r < 5 else (None,) * 541 for r in range(nr)]
    flags = (None,) * 541
    columns = [(-1, r, col) for r, col in enumerate(registers)]
    states = [(registers[:], flags)]
    for t, (op, d, s) in enumerate(program):
        a, b = registers[d], registers[s]
        if op == 0:
            registers[d] = b
        elif op == 1:
            flags = tuple(0 if d == s else None if a0 is None or b0 is None
                          else (a0 > b0) - (a0 < b0) for a0, b0 in zip(a, b))
        else:
            def choose(a0, b0, f):
                if f is None:
                    return a0 if a0 == b0 else None
                yes = f < 0 if op == 2 else f <= 0 if op == 3 else f > 0 if op == 4 else f >= 0
                return b0 if yes else a0
            registers[d] = tuple(choose(a0, b0, f) for a0, b0, f in zip(a, b, flags))
        if op != 1:
            columns.append((t, d, registers[d]))
        states.append((registers[:], flags))
    return columns, states


def reg(r):
    return f"P{r}" if r < 5 else f"S{r-5}"


def packed(column, chosen, bits):
    return [z3.BitVecVal(sum((1 << i) for i, t in enumerate(chosen)
                              if (((7 if column[t] is None else column[t]) >> b) & 1)), bits)
            for b in range(3)]


def solve_window(program, nr, start, width, seconds, output, control=False, delete=None):
    began = time.monotonic()
    prefix_columns, states = concrete(program[:start], nr)
    initial_regs, initial_flags = states[-1]
    chosen = sorted({(173 * i + 19) % 541 for i in range(16)})
    attempts = 0
    while time.monotonic() - began < seconds:
        attempts += 1
        bits = len(chosen)
        zero = z3.BitVecVal(0, bits)
        allbits = z3.BitVecVal((1 << bits) - 1, bits)
        rs = [packed(col, chosen, bits) for col in initial_regs]
        lt, gt, un = [z3.BitVecVal(sum(1 << i for i, t in enumerate(chosen)
                                     if initial_flags[t] == outcome), bits)
                      for outcome in (-1, 1, None)]
        goals = [packed(goal, chosen, bits) for goal in GOALS]
        conditions = [[z3.BoolVal(any(all(col[t] == GOALS[j][t] for t in chosen)
                                           for _, _, col in prefix_columns))] for j in range(5)]
        solver = z3.Solver()
        choices = []

        def select(index):
            return [
                z3.simplify(z3.If(index == nr - 1, rs[nr - 1][b],
                    nested(index, b))) for b in range(3)]

        def nested(index, bit):
            result = rs[0][bit]
            for r in range(1, nr - 1):
                result = z3.If(index == r, rs[r][bit], result)
            return result

        def step(op, d, s, dynamic):
            nonlocal rs, lt, gt, un
            a = select(d) if dynamic else rs[d]
            b = select(s) if dynamic else rs[s]
            eq, nlt, ngt = allbits, zero, zero
            for bit in (2, 1, 0):
                nlt = nlt | (eq & ~a[bit] & b[bit])
                ngt = ngt | (eq & a[bit] & ~b[bit])
                eq = eq & ~(a[bit] ^ b[bit])
            nu = (a[0] & a[1] & a[2]) | (b[0] & b[1] & b[2])
            if dynamic:
                nu = z3.If(d == s, zero, nu)
                nlt = z3.If(d == s, zero, nlt)
                ngt = z3.If(d == s, zero, ngt)
            elif d == s:
                nu = nlt = ngt = zero
            nlt, ngt = nlt & ~nu, ngt & ~nu
            if dynamic:
                cond = z3.If(op == 2, lt, z3.If(op == 3, ~(gt | un), z3.If(op == 4, gt, ~(lt | un))))
            else:
                cond = lt if op == 2 else ~(gt | un) if op == 3 else gt if op == 4 else ~(lt | un)
            difference = (a[0] ^ b[0]) | (a[1] ^ b[1]) | (a[2] ^ b[2])
            value = [(a[k] & ~cond) | (b[k] & cond) | (un & difference) for k in range(3)]
            if dynamic:
                value = [z3.If(op == 0, b[k], z3.If(op == 1, a[k], value[k])) for k in range(3)]
                rs = [[z3.If(d == r, value[k], rs[r][k]) for k in range(3)] for r in range(nr)]
                lt, gt, un = [z3.If(op == 1, new, old) for new, old in ((nlt, lt), (ngt, gt), (nu, un))]
            elif op == 0:
                value = b
                rs[d] = value
            elif op == 1:
                lt, gt, un = nlt, ngt, nu
            else:
                rs[d] = value
            if dynamic or op != 1:
                for j in range(5):
                    conditions[j].append(z3.And(*(value[k] == goals[j][k] for k in range(3))))

        for i in range(width if control else width - 1):
            op, d, s = z3.Ints(f"op{i} d{i} s{i}")
            solver.add(op >= 0, op < 6, d >= 0, d < nr, s >= 0, s < nr)
            choices.append((op, d, s))
            if control:
                solver.add(*(x == v for x, v in zip((op, d, s), program[start + i])))
            elif delete is not None:
                original = program[start + i + (i >= delete)]
                if original[0] < 2:
                    solver.add(op == original[0])
                else:
                    solver.add(op >= 2)
                if original[0] != 1:
                    solver.add(d == original[1])
            step(op, d, s, True)
        for instruction in program[start + width:]:
            step(*instruction, False)
        for alternatives in conditions:
            solver.add(z3.Or(*alternatives))
        remaining = seconds - (time.monotonic() - began)
        if remaining <= 0:
            break
        solver.set(timeout=max(1, int(1000 * remaining)))
        status = solver.check()
        if status != z3.sat:
            return {"window": start, "status": str(status), "cases": bits,
                    "attempts": attempts, "seconds": time.monotonic() - began}
        model = solver.model()
        replacement = [tuple(model.eval(x).as_long() for x in instruction) for instruction in choices]
        candidate = program[:start] + replacement + program[start + width:]
        columns, _ = concrete(candidate, nr)
        witnesses = []
        added = set()
        for j, goal in enumerate(GOALS):
            full = [(t, r) for t, r, col in columns if col == goal]
            if full:
                witnesses.append(full[0])
                continue
            witnesses.append(None)
            for _, _, col in columns:
                if all(col[t] == goal[t] for t in chosen):
                    added.add(next(t for t in range(541) if col[t] != goal[t]))
        if all(witness is not None for witness in witnesses):
            text = [f"# n=5 model=out iset=I1 source=w6-window-sat k={len(candidate)}"]
            for j, (t, r) in enumerate(witnesses):
                if t == -1:
                    text.append(f"out {j}, {reg(r)}")
            for t, (op, d, s) in enumerate(candidate):
                text.append(f"{OPS[op]} {reg(d)}, {reg(s)}")
                for j, witness in enumerate(witnesses):
                    if witness[0] == t:
                        text.append(f"out {j}, {reg(witness[1])}")
            Path(output).write_text("\n".join(text) + "\n")
            return {"window": start, "status": "CANDIDATE", "file": output,
                    "cases": bits, "attempts": attempts, "seconds": time.monotonic() - began}
        assert added - set(chosen), "CEGIS must add a case"
        chosen = sorted(set(chosen) | added)
    return {"window": start, "status": "timeout", "cases": len(chosen),
            "attempts": attempts, "seconds": time.monotonic() - began}


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("seed")
    parser.add_argument("--width", type=int, default=5)
    parser.add_argument("--seconds", type=float, default=40)
    parser.add_argument("--first", type=int, default=12)
    parser.add_argument("--last", type=int, default=24)
    parser.add_argument("--control", action="store_true")
    parser.add_argument("--delete", type=int)
    args = parser.parse_args()
    program, nr = read(args.seed)
    for start in range(args.first, min(args.last + 1, len(program) - args.width + 1)):
        result = solve_window(program, nr, start, args.width, args.seconds,
                              f"candidates/window{args.width}_{start}_k{32 if args.control else 31}.s",
                              args.control, args.delete)
        print(json.dumps(result), flush=True)
        if result["status"] == "CANDIDATE":
            break
