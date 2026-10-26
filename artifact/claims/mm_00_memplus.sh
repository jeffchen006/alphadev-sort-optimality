#!/bin/bash
# CLAIMS (spec, upper, critic; MODEL.md §4.5): (a) MM+ kernels (memory source operands in cmp/cmov) of length 7/15/26/39/40
# for n = 2/3/4/5/5 are strict-correct; (b) n=2 exact optimum MM = 8, MM+ = 7 (exhaustive BFS, T-relaxed, all weak orders);
# (c) n=3 MM+ optimum = 15 (critic bf_mm.cpp IDDFS: L <= 14 UNSAT; uncertified).
# Expected: all PASS; "FOUND L=8" (mem), "FOUND L=7" (memplus); critic: L=14 UNSAT. Time: (a,b) ~6 min; (c) see critic log.
source "$(dirname "$0")/../lib.sh"
P=$SRC/programs
for f in $P/variants/memplus_sort2_7.s $P/found/*memops*.s $P/found/*memplus*.s; do
  run env PYTHONPATH=$SRC/shared python3 $SRC/shared/judge.py $f --strict --model memplus -q; done
run env PYTHONPATH=$SRC/shared python3 $SRC/spec/mm_bfs.py 2 8 mem I1
run env PYTHONPATH=$SRC/shared python3 $SRC/spec/mm_bfs.py 2 8 memplus I1
expect "model=mem iset=I1: FOUND L=8"
expect "model=memplus iset=I1: FOUND L=7"
grep -q "^FAIL" $LOG && { say "a program FAILED"; FAILS=$((FAILS+1)); }
if [ -n "${WITH_CRITIC:-}" ]; then
  run g++ -O2 -o $OUT/bf_mm $SRC/critic/bf_mm.cpp
  say "critic bf_mm: run as in agents/critic/logs/mm_n3_memplus_I1.log (owner confirms the exact arguments)"
fi
finish
