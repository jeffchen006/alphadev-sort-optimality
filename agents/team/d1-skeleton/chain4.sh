#!/bin/bash
until grep -q "BATCH DONE" logs/batch_flag3.log; do sleep 60; done
mkdir -p sk/net9; for f in ../d7-structure/netsk/sk9_*.txt; do ln -sf ../../$f sk/net9/; done
./batch3.sh sk/net9 31 8 3600
