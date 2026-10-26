#!/bin/bash
# dev copy of tools/solve.sh: n k I types tag
cd "$(dirname "$0")"
n=$1; k=$2; I=$3; ts=$4; tag=$5
B=../../../bin; T=.lake/build/bin/lrat-tool
f=cnf/n${n}_${I}_k${k}_$tag
$T dimacs $n $k $I $ts $f.cnf > $f.info
t0=$(date +%s.%N)
nice -n 10 $B/cadical -q --lrat=true --binary=false $f.cnf $f.lrat > $f.out; rc=$?
t1=$(date +%s.%N)
line="$(date '+%F %T') n=$n k=$k $I types=$ts $(head -1 $f.cnf) rc=$rc solve=$(printf %.1f $(echo "$t1-$t0"|bc))s"
if [ $rc = 20 ]; then
  raw=$(du -m $f.lrat|cut -f1)
  tr=$($T trim $f.lrat $f.trim.lrat) && mv $f.trim.lrat $f.lrat
  line="$line raw=${raw}MB ($tr) lrat=$(du -m $f.lrat|cut -f1)MB"
fi
echo "$line" | tee -a logs/solve.log
