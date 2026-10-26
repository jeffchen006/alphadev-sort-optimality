#!/bin/bash
# usage: prove.sh <cnf> [threads-unused]  -> cadical LRAT proof, checked by cake_lpr (CakeML-verified) and lrat-check
set -u
cnf=$1; base=${cnf%.cnf}
BIN=/path/to/repo/bin
T0=$(date +%s)
$BIN/cadical -q --lrat=true --binary=false "$cnf" "$base.lrat" > "$base.solve.out"; rc=$?
T1=$(date +%s)
echo "cadical exit $rc ($((T1-T0))s) $(grep '^s ' $base.solve.out)"
[ $rc -eq 20 ] || exit 1
$(dirname $0)/tools/cake_lpr "$cnf" "$base.lrat" --CML_HEAP_SIZE=60000 > "$base.cake.out" 2>&1
T2=$(date +%s)
echo "cake_lpr: $(cat $base.cake.out | head -2) ($((T2-T1))s)"
echo "cnf_sha256 $(sha256sum "$cnf" | cut -d' ' -f1)"
echo "lrat_sha256 $(sha256sum "$base.lrat" | cut -d' ' -f1) size $(stat -c %s "$base.lrat")"
grep -q "s VERIFIED UNSAT" "$base.cake.out" && { [ -n "${KEEP:-}" ] || rm -f "$base.lrat"; exit 0; }
exit 1
