#!/bin/bash
# queue.sh PAR : master queue over priority-ordered dirs; result = DIR/res/<name>.out with RESULT NONE/FOUND/TIMEOUT.
# Loops until every input has a final line; a killed xargs only causes another round (no item is lost or faked).
PAR=${1:-15}
while ps -eo args | awk '$1=="./dagx_bin3"' | grep -q .; do sleep 20; done
DIRS0="sk/fresh31n sk/w3x_n __C8N1__ sk/r4 sk/fam_sel sk/r3p8 sk/d4c8 sk/d4c9 sk/w8 sk/ord9 sk/ord10 sk/d4c7"
while true; do
  DIRS=$(echo $DIRS0 | sed "s#__C8N1__#$(ls -d sk/c8n1/*/ 2>/dev/null | sed 's#/$##' | tr '\n' ' ')#")
  todo=logs/queue_todo.txt; : > $todo
  for D in $DIRS; do mkdir -p $D/res; for f in $D/*.txt; do [ -e "$f" ] || continue; b=$(basename $f .txt)
      o=$D/res/$b.out; if [ -s $o ] && grep -q "^RESULT \(NONE\|FOUND\|TIMEOUT\)" $o; then continue; fi; echo $f >> $todo; done; done
  n=$(wc -l < $todo); echo "$(date) todo $n"; [ $n -eq 0 ] && grep -q "GEN DONE" logs/gen_c8n1.log && break; [ $n -eq 0 ] && { sleep 60; continue; }
  xargs -a $todo -P $PAR -I{} bash -c 'f={}; D=$(dirname $f); b=$(basename $f .txt); T=3600; case $D in sk/d4c7) T=14400;; esac
     ulimit -v 4000000; nice -n 10 timeout $T ./dagx_bin3 $f 31 1 > $D/res/$b.out 2>&1; rc=$?
     if ! grep -q "^RESULT" $D/res/$b.out; then if [ $rc -eq 124 ]; then echo "RESULT TIMEOUT ${T}s" >> $D/res/$b.out; else : > $D/res/$b.out; fi; fi'
  sleep 10
done
echo QUEUE DONE
