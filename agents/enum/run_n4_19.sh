#!/bin/bash
# n=4, I1, model out, strict perms (relaxation), rule NG v3, S4 symmetry, incremental h, chunked, 4-byte keys, pre-sized
cd "$(dirname "$0")"
echo "KB=19"; NG=1 CMAX=10 NOREC=1 VCAP=1048576 VLOAD=95 /usr/bin/time -f "%es %MKB" nice -n 10 ./bin/enum_out_v8 4 0 1 19 64 1 2>&1
