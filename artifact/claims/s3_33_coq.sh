#!/bin/bash
# CLAIM (coq 20:30): Rocq theorem CmovSort.Sort3.sort3_lb: no M_out program, n=3, k <= 10, I1, R = 13, relaxed
# (strict permutations = sound subset); soundness proved in Rocq 9.3 (no Admitted; Print Assumptions = PrimInt63 only);
# the checker is extracted to OCaml and run. Expected: "n=3 I1 k=10 all_okb=true". Time ~18 min, 1 core, 0.7 GB.
source "$(dirname "$0")/../lib.sh"
W=$OUT/coq; rm -rf $W; cp -r $SRC/coq $W; mkdir -p $W/tools
cp $ROOT/agents/coq/tools/env.sh $W/tools/env.sh   # opam environment of the Rocq toolchain (not part of the snapshot)
cd $W; run ./run_sort3.sh I1 10
expect "n=3 I1 k=10 all_okb=true"
finish
