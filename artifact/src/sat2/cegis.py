#!/usr/bin/env python3
"""sat2 CEGIS driver. UNSAT on a subset of order types => UNSAT for all (sound: fewer constraints).
SAT => check the program with the own simulator on all order types; add a failing type; repeat.

Example: python3 cegis.py --n 3 --k 11 --iset I1 --enc cnf
"""
import argparse, json, os, random, sys, time
from common import weak_orders, failures, strict_failures, format_program


def make_solver(args, n, k, R):
    if args.enc == "cnf":
        from cnf_enc import CNFEncoding
        from pysat.solvers import Solver
        from cnf_enc import ALL_RULES
        rules = (ALL_RULES - {"llS"} - {"llP"} - ({"llPall"} if args.out == "fixed" else set())
                 - ({"snapT"} if args.out != "snap" else set())) if args.rules == "all" \
            else [x for x in args.rules.split(",") if x]
        enc = CNFEncoding(n, k, R, args.iset, args.out, args.no_noop, not args.no_sym, rules=rules,
                          min_cmp=args.min_cmp, min_cmov=args.min_cmov,
                          max_cmp=args.max_cmp, nop=args.nop)
        sat = Solver(name=args.solver)
        state = {"sent": 0}

        def flush():
            cl = enc.c.clauses
            for x in cl[state["sent"]:]:
                sat.add_clause(x)
            state["sent"] = len(cl)

        def solve():
            flush()
            if not sat.solve():
                return None
            return enc.decode(sat.get_model())

        def size():
            return enc.c.nv, len(enc.c.clauses)
        args.rules_resolved = ",".join(sorted(enc.rules))
        return enc, solve, size
    else:
        from smt_enc import SMTEncoding
        enc = SMTEncoding(n, k, R, args.iset, args.out, args.no_noop, not args.no_sym)
        return enc, enc.solve, lambda: (None, len(enc.s.assertions()))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--n", type=int, required=True)
    ap.add_argument("--k", type=int, required=True)
    ap.add_argument("--R", type=int, default=None, help="registers, default n+k")
    ap.add_argument("--iset", default="I0", choices=["I0", "I1"])
    ap.add_argument("--enc", default="cnf", choices=["cnf", "smt"])
    ap.add_argument("--solver", default="cadical195")
    ap.add_argument("--out", default="fixed", choices=["fixed", "free", "snap", "snapw"],
                    help="fixed: final P0..; free: final, any registers; snap: any register at any step (judge model=out)")
    ap.add_argument("--free-out", action="store_true", help="same as --out free")
    ap.add_argument("--no-noop", action="store_true", help="forbid mov/cmov D,D (needs length sweep for soundness)")
    ap.add_argument("--no-sym", action="store_true", help="no scratch first-write-order symmetry breaking")
    ap.add_argument("--rules", default="", help="cnf only: comma list or all (see RULES.md)")
    ap.add_argument("--min-cmp", type=int, default=0, help="cnf: #cmp >= this (bounds C1)")
    ap.add_argument("--max-cmp", type=int, default=None, help="cnf: #cmp <= this (cube split)")
    ap.add_argument("--nop", action="store_true", help="cnf: NOP-suffix mode, one CNF for all lengths <= k")
    ap.add_argument("--min-cmov", type=int, default=0, help="cnf: #cmov >= this (bounds C2)")
    ap.add_argument("--perms", action="store_true", help="start with all n! permutations")
    ap.add_argument("--hcmp", action="store_true", help="cnf: add all n! permutations + per-step L7 class bound")
    ap.add_argument("--init", type=int, default=2)
    ap.add_argument("--all", action="store_true", help="add every order type up front (no CEGIS)")
    ap.add_argument("--seed", type=int, default=1)
    ap.add_argument("--save", default=None)
    ap.add_argument("--dump", default=None, help="write the final-subset CNF (cnf enc) to this file")
    ap.add_argument("--json", default=None)
    ap.add_argument("--types-json", default=None, help="start from the 'subset' of a res/*.json file")
    ap.add_argument("--dump-only", action="store_true", help="with --dump: write the CNF of the start subset, no solve")
    args = ap.parse_args()
    if args.free_out:
        args.out = "free"
    n, k = args.n, args.k
    R = args.R or n + k
    allt = weak_orders(n)
    rng = random.Random(args.seed)
    t0 = time.time()
    enc, solve, size = make_solver(args, n, k, R)
    if args.types_json:
        init = [tuple(e) for e in json.load(open(args.types_json))["subset"]]
    else:
        init = allt if args.all else rng.sample(allt, min(args.init, len(allt)))
    if args.hcmp or args.perms:
        perms = [e for e in allt if len(set(e)) == n]
        init = perms + [e for e in init if e not in perms]
    for e in init:
        enc.add_type(e)
    if args.hcmp:
        enc.add_hcmp(perms)
    it, result, prog, outs = 0, None, None, None
    if args.dump_only:
        cl = enc.c.clauses
        with open(args.dump, "w") as f:
            f.write(f"p cnf {enc.c.nv} {len(cl)}\n")
            for x in cl:
                f.write(" ".join(map(str, x)) + " 0\n")
        print(f"dumped {args.dump}: {enc.c.nv} vars {len(cl)} clauses, {len(enc.types)} types")
        return
    while True:
        it += 1
        ts = time.time()
        r = solve()
        dt = time.time() - ts
        print(f"iter {it} types {len(enc.types)} size {size()} solve {dt:.2f}s -> {'UNSAT' if r is None else 'SAT'}",
              flush=True)
        if r is None:
            result = "UNSAT"
            break
        prog, outs = r
        bad = failures(prog, n, R, outs)
        if not bad:
            result = "SAT"
            break
        e = rng.choice(bad)
        assert e not in enc.types, "solver program fails on a type already in the subset: encoding bug"
        enc.add_type(e)
    total = time.time() - t0
    info = dict(n=n, k=k, R=R, iset=args.iset, enc=args.enc, out=args.out, no_noop=args.no_noop,
                scratch_sym=not args.no_sym, rules=args.rules, rules_resolved=getattr(args, "rules_resolved", ""), hcmp=args.hcmp, nop=args.nop, max_cmp=args.max_cmp, min_cmp=args.min_cmp, min_cmov=args.min_cmov, result=result, iters=it, types=len(enc.types), time=round(total, 2),
                subset=[list(e) for e in enc.types])
    print(f"RESULT {result} n={n} k={k} R={R} iset={args.iset} enc={args.enc} out={args.out} "
          f"rules={args.rules or '-'} [{getattr(args, 'rules_resolved', '')}] card={args.min_cmp},{args.min_cmov},max{args.max_cmp} nop={args.nop} time={total:.2f}s iters={it} types={len(enc.types)}", flush=True)
    if result == "SAT":
        strict = strict_failures(prog, n, R, outs)
        info["strict_ok"] = not strict
        model = "reg" if args.out == "fixed" else "out"
        hdr = f"# n={n} R={R} iset={args.iset} model={model} source=sat2_{args.enc}_cegis k={len(prog)} K={k}"
        txt = format_program(prog, n, hdr, None if args.out == "fixed" else outs)
        info["program"] = txt
        info["outs"] = outs
        print(txt, end="")
        print(f"outs {outs} strict_ok {not strict}")
        if args.save:
            with open(args.save, "w") as f:
                f.write(txt)
            import subprocess
            judge = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../shared/judge.py")
            jr = subprocess.run([sys.executable, judge, args.save, "--strict", "--model", model, "--iset", args.iset],
                                capture_output=True, text=True)
            info["judge"] = (jr.stdout + jr.stderr).strip()[-500:]
            print("JUDGE:", info["judge"].replace("\n", " | "))
    if args.dump and args.enc == "cnf":
        cl = enc.c.clauses
        with open(args.dump, "w") as f:
            f.write(f"p cnf {enc.c.nv} {len(cl)}\n")
            for x in cl:
                f.write(" ".join(map(str, x)) + " 0\n")
    if args.json:
        with open(args.json, "w") as f:
            json.dump(info, f)


if __name__ == "__main__":
    main()
