#!/usr/bin/env python3
"""Check prefix coverage, hashes, and optionally every saved DRAT certificate."""
import argparse
import json
from pathlib import Path
import subprocess
import sys
import tempfile

from independent_c2 import sha
from prefix_campaign import roots, selectors
from certify_c2 import CHECKER
sys.setrecursionlimit(10000)


def replay_record(path, check):
    rec = json.loads(path.read_text())
    if rec['status'] != 'UNSAT_VERIFIED':
        return rec['status']
    base = Path(rec['base'])
    meta = json.loads(Path(str(base)+'.json').read_text())
    assert sha(Path(str(base)+'.cnf')) == meta['cnf_sha256']
    proof = Path(rec['tag']+'.drat')
    assert sha(proof) == rec['proof_sha256']
    assert rec['verified']
    assert rec['checker_sha256'] == sha(CHECKER)
    with tempfile.TemporaryDirectory(prefix='w11-replay-') as td:
        formula = Path(td)/'cube.cnf'
        with Path(str(base)+'.cnf').open() as inp, formula.open('w') as out:
            header = inp.readline().split()
            out.write(f'p cnf {header[2]} {int(header[3])+len(rec["units"])}\n')
            for b in iter(lambda: inp.read(1 << 20), ''):
                out.write(b)
            for lit in rec['units']:
                out.write(f'{lit} 0\n')
        assert sha(formula) == rec['cnf_sha256']
        if check:
            p = subprocess.run([str(CHECKER), str(formula), str(proof)],
                               capture_output=True, text=True)
            assert p.returncode == 0 and 's VERIFIED' in p.stdout.splitlines()
    return 'UNSAT_VERIFIED'


def audit(path, check):
    state = json.loads(path.read_text())
    meta = json.loads(Path(state['base']+'.json').read_text())
    expected = roots(meta)
    assert state['roots'] == [r['name'] for r in expected]
    assert state['base_sha256'] == meta['cnf_sha256']
    for r in expected:
        assert state['nodes'][r['name']]['units'] == r['units']
    available = set(selectors(meta))
    seen = set()
    counts = {}
    def visit(name):
        assert name not in seen
        seen.add(name)
        node = state['nodes'][name]
        status = node['status']
        counts[status] = counts.get(status, 0)+1
        if status == 'BRANCHED':
            lit = node['split_literal']
            assert lit in available
            assert len(node['children']) == 2
            a, b = [state['nodes'][x] for x in node['children']]
            assert a['units'] == node['units']+[lit]
            assert b['units'] == node['units']+[-lit]
            return all([visit(ch) for ch in node['children']])
        if status == 'UNSAT_VERIFIED':
            rec = Path(node['result'])
            result = json.loads(rec.read_text())
            assert result['units'] == node['units']
            assert replay_record(rec, check) == status
            return True
        return False
    closed = sum(visit(r) for r in state['roots'])
    assert seen == set(state['nodes'])
    return dict(state=str(path), counts=counts, roots=len(expected),
                closed_roots=closed, complete=closed == len(expected),
                reran_checker=check)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('paths', nargs='+')
    ap.add_argument('--check', action='store_true')
    args = ap.parse_args()
    for name in args.paths:
        path = Path(name)
        if path.name == 'state.json':
            print(json.dumps(audit(path, args.check)), flush=True)
        else:
            print(json.dumps(dict(path=name, status=replay_record(path, args.check))))


if __name__ == '__main__':
    main()
