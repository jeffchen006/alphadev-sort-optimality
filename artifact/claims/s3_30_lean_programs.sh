#!/bin/bash
# CLAIM (lean 19:07): AlphaDev sort3/4/5 (L = 17/28/42, model=mem) sort on the Lean x86 semantics (BitVec 32, all garbage,
# all 16 flag states); kernel proofs (decide +kernel), axioms propext/Classical.choice/Quot.sound only.
# Expected (lean): 3 lines 'SortProof.alphadev_sortK_x86' depends on axioms: [propext, Classical.choice, Quot.sound].
# Time 15-25 min pinned to 1 core (taskset), RAM <= 5 GB.
source "$(dirname "$0")/../lib.sh"
mirror lean; W=$OUT/agents/lean; cd $W   # SortProof/Programs.lean reads ../../../programs/*
run $TS lake build
printf 'import SortProof\n#print axioms SortProof.alphadev_sort3_x86\n#print axioms SortProof.alphadev_sort4_x86\n#print axioms SortProof.alphadev_sort5_x86\n' > ax.lean
$TS lake env lean ax.lean 2>&1 | tr -d '\n' | sed 's/\x27SortProof/\n&/g' | tr -s ' ' >> $LOG; echo >> $LOG
for k in 3 4 5; do expect "'SortProof.alphadev_sort${k}_x86' depends on axioms: \[propext, ?Classical.choice, ?Quot.sound\]"; done
grep -q "sorryAx\|ofReduceBool" $LOG && { say "unexpected axiom"; FAILS=$((FAILS+1)); }
finish
