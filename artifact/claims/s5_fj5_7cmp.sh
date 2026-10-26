#!/bin/bash
# CLAIM (bounds B1): the #cmp >= ceil(log2 n!) bound is tight for n=5: a sort5 with only 7 cmp exists (72 instructions).
# Expected: bounds' sim.py prints relaxed and strict (True, None); the judge also PASSes. Time < 1 min, 1 core.
source "$(dirname "$0")/../lib.sh"
cd $SRC/bounds
run python3 sim.py 5 fj5_7cmp.s
run env PYTHONPATH=$SRC/shared python3 $SRC/shared/judge.py fj5_7cmp.s --strict
expect "True, None\) strict \(True, None\)"
finish
