#!/bin/bash
./batch3.sh sk/c8u 31 11 7200
./batch3.sh sk/r10 31 11 3600
mkdir -p sk/net10; for f in ../d7-structure/netsk/sk10_*.txt; do ln -sf ../../$f sk/net10/; done
./batch3.sh sk/net10 31 11 3600
./batch3.sh sk/r3p8 31 11 3600
./batch3.sh sk/d4c8 31 11 3600
./batch3.sh sk/d4c9 31 11 3600
./batch3.sh sk/d4c7 31 11 14400
