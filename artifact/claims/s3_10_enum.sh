#!/bin/bash
# CLAIM (enum 20:10): n=3, M_out, I1 and I0, R unbounded, T-relaxed, 13 weak orders: no program with k <= 10 (set-model BFS,
# rules agents/enum/PRUNING.md, reviewed by theory). Uncertified (search claim).
# Expected: the bound-10 runs report no solution; the bound-11 run finds one. Time ~2 min at THREADS=1.
source "$(dirname "$0")/../lib.sh"
T=${THREADS:-1}
run g++ -O3 -march=native -fopenmp -o $OUT/enum_out $SRC/enum/src/enum_out.cpp
run $OUT/enum_out 3 1 1 10 $T 1          # I1, weak orders, bound 10, symmetry on
run $OUT/enum_out 3 1 0 10 $T 1          # I0
run $OUT/enum_out 3 1 1 11 $T 1 $OUT/w11.s   # sanity: k = 11 is found
[ -f $OUT/w11.s ] && run env PYTHONPATH=$SRC/shared python3 $SRC/shared/judge.py $OUT/w11.s --strict --model out
expect "PASS"
say "(compare the enum_out lines above with agents/enum/logs; enum must confirm the exact expected strings)"
finish
