#!/bin/bash
# DRAT certificate for one joint-RD size UNSAT: no DAG with <= K nodes (cmp+cmov) at depth <= D.
# usage: ./prove_joint.sh n D K cl
set -e
cd "$(dirname "$0")"
n=$1; D=$2; K=$3; cl=${4:-1}
b=proofs/joint_n${n}_D${D}_K${K}_cl${cl}
python3 relax_joint.py $n $D $K --T --cl $cl --cnf $b.cnf --proof $b.drat
../../bin/drat-trim $b.cnf $b.drat -w | grep -E "^s |VERIFIED|ERROR" | head -3
