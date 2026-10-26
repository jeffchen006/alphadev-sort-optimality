#!/bin/bash
# CLAIM (bounds R2 + B1, 4th tool): n=3, M_out, I1, perms, T-relaxed: #mov+#cmov >= 8 with cmp free, #cmp >= 3 => k >= 11;
# exact set model: none <= 10, found 11. Also #cmov >= 6 (R1). Uncertified.
# Expected: "none" for the bound runs and "found" / "FOUND" at 11. Time ~1 min, 1 core.
source "$(dirname "$0")/../lib.sh"
run g++ -O2 -o $OUT/rsearch $SRC/bounds/rsearch.cpp
run $OUT/rsearch 2 3 1 9
run $OUT/rsearch 3 3 1 11
run env PYTHONPATH=$SRC/shared python3 $SRC/bounds/mincmov.py 3 6
expect "n=3 W<=7: none"
expect "n=3 W<=8: FOUND"
expect "n=3 k<=10: none"
expect "n=3 k<=11: FOUND"
expect "n=3 m<=5: none"
finish
