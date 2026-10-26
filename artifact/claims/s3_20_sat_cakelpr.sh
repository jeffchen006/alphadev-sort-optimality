#!/bin/bash
# CLAIM (sat 19:54, reviewed by theory): n=3, I1, M_out (snap), R=n+k=13, T-relaxed, 6 permutations (sound subset),
# NOP mode (= all k <= 10), rules canon,pcanon,comm,dead,flags,cmpord,movfresh,snapcmov + cut hcmp (paper proofs:
# agents/sat/RULES.md, theory reviews): UNSAT, certified by cake_lpr. => k_out(3) >= 11, L_AD(3) >= 17.
# I0 variant: same CNF generator with I0 (sat 20:06). Expected: "s VERIFIED UNSAT" twice.
# Time: I1 cadical ~670 s + cake_lpr ~310 s; I0 ~410 s + ~210 s. 1 core. Disk: LRAT up to a few GB (deleted after check).
source "$(dirname "$0")/../lib.sh"
W=$OUT/work; rm -rf $W; mkdir -p $W/cnf; cp $SRC/sat/*.py $W/; cd $W
for I in I1 I0; do
  run python3 gen_full.py 3 10 $I snap t h=canon,pcanon,comm,dead,flags,cmpord,movfresh,snapcmov,hcmp
  certify cnf/f3_${I}_snap_k10_h_t.cnf
done
for I in I1 I0; do say "clauses-only sha256 $I $(grep -v '^c' cnf/f3_${I}_snap_k10_h_t.cnf | sha256sum | cut -c1-64)"; done
# full-file sha256 from sat (current gen_full.py); clause-only sha256 (independent of the 'c' header line)
expect "cnf f3_I1_snap_k10_h_t.cnf sha256 9703b8e5350f903f8b5fe444cb489185dfa753b391614333c54b6d17d8d2a0fc|clauses-only sha256 I1 5c3b16217252cf6dc37b363600369fec4d3ad961347ef37047277b8263bb83ac"
expect "cnf f3_I0_snap_k10_h_t.cnf sha256 d8ec81bd6ec39bc23d186eb59b2be6aeab6e5a2336373022a0b563b2ff845015|clauses-only sha256 I0 a4cb56b3aa36bdb2f752b670bad28c01cb6c93e9ff67459a7ee89572778da12d"
[ $(grep -c "s VERIFIED UNSAT" $LOG) -eq 2 ] && say "EXPECT OK  : 2 x s VERIFIED UNSAT" || { say "EXPECT FAIL: 2 x s VERIFIED UNSAT"; FAILS=$((FAILS+1)); }
finish
