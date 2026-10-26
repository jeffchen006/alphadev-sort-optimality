#!/bin/bash
# CLAIM (critic 19:00): n=3, RS (= M_out), I1, R unbounded, T-relaxed, 13 weak orders: UNSAT for every k = 0..10
# (independent IDDFS, prunings agents/critic/BF_NOTES.md). Uncertified.
# Expected: "k=10 UNSAT". Time ~27 min, 1 core (1.7e9 nodes). I0 variant: ~2 min.
source "$(dirname "$0")/../lib.sh"
run g++ -O2 -o $OUT/bf $SRC/critic/bf.cpp
run $OUT/bf 3 snapshot I0 10 hplus
run $OUT/bf 3 snapshot I1 10 hplus
expect "k=10 UNSAT"
finish
