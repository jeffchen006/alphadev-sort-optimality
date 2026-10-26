#!/bin/bash
# CLAIM (proofs 20:29 + 21:16): ONE CakePB-checked proof "F0 UNSAT", where F0 = lean-lrat's VERIFIED rule-free encoder CNF
# and the symmetry rules canon+pcanon enter as checked dominance steps (no unverified checker): n=3, k=7 (and k=8),
# R=n+k, I1, snap (M_out), all 13 weak orders. The k=10 run (the AlphaDev bound) does not fit CakePB's heap yet.
# Trust note: lrat-tool binary is an input of the checked chain only through F0.cnf (CNF file itself is what cake_pb_cnf checks).
# Expected: cake_pb_cnf "s VERIFIED UNSAT". Time k=7: ~1 min, but 26 GB RAM (k=8: 67 GB). 1 core.
source "$(dirname "$0")/../lib.sh"
K=${K:-7}
NEED=$(( K == 7 ? 30 : 75 ))   # GB of free RAM that cake_pb_cnf needs (proofs: k=7 26 GB, k=8 67 GB)
AV=$(awk '/MemAvailable/ {print int($2/1048576)}' /proc/meminfo)
[ $AV -ge $NEED ] || { say "SKIPPED: needs ~${NEED} GB free RAM, only ${AV} GB available now (the machine is shared). Re-run later."; echo "RESULT $NAME: SKIPPED (RAM)"; exit 2; }
# regcanon.py matches the CNF layout of lean-lrat's v1 encoder = the frozen binary agents/proofs/vendor/lrat-tool
# (the current lean-lrat source has a different layout and is NOT used here). Provenance: proofs 20:29 / 21:16.
LT=$SRC/proofs/vendor/lrat-tool; chmod +x $LT
W=$OUT/sym; rm -rf $W; mkdir -p $W; cp $SRC/proofs/symcert/*.py $W/; cd $W
run python3 regcanon.py --source leanlrat --leanlrat $LT -k $K --inputs --out rc
cd rc
run $BIN/cadical -q --lrat=true --binary=true F1.cnf F1.lrat
run python3 -I ../full_proof.py F0.cnf F1.cnf sb.pbp F1.lrat full.pbp
run $CAKE/cake_pb_cnf F0.cnf full.pbp
say "F0 sha256 $(sha256sum F0.cnf | cut -d' ' -f1)"
expect "s VERIFIED UNSAT"
rm -f F1.lrat full.pbp
finish
