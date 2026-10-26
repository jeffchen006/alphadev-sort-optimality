"""Check variable-domain four-position transitions against the scalar evaluator."""
import itertools
import argparse
import json
from pathlib import Path
import random
import resource
import time

from pysat.solvers import Solver
from analyze import simulate
from rank_encode import RankEnc
from binary_encode import BinaryEnc
from reference_window import CASES, OPS, read


def run():
    resource.setrlimit(resource.RLIMIT_AS, (3 * 1024**3, 3 * 1024**3))
    parser = argparse.ArgumentParser()
    parser.add_argument('--binary', action='store_true')
    args = parser.parse_args()
    factory = BinaryEnc if args.binary else RankEnc
    rng = random.Random(20261026)
    repair, _ = read('seeds/repair32.s')
    seed, _ = read('seeds/near31.s')
    rows = []
    began = time.monotonic()
    for trial in range(18):
        # The appended move explicitly exercises the one added register.
        p = list(repair if trial % 3 == 0 else seed) + [(0, 7, 0)]
        free = set(rng.sample(range(len(p) - 1), 3)) | {len(p) - 1}
        if trial % 3 == 2:
            position = min(free)
            p[position] = (trial % 6, rng.randrange(8), rng.randrange(8))
        cases = CASES if trial < 3 else rng.sample(CASES, 27)
        columns = {}
        for case in cases:
            code = [(OPS[o], f'P{d}' if d < 5 else f'S{d-5}',
                     f'P{s}' if s < 5 else f'S{s-5}') for o, d, s in p]
            _, snaps, _ = simulate(code, case, garbage=5 if args.binary else max(case) + 1)
            for t, r, value in snaps:
                columns.setdefault((t, r), []).append(value)
        goals = list(zip(*(sorted(case) for case in cases)))
        expected = all(any(tuple(col) == goal for col in columns.values()) or
                       any(tuple(case[r] for case in cases) == goal for r in range(5))
                       for goal in goals)
        e = factory(5, len(p), R=8, iset='I1', outmode='snap', rules=())
        domains, destinations, sources = [], [], []
        for i, (o, d, s) in enumerate(p):
            e.cl(e.op[i][OPS[o]])
            e.cl(e.d[i][d])
            e.cl(e.s[i][s])
            domains.append(OPS if i in free else [OPS[o]])
            destinations.append(None if i in free else d)
            sources.append(None if i in free else s)
        e.configure(p, domains, destinations, sources)
        for case in cases:
            e.add_type(case)
        with Solver(name='cadical195', bootstrap_with=e.clauses) as solver:
            actual = solver.solve()
        assert actual == expected, (trial, actual, expected)
        rows.append({'trial': trial, 'cases': len(cases), 'free': sorted(free),
                     'expected_sat': expected, 'actual_sat': actual})
    result = {'status': 'MATCH', 'programs': len(rows), 'encoder': factory.__name__,
              'full_541_case_programs': 3, 'rows': rows,
              'seconds': time.monotonic() - began}
    path = 'round2/binary_variable_domain_crosscheck.json' if args.binary else 'round2/variable_domain_crosscheck.json'
    Path(path).write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({k: v for k, v in result.items() if k != 'rows'}))


if __name__ == '__main__':
    run()
