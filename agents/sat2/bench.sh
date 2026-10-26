#!/bin/bash
# bench.sh n kmin kmax types.json [cegis args]: dump CNF of the fixed type set and time kissat (timeout 3600 s)
n=$1; k0=$2; k1=$3; tj=$4; shift 4
cd "$(dirname "$0")"
tag=$(echo "$*" | tr -d ' -' | cut -c1-40)
for k in $(seq $k0 $k1); do
  f=cnf/bench_s${n}_k${k}_${tag}.cnf
  python3 cegis.py --n $n --k $k --types-json $tj "$@" --dump $f --dump-only > /dev/null
  s=$(date +%s.%N); timeout 3600 ../../bin/kissat -q $f > /dev/null; rc=$?; e=$(date +%s.%N)
  echo "n=$n k=$k args=[$*] vars/clauses=$(head -1 $f | cut -d' ' -f3,4) rc=$rc time=$(echo "$e - $s" | bc)"
  [ $rc = 124 ] && break
done
