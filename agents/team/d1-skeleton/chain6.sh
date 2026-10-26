#!/bin/bash
true
mkdir -p sk/ord9 sk/ord10
for f in ../d7-structure/netsk/ord9/*.txt; do ln -sf ../../$f sk/ord9/; done
for f in ../d7-structure/netsk/ord10/*.txt; do ln -sf ../../$f sk/ord10/; done
./batch3.sh sk/ord9 31 8 3600
./batch3.sh sk/ord10 31 8 3600
