#!/bin/bash
# CLAIM (lean-lrat 20:03; proofs 20:32): Lean theorem sort3_I1c_no_le9 : ∀ p o, |p| ≤ 9 → I1 → ¬ XSnap 3 p o, via the
# Lean-verified CNF encoder + first-touch rule (proved) + Lean core's verified LRAT checker. The same CNF+LRAT is also
# VERIFIED by cake_lpr. STATUS: k <= 10 (the AlphaDev bound) is still running at lean-lrat (cubes) -> update this script.
# Expected: lake build of Results/Sort3_I1c_K9 OK; cake_lpr "s VERIFIED UNSAT". Time ~15 min, 1 core.
source "$(dirname "$0")/../lib.sh"
mirror lean-lrat; W=$OUT/agents/lean-lrat; cd $W; mkdir -p cnf logs
run bash -c "cd vendor && grep -E '\\./SortProof(\\.lean|/)' $SRC/lean/frozen/v2/SHA256SUMS | sha256sum -c -"   # vendor = lean frozen/v2
run $TS lake build lrat-tool
run $TS tools/solve.sh 3 9 I1c
certify cnf/n3_I1c_k9.cnf
run tools/mkresult.sh 3 9 I1c
run $TS lake env lean Results/Sort3_I1c_K9.lean
expect "cnf n3_I1c_k9.cnf sha256 a1334fcdea11590bc017fc292187251798a7846160ede7f5436a66faf8a25360"
expect "s VERIFIED UNSAT"
finish
