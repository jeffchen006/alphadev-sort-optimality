#!/bin/bash
# CLAIM (bounds R1, theory-reviewed): n=4, T-relaxed, I1, perms, ALL correct programs, any R: #cmov >= 10. Uncertified search.
# Expected: "n=4 m<=9: none". Time ~340 s, 1 core, ~2 GB.
source "$(dirname "$0")/../lib.sh"
run g++ -O2 -o $OUT/rsearch $SRC/bounds/rsearch.cpp
run $OUT/rsearch 1 4 1 9
expect "n=4 m<=9: none"
finish
