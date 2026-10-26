#!/bin/bash
# n=4, I1, model out, strict perms (relaxation), rule NG (with garbage-register count), S4 symmetry: bounds 18, 19
cd "$(dirname "$0")"
for kb in 18 19; do echo "KB=$kb"; NG=1 CMAX=12 NOREC=1 /usr/bin/time -f "%es %MKB" nice -n 10 ./bin/enum_out_v3 4 0 1 $kb 64 1 2>&1; done
