#!/bin/bash
# CLAIM (bounds, SORT5_SPLIT-style split for sort4, case c = 9 cmps; theory review of the split: agents/theory/reviews):
# n=4, M_out, I1, T-relaxed, exact set model with EXACTC=1 MCUT=10: no program with k <= 19 in case c=9. Uncertified.
# Expected: "n=4 k<=19: none". Time ~402 s, 1 core, ~1 GB.
source "$(dirname "$0")/../lib.sh"
run g++ -O2 -o $OUT/rsearch $SRC/bounds/rsearch.cpp
run env EXACTC=1 MCUT=10 $OUT/rsearch 3 4 1 19 9
expect "n=4 k<=19: none"
finish
