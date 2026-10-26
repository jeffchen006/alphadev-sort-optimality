#!/bin/bash
# LRAT certificate: cadical --lrat proof, checked by cake_lpr (CakeML-verified checker, agents/proofs/tools/bin).
# usage: ./lrat_check.sh file.cnf      -> writes file.lrat and file.cake.log
set -e
f=$1; b=${f%.cnf}
CAKE=$(dirname "$0")/../proofs/tools/bin/cake_lpr
../../bin/cadical -q --lrat=true --no-binary "$f" "$b.lrat" > "$b.cadical.log" || true
grep -q "s UNSATISFIABLE" "$b.cadical.log" || { echo "$f: cadical did not say UNSAT"; exit 1; }
$CAKE "$f" "$b.lrat" > "$b.cake.log" 2>&1 || true
echo "$f: $(tail -n 1 $b.cake.log)"
