#!/bin/bash
# at the depth-19 commit: stop lat_d2, resume from the checkpoint with lat_d2c (cand compaction, CANDMAX 250 GB apparent)
cd "$(dirname "$0")"
until grep -q '^depth 19:' logs/k31_ext.log || ! pgrep -f '^./lat_d2 5 0 1 31' >/dev/null; do sleep 20; done
grep -q '^depth 19:' logs/k31_ext.log || { echo "lat_d2 ended before depth 19" >> logs/k31_ext.log; exit 1; }
pkill -f '^./lat_d2 5 0 1 31'; sleep 5
echo "== switch to lat_d2c (resume) $(date)" >> logs/k31_ext.log
LAT=2 NOREC=1 CMAX=16 PACK3=1 CHUNK=300000 CANDMAX=250000 EXTDIR=$PWD/ext31 /usr/bin/time -f "%es %MKB" nice -n 10 ./lat_d2c 5 0 1 31 12 1 >> logs/k31_ext.log 2>&1
