#!/bin/bash
f=$1; b=$(basename $f .txt)
grep -v '^#' $f > r3c7/$b.in
r=$(timeout 3600 nice -n 10 ./dagx_bin2_d1 r3c7/$b.in 31 1 | grep RESULT); echo "$b ${r:-TIMEOUT}" >> r3c7/summary.txt
