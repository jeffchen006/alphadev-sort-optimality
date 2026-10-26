#!/usr/bin/env python3
"""Certified finite relaxation for all c=0 programs, at any length.

Fix initial flags to eq and initial scratch values above all inputs. Then
every instruction either does nothing or copies a fixed symbol. An out value
is one fixed input symbol or the scratch symbol. No such symbol is the minimum
on all strict input orders. The CNF permits an arbitrary choice of that symbol
for output zero, so it is a relaxation of all no-comparison programs.
"""
import itertools
import json
from pathlib import Path
import subprocess
from pysat.solvers import Solver
from independent_c2 import Formula, sha
from certify_c2 import CHECKER


def main():
    root = Path(__file__).resolve().parents[1]/'independent/no_comparison'
    root.mkdir(parents=True, exist_ok=True)
    cnf = root/'c0.cnf'
    f = Formula(cnf)
    choices = f.one(6)  # P0..P4 or T; T is larger than every input.
    orders = list(itertools.permutations(range(5)))
    witnesses = []
    for symbol, choice in enumerate(choices):
        witness = next(order for order in orders
                       if symbol == 5 or order[symbol] != min(order))
        witnesses.append(dict(symbol=symbol, input_order=witness))
        f.clause(-choice)
    f.finish()
    clauses = []
    for line in cnf.read_text().splitlines()[1:]:
        clauses.append(list(map(int, line.split()[:-1])))
    with Solver(name='cadical195', bootstrap_with=clauses, with_proof=True) as s:
        assert s.solve() is False
        proof = root/'c0.drat'
        proof.write_text('\n'.join(s.get_proof())+'\n')
    p = subprocess.run([str(CHECKER), str(cnf), str(proof)],
                       capture_output=True, text=True)
    (root/'c0.check').write_text(p.stdout+p.stderr)
    assert p.returncode == 0 and 's VERIFIED' in p.stdout.splitlines()
    rec = dict(scope='c=0, every length, strict correctness lower-bound relaxation',
               status='UNSAT_VERIFIED', cnf_sha256=sha(cnf), proof_sha256=sha(proof),
               checker_sha256=sha(CHECKER), encoder_sha256=sha(__file__),
               witness_orders=witnesses,
               required_review='The no-comparison symbolic-copy relaxation argument.')
    (root/'c0.json').write_text(json.dumps(rec, indent=2)+'\n')
    print(json.dumps(rec), flush=True)


if __name__ == '__main__':
    main()
