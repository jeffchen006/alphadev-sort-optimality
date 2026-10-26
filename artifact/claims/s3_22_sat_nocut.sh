#!/bin/bash
# CLAIM (sat 20:43 + 21:19): second certificate of k_out(3) >= 11 WITHOUT the cut hcmp: n=3, I1 and I0, M_out (snap),
# R=13, T-relaxed, 6 permutations, NOP mode (= all k <= 10), rules canon,pcanon,comm,dead,flags,cmpord,movfresh,snapcmov
# only: UNSAT, certified by cake_lpr. Expected: 2 x "s VERIFIED UNSAT" and sat's CNF hashes.
# Time: I1 cadical ~3950 s + cake_lpr ~1160 s; I0 ~1900 s + ~700 s (about 2 h 10 min), 1 core. Disk: LRAT several GB.
source "$(dirname "$0")/../lib.sh"
W=$OUT/work; rm -rf $W; mkdir -p $W/cnf; cp $SRC/sat/*.py $W/; cd $W
for I in I1 I0; do
  run python3 gen_full.py 3 10 $I snap t r8=canon,pcanon,comm,dead,flags,cmpord,movfresh,snapcmov
  certify cnf/f3_${I}_snap_k10_r8_t.cnf
done
expect "cnf f3_I1_snap_k10_r8_t.cnf sha256 2002fda0468e385c3f8ead3dcad54a8fc01aff62cd1592c39e337b4c70d07778"
expect "cnf f3_I0_snap_k10_r8_t.cnf sha256 dae39dce2e64daa32d41e5496bcfe41dab0b03ca898db24f20bc177baad4f1d5"
[ $(grep -c "s VERIFIED UNSAT" $LOG) -eq 2 ] && say "EXPECT OK  : 2 x s VERIFIED UNSAT" || { say "EXPECT FAIL: 2 x s VERIFIED UNSAT"; FAILS=$((FAILS+1)); }
finish
