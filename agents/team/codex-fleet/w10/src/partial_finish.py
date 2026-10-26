#!/usr/bin/env python3
"""Final serial controls, one direct sort5 gap query, and proof checking."""
import json
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parents[1]
OUT = HERE/'round2'


def validate(path):
    with open(str(path.with_suffix(''))+'.judge', 'w') as log:
        subprocess.run([sys.executable, str(HERE/'src/partial_validate.py'), str(path)],
                       check=True, stdout=log, stderr=subprocess.STDOUT)


def query(name, args):
    tag = OUT/name
    cmd = [sys.executable, str(HERE/'src/partial_sat.py'), '--tag', str(tag),
           '--origin', '--proof', '--release-clauses'] + args
    print('START', name, flush=True)
    subprocess.run(cmd, check=True)
    data = json.loads(tag.with_suffix('.json').read_text())
    if data['status'] == 'SATISFIABLE':
        validate(tag.with_suffix('.s'))
    print('DONE', name, flush=True)


def main():
    validate(OUT/'n2_k4_partial.s')
    n3 = OUT/'n3_k11_partial.s'
    normalized = OUT/'n3_k11_lattice_normalized.s'
    text = n3.read_text().replace('cmovle S0, P0', 'mov S0, P0', 1)
    assert text != n3.read_text()
    normalized.write_text(text)
    validate(normalized)
    query('n3_k11_lattice_fixed', ['--n', '3', '--k', '11', '--c', '3',
          '--mode', 'lattice', '--fixed', str(normalized), '--timeout', '30'])
    source = HERE/'programs/exception_0_original.s'
    base = ['--n', '5', '--c', '9', '--mode', 'partial', '--cases', 'strict',
            '--flag-program', str(source), '--free-first']
    query('n5_k32_partial_fixed', base + ['--k', '32', '--fixed', str(source),
          '--timeout', '30'])
    query('n5_k31_partial_flags_blocks', base + ['--k', '31',
          '--blocks', '3,5,2,2,2,2,2,2,2', '--timeout', '120'])
    subprocess.run([sys.executable, str(HERE/'src/partial_proofs.py'), str(OUT),
                    '--timeout', '90'], check=True)


if __name__ == '__main__':
    main()
