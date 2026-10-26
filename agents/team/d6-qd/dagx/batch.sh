#!/bin/bash
# batch.sh DIR K PAR TIMEOUT : run dagx on every DIR/*.txt not yet done; results in DIR/res/<name>.out
D=$1; K=$2; PAR=${3:-12}; TO=${4:-1800}
mkdir -p $D/res
ls $D/*.txt | while read f; do b=$(basename $f .txt); [ -s $D/res/$b.out ] && grep -q RESULT $D/res/$b.out && continue; echo $f; done | \
  xargs -P $PAR -I{} bash -c 'b=$(basename {} .txt); ulimit -v 4000000; nice -n 10 timeout '$TO' ./dagx_bin {} '$K' 1 > '$D'/res/$b.out 2>&1; grep -q RESULT '$D'/res/$b.out || echo "RESULT TIMEOUT '$TO's" >> '$D'/res/$b.out'
echo BATCH DONE $D
