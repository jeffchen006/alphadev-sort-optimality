#!/bin/bash
# wait until chain2 finished d4c9, stop chain2 (it would start d4c7), then run r10 and d4c7
until grep -q "BATCH DONE sk/d4c9" logs/batch_chain2.log; do sleep 60; done
ps -eo pid,args | awk '$2=="sh" && $3=="-c" && $4=="./batch.sh" && $5=="sk/n7"{print $1}' | xargs -r kill
sleep 5
ps -eo pid,args | awk '$3=="./batch.sh" && $4=="sk/d4c7"{print $1}' | xargs -r kill
ps -eo pid,args | awk '$2=="./dagx_bin" && $3 ~ /d4c7/{print $1}' | xargs -r kill
for f in $(grep -l "RESULT TIMEOUT" sk/d4c7/res/*.out 2>/dev/null); do : > $f; done
./batch.sh sk/r10 31 11 3600
./batch.sh sk/d4c7 31 11 14400
