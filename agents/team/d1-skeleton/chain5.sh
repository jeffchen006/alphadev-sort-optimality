#!/bin/bash
# after r10 (11 jobs) and flag (9 jobs) end, run the rest at <= 16 total
until ! ps -eo args | awk '$1=="/bin/bash" && $2=="./batch3.sh" && $3=="sk/r10"' | grep -q .; do sleep 60; done
mkdir -p sk/net10 sk/net9
for f in ../d7-structure/netsk/sk10_*.txt; do ln -sf ../../$f sk/net10/; done
for f in ../d7-structure/netsk/sk9_*.txt; do ln -sf ../../$f sk/net9/; done
./batch3.sh sk/net9 31 7 3600
./batch3.sh sk/net10 31 7 3600
./batch3.sh sk/r3p8 31 7 3600
./batch3.sh sk/d4c8 31 7 3600
./batch3.sh sk/d4c9 31 7 3600
./batch3.sh sk/d4c7 31 7 14400
