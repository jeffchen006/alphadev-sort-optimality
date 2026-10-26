#!/bin/bash
# driver.sh A B : for unique templates A..B of tplu.txt: genext (cap 8 = complete for <= 4 free slots) + dagx_bin2 K=31
cd /path/to/repo/agents/team/d5-extend/gx
P=${P:-8}
for i in $(seq $1 $2); do
  sed -n "${i}p" tplu.txt | cut -f4 | tr ' ' '\n' > u$i.tpl
  nf=$(grep -c '^\*' u$i.tpl); m=$((2*nf)); [ $m -lt 8 ] && m=8
  nice ./genext u$i.tpl $m ../../d1-skeleton/out > u$i.sk 2> u${i}_gen.log
  n=$(wc -l < u$i.sk)
  touch u${i}k31/summary.txt 2>/dev/null; mkdir -p u${i}k31; touch u${i}k31/summary.txt; TMO=1800 bash -c "seq 1 $n | grep -vxF -f <(awk '{print \$1}' u${i}k31/summary.txt) | ./d5xargs -P $P -I{} ./rundagx.sh u$i.sk {} 31 u${i}k31"
  echo "u$i free=$nf cap=$m skeletons=$n done=$(cat u${i}k31/summary.txt 2>/dev/null | wc -l) found=$(grep -c FOUND u${i}k31/summary.txt 2>/dev/null) none=$(grep -c NONE u${i}k31/summary.txt 2>/dev/null) $(date +%T)" >> driver.log
  if grep -q FOUND u${i}k31/summary.txt 2>/dev/null; then echo "FOUND in u$i" >> driver.log; fi
done
