"""Audit selector truth tables and regenerate every four-position formula."""
import contextlib
import hashlib
import io
import itertools
import json
from pathlib import Path
import resource
import time
from types import SimpleNamespace

from pysat.solvers import Solver as RealSolver
from rank_encode import RankEnc
from binary_encode import BinaryEnc
from reference_window import CASES
import search


class StopAudit(Exception):
    pass


class CaptureSolver:
    def __init__(self, **kwargs):
        pass

    def __enter__(self):
        return self

    def __exit__(self, *args):
        return False

    def set_phases(self, phases):
        pass

    def append_formula(self, clauses):
        pass

    def solve(self):
        raise StopAudit()


class AuditEnc(RankEnc):
    latest = None

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        AuditEnc.latest = self
        self.mux_calls = 0
        self.min_data_literal = None

    def mux(self, condition, yes, no):
        self.mux_calls += 1
        for value in (yes, no):
            if type(value) is int:
                self.min_data_literal = min(self.min_data_literal or abs(value), abs(value))
        return super().mux(condition, yes, no)


class AuditBinaryEnc(BinaryEnc):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        AuditEnc.latest = self
        self.mux_calls = 0
        self.min_data_literal = None

    def mux(self, condition, yes, no):
        self.mux_calls += 1
        for value in (yes, no):
            if type(value) is int:
                self.min_data_literal = min(self.min_data_literal or abs(value), abs(value))
        return super().mux(condition, yes, no)


def truth_tables(factory):
    checks = 0
    for condition, yes, no in itertools.product([True, False, 1, -1, 2, -2, 3, -3], repeat=3):
        e = factory.__new__(factory)
        e.nvars, e.clauses = 3, []
        e.cache = {}
        e.boolean_collision_hits = 0
        out = e.mux(condition, yes, no)
        with RealSolver(name='cadical195', bootstrap_with=e.clauses) as solver:
            for assignment in itertools.product([False, True], repeat=3):
                def value(x):
                    return x if type(x) is bool else assignment[abs(x)-1] if x > 0 else not assignment[abs(x)-1]
                assumptions = [i + 1 if bit else -i - 1 for i, bit in enumerate(assignment)]
                assert solver.solve(assumptions=assumptions)
                model = {x for x in solver.get_model() if x > 0}
                actual = out if type(out) is bool else out in model if out > 0 else -out not in model
                assert actual == (value(yes) if value(condition) else value(no)), (condition, yes, no, assignment)
                checks += 1
    return checks


def formula_digest(e):
    h = hashlib.sha256()
    h.update(f'p cnf {e.nvars} {len(e.clauses)}\n'.encode())
    for clause in e.clauses:
        h.update((' '.join(map(str, clause)) + ' 0\n').encode())
    return h.hexdigest()


def main():
    resource.setrlimit(resource.RLIMIT_AS, (3 * 1024**3, 3 * 1024**3))
    began = time.monotonic()
    helper_checks = {factory.__name__: truth_tables(factory) for factory in (RankEnc, BinaryEnc)}
    checks = sum(helper_checks.values())
    search.Solver, search.RankEnc = CaptureSolver, AuditEnc
    search.BinaryEnc = AuditBinaryEnc
    records = []
    for file in sorted(Path('round2').glob('quad_*.json')):
        row = json.loads(file.read_text())
        cmd = row['command']
        initial = int(cmd[cmd.index('--initial') + 1]) if '--initial' in cmd else 16
        args = SimpleNamespace(seed='seeds/near31.s', output='round2/audit_unused.s',
            registers=8, changes=0, prefix=0, free=','.join(map(str, row['window'])),
            typed=False, operands=False, fixed_dest=False, delete=None, maxcmp=0,
            initial=initial, random_seed=711, solver='cadical195', proof=False,
            all_cases='--all-cases' in cmd, binary='--binary' in cmd, no_fold_readonly=False)
        with contextlib.redirect_stdout(io.StringIO()):
            try:
                search.solve(args)
            except StopAudit:
                pass
        e = AuditEnc.latest
        events = []
        for line in file.with_suffix('.log').read_text().splitlines():
            try:
                events.append(json.loads(line))
            except json.JSONDecodeError:
                pass
        for event in events:
            if event.get('step') == 'candidate':
                assert event.get('added'), 'A blocked candidate needs a separate replay'
                for t in sorted(event['added']):
                    e.add_type(CASES[t])
        collision_hits = getattr(e, 'boolean_collision_hits', 0)
        assert collision_hits == 0, (file, collision_hits)
        result = {'file': str(file), 'status': row['status'], 'cases': len(e.types),
                  'encoder': 'binary' if args.binary else 'rank',
                  'mux_calls': e.mux_calls, 'minimum_data_literal': e.min_data_literal,
                  'boolean_collision_hits': collision_hits}
        if row['status'] == 'UNSAT':
            result['regenerated_cnf_sha256'] = formula_digest(e)
            result['matches_stored_cnf'] = result['regenerated_cnf_sha256'] == row['cnf_sha256']
            assert result['matches_stored_cnf'], (file, result)
        records.append(result)
        del e
        if len(records) % 20 == 0:
            print(json.dumps({'step': 'audit', 'attempts': len(records),
                              'seconds': time.monotonic() - began}), flush=True)
    report = {'status': 'MATCH', 'truth_table_checks': checks, 'attempts': len(records),
              'truth_table_checks_by_helper': helper_checks,
              'UNSAT_formulas_reproduced': sum(r.get('matches_stored_cnf', False) for r in records),
              'boolean_collision_hits': sum(r['boolean_collision_hits'] for r in records),
              'minimum_data_literal': min(r['minimum_data_literal'] for r in records),
              'seconds': time.monotonic() - began, 'records': records}
    report['helper_source_hashes'] = {str(p): hashlib.sha256(p.read_bytes()).hexdigest()
                                    for p in map(Path, ['round2/rank_encode_before.py', 'src/rank_encode.py', 'src/binary_encode.py'])}
    Path('round2/encoding_audit.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({k: v for k, v in report.items() if k != 'records'}), flush=True)


if __name__ == '__main__':
    main()
