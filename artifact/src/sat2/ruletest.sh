#!/bin/bash
# rule ablation on a fixed type subset: ruletest.sh json n k iset out
j=$1; n=$2; k=$3; i=$4; o=$5
cd "$(dirname "$0")"
for r in "" "scr,tread,comm,noop,precmov,deadcmp,deadw" "live" "scr,tread,comm,noop,precmov,deadcmp,deadw,live" "scr,tread,live" "comm,live"; do
  f=cnf/abl_s${n}_${i}_${o}_k${k}_$(echo "${r:-none}" | tr ',' '_' | cut -c1-40).cnf
  python3 cegis.py --n $n --k $k --iset $i --out $o --types-json $j --rules "$r" --dump $f --dump-only > /dev/null
  s=$(date +%s.%N); timeout 1800 ../../bin/kissat -q $f > /dev/null; rc=$?; e=$(date +%s.%N)
  echo "rules=${r:-none} rc=$rc time=$(echo "$e - $s" | bc)"
done
