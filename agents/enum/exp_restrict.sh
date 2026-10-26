#!/bin/bash
# restricted residual R_i(t): exact remaining cost of AlphaDev sort5 prefix t on the 24 inputs where x_i is max (NG=1)
cd "$(dirname "$0")"
F=../../programs/out/alphadev_sort5_42_suppG_out.s
for t in 30 28 26 24 22 20 18 16 14 12 10 8; do
  r=$((32-t)); line="t=$t rem=$r"
  for i in 0 1 2 3 4; do
    o=$(taskset -c 160-191 nice -n 15 timeout 900 env NG=1 CMAX=40 NOREC=1 SUBMAX=$i PREFIX=$F:$t ./bin/enum_out 5 0 1 $r 6 0 2>&1 | grep -E "^RESULT|h\(root")
    h=$(echo "$o" | sed -n 's/h(root)=//p'); m=$(echo "$o" | sed -n 's/RESULT min=\([0-9]*\).*/\1/p'); [ -z "$m" ] && m="?"
    line="$line | i=$i h=$h R=$m"
  done
  echo "$line"
done
