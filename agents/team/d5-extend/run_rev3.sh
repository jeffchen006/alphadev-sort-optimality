#!/bin/bash
zcat ../../upper/runs/r4/s5k32_coll.txt.gz | awk -v N=4 '/^#/{c++} {print > ("rev3_in." (c%N))}'
for i in 0 1 2 3; do nice -n 10 ./rev3 12 < rev3_in.$i > rev3_out.$i 2> rev3_err.$i & done
wait; rm rev3_in.*
