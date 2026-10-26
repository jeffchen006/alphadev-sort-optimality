#!/usr/bin/env python3
"""Exercise both exceptional values as cmp operands, then reject the bound."""
import json
from pathlib import Path
from c2_controls import HERE, CONTROL, build
from verify import read_program, simulate


def main():
    path = CONTROL/'two_exception_comparands_fixed.s'
    original = (CONTROL/'control_pure_fixed.s').read_text()
    prefix = ('# n=5 model=out iset=I1 source=w11_two_cmp_controls\n'
              'cmp P0, P1\nmov S99, P0\ncmovl S99, P2\n'
              'cmp S99, P3\ncmovg S99, P3\n'
              'cmp S99, P4\ncmovg P4, P4\n')
    path.write_text(prefix+original)
    n, code = read_program(path)
    print(json.dumps(simulate(n, code)), flush=True)
    records = []
    records.append(build('two_exception_comparands', 5, 39, 12, 2, path))
    records.append(build('reject_two_comparands_bound1', 5, 39, 12, 1, path))
    records.append(build('reject_exception_comparands_lattice_cmp',
                         5, 39, 12, 2, path, lc=True))
    (CONTROL/'comparands_summary.json').write_text(
        json.dumps(records, indent=2)+'\n')


if __name__ == '__main__':
    main()
