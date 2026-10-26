#!/usr/bin/env python3
"""Additional serial queries. Run only after partial_campaign has finished."""
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parents[1]


def main():
    queries = [
        ('n4_k19_any_freeblocks', 19, 'full', 'strict', [], 240),
        ('n4_k19_partial_weak_b33332', 19, 'partial', 'weak',
         ['--blocks', '3,3,3,3,2'], 120),
        ('n4_k19_partial_freeblocks_noprune', 19, 'partial', 'strict', [], 240),
        ('n4_k20_partial_synth', 20, 'partial', 'weak',
         ['--blocks', '3,3,3,3,3'], 120),
        ('n4_k20_lattice_synth', 20, 'lattice', 'weak',
         ['--blocks', '3,3,3,3,3'], 120),
    ]
    for name, k, mode, cases, extra, seconds in queries:
        tag = HERE/'round2'/name
        cmd = [sys.executable, str(HERE/'src/partial_sat.py'), '--n', '4',
               '--k', str(k), '--c', '5', '--mode', mode, '--origin', '--proof',
               '--cases', cases, '--network', '01,23,02,13,12', '--tag', str(tag),
               '--timeout', str(seconds)] + extra
        print('START', name, flush=True)
        subprocess.run(cmd, check=True)
        if tag.with_suffix('.s').exists():
            subprocess.run([sys.executable, str(HERE/'src/partial_validate.py'),
                            str(tag)+'.s'], check=True)
        print('DONE', name, flush=True)


if __name__ == '__main__':
    main()
