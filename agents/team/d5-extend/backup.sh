#!/bin/bash
# copy every result summary to backup/ every 10 min (no rm, no globs in result folders)
cd /path/to/repo/agents/team/d5-extend
while true; do
  for d in pt/fw14n pt/fr31n pt/w6n pt/ptd31 pt/w6s31 pt/r3c7 gx/t1k31 gx/t1xk31; do
    [ -f $d/summary.txt ] && cp $d/summary.txt backup/$(echo $d | tr / _).summary.txt
  done
  for f in gx/u[0-9]*k31/summary.txt; do cp "$f" backup/$(echo $f | tr / _); done
  sleep 600
done
