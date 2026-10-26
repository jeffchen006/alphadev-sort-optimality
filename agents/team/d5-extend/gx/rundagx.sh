#!/bin/bash
# rundagx.sh SKFILE LINE K OUTDIR : run d1's dagx (read-only copy) on skeleton LINE of SKFILE
f=$1; i=$2; K=$3; o=$4; mkdir -p $o
sed -n "${i}p" $f | tr ' ' '\n' > $o/s$i.txt
timeout ${TMO:-3600} nice -n 10 ./dagx_bin2_d1 $o/s$i.txt $K 1 > $o/r$i.txt 2>&1
echo "$i $(grep RESULT $o/r$i.txt || echo TIMEOUT)" >> $o/summary.txt
