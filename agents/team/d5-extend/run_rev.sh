#!/bin/bash
# split s5k32 into 6 parts on program boundaries, run rev2 on each
zcat ../../upper/runs/r4/s5k32_coll.txt.gz | awk -v N=6 '/^#/{c++} {print > ("rev_in." (c%N))}'
for i in 0 1 2 3 4 5; do nice -n 10 ./rev2 6 < rev_in.$i > rev_out.$i 2> rev_err.$i & done
wait; rm rev_in.*
