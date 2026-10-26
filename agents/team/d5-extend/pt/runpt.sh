#!/bin/bash
# runpt.sh SKFILE LINE K OUTDIR NODELIMIT
f=$1; i=$2; K=$3; o=$4; nl=$5; mkdir -p $o
sed -n "${i}p" $f | tr ' ' '\n' > $o/s$i.txt
timeout ${TMO:-3600} nice -n 10 ./dagx_bin2_d1 $o/s$i.txt $K 1 $nl > $o/r$i.txt 2>&1
r=$(grep RESULT $o/r$i.txt | awk '{print $2}'); echo "$i ${r:-TIMEOUT}" >> $o/summary.txt
[ "$r" = NONE ] && rm -f $o/s$i.txt $o/r$i.txt
