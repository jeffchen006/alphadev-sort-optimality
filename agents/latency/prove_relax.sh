#!/bin/bash
# DRAT certificate for one relaxed-DAG UNSAT instance: build CNF, kissat proof, drat-trim check.
# usage: ./prove_relax.sh n j D cl     (T allowed = lower-bound relaxation)
set -e
cd "$(dirname "$0")"
n=$1; j=$2; D=$3; cl=${4:-1}
b=proofs/relax_n${n}_j${j}_D${D}_cl${cl}
python3 relax.py $n $j $D --T --cl $cl --cnf $b.cnf --proof $b.drat | sed 's/layers.*->/->/'
../../bin/drat-trim $b.cnf $b.drat -w | grep -E "^s |VERIFIED|ERROR" | head -3
