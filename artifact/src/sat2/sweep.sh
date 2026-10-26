#!/bin/bash
# usage: sweep.sh n enc iset outmode(fixed|free) kmin kmax [extra args]
# runs k = kmin.. until first SAT; logs to logs/, json to res/
n=$1; enc=$2; iset=$3; om=$4; kmin=$5; kmax=$6; shift 6
fo="--out $om"
cd "$(dirname "$0")"
for k in $(seq $kmin $kmax); do
  tag=sort${n}_${iset}_${om}_${enc}${TAG}_k${k}
  nice -n 10 python3 cegis.py --n $n --k $k --iset $iset --enc $enc $fo --json res/$tag.json \
     --save found/sat2_sort${n}_${iset}_${om}_k${k}.s "$@" > logs/$tag.log 2>&1
  grep -q "RESULT SAT" logs/$tag.log && break
done
