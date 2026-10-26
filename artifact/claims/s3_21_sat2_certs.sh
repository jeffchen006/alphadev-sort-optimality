#!/bin/bash
# CLAIM (sat2 19:32 + proofs 20:38): n=3, I1, M_out, R=n+k, T-relaxed, CEGIS subsets of weak orders, sat2 rules R1-R6,
# M1-M4, live + C1 (#cmp>=3): the final-subset CNFs for every k = 1..10 are UNSAT, each certified by cake_lpr.
# (Re-running the CEGIS sweep itself: cd agents/sat2 && TAG=_rall_c1 ./sweep.sh 3 cnf I1 snapw 1 11 --rules all --min-cmp 3,
#  several hours; not done here.) Expected: 10 x "s VERIFIED UNSAT". Time: k<=9 a few min, k=10 ~30-60 min. 1 core.
source "$(dirname "$0")/../lib.sh"
( cd $SRC/sat2 && sha256sum -c cert/SHA256SUMS ) >> $LOG 2>&1 && say "cert SHA256SUMS OK" || { say "cert SHA256SUMS FAIL"; FAILS=$((FAILS+1)); }
for k in 1 2 3 4 5 6 7 8 9 10; do certify $SRC/sat2/cert/s3_I1_out_k$k.cnf; done
# short re-run of the CEGIS search itself with sat2's current code (needs pysat); k = 1..9, ~80 s
W=$OUT/cegis; rm -rf $W; cp -r $SRC/sat2 $W; cd $W
for k in 1 2 3 4 5 6 7 8 9; do run python3 cegis.py --n 3 --k $k --iset I1 --out snapw --rules all --min-cmp 3; done
[ $(grep -cE "^RESULT UNSAT n=3 k=[1-9]" $LOG) -eq 9 ] && say "EXPECT OK  : 9 x RESULT UNSAT (CEGIS k=1..9)" || { say "EXPECT FAIL: 9 x RESULT UNSAT (CEGIS k=1..9)"; FAILS=$((FAILS+1)); }
[ $(grep -c "s VERIFIED UNSAT" $LOG) -eq 10 ] && say "EXPECT OK  : 10 x s VERIFIED UNSAT" || { say "EXPECT FAIL: 10 x s VERIFIED UNSAT"; FAILS=$((FAILS+1)); }
finish
