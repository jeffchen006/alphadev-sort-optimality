#!/bin/bash
cd /path/to/repo/agents/team/d5-extend/pt
for f in ../../d1-skeleton/sk/c8u/*.txt ../../d1-skeleton/sk/c8r2u/*.txt; do
  b=$(basename $(dirname $f))_$(basename $f .txt)
  timeout 1200 nice ./neigh2 $f 100000 2> n2/$b.log | gzip > n2/$b.sk.gz
  echo "$b $(tail -1 n2/$b.log)" >> n2/counts.txt
done
