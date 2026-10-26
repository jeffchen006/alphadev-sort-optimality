#!/bin/bash
# jloop.sh n D K0 K1 [extra args]: joint size bound sweep, stops at first SAT
n=$1; D=$2; k0=$3; k1=$4; shift 4
for K in $(seq $k0 $k1); do
  out=$(python3 relax_joint.py $n $D $K --T "$@")
  echo "$out"
  echo "$out" | grep -q ": SAT" && break
done
