#!/bin/bash
# CLAIM (lean-lrat 23:28): Lean theorems sort3_I1_no_le10 (no M_out program, n=3, k <= 10, I1, x86 strict) and
# sort3_I1_MM_no_le16 (AlphaDev model MM: no sort3 with L <= 16), via the Lean-VERIFIED CNF encoder ("dev": all rules
# proved in Lean, incl. hcmp), one cadical LRAT (887 MB), checked by Lean core's verified LRAT checker.
# Trust: Lean kernel + compiler (native_decide axioms layout3/perm3/unsat3). cake_lpr also checks the same CNF/LRAT pair.
# Expected: two axiom lines starting "[propext," and no error / sorry; cake_lpr "s VERIFIED UNSAT".
# Time ~40 min (cadical ~560 s, LRAT trim ~750 s, Lean 433 s), 1 core, <= 11 GB RAM.
source "$(dirname "$0")/../lib.sh"
AV=$(awk '/MemAvailable/ {print int($2/1048576)}' /proc/meminfo)
[ $AV -ge 14 ] || { say "SKIPPED: the Lean step needs ~11 GB, only ${AV} GB RAM available now (shared machine). Re-run later."; echo "RESULT $NAME: SKIPPED (RAM)"; exit 2; }
mirror lean-lrat; cd $OUT/agents/lean-lrat/dev; mkdir -p cnf logs
run $TS lake build
run $TS ./solve.sh 3 10 I1nh ../types/perm3.txt perm
say "cnf sha256 $(sha256sum cnf/n3_I1nh_k10_perm.cnf | cut -d' ' -f1)"
run $CAKE/cake_lpr cnf/n3_I1nh_k10_perm.cnf cnf/n3_I1nh_k10_perm.lrat   # same (trimmed, text) LRAT that Lean checks
$TS lake env lean Results/Sort3_I1nh_K10.lean > $OUT/lean.out 2>&1; say "lean exit $? (empty output after a long run = killed, usually OOM)"
tr -d '\n' < $OUT/lean.out | sed "s/'sort3/\n&/g" | tr -s ' ' >> $LOG; echo >> $LOG
expect "'sort3_I1_no_le10' depends on axioms: \[propext,"
expect "'sort3_I1_MM_no_le16' depends on axioms: \[propext,"
expect "s VERIFIED UNSAT"
grep -qi "sorry\|^error\| error:" $LOG && { say "error or sorry in output"; FAILS=$((FAILS+1)); }
rm -f cnf/*.lrat
finish
